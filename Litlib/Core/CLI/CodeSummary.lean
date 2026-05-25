-- FILENAME: Litlib/Core/CLI/CodeSummary.lean

import Lean
import Litlib.Core.CLI.Engine

open Lean Meta

namespace Litlib.Core.CLI

private def nameToFilePath : Name → System.FilePath
  | .anonymous => System.FilePath.mk "."
  | .str .anonymous s => System.FilePath.mk s
  | .str p s => nameToFilePath p / s
  | .num p _ => nameToFilePath p

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

  -- Also search inside .lake/packages for Litlib files imported downstream
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
    if let some wIdx := validWheres.back? then
      return String.ofList (chars.extract 0 wIdx).toList

  -- Parse backwards through valid level-0 assignments to find the proof start
  for idx in validAssigns.reverse do
    let mut j := idx + 2
    while j < chars.size && chars[j]!.isWhitespace do j := j + 1
    if j + 1 < chars.size && chars[j]! == 'b' && chars[j+1]! == 'y' then
      return String.ofList (chars.extract 0 idx).toList
      
  -- Fallback: If no `:= by` is found, take the absolute last `:=` as the term proof assignment
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

      let mut newQ := rest
      let mut newV := v
      for c in consts.toList do
        let isLocalMod := match env.getModuleIdxFor? c with
          | some idx =>
            let modName := env.header.moduleNames[idx.toNat]!
            let mStr := modName.toString
            mStr.startsWith "Litlib" || mStr.startsWith rootModule.toString
          | none => false
        
        let isAuto := c.isInternal || 
          (match c with 
          | .str _ s => s == "mk" || s == "rec" || s == "casesOn" || s == "recOn" || s.startsWith "match_" || s.startsWith "proof_" || s.startsWith "eq_" 
          | _ => false)

        let isProj := (← Lean.getProjectionFnInfo? c).isSome

        if !newV.contains c && isLocalMod && !isAuto && !isProj && c != curr then
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
  return res

def runCodeSummary (rootModule : Name) (env : Environment) (globalData : GlobalData) : IO UInt32 := do
  IO.println "\n===================================================================="
  IO.println "                        CODE SUMMARY"
  IO.println "===================================================================="

  if globalData.papers.isEmpty && globalData.theorems.isEmpty then
    IO.println "\n  [No tracked items found matching the filter.]\n"
    return 0

  -- 1. Gather all explicit target roots
  let mut roots : NameSet := {}
  for paper in globalData.papers do
    for eq in paper.equations do
      roots := roots.insert eq.declName
      for prf in eq.proofs do
        roots := roots.insert prf.declName

  for thm in globalData.theorems do
    roots := roots.insert thm.declName

  -- 2. Traverse AST
  let ctx : Core.Context := { fileName := "<litlib>", fileMap := default }
  let state : Core.State := { env := env }
  let (allLocalConsts, _) ← (collectLocalDepsRec rootModule roots.toList roots).toIO ctx state

  -- 3. Group by Module
  let mut byModule : NameMap (Array Name) := {}
  for n in allLocalConsts.toList do
    if let some idx := env.getModuleIdxFor? n then
      let modName := env.header.moduleNames[idx.toNat]!
      let arr := match byModule.find? modName with
        | some a => a.push n
        | none => #[n]
      byModule := byModule.insert modName arr

  -- 4. Print
  let mut sortedMods := #[]
  for (modName, _) in byModule.toList do
    sortedMods := sortedMods.push modName
  sortedMods := sortedMods.qsort fun a b => a.toString < b.toString

  for modName in sortedMods do
    IO.println s!"\n-- MODULE: {modName}"
    IO.println s!"--------------------------------------------------------------------"
    let names := (byModule.find? modName).getD #[]
    let sortedNames := names.qsort fun a b => a.toString < b.toString
    for n in sortedNames do
      let codeStr ← ppDecl env n
      IO.println codeStr
      IO.println ""

  IO.println "====================================================================\n"
  return 0

end Litlib.Core.CLI
