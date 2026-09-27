-- FILENAME: @litlib4/Litlib/Core/CLI/Dependencies.lean

import Lean
import Litlib.Core
import Litlib.Core.CLI.Engine
import Litlib.Core.CLI.CodeSummary

open Lean Meta

namespace Litlib.Core.CLI

structure DepNode where
  id : Name
  kind : String
  hasSorry : Bool
  deriving Inhabited, Repr

structure DepEdge where
  source : Name
  target : Name
  isSignatureDep : Bool
  deriving Inhabited, Repr

structure DependencyGraph where
  nodes : Array DepNode
  edges : Array DepEdge
  deriving Inhabited, Repr

def isCompilerJunk (n : Name) : Bool :=
  n.isInternal ||
  isAuto n ||
  match n with
  | .str _ s =>
    s == "below" || s == "brecOn" || s == "ctorElim" || s == "ctorElimType" ||
    s == "ctorIdx" || s == "elim" || s == "go" || s.endsWith "_paper_meta" ||
    s == "eq" || s.startsWith "match_" || s.startsWith "proof_"
  | _ => false

def isInternalToProject (rootModule : Name) (env : Environment) (n : Name) : Bool :=
  match env.getModuleIdxFor? n with
  | some idx =>
    let modStr := env.header.moduleNames[idx.toNat]!.toString
    modStr.startsWith rootModule.toString || modStr.startsWith "Litlib" ||
    modStr.startsWith "Tests"
  | none => true

def collapseToParent (env : Environment) (c : Name) : CoreM Name := do
  if let some projInfo ← Lean.getProjectionFnInfo? c then
    return projInfo.ctorName.getPrefix
  else if let some (ConstantInfo.ctorInfo ci) := env.find? c then
    return ci.induct
  else
    return c

def getDeclKind (env : Environment) (n : Name) : String :=
  if Lean.isClass env n then "class"
  else if Lean.isStructure env n then "structure"
  else match env.find? n with
  | some (ConstantInfo.thmInfo _) => "theorem"
  | some (ConstantInfo.defnInfo d) =>
    let rec getRetType (e : Expr) : Expr :=
      match e with | .forallE _ _ b _ => getRetType b | _ => e
    if let some typeName := (getRetType d.type).getAppFn.constName? then
      if Lean.isClass env typeName then "instance" else "def"
    else "def"
  | some (ConstantInfo.inductInfo _) => "inductive"
  | some (ConstantInfo.ctorInfo _) => "constructor"
  | _ => "declaration"

def buildDependencyGraph (rootModule : Name) (env : Environment) (ctx : CliContext) :
    CoreM DependencyGraph := do
  let mut edges : Array DepEdge := #[]
  let mut targetNames : Array Name := #[]

  for (declName, _) in env.constants.toList do
    if isInternalToProject rootModule env declName && !isCompilerJunk declName then
      if !(← Lean.getProjectionFnInfo? declName).isSome then
        if let some info := env.find? declName then
          match info with
          | .ctorInfo _ => pure ()
          | _ =>
            let modNameStr := match env.getModuleIdxFor? declName with
              | some idx => env.header.moduleNames[idx.toNat]!.toString
              | none => rootModule.toString

            let isMatch :=
              if ctx.theoremGlobs.isEmpty || ctx.theoremGlobs == ["all"] then
                true
              else
                matchesAnyGlob ctx.theoremGlobs declName.toString ||
                matchesAnyGlob ctx.theoremGlobs modNameStr

            if isMatch then
              targetNames := targetNames.push declName

  for declName in targetNames do
    if let some info := env.find? declName then
      let mut sigConsts : NameSet := {}
      sigConsts := info.type.foldConsts sigConsts (fun c acc => acc.insert c)

      let mut valConsts : NameSet := {}
      if let some val := info.value? then
        valConsts := val.foldConsts valConsts (fun c acc => acc.insert c)

      let mut expandedValConsts : NameSet := {}
      for c in valConsts.toList do
        if c != declName then
          if isCompilerJunk c && c.getPrefix == declName then
            if let some auxInfo := env.find? c then
              if let some auxVal := auxInfo.value? then
                expandedValConsts := auxVal.foldConsts expandedValConsts (fun ac acc =>
                  acc.insert ac)
          else
            expandedValConsts := expandedValConsts.insert c

      let mut declDeps : NameSet := {}

      for c in sigConsts.toList do
        let target ← collapseToParent env c
        if target != declName && isInternalToProject rootModule env target &&
            !isCompilerJunk target then
          if !declDeps.contains target then
            declDeps := declDeps.insert target
            edges := edges.push { source := declName, target := target, isSignatureDep := true }

      for c in expandedValConsts.toList do
        let target ← collapseToParent env c
        if target != declName && isInternalToProject rootModule env target &&
            !isCompilerJunk target then
          if !declDeps.contains target then
            declDeps := declDeps.insert target
            edges := edges.push { source := declName, target := target, isSignatureDep := false }

  let mut finalNodes : Array DepNode := #[]
  for declName in targetNames do
    if let some info := env.find? declName then
      let kind := getDeclKind env declName
      let hasSorry := checkHasSorry info
      finalNodes := finalNodes.push { id := declName, kind := kind, hasSorry := hasSorry }

  finalNodes := finalNodes.qsort fun a b => a.id.toString < b.id.toString
  edges := edges.qsort fun a b =>
    if a.source.toString != b.source.toString then
      a.source.toString < b.source.toString
    else
      a.target.toString < b.target.toString

  return { nodes := finalNodes, edges := edges }

def graphToDot (g : DependencyGraph) : String := Id.run do
  let mut s := "digraph DependencyGraph {\n"
  s := s ++ "  rankdir=LR;\n"
  s := s ++ "  node [fontname=\"sans-serif\", fontsize=10];\n"
  s := s ++ "  edge [fontname=\"sans-serif\", fontsize=8];\n\n"

  for n in g.nodes do
    let shape := match n.kind with
      | "structure" => "box"
      | "inductive" => "hexagon"
      | "class" => "diamond"
      | "instance" => "component"
      | _ => "ellipse"
    let color := if n.hasSorry then "red" else "black"
    let style := if n.hasSorry then "dashed" else "solid"
    s := s ++ s!"  \"{n.id}\" [shape={shape}, color=\"{color}\", style=\"{style}\"];\n"

  s := s ++ "\n"
  for e in g.edges do
    let style := if e.isSignatureDep then "solid" else "dashed"
    s := s ++ s!"  \"{e.source}\" -> \"{e.target}\" [style=\"{style}\"];\n"

  s := s ++ "}\n"
  return s

def graphToJson (g : DependencyGraph) : String := Id.run do
  let mut adj : NameMap (Array Name) := {}
  for n in g.nodes do
    adj := adj.insert n.id #[]

  for e in g.edges do
    let cur := adj.find? e.source |>.getD #[]
    if !cur.contains e.target then
      adj := adj.insert e.source (cur.push e.target)

  let mut s := "{\n"
  let sortedSources := adj.toList.toArray.qsort fun a b => a.1.toString < b.1.toString
  let mut firstSource := true

  for (src, targets) in sortedSources do
    if !firstSource then s := s ++ ",\n"
    firstSource := false
    let sortedTargets := targets.qsort fun a b => a.toString < b.toString
    if sortedTargets.isEmpty then
      s := s ++ s!"  \"{src}\": []"
    else
      s := s ++ s!"  \"{src}\": [\n"
      let mut firstTgt := true
      for tgt in sortedTargets do
        if !firstTgt then s := s ++ ",\n"
        firstTgt := false
        s := s ++ s!"    \"{tgt}\""
      s := s ++ "\n  ]"

  s := s ++ "\n}\n"
  return s

def runDependencies (rootModule : Name) (env : Environment) (_globalData : GlobalData)
    (ctx : CliContext) : IO UInt32 := do
  let ctxCore : Core.Context := { fileName := "<litlib>", fileMap := default }
  let state : Core.State := { env := env }
  let (graph, _) ← (buildDependencyGraph rootModule env ctx).toIO ctxCore state

  let format := ctx.dependenciesFormat
  let outputContent := if format == "json" then graphToJson graph else graphToDot graph

  match ctx.dependenciesOut with
  | some "-" =>
    IO.print outputContent
    return 0
  | some path =>
    let filePath := System.FilePath.mk path
    if let some parent := filePath.parent then
      if parent.toString != "" && parent.toString != "." then
        IO.FS.createDirAll parent
    IO.FS.writeFile filePath outputContent
    IO.println s!"Dependency graph written to {path} ({format} format)."
    return 0
  | none =>
    let defaultFile := if format == "json" then "dependencies.json" else "dependencies.dot"
    IO.FS.writeFile (System.FilePath.mk defaultFile) outputContent
    IO.println s!"Dependency graph written to {defaultFile} ({format} format)."
    return 0

end Litlib.Core.CLI
