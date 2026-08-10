-- FILENAME: Litlib/Core/CLI/CodeSummary.lean

import Lean
import Litlib.Core.CLI.Engine
import Litlib.Core.CLI.Bibtex
import Litlib.Core.CLI.Latex

open Lean Meta

namespace Litlib.Core.CLI

private def nameToFilePath : Name → System.FilePath
  | .anonymous => System.FilePath.mk "."
  | .str .anonymous s => System.FilePath.mk s
  | .str p s => nameToFilePath p / s
  | .num p _ => nameToFilePath p

/-- Strictly pattern matches the tail of the Name to filter auto-generated junk -/
def isAuto (n : Name) : Bool :=
  n.isInternal ||
  match n with
  | .str _ s =>
    s == "mk" || s == "rec" || s == "casesOn" || s == "recOn" ||
    s == "noConfusion" || s == "noConfusionType" || s == "injEq" ||
    s.startsWith "match_" || s.startsWith "proof_" || s.startsWith "eq_" ||
    s.startsWith "sizeOf" || s.startsWith "inst" || s.startsWith "_aux" ||
    s.endsWith "inj" || s.endsWith "ext" || s.endsWith "ext_iff"
  | _ => false

/-- Attempts to locate the .lean source file for a given module. -/
private def findSourceFile (modName : Name) : IO (Option System.FilePath) := do
  let sp ← Lean.searchPathRef.get
  let relPath := (nameToFilePath modName).withExtension "lean"

  if let some oleanPath ← Lean.SearchPath.findWithExt sp "olean" modName then
    let mut curr := oleanPath
    let mut depth := 0
    let mut temp := modName
    while temp != .anonymous do
      match temp with
      | .str p _ => depth := depth + 1; temp := p
      | .num p _ => depth := depth + 1; temp := p
      | .anonymous => break

    for _ in [0:depth] do
      if let some parent := curr.parent then curr := parent

    if curr.fileName == some "lean" then curr := curr.parent.getD curr
    if curr.fileName == some "lib" then curr := curr.parent.getD curr
    if curr.fileName == some "build" then curr := curr.parent.getD curr
    if curr.fileName == some ".lake" then curr := curr.parent.getD curr

    let candidates := #[
      curr / relPath,
      curr / "src" / relPath,
      curr / "lib" / relPath
    ]
    for c in candidates do
      if ← c.pathExists then return some c

  let candidates := #[
    relPath,
    System.FilePath.mk "src" / relPath,
    System.FilePath.mk "lib" / relPath
  ]
  for c in candidates do
    if ← c.pathExists then return some c

  let packagesDir := System.FilePath.mk ".lake" / "packages"
  if ← packagesDir.isDir then
    for entry in ← packagesDir.readDir do
      let pkgSrcPath := entry.path / relPath
      if ← pkgSrcPath.pathExists then return some pkgSrcPath
      let pkgSrcSrcPath := entry.path / "src" / relPath
      if ← pkgSrcSrcPath.pathExists then return some pkgSrcSrcPath

  return none

/-- Extracts the exact text of the declaration from the source file. -/
private def extractSourceCode (env : Environment) (n : Name) : CoreM (Option String) := do
  let some ranges ← Lean.findDeclarationRanges? n | return none
  let some modIdx := env.getModuleIdxFor? n | return none
  let modName := env.header.moduleNames[modIdx.toNat]!
  let some srcPath ← findSourceFile modName | return none

  let lines ← IO.FS.lines srcPath
  let startLine := ranges.range.pos.line - 1
  let endLine := ranges.range.endPos.line
  if startLine < lines.size then
    let codeLines := lines.extract startLine (min endLine lines.size)
    let mut code := String.intercalate "\n" codeLines.toList
    if let some doc ← Lean.findDocString? env n then
      if !code.trimAscii.toString.startsWith "/--" then
        code := s!"/--\n{doc.trimAscii.toString}\n-/\n" ++ code
    return some code
  return none

/-- Safely strips the `:= ...` or `where ...` proof block from theorems and instances. -/
private def stripProofToSignature (s : String) (isInst : Bool) : String := Id.run do
  let chars := s.toList.toArray
  let mut level := 0
  let mut inString := false
  let mut inLineComment := false
  let mut blockCommentDepth := 0

  let mut validAssigns : Array Nat := #[]
  let mut validWheres : Array Nat := #[]

  let mut i := 0
  while i < chars.size do
    let c := chars[i]!
    let nextC := if i + 1 < chars.size then chars[i+1]! else ' '

    if inLineComment then
      if c == '\n' then inLineComment := false
      i := i + 1
      continue

    if blockCommentDepth > 0 then
      if c == '/' && nextC == '-' then
        blockCommentDepth := blockCommentDepth + 1
        i := i + 2
        continue
      else if c == '-' && nextC == '/' then
        blockCommentDepth := blockCommentDepth - 1
        i := i + 2
        continue
      i := i + 1
      continue

    if inString then
      if c == '"' && (i == 0 || chars[i-1]! != '\\') then
        inString := false
      i := i + 1
      continue

    if c == '"' then
      inString := true
      i := i + 1
      continue
    if c == '-' && nextC == '-' then
      inLineComment := true
      i := i + 2
      continue
    if c == '/' && nextC == '-' then
      blockCommentDepth := 1
      i := i + 2
      continue

    if c == '(' || c == '[' || c == '{' || c == '⦃' || c == '⟨' then level := level + 1
    else if c == ')' || c == ']' || c == '}' || c == '⦄' || c == '⟩' then level := level - 1

    if level == 0 && c == ':' && nextC == '=' then
      validAssigns := validAssigns.push i

    if level == 0 && c == 'w' && i + 4 < chars.size && chars[i+1]! == 'h' && chars[i+2]! == 'e' && chars[i+3]! == 'r' && chars[i+4]! == 'e' then
      let prevC := if i > 0 then chars[i-1]! else ' '
      let nextW := if i + 5 < chars.size then chars[i+5]! else ' '
      if prevC.isWhitespace && (nextW.isWhitespace || nextW == '\n') then
        validWheres := validWheres.push i

    i := i + 1

  if isInst then
    if validWheres.size > 0 then
      return String.ofList (chars.extract 0 validWheres[0]!).toList

  for idx in validAssigns do
    let mut j := idx + 2
    while j < chars.size && chars[j]!.isWhitespace do j := j + 1
    if j + 1 < chars.size && chars[j]! == 'b' && chars[j+1]! == 'y' then
      let nextW := if j + 2 < chars.size then chars[j+2]! else ' '
      if nextW.isWhitespace || nextW == '\n' || j + 2 == chars.size then
        return String.ofList (chars.extract 0 idx).toList

  if let some lastIdx := validAssigns.back? then
    return String.ofList (chars.extract 0 lastIdx).toList

  return s

def withPPOptions {α} (x : MetaM α) : MetaM α := do
  let opts := (← getOptions)
    |>.insert `maxHeartbeats (Lean.DataValue.ofNat 5000000)
    |>.insert `maxRecDepth (Lean.DataValue.ofNat 10000)
    |>.insert `pp.maxDepth (Lean.DataValue.ofNat 1000)
    |>.insert `pp.maxSteps (Lean.DataValue.ofNat 1000000)
    |>.insert `pp.deepTerms (Lean.DataValue.ofBool true)
    |>.insert `pp.notation (Lean.DataValue.ofBool true)
    |>.insert `pp.fullNames (Lean.DataValue.ofBool false)
    |>.insert `pp.proofs (Lean.DataValue.ofBool false)
    |>.insert `pp.rawOnError (Lean.DataValue.ofBool true)
  withOptions (fun _ => opts) x

partial def collectLocalDepsRec (rootModule : Name) (q : List Name) (v : NameSet) : CoreM NameSet := do
  match q with
  | [] => return v
  | curr :: rest =>
    let env ← getEnv
    if let some info := env.find? curr then
      let mut consts : NameSet := {}

      consts := info.type.foldConsts consts (fun c acc => acc.insert c)
      if let .defnInfo d := info then
        consts := d.value.foldConsts consts (fun c acc => acc.insert c)

      if let .inductInfo i := info then
        for ctor in i.ctors do
          if let some ctorInfo := env.find? ctor then
            consts := ctorInfo.type.foldConsts consts (fun c acc => acc.insert c)

      let mut newQ := rest
      let mut newV := v
      for c in consts.toList do
        let modStr := match env.getModuleIdxFor? c with
          | some idx => env.header.moduleNames[idx.toNat]!.toString
          | none => rootModule.toString

        let isLocalMod := match env.getModuleIdxFor? c with
          | some _ => modStr.startsWith "Litlib" || modStr.startsWith rootModule.toString
          | none => true -- Test Compatibility

        let isProj := (← Lean.getProjectionFnInfo? c).isSome

        let isTracked := (litlibTrackExt.find? env c).isSome || (litlibEqExt.find? env c).isSome
        let isThm := match env.find? c with | some (.thmInfo _) => true | _ => false

        -- Recursively strip Pi (∀) types to reliably detect parameterized instances
        let rec getRetType (e : Expr) : Expr :=
          match e with | .forallE _ _ b _ => getRetType b | _ => e

        let isInst := match env.find? c with
          | some c_info =>
            if let some typeName := (getRetType c_info.type).getAppFn.constName? then
              Lean.isClass env typeName
            else false
          | none => false

        let isMath := c.toString.contains ".Math." || modStr.contains ".Math."

        -- THE SURGICAL RULE: Theorems, Instances, and Math plumbing MUST be explicitly tracked to be crawled.
        let allowedByLitlib := if isThm || isInst || isMath then isTracked else true

        if !newV.contains c && isLocalMod && !isAuto c && !isProj && allowedByLitlib && c != curr then
          newV := newV.insert c
          newQ := c :: newQ

      collectLocalDepsRec rootModule newQ newV
    else
      collectLocalDepsRec rootModule rest v

def ppDecl (env : Environment) (name : Name) : IO String := do
  let ctx : Core.Context := { fileName := "<litlib>", fileMap := default }
  let state : Core.State := { env := env }
  let (res, _) ← (MetaM.run' (withPPOptions do
    let isThm := match env.find? name with | some (ConstantInfo.thmInfo _) => true | _ => false

    if let some src ← extractSourceCode env name then
      let isInst := src.trimAscii.toString.startsWith "instance"
      if isThm || isInst then
        return (stripProofToSignature src isInst).trimAsciiEnd.toString
      else
        return src.trimAsciiEnd.toString
    else if let some info := env.find? name then
      match info with
      | ConstantInfo.inductInfo i =>
        if isStructure env name then
          let mut fieldsStr := ""
          match i.ctors with
          | ctor :: _ =>
            if let some (ConstantInfo.ctorInfo c) := env.find? ctor then
              fieldsStr := s!" :\n  {← ppExpr c.type}"
          | [] => pure ()
          return s!"class/structure {name}{fieldsStr}"
        else
          return s!"inductive {name} :\n  {← ppExpr i.type}"
      | ConstantInfo.thmInfo t => return s!"theorem {name} :\n  {← ppExpr t.type}"
      | ConstantInfo.defnInfo d => return s!"def {name} :\n  {← ppExpr d.type} :=\n  {← ppExpr d.value}"
      | ConstantInfo.axiomInfo a => return s!"axiom {name} :\n  {← ppExpr a.type}"
      | ConstantInfo.opaqueInfo o => return s!"opaque {name} :\n  {← ppExpr o.type} :=\n  {← ppExpr o.value}"
      | ConstantInfo.ctorInfo c => return s!"constructor {name} :\n  {← ppExpr c.type}"
      | _ => return s!"declaration {name} :\n  {← ppExpr info.type}"
    else
      return s!"-- {name} <not found>"
  )).toIO ctx state

  -- Prevent LaTeX fonts from crashing on Mathlib's mathcal nhds symbol
  return res.replace "𝓝" "nhds "

def gatherRoots (rootModule : Name) (globalData : GlobalData) (ctx : CliContext) : CoreM NameSet := do
  let env ← getEnv
  let mut roots : NameSet := {}

  let isLocal (declName : Name) : Bool :=
    match env.getModuleIdxFor? declName with
    | some idx =>
      let modName := env.header.moduleNames[idx.toNat]!
      modName.toString.startsWith rootModule.toString
    | none => true -- Test Compatibility

  for paper in globalData.papers do
    for eq in paper.equations do
      if isLocal eq.declName then
        let modNameStr := match env.getModuleIdxFor? eq.declName with
          | some idx => env.header.moduleNames[idx.toNat]!.toString
          | none => rootModule.toString
        if matchesAnyGlob ctx.referenceGlobs eq.declName.toString || matchesAnyGlob ctx.referenceGlobs modNameStr then
          roots := roots.insert eq.declName
          for prf in eq.proofs do
            if isLocal prf.declName then
              roots := roots.insert prf.declName

  for thm in globalData.theorems do
    if isLocal thm.declName then
      let modNameStr := match env.getModuleIdxFor? thm.declName with
        | some idx => env.header.moduleNames[idx.toNat]!.toString
        | none => rootModule.toString
      if matchesAnyGlob ctx.theoremGlobs thm.declName.toString || matchesAnyGlob ctx.theoremGlobs modNameStr then
        roots := roots.insert thm.declName

  if !ctx.litlibTheoremsOnly then
    for (declName, _) in env.constants.toList do
      if !isAuto declName && !(← Lean.getProjectionFnInfo? declName).isSome then
        if isLocal declName then
          let modNameStr := match env.getModuleIdxFor? declName with
            | some idx => env.header.moduleNames[idx.toNat]!.toString
            | none => rootModule.toString
          let isMatch := matchesAnyGlob ctx.theoremGlobs declName.toString ||
                         matchesAnyGlob ctx.referenceGlobs declName.toString ||
                         matchesAnyGlob ctx.theoremGlobs modNameStr ||
                         matchesAnyGlob ctx.referenceGlobs modNameStr
          if isMatch then
            roots := roots.insert declName

  return roots

def runCodeSummary (rootModule : Name) (env : Environment) (globalData : GlobalData) (ctx : CliContext) : IO UInt32 := do
  let isLatex := ctx.latexDir.isSome
  let outStrRef ← IO.mkRef (if isLatex then "\\printleanrefs\n\\vspace{2em}\n\\begin{minted}{lean}\n" else "")

  let appendLine (s : String) : IO Unit := do
    if isLatex then
      outStrRef.modify (fun out => out ++ s ++ "\n")
    else
      IO.println s

  if !isLatex then
    appendLine "\n===================================================================="
    appendLine "                        CODE SUMMARY"
    appendLine "===================================================================="

  let ctxCore : Core.Context := { fileName := "<litlib>", fileMap := default }
  let state : Core.State := { env := env }

  let (roots, _) ← (gatherRoots rootModule globalData ctx).toIO ctxCore state

  -- WARNING SYSTEM: Check for unmatched filters/designators
  if ctx.explicitFilters then
    let allGlobs := (ctx.theoremGlobs ++ ctx.referenceGlobs).filter (fun g => g != "all" && g != "")
    let mut uniqueGlobs : List String := []
    for g in allGlobs do if !uniqueGlobs.contains g then uniqueGlobs := uniqueGlobs ++ [g]

    for glob in uniqueGlobs do
      let mut matched := false
      for n in roots.toList do
        if globMatch glob n.toString then
          matched := true
          break
        let modNameStr := match env.getModuleIdxFor? n with
          | some idx => env.header.moduleNames[idx.toNat]!.toString
          | none => rootModule.toString
        if globMatch glob modNameStr then
          matched := true
          break
      if !matched then
        IO.println s!"[WARNING] The filter or .leanrefs designator '{glob}' did not match any tracked theorems."

  if roots.isEmpty then
    if !isLatex then appendLine "\n  [No items found matching the filter.]\n"
    return 0

  let (allLocalConsts, _) ← (collectLocalDepsRec rootModule roots.toList roots).toIO ctxCore state

  let mut byModule : NameMap (Array Name) := {}
  let printedDecls := allLocalConsts.toList

  let mut nameMap : Array (String × Name) := #[]
  for n in printedDecls do
    let s := n.getString!
    let mut count := 0
    for x in printedDecls do if x.getString! == s then count := count + 1
    if count == 1 then nameMap := nameMap.push (s, n)

    let f := n.toString
    if f != s then nameMap := nameMap.push (f, n)

  for n in printedDecls do
    if let some idx := env.getModuleIdxFor? n then
      let modName := env.header.moduleNames[idx.toNat]!
      let arr := match byModule.find? modName with
        | some a => a.push n
        | none => #[n]
      byModule := byModule.insert modName arr

  let mut sortedMods := #[]
  for (modName, _) in byModule.toList do
    sortedMods := sortedMods.push modName
  sortedMods := sortedMods.qsort fun a b => a.toString < b.toString

  for modName in sortedMods do
    appendLine s!"\n-- MODULE: {modName}"
    appendLine s!"--------------------------------------------------------------------"
    let names := (byModule.find? modName).getD #[]
    let sortedNames := names.qsort fun a b => a.toString < b.toString
    for n in sortedNames do
      let codeStr ← ppDecl env n
      let formattedCode := injectLabelsAndLinks codeStr n nameMap isLatex
      appendLine formattedCode
      appendLine ""

  if isLatex then
    outStrRef.modify (fun out => out ++ "\\end{minted}\n")
    let finalOutStr ← outStrRef.get
    if let some dirStr := ctx.latexDir then
      let dir := System.FilePath.mk dirStr
      IO.FS.createDirAll dir
      generateLitlibSty dir
      generateLatexReadme dir
      IO.FS.writeFile (dir / "litlib-code-summary.tex") finalOutStr

      let existingKeys ← scanForExistingBibKeys dir
      let bibStr ← generateBibtexString globalData existingKeys
      IO.FS.writeFile (dir / "litlib-references.bib") bibStr

      IO.println s!"LaTeX artifacts generated in {dir}"
  else
    appendLine "====================================================================\n"

  return 0

end Litlib.Core.CLI
