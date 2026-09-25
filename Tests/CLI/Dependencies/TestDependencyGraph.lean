-- FILENAME: Tests/CLI/Dependencies/TestDependencyGraph.lean


import Lean
import Litlib.Core.CLI
import Litlib.Core.CLI.Dependencies

open Lean Litlib.Core.CLI

def main : IO UInt32 := do
  Lean.initSearchPath (← Lean.findSysroot)
  let mut sp ← Lean.searchPathRef.get
  let buildLib := System.FilePath.mk ".lake" / "build" / "lib" / "lean"
  if !(sp.contains buildLib) then
    Lean.searchPathRef.set (buildLib :: sp)

  -- Import the dependency graph fixtures
  let env ← importModules #[
    { module := `Tests.Fixtures.DependencyGraph.BaseDefs },
    { module := `Tests.Fixtures.DependencyGraph.MidDefs },
    { module := `Tests.Fixtures.DependencyGraph.TopTheorems }
  ] {}

  let ctxCore : Core.Context := { fileName := "<litlib>", fileMap := default }
  let state : Core.State := { env := env }

  let ctx : CliContext := {
    action := "dependencies",
    targetTheorems := true,
    theoremGlobs := ["Tests.Fixtures.DependencyGraph.*"]
  }

  let (graph, _) ← (buildDependencyGraph `Tests env ctx).toIO ctxCore state

  -- Check 1: Key declarations are present as nodes across all three strata
  let nodeIds := graph.nodes.map (·.id.toString)
  let expectedNodes := [
    "Tests.Fixtures.DependencyGraph.TopTheorems.topTheoremC",
    "Tests.Fixtures.DependencyGraph.TopTheorems.topSignatureProofSeparation",
    "Tests.Fixtures.DependencyGraph.TopTheorems.topLitlibConsumer",
    "Tests.Fixtures.DependencyGraph.TopTheorems.topIncompleteSorry",
    "Tests.Fixtures.DependencyGraph.TopTheorems.topMathlibBoundary",
    "Tests.Fixtures.DependencyGraph.MidDefs.midTheoremA",
    "Tests.Fixtures.DependencyGraph.MidDefs.midTheoremB",
    "Tests.Fixtures.DependencyGraph.MidDefs.MidConfig",
    "Tests.Fixtures.DependencyGraph.BaseDefs.baseTheoremZ",
    "Tests.Fixtures.DependencyGraph.BaseDefs.baseHelper",
    "Tests.Fixtures.DependencyGraph.BaseDefs.BaseConfig",
    "Tests.Fixtures.DependencyGraph.BaseDefs.BaseCell"
  ]
  for exp in expectedNodes do
    if !nodeIds.contains exp then
      IO.println s!"[FAIL] Missing expected node: {exp}"
      return 1

  -- Check 2: Direct dependency edges (Immediate, not collapsed)
  let thmC := `Tests.Fixtures.DependencyGraph.TopTheorems.topTheoremC
  let thmCDeps := graph.edges.filter (fun e => e.source == thmC) |>.map (·.target)

  if !thmCDeps.contains `Tests.Fixtures.DependencyGraph.MidDefs.midTheoremA then
    IO.println "[FAIL] topTheoremC missing direct edge to midTheoremA"
    return 1
  if !thmCDeps.contains `Tests.Fixtures.DependencyGraph.MidDefs.midTheoremB then
    IO.println "[FAIL] topTheoremC missing direct edge to midTheoremB"
    return 1

  -- topTheoremC must NOT directly depend on baseTheoremZ (transitive through midTheoremA)
  if thmCDeps.contains `Tests.Fixtures.DependencyGraph.BaseDefs.baseTheoremZ then
    IO.println "[FAIL] topTheoremC falsely contains direct edge to baseTheoremZ (transitive leak)"
    return 1

  -- midTheoremA must directly depend on baseTheoremZ
  let thmA := `Tests.Fixtures.DependencyGraph.MidDefs.midTheoremA
  let thmADeps := graph.edges.filter (fun e => e.source == thmA) |>.map (·.target)
  if !thmADeps.contains `Tests.Fixtures.DependencyGraph.BaseDefs.baseTheoremZ then
    IO.println "[FAIL] midTheoremA missing direct edge to baseTheoremZ"
    return 1

  -- Check 3: Signature vs Proof dependency separation
  let sigSep := `Tests.Fixtures.DependencyGraph.TopTheorems.topSignatureProofSeparation
  let sigEdges := graph.edges.filter (fun e => e.source == sigSep && e.isSignatureDep)
  let valEdges := graph.edges.filter (fun e => e.source == sigSep && !e.isSignatureDep)

  let sigTargets := sigEdges.map (·.target.toString)
  let valTargets := valEdges.map (·.target.toString)

  if !sigTargets.any (fun s => s.contains "MidConfig") then
    IO.println "[FAIL] topSignatureProofSeparation missing MidConfig in signature deps"
    return 1
  if !valTargets.contains "Tests.Fixtures.DependencyGraph.MidDefs.midTheoremA" then
    IO.println "[FAIL] topSignatureProofSeparation missing midTheoremA in proof deps"
    return 1

  -- Check 4: Proof completeness / sorry tracking
  let incThm := `Tests.Fixtures.DependencyGraph.TopTheorems.topIncompleteSorry
  let sorryNode := graph.nodes.find? (fun n => n.id == incThm)
  if sorryNode.isNone || !sorryNode.get!.hasSorry then
    IO.println "[FAIL] topIncompleteSorry not flagged with hasSorry = true"
    return 1

  let soundThm := `Tests.Fixtures.DependencyGraph.TopTheorems.topTheoremC
  let soundNode := graph.nodes.find? (fun n => n.id == soundThm)
  if soundNode.isNone || soundNode.get!.hasSorry then
    IO.println "[FAIL] topTheoremC falsely flagged with hasSorry = true"
    return 1

  -- Check 5: Mathlib / Core boundary cutoff (No external nodes should exist in graph.nodes)
  let externalLeaked := graph.nodes.any (fun n => n.id == `Nat.add_comm || n.id == `Eq)
  if externalLeaked then
    IO.println "[FAIL] Core/Mathlib constants were included in graph nodes"
    return 1

  -- Check 6: Output serialization smoke test (clean minimal JSON dictionary)
  let dotOut := graphToDot graph
  if !dotOut.contains "digraph" || !dotOut.contains "topTheoremC" then
    IO.println "[FAIL] graphToDot output malformed"
    return 1

  let jsonOut := graphToJson graph
  if !jsonOut.contains "topTheoremC" || !jsonOut.contains "midTheoremA" then
    IO.println "[FAIL] graphToJson output missing expected dependency entries"
    return 1

  -- Ensure JSON does NOT leak Core/Mathlib plumbing
  if jsonOut.contains "Nat.add_comm" || jsonOut.contains "congrArg" || jsonOut.contains "brecOn" then
    IO.println "[FAIL] graphToJson contains leaked Mathlib/Core boundary constants"
    return 1

  IO.println "Success: Dependency graph analysis tests passed."
  return 0

#eval show IO Unit from do
  let res ← main
  if res != 0 then
    throw (IO.userError "Dependency graph assertions failed.")
