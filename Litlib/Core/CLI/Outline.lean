-- FILENAME: Litlib/Core/CLI/Outline.lean

import Lean
import Litlib.Core.CLI.Engine
import Litlib.Core.CLI.CodeSummary

open Lean

namespace Litlib.Core.CLI

private def stringContains (s sub : String) : Bool :=
  (s.splitOn sub).length > 1

/-- Short kind label for 1-line outline entries. -/
def getShortDeclKind (env : Environment) (n : Name) : String :=
  if Lean.isClass env n then "class"
  else if Lean.isStructure env n then "struct"
  else match env.find? n with
  | some (.thmInfo _) => "thm"
  | some (.defnInfo d) =>
    let rec getRetType (e : Expr) : Expr :=
      match e with | .forallE _ _ b _ => getRetType b | _ => e
    if let some typeName := (getRetType d.type).getAppFn.constName? then
      if Lean.isClass env typeName then "inst" else "def"
    else "def"
  | some (.inductInfo _) => "ind"
  | some (.axiomInfo _) => "ax"
  | some (.opaqueInfo _) => "ax"
  | _ => "decl"

/-- Strips block comments (`/-- ... -/`, `/- ... -/`), line comments, and leading attributes. -/
private def stripCommentsAndAttrs (s : String) : String := Id.run do
  let chars := s.toList.toArray
  let mut out : Array Char := #[]
  let mut i := 0
  let mut inString := false
  let mut inLineComment := false
  let mut blockDepth := 0
  let mut attrDepth := 0

  while i < chars.size do
    let c := chars[i]!
    let nextC := if i + 1 < chars.size then chars[i + 1]! else ' '

    if inLineComment then
      if c == '\n' then
        inLineComment := false
        out := out.push ' '
      i := i + 1
      continue

    if blockDepth > 0 then
      if c == '/' && nextC == '-' then
        blockDepth := blockDepth + 1
        i := i + 2
        continue
      else if c == '-' && nextC == '/' then
        blockDepth := blockDepth - 1
        i := i + 2
        continue
      i := i + 1
      continue

    if attrDepth > 0 then
      if c == '[' then attrDepth := attrDepth + 1
      else if c == ']' then attrDepth := attrDepth - 1
      i := i + 1
      continue

    if inString then
      out := out.push c
      if c == '"' && (i == 0 || chars[i - 1]! != '\\') then
        inString := false
      i := i + 1
      continue

    if c == '"' then
      inString := true
      out := out.push c
      i := i + 1
      continue

    if c == '-' && nextC == '-' then
      inLineComment := true
      i := i + 2
      continue

    if c == '/' && nextC == '-' then
      blockDepth := 1
      i := i + 2
      continue

    if c == '@' && nextC == '[' then
      attrDepth := 1
      i := i + 2
      continue

    out := out.push c
    i := i + 1

  return String.ofList out.toList

/-- Collapses all whitespace runs (newlines, tabs, multiple spaces) into single spaces. -/
private def collapseWhitespace (s : String) : String := Id.run do
  let mut words : Array String := #[]
  let mut cur : Array Char := #[]
  for c in s.toList do
    if c.isWhitespace || c == '\n' || c == '\r' || c == '\t' then
      if !cur.isEmpty then
        words := words.push (String.ofList cur.toList)
        cur := #[]
    else
      cur := cur.push c
  if !cur.isEmpty then
    words := words.push (String.ofList cur.toList)
  return String.intercalate " " words.toList

/-- Strips leading declaration keywords from a collapsed 1-line signature. -/
private def stripLeadingDeclKeyword (s : String) : String := Id.run do
  let mut cur := s.trimAscii.toString
  let modifiers := ["noncomputable ", "protected ", "private ", "unsafe ", "partial "]
  for m in modifiers do
    if cur.startsWith m then
      cur := (cur.drop m.length).trimAscii.toString
  let keywords := [
    "theorem ", "lemma ", "def ", "abbrev ", "structure ",
    "class ", "inductive ", "instance ", "axiom ", "opaque ",
    "class/structure ", "declaration "
  ]
  for kw in keywords do
    if cur.startsWith kw then
      cur := (cur.drop kw.length).trimAscii.toString
      break
  return cur

/--
Strips top-level definition bodies (`:= ...`), `where ...` blocks, and inductive constructor
bars (`| ...`) at bracket depth 0 so `--outline` only emits compact declaration signatures.
-/
private def stripBodyForOutline (s : String) : String := Id.run do
  let chars := s.toList.toArray
  let mut level : Int := 0
  let mut inString := false
  let mut i := 0

  while i < chars.size do
    let c := chars[i]!
    let nextC := if i + 1 < chars.size then chars[i + 1]! else ' '

    if inString then
      if c == '"' && (i == 0 || chars[i - 1]! != '\\') then
        inString := false
      i := i + 1
      continue

    if c == '"' then
      inString := true
      i := i + 1
      continue

    if c == '(' || c == '[' || c == '{' || c == '⦃' || c == '⟨' then
      level := level + 1
    else if c == ')' || c == ']' || c == '}' || c == '⦄' || c == '⟩' then
      if level > 0 then level := level - 1

    if level == 0 then
      if c == ':' && nextC == '=' then
        return String.ofList (chars.extract 0 i).toList
      if c == 'w' && i + 4 < chars.size &&
          chars[i + 1]! == 'h' && chars[i + 2]! == 'e' &&
          chars[i + 3]! == 'r' && chars[i + 4]! == 'e' then
        let prevOk := if i == 0 then true else chars[i - 1]!.isWhitespace
        let nextOk := if i + 5 >= chars.size then true else chars[i + 5]!.isWhitespace
        if prevOk && nextOk then
          return String.ofList (chars.extract 0 i).toList
      if c == '|' && nextC != '|' then
        let prevOk := if i == 0 then true else chars[i - 1]!.isWhitespace
        let nextOk := nextC.isWhitespace
        if prevOk && nextOk then
          return String.ofList (chars.extract 0 i).toList

    i := i + 1

  return s

/-- Formats a single declaration into its 1-line outline representation. -/
def formatOutlineDecl (env : Environment) (usesMap : NameMap Nat) (eqProofDecls : NameSet)
    (n : Name) : IO String := do
  let rawSig ← ppDecl env n
  let sigOnly := stripBodyForOutline (stripCommentsAndAttrs rawSig)
  let cleanSig := collapseWhitespace sigOnly
  let bodySig := stripLeadingDeclKeyword cleanSig

  let kind := getShortDeclKind env n
  let uses := usesMap.find? n |>.getD 0
  let tracked := isTrackedDecl env eqProofDecls n

  let prefixTag :=
    if uses == 0 && !tracked then
      s!"[{kind}, uses=0, UNTRACKED-LEAF]"
    else
      s!"[{kind}, uses={uses}]"

  if tracked then
    let parts := bodySig.splitOn " "
    match parts with
    | head :: tail =>
      let rest := String.intercalate " " tail
      if rest.isEmpty then
        return s!"{prefixTag} {head} [TRACK]"
      else
        return s!"{prefixTag} {head} [TRACK] {rest}"
    | [] =>
      return s!"{prefixTag} {n} [TRACK]"
  else
    return s!"{prefixTag} {bodySig}"

/-- Formats the complete 1-line outline for all declarations matching `ctx`. -/
def formatOutline (rootModule : Name) (env : Environment) (_globalData : GlobalData)
    (ctx : CliContext) : IO String := do
  let ctxCore : Core.Context := { fileName := "<litlib>", fileMap := default }
  let state : Core.State := { env := env }

  let ((usesMap, _), _) ← (computeUsesAndDeps rootModule env).toIO ctxCore state
  let eqProofDecls := collectEqProofDecls env

  let mut byModule : NameMap (Array Name) := {}

  for (declName, info) in env.constants.toList do
    if isLocalToRoot rootModule env declName && !isAuto declName then
      if (litlibPaperExt.find? env declName).isNone then
        let (isProj, _) ← (Lean.getProjectionFnInfo? declName : CoreM _).toIO ctxCore state
        if !isProj.isSome then
          match info with
          | .ctorInfo _ => pure ()
          | _ =>
            let modName := match env.getModuleIdxFor? declName with
              | some idx => env.header.moduleNames[idx.toNat]!
              | none => rootModule
            let modNameStr := modName.toString
            if matchesAllFilterTokens env usesMap eqProofDecls ctx declName modNameStr then
              let arr := byModule.find? modName |>.getD #[]
              byModule := byModule.insert modName (arr.push declName)

  let mut sortedMods : Array Name := #[]
  for (modName, _) in byModule.toList do
    sortedMods := sortedMods.push modName
  sortedMods := sortedMods.qsort fun a b => a.toString < b.toString

  let mut outLines : Array String := #[]
  for modName in sortedMods do
    let modPath := modName.toString.replace "." "/"
    let lineCount ← do
      if let some srcPath ← findSourceFile modName then
        let lines ← IO.FS.lines srcPath
        pure lines.size
      else
        pure 0
    outLines := outLines.push s!"-- {modPath}.lean ({lineCount}L)"

    let decls := (byModule.find? modName |>.getD #[]).qsort fun a b => a.toString < b.toString
    for d in decls do
      let line ← formatOutlineDecl env usesMap eqProofDecls d
      outLines := outLines.push line
    outLines := outLines.push ""

  return String.intercalate "\n" outLines.toList

def runOutline (rootModule : Name) (env : Environment) (globalData : GlobalData)
    (ctx : CliContext) : IO UInt32 := do
  let out ← formatOutline rootModule env globalData ctx
  IO.print out
  return 0

end Litlib.Core.CLI
