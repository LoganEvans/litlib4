-- FILENAME: Litlib/Core/CLI/Engine.lean

import Lean
import Litlib.Core

open Lean

namespace Litlib.Core.CLI

-- ==========================================
-- Basic Regex / Glob Matching Engine
-- ==========================================

def myTrim (s : String) : String :=
  let chars := s.toList
  let chars1 := chars.dropWhile Char.isWhitespace
  let chars2 := chars1.reverse.dropWhile Char.isWhitespace
  String.ofList chars2.reverse

def myDropLeft (s : String) (n : Nat) : String :=
  String.ofList (s.toList.drop n)

def myDropRight (s : String) (n : Nat) : String :=
  let chars := s.toList
  if chars.length <= n then "" else String.ofList (chars.take (chars.length - n))

/-- 
Performs robust regex-lite matching on a string. 
Supported syntax:
- `^text` (Starts with exact)
- `text$` (Ends with exact)
- `^text$` (Exact match)
- `*` or `all` (Match all)
- `text` (Contains)
- `*foo*bar.*` (Ordered wildcard matching, `.*` gracefully supported)
-/
def globMatch (pat target : String) : Bool :=
  let p := (myTrim pat).replace ".*" "*"
  if p == "" then false
  else if p == "*" || p == "all" then true
  else if p.startsWith "^" && p.endsWith "$" then
    target == (myDropRight (myDropLeft p 1) 1).replace "*" ""
  else if p.startsWith "^" then
    target.startsWith ((myDropLeft p 1).replace "*" "")
  else if p.endsWith "$" then
    target.endsWith ((myDropRight p 1).replace "*" "")
  else Id.run do
    let parts := p.splitOn "*" |>.filter (· ≠ "")
    let mut curr := target
    let mut ok := true
    for part in parts do
      let splitted := curr.splitOn part
      if splitted.length <= 1 then
        ok := false
        break
      else
        -- Take the remainder of the string after the FIRST occurrence of 'part'
        curr := String.intercalate part (splitted.drop 1)
    return ok

def matchesAnyGlob (globs : List String) (target : String) : Bool :=
  if globs.isEmpty then true else globs.any (fun pat => globMatch pat target)

-- ==========================================
-- Presentation Data Models
-- ==========================================

structure LitRefData where
  name : Name
  data : LitlibData
  deriving Inhabited

structure TheoremInfo where
  name : Name
  desc : String
  hasSorry : Bool
  litRefs : Array LitRefData
  deriving Inhabited

structure SummaryItem where
  moduleName : Name
  declName : Name
  codeStr : String
  type : String
  desc : String := ""
  deriving Inhabited

structure GlobalData where
  theorems : Array TheoremInfo
  litRefs : Array LitRefData
  summaryItems : Array SummaryItem
  deriving Inhabited

/-- Config state for the CLI action -/
structure CliContext where
  action : String := "dashboard"
  targetTheorems : Bool := false
  targetReferences : Bool := false
  theoremGlobs : List String := []
  referenceGlobs : List String := []

-- ==========================================
-- Source Code Extraction logic 
-- ==========================================

def nameToFilePath : Name → System.FilePath
  | .anonymous => System.FilePath.mk "."
  | .str .anonymous s => System.FilePath.mk s
  | .str p s => nameToFilePath p / s
  | .num p _ => nameToFilePath p

def nameDepth : Name → Nat
  | .anonymous => 0
  | .str p _ => nameDepth p + 1
  | .num p _ => nameDepth p + 1

partial def findOleans (dir : System.FilePath) (pref : Name) : IO (Array Name) := do
  let mut arr := #[]
  try
    for entry in ← dir.readDir do
      if ← entry.path.isDir then
        let nextPref := if pref == Name.anonymous then Name.mkSimple entry.fileName else pref ++ Name.mkSimple entry.fileName
        arr := arr ++ (← findOleans entry.path nextPref)
      else if entry.path.extension == some "olean" then
        if let some stem := entry.path.fileStem then
          let modName := if pref == Name.anonymous then Name.mkSimple stem else pref ++ Name.mkSimple stem
          arr := arr.push modName
  catch _ => pure ()
  return arr

def discoverModules (rootModule : Name) : IO (Array Name) := do
  let sp ← Lean.searchPathRef.get
  let mut allMods := #[]
  
  for p in sp do
    let rootOlean := p / s!"{rootModule}.olean"
    if ← rootOlean.pathExists then
      if !allMods.contains rootModule then allMods := allMods.push rootModule
      
    let rootDir := p / rootModule.toString
    if ← rootDir.isDir then
      let mods ← findOleans rootDir rootModule
      for m in mods do
        if !allMods.contains m then allMods := allMods.push m
        
  if allMods.isEmpty then return #[rootModule] else return allMods

def unionNameSet (a b : NameSet) : NameSet := b.toList.foldl (fun acc x => acc.insert x) a

structure DepResult where
  hasSorry : Bool
  litRefs : NameSet
  localDecls : NameSet
  deriving Inhabited

structure DepState where
  memo : Lean.NameMap DepResult := {}
  visited : NameSet := {}
  deriving Inhabited

abbrev DepM := StateM DepState

partial def findLitRef (env : Environment) (n : Name) : Option Name :=
  if n == Name.anonymous then none
  else if (litlibExt.find? env n).isSome then some n
  else match n with
  | .str p _ => findLitRef env p
  | .num p _ => findLitRef env p
  | _ => none

partial def collectDepsMemo (env : Environment) (n : Name) : DepM DepResult := do
  let s ← get
  if let some res := s.memo.find? n then return res
  if s.visited.contains n then return { hasSorry := false, litRefs := {}, localDecls := {} }
  modify fun s => { s with visited := s.visited.insert n }
  
  if n == `sorryAx then
    let res : DepResult := { hasSorry := true, litRefs := {}, localDecls := {} }
    modify fun s => { s with memo := s.memo.insert n res }
    return res
    
  let isExt := match env.getModuleIdxFor? n with
    | some idx => 
      let modName := env.header.moduleNames[idx.toNat]!
      Name.isPrefixOf `Mathlib modName || Name.isPrefixOf `Lean modName || Name.isPrefixOf `Init modName || Name.isPrefixOf `Std modName || Name.isPrefixOf `Lake modName
    | none => false

  if isExt then return { hasSorry := false, litRefs := {}, localDecls := {} }
    
  let mut res : DepResult := { hasSorry := false, litRefs := {}, localDecls := {} }
  if let some refName := findLitRef env n then
    res := { res with litRefs := res.litRefs.insert refName }
  res := { res with localDecls := res.localDecls.insert n }

  match env.find? n with
  | some info =>
    let mut consts := info.type.foldConsts ({} : NameSet) (fun n acc => acc.insert n)
    if let some v := info.value? then consts := v.foldConsts consts (fun n acc => acc.insert n)
    for c in consts.toList do
      let childRes ← collectDepsMemo env c
      res := { hasSorry := res.hasSorry || childRes.hasSorry, litRefs := unionNameSet res.litRefs childRes.litRefs, localDecls := unionNameSet res.localDecls childRes.localDecls }
  | none => pure ()

  modify fun s => { s with memo := s.memo.insert n res }
  return res

def isAutoGenerated (env : Environment) (n : Name) : Bool :=
  if n.isInternal then true
  else if (env.getProjectionFnInfo? n).isSome then true
  else match n with
  | Name.str _ s =>
    s == "mk" || s == "rec" || s == "casesOn" || s == "injEq" || 
    s == "noConfusionType" || s == "noConfusion" || s == "recOn" || 
    s == "brecOn" || s == "binductionOn" || s == "below" || 
    s == "ndrec" || s == "ndrecOn" || s == "sizeOf_spec" ||
    s.startsWith "match_" || s.contains "match_" || s.startsWith "proof_" || s.startsWith "eq_"
  | Name.num _ _ => true
  | _ => false

def findSourceFile (modName : Name) : IO (Option System.FilePath) := do
  let sp ← Lean.searchPathRef.get
  let relPath := (nameToFilePath modName).withExtension "lean"
  
  -- Attempt 1: Resolve the exact project root by walking backward from the active .olean file
  if let some oleanPath ← Lean.SearchPath.findWithExt sp "olean" modName then
    let mut libDir := oleanPath
    for _ in [0:nameDepth modName] do
      if let some parent := libDir.parent then
        libDir := parent
        
    let mut projRoot := libDir
    if projRoot.fileName == some "lean" then projRoot := projRoot.parent.getD projRoot
    if projRoot.fileName == some "lib" then projRoot := projRoot.parent.getD projRoot
    if projRoot.fileName == some "build" then projRoot := projRoot.parent.getD projRoot
    if projRoot.fileName == some ".lake" then projRoot := projRoot.parent.getD projRoot

    let candidates : Array System.FilePath := #[
      projRoot / relPath,
      projRoot / "src" / relPath,
      projRoot / "lib" / relPath
    ]
    for c in candidates do
      if ← c.pathExists then return some c

  -- Attempt 2: Local blind fallback
  let candidates : Array System.FilePath := #[ relPath, System.FilePath.mk "src" / relPath, System.FilePath.mk "lib" / relPath, System.FilePath.mk "Main.lean" ]
  for p in candidates do if ← p.pathExists then return some p
  
  -- Attempt 3: Lake packages blind fallback
  let packagesDir := System.FilePath.mk ".lake" / "packages"
  if ← packagesDir.isDir then
    for entry in ← packagesDir.readDir do
      let pkgSrcPath := entry.path / relPath
      if ← pkgSrcPath.pathExists then return some pkgSrcPath
      let pkgSrcSrcPath := entry.path / "src" / relPath
      if ← pkgSrcSrcPath.pathExists then return some pkgSrcSrcPath
      
  return none

def extractSourceCode (env : Environment) (n : Name) : CoreM (Option String) := do
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
      if !code.trimAsciiStart.toString.startsWith "/--" then
        code := s!"/--\n{doc.trimAscii.toString}\n-/\n" ++ code
    return some code
  return none

def withPPOptions {α} (x : MetaM α) : MetaM α := do
  let opts := (← getOptions)
    |>.setNat `maxHeartbeats 0 |>.setNat `maxRecDepth 1000000 |>.setNat `pp.maxDepth 1000000
    |>.setNat `pp.maxSteps 1000000 |>.setBool `pp.deepTerms true |>.setBool `pp.notation true
    |>.setBool `pp.proofs false |>.setBool `pp.universes false |>.setBool `pp.fullNames false
    |>.setBool `pp.explicit false |>.setBool `pp.analyze.typeAscription false |>.setBool `pp.match false
  withOptions (fun _ => opts) x

def buildPrefixes (env : Environment) (rootModule : Name) : Array String := Id.run do
  let mut arr := #[]
  let rootStr := rootModule.toString
  for mod in env.header.moduleNames do
    let mStr := mod.toString
    if mStr.startsWith rootStr || mStr.startsWith "Litlib" then arr := arr.push s!"{mStr}."
  if !arr.contains s!"{rootStr}." then arr := arr.push s!"{rootStr}."
  return arr.qsort (fun a b => a.length > b.length)

def cleanTypes (prefixes : Array String) (s : String) : String :=
  let stripped := prefixes.foldl (fun acc p => acc.replace p "") s
  stripped.replace "Complex" "ℂ" |>.replace "Real" "ℝ" |>.replace "failed to pretty print expression (use 'set_option pp.rawOnError true' for raw representation)" "<expression too large>"

def ppSignature (type : Expr) (isStructure : Bool) (prefixes : Array String) : MetaM String := withPPOptions do
  Meta.forallTelescope type fun fvars body => do
    let mut reqs := #[]
    for fvar in fvars do
      let decl ← fvar.fvarId!.getDecl
      if !isStructure && decl.binderInfo == .instImplicit then continue
      let typeStr := cleanTypes prefixes (toString (← Meta.ppExpr decl.type))
      let mut nameStr := decl.userName.eraseMacroScopes.toString
      if nameStr == "a" || nameStr.startsWith "inst" || nameStr == "_" then nameStr := "_"
      if isStructure then
        reqs := reqs.push s!"  {nameStr} : {typeStr}"
      else
        let binderStr := match decl.binderInfo with
          | .implicit => if nameStr == "_" then "{" ++ typeStr ++ "}" else "{" ++ nameStr ++ " : " ++ typeStr ++ "}"
          | .strictImplicit => if nameStr == "_" then "⦃" ++ typeStr ++ "⦄" else "⦃" ++ nameStr ++ " : " ++ typeStr ++ "⦄"
          | _ => if nameStr == "_" then typeStr else "(" ++ nameStr ++ " : " ++ typeStr ++ ")"
        reqs := reqs.push binderStr
    let bodyStr := cleanTypes prefixes (toString (← Meta.ppExpr body))
    if isStructure then return String.intercalate "\n" reqs.toList
    else
      if reqs.isEmpty then return s!" : {bodyStr}" else return s!"{String.intercalate " " reqs.toList} :\n  {bodyStr}"

def ppDeclFallback (env : Environment) (n : Name) (prefixes : Array String) : MetaM String := withPPOptions do
  let docStr := match ← Lean.findDocString? env n with | some doc => s!"/--\n{doc.trimAscii.toString}\n-/\n" | none => ""
  let declStr ← match env.find? n with
    | some (ConstantInfo.thmInfo t) => pure s!"theorem {n.getString!} {← ppSignature t.type false prefixes}"
    | some (ConstantInfo.defnInfo d) => pure s!"def {n.getString!} {← ppSignature d.type false prefixes} := ..."
    | some (ConstantInfo.axiomInfo a) => pure s!"axiom {n.getString!} : {cleanTypes prefixes (toString (← Meta.ppExpr a.type))}"
    | some (ConstantInfo.opaqueInfo o) => pure s!"opaque {n.getString!} : {cleanTypes prefixes (toString (← Meta.ppExpr o.type))}"
    | some (ConstantInfo.inductInfo i) => 
      if Lean.isStructure env n then
        let mut fieldsStr := ""
        match i.ctors with
        | ctor :: _ => if let some (ConstantInfo.ctorInfo c) := env.find? ctor then fieldsStr ← ppSignature c.type true prefixes
        | [] => pure ()
        pure s!"structure {n.getString!} where\n{fieldsStr}"
      else
        let typeStr := cleanTypes prefixes (toString (← Meta.ppExpr i.type))
        let mut ctorStrs := #[]
        for ctor in i.ctors do
          if let some (ConstantInfo.ctorInfo c) := env.find? ctor then
            ctorStrs := ctorStrs.push s!"  | {match ctor with | .str _ s => s | _ => ctor.toString} : {cleanTypes prefixes (toString (← Meta.ppExpr c.type))}"
        pure s!"inductive {n.getString!} : {typeStr}\n{String.intercalate "\n" ctorStrs.toList}"
    | some (ConstantInfo.ctorInfo c) => pure s!"constructor {n.getString!} : {cleanTypes prefixes (toString (← Meta.ppExpr c.type))}"
    | _ => pure s!"declaration {n.getString!}"
  return docStr ++ declStr

def stripProofToSignature (s : String) : String := Id.run do
  let chars := s.toList.toArray
  let mut level := 0; let mut letHaveCount := 0; let mut currentWord : Array Char := #[]; let mut out : Array Char := #[]
  let mut i := 0
  while i < chars.size do
    let c := chars[i]!
    if c.isAlphanum || c == '_' then currentWord := currentWord.push c
    else
      if level == 0 then
        let w := String.ofList currentWord.toList
        if w == "let" || w == "have" || w == "obtain" then letHaveCount := letHaveCount + 1
      currentWord := #[]
    if c == '(' || c == '[' || c == '{' || c == '⦃' then level := level + 1
    else if c == ')' || c == ']' || c == '}' || c == '⦄' then level := level - 1
    if level == 0 && i + 1 < chars.size && chars[i]! == ':' && chars[i+1]! == '=' then
      if letHaveCount > 0 then letHaveCount := letHaveCount - 1
      else return String.ofList out.toList
    out := out.push c; i := i + 1
  return s

def processDecl (env : Environment) (declName : Name) (prefixes : Array String) (isSorry : Bool) : CoreM String := do
  let isDef := match env.find? declName with | some (ConstantInfo.defnInfo _) => true | _ => false
  let isStruct := Lean.isStructure env declName
  let isInduct := match env.find? declName with | some (ConstantInfo.inductInfo _) => true | _ => false
  let isAxiom := match env.find? declName with | some (ConstantInfo.axiomInfo _) => true | _ => false
  let isOpaque := match env.find? declName with | some (ConstantInfo.opaqueInfo _) => true | _ => false
  let appendStatus (base : String) : String := if isAxiom then base ++ " := axiom" else if isOpaque then base ++ " := opaque" else if isSorry then base ++ " := sorry" else base ++ " := ..."

  if let some src ← extractSourceCode env declName then
    if isDef || isStruct || isInduct then return src else return appendStatus (stripProofToSignature src).trimAsciiEnd.toString
  else
    let ast ← Meta.MetaM.run' (ppDeclFallback env declName prefixes)
    if isDef || isStruct || isInduct then return ast else return appendStatus ast.trimAsciiEnd.toString

/-- 
Evaluates the environment inside CoreM based on CLI target config.
-/
def extractAllTheorems (env : Environment) (ctx : CliContext) : CoreM GlobalData := do
  let rootModules := env.header.moduleNames.filter (fun m => !m.toString.startsWith "Litlib")
  let rootModule := if rootModules.isEmpty then `Litlib else rootModules[0]!
  let prefixes := buildPrefixes env rootModule

  let mut processedThms : NameSet := {}
  let mut depState : DepState := {}
  
  let mut theorems := #[]
  let mut globalLitRefs : NameMap LitlibData := {}
  let mut summaryItems := #[]
  let mut renderedNames : NameSet := {}

  -- Helper to reduce boilerplate local definitions extraction
  let extractLocals (n : Name) (currentItems : Array SummaryItem) (currentNames : NameSet) (state : DepState) : CoreM (Array SummaryItem × NameSet × DepState) := do
    let mut updatedItems := currentItems
    let mut updatedNames := currentNames
    let mut updatedState := state
    if let some info := env.find? n then
      let mut consts := info.type.foldConsts ({} : NameSet) (fun c acc => acc.insert c)
      if let some v := info.value? then consts := v.foldConsts consts (fun c acc => acc.insert c)
      for c in consts.toList do
        let isExt := match env.getModuleIdxFor? c with | some idx => let modName := env.header.moduleNames[idx.toNat]!; Name.isPrefixOf `Mathlib modName || Name.isPrefixOf `Lean modName || Name.isPrefixOf `Init modName || Name.isPrefixOf `Std modName || Name.isPrefixOf `Lake modName | none => false
        if !isExt && c != n && findLitRef env c == none && !isAutoGenerated env c then
          if !updatedNames.contains c then
            updatedNames := updatedNames.insert c
            let (cRes, nextState) := (collectDepsMemo env c).run updatedState
            updatedState := nextState
            let code ← processDecl env c prefixes cRes.hasSorry
            let modName := match env.getModuleIdxFor? c with | some idx => env.header.moduleNames[idx.toNat]! | none => `Unknown
            updatedItems := updatedItems.push { moduleName := modName, declName := c, codeStr := code, type := "localDef", desc := "" }
    pure (updatedItems, updatedNames, updatedState)

  -- 1. Grab everything tagged as a Theorem
  let thmKeys := env.constants.fold (fun acc declName _ => match litlibTheoremExt.find? env declName with | some desc => acc.push (declName, desc) | none => acc) #[]
  for (declName, desc) in thmKeys do
    if processedThms.contains declName then continue
    processedThms := processedThms.insert declName

    let (depRes, nextState) := (collectDepsMemo env declName).run depState
    depState := nextState
    
    let mut thmLitRefs := #[]
    for ref in depRes.litRefs.toList do
      if let some data := litlibExt.find? env ref then
        thmLitRefs := thmLitRefs.push { name := ref, data := data }
        if !globalLitRefs.contains ref then globalLitRefs := globalLitRefs.insert ref data

    theorems := theorems.push { name := declName, desc := desc, hasSorry := depRes.hasSorry, litRefs := thmLitRefs }

    if !renderedNames.contains declName then
      renderedNames := renderedNames.insert declName
      let code ← processDecl env declName prefixes depRes.hasSorry
      let modName := match env.getModuleIdxFor? declName with | some idx => env.header.moduleNames[idx.toNat]! | none => `Unknown
      summaryItems := summaryItems.push { moduleName := modName, declName := declName, codeStr := code, type := "theorem", desc := desc }

    for ref in depRes.litRefs.toList do
      if !renderedNames.contains ref then
        renderedNames := renderedNames.insert ref
        let (refRes, nextState) := (collectDepsMemo env ref).run depState
        depState := nextState
        let code ← processDecl env ref prefixes refRes.hasSorry
        let modName := match env.getModuleIdxFor? ref with | some idx => env.header.moduleNames[idx.toNat]! | none => `Unknown
        summaryItems := summaryItems.push { moduleName := modName, declName := ref, codeStr := code, type := "litRef", desc := "" }

    -- Gather local variables explicitly for the theorem
    let (newItems, newNames, newState) ← extractLocals declName summaryItems renderedNames depState
    summaryItems := newItems; renderedNames := newNames; depState := newState

  -- 1.5. Grab everything tagged as a Reference (catches standalone signatures)
  let refKeys : Array Name := env.constants.fold (fun acc declName _ => if (litlibExt.find? env declName).isSome then acc.push declName else acc) (#[] : Array Name)
  for n in refKeys do
    if let some data := litlibExt.find? env n then
      if !globalLitRefs.contains n then globalLitRefs := globalLitRefs.insert n data
      
      let (refRes, nextState) := (collectDepsMemo env n).run depState
      depState := nextState
      
      if !renderedNames.contains n then
        renderedNames := renderedNames.insert n
        let code ← processDecl env n prefixes refRes.hasSorry
        let modName := match env.getModuleIdxFor? n with | some idx => env.header.moduleNames[idx.toNat]! | none => `Unknown
        summaryItems := summaryItems.push { moduleName := modName, declName := n, codeStr := code, type := "litRef", desc := "" }
      
      -- Gather local variables explicitly for the reference
      let (newItems, newNames, newState) ← extractLocals n summaryItems renderedNames depState
      summaryItems := newItems; renderedNames := newNames; depState := newState


  -- 2. Filter the gathered items based on the CLI context and dependency graph
  let mut keptNames : NameSet := {}
  let mut filteredTheorems := #[]
  
  if ctx.targetTheorems then
    for t in theorems do
      if matchesAnyGlob ctx.theoremGlobs t.name.toString then
        filteredTheorems := filteredTheorems.push t
        keptNames := keptNames.insert t.name
        -- Pull in ALL dependencies of this theorem so they render in the summary
        if let some res := depState.memo.find? t.name then
          for r in res.litRefs.toList do keptNames := keptNames.insert r
          for d in res.localDecls.toList do keptNames := keptNames.insert d

  let mut litRefsArr := #[]
  for (n, d) in globalLitRefs.toList do
    let isExplicitlyTargeted := ctx.targetReferences && matchesAnyGlob ctx.referenceGlobs n.toString
    let isDepOfTheorem := keptNames.contains n
    
    if isExplicitlyTargeted || isDepOfTheorem then
      litRefsArr := litRefsArr.push { name := n, data := d }
      if isExplicitlyTargeted then
        keptNames := keptNames.insert n
        -- Pull in local dependencies of this targeted reference
        if let some res := depState.memo.find? n then
          for ld in res.localDecls.toList do keptNames := keptNames.insert ld

  -- Finally, strictly filter the rendered code stubs
  let finalSummary := summaryItems.filter (fun item => keptNames.contains item.declName)

  return { theorems := filteredTheorems, litRefs := litRefsArr, summaryItems := finalSummary }

end Litlib.Core.CLI
