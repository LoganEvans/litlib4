-- FILENAME: Tests/CLI/Dashboard/TestDashboardHierarchy.lean

import Lean
import Litlib.Core.CLI

open Lean Litlib.Core.CLI

def main : IO UInt32 := do
  Lean.initSearchPath (← Lean.findSysroot)
  let mut sp ← Lean.searchPathRef.get
  let buildLib := System.FilePath.mk ".lake" / "build" / "lib" / "lean"
  if !(sp.contains buildLib) then
    Lean.searchPathRef.set (buildLib :: sp)

  let env ← importModules #[{ module := `Tests.Fixtures.LiteratureMock }] {}
  let ctx := parseArgs ["--dashboard"]
  let ctxCore : Core.Context := { fileName := "<litlib>", fileMap := default }
  let state : Core.State := { env := env }

  let (globalData, _) ← (extractAllTheorems env ctx).toIO ctxCore state

  let mockPaperOpt := globalData.papers.find? (fun p => p.paperId.toString == "mock1984spacetime")
  if mockPaperOpt.isNone then
    IO.println "[FAIL] Paper 'mock1984spacetime' was not discovered in environment."
    return 1

  let mockPaper := mockPaperOpt.get!
  if mockPaper.equations.size != 2 then
    IO.println s!"[FAIL] Expected 2 equations under paper, found: {mockPaper.equations.size}"
    return 1

  let thmOpt := globalData.theorems.find? (fun t => t.declName.toString.endsWith "mockMetricSoundness")
  if thmOpt.isNone then
    IO.println "[FAIL] Standalone theorem 'mockMetricSoundness' was not discovered."
    return 1

  let thm := thmOpt.get!
  if thm.deps.size != 2 then
    IO.println s!"[FAIL] Expected 2 literature dependencies on theorem, found: {thm.deps.size}"
    return 1

  IO.println "Success: Dashboard hierarchy and literature dependency tests passed."
  return 0

#eval show IO Unit from do
  let res ← main
  if res != 0 then
    throw (IO.userError "Dashboard hierarchy assertions failed.")
