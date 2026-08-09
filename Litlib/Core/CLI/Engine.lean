-- FILENAME: Litlib/Core/CLI/Engine.lean

import Lean
import Litlib.Core

open Lean

namespace Litlib.Core.CLI

structure ProofInfo where
  declName : Name
  hasSorry : Bool
  deriving Inhabited

structure EquationInfo where
  declName : Name
  data : LitlibEqData
  proofs : Array ProofInfo
  deriving Inhabited

structure PaperInfo where
  paperId : Name
  data : LitlibData
  equations : Array EquationInfo
  deriving Inhabited

structure TheoremDep where
  eqName : Name
  paperId : String
  paperTitle : String
  eqNum : String
  isProved : Bool
  deriving Inhabited

structure StandaloneTheoremInfo where
  declName : Name
  desc : String
  hasSorry : Bool
  deps : Array TheoremDep
  isDef : Bool := false
  deriving Inhabited

structure GlobalData where
  papers : Array PaperInfo
  theorems : Array StandaloneTheoremInfo
  deriving Inhabited

structure CliContext where
  action : String := "dashboard"
  targetTheorems : Bool := false
  targetReferences : Bool := false
  theoremGlobs : List String := []
  referenceGlobs : List String := []
  litlibTheoremsOnly : Bool := false
  latexDir : Option String := none
  explicitFilters : Bool := false

def myDropRight (s : String) (n : Nat) : String :=
  let chars := s.toList
  if chars.length <= n then "" else String.ofList (chars.take (chars.length - n))

def myDropLeft (s : String) (n : Nat) : String :=
  String.ofList (s.toList.drop n)

def globMatch (pat target : String) : Bool :=
  let p := pat.trimAscii.toString.replace ".*" "*"
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
        curr := String.intercalate part (splitted.drop 1)
    return ok

def matchesAnyGlob (globs : List String) (target : String) : Bool :=
  if globs.isEmpty then false else globs.any (fun pat => globMatch pat target)

def hasSorryInExpr (e : Expr) : Bool :=
  e.foldConsts false fun n b => b || n == ``sorryAx

def checkHasSorry (info : ConstantInfo) : Bool :=
  match info.value? with
  | some v => hasSorryInExpr v
  | none =>
    match info with
    | ConstantInfo.axiomInfo _ => true
    | ConstantInfo.opaqueInfo _ => true
    | _ => false

def extractAllTheorems (env : Environment) (ctx : CliContext) : CoreM GlobalData := do
  let mut finalPaperMap : NameMap PaperInfo := {}
  let mut eqMap : NameMap EquationInfo := {}

  -- 1. Discover Papers
  for (declName, _) in env.constants.toList do
    if let some paperData := litlibPaperExt.find? env declName then
      let pId := Name.mkSimple paperData.id
      finalPaperMap := finalPaperMap.insert pId { paperId := pId, data := paperData, equations := #[] }

  -- 2. Discover Equations
  for (declName, _) in env.constants.toList do
    if let some eqData := litlibEqExt.find? env declName then
      eqMap := eqMap.insert declName { declName := declName, data := eqData, proofs := #[] }

  -- 3. Discover Proofs for the Equations
  for (declName, info) in env.constants.toList do
    let targetName := info.type.getAppFn.constName?
    if let some tn := targetName then
      let isAuto :=
        declName.isInternal ||
        (match declName with
        | .str _ s => s == "mk" || s == "rec" || s == "casesOn" || s == "recOn" || s == "noConfusion" || s == "noConfusionType" || s == "injEq"
        | _ => false)
      if !isAuto && declName != tn then
        if let some eInfo := eqMap.find? tn then
          let hSorry := checkHasSorry info
          let newEInfo := { eInfo with proofs := eInfo.proofs.push { declName := declName, hasSorry := hSorry } }
          eqMap := eqMap.insert tn newEInfo

  -- 4. Discover Standalone Theorems, Definitions, and their Equation Dependencies
  let mut standaloneTheorems : Array StandaloneTheoremInfo := #[]
  for (declName, info) in env.constants.toList do
    if let some desc := litlibTrackExt.find? env declName then
      let isDef := match info with | .thmInfo _ => false | _ => true
      let hSorry := checkHasSorry info

      let mut usedConsts : NameSet := {}
      usedConsts := info.type.foldConsts usedConsts (fun c acc => acc.insert c)
      if let some v := info.value? then
        usedConsts := v.foldConsts usedConsts (fun c acc => acc.insert c)

      let mut deps : Array TheoremDep := #[]
      for c in usedConsts.toList do
        if let some eInfo := eqMap.find? c then
          let isProved := !eInfo.proofs.isEmpty && eInfo.proofs.any (fun p => !p.hasSorry)
          let pIdName := Name.mkSimple eInfo.data.paperId
          let pTitle := if let some pInfo := finalPaperMap.find? pIdName then pInfo.data.title else "Unknown Paper"

          if !(deps.any fun d => d.eqName == c) then
            deps := deps.push {
              eqName := c
              paperId := eInfo.data.paperId
              paperTitle := pTitle
              eqNum := eInfo.data.eqNum
              isProved := isProved
            }

      standaloneTheorems := standaloneTheorems.push {
        declName := declName,
        desc := desc,
        hasSorry := hSorry,
        deps := deps,
        isDef := isDef
      }

  -- 5. Nest Equations under Papers
  for (_, eqInfo) in eqMap.toList do
    let pId := Name.mkSimple eqInfo.data.paperId
    if let some pInfo := finalPaperMap.find? pId then
      let newPInfo := { pInfo with equations := pInfo.equations.push eqInfo }
      finalPaperMap := finalPaperMap.insert pId newPInfo

  let mut finalPapers := #[]
  for (_, p) in finalPaperMap.toList do
    finalPapers := finalPapers.push p

  finalPapers := finalPapers.qsort fun a b =>
    if a.data.year != b.data.year then a.data.year < b.data.year
    else a.data.title < b.data.title

  -- 6. Apply User Filters
  let mut filteredTheorems := #[]
  if ctx.targetTheorems then
    for thm in standaloneTheorems do
      let modNameStr := match env.getModuleIdxFor? thm.declName with
        | some idx => env.header.moduleNames[idx.toNat]!.toString
        | none => ""
      if matchesAnyGlob ctx.theoremGlobs thm.declName.toString || matchesAnyGlob ctx.theoremGlobs modNameStr then
        filteredTheorems := filteredTheorems.push thm

  let mut filteredPapers := #[]
  if ctx.targetReferences then
    for p in finalPapers do
      let paperMatches := matchesAnyGlob ctx.referenceGlobs p.paperId.toString
      let mut keptEqs := #[]
      for eq in p.equations do
        let modNameStr := match env.getModuleIdxFor? eq.declName with
          | some idx => env.header.moduleNames[idx.toNat]!.toString
          | none => ""
        if paperMatches || matchesAnyGlob ctx.referenceGlobs eq.declName.toString || matchesAnyGlob ctx.referenceGlobs modNameStr then
          keptEqs := keptEqs.push eq
      if paperMatches || !keptEqs.isEmpty then
        filteredPapers := filteredPapers.push { p with equations := if paperMatches then p.equations else keptEqs }

  return { papers := filteredPapers, theorems := filteredTheorems }

end Litlib.Core.CLI
