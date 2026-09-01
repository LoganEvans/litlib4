-- FILENAME: Tests/CLI/Summary/TestStructureSafety.lean

import Lean
import Litlib.Core.CLI

open Lean Litlib.Core.CLI

def stringContains (s sub : String) : Bool :=
  (s.splitOn sub).length > 1

def countOccurrences (s sub : String) : Nat :=
  let parts := s.splitOn sub
  if parts.isEmpty then 0 else parts.length - 1

def main : IO UInt32 := do
  Lean.initSearchPath (← Lean.findSysroot)
  let mut sp ← Lean.searchPathRef.get
  let buildLib := System.FilePath.mk ".lake" / "build" / "lib" / "lean"
  if !(sp.contains buildLib) then
    Lean.searchPathRef.set (buildLib :: sp)

  let env ← importModules #[{ module := `Tests.Fixtures.StructureSafety }] {}
  let ctx : CliContext := {
    action := "code-summary",
    theoremGlobs := ["Tests.Fixtures.StructureSafety.*"],
    referenceGlobs := ["Tests.Fixtures.StructureSafety.*"],
    explicitFilters := true
  }

  let ctxCore : Core.Context := { fileName := "<litlib>", fileMap := default }
  let state : Core.State := { env := env }

  let (roots, _) ← (gatherRoots `Tests.Fixtures.StructureSafety { papers := #[], theorems := #[] } ctx).toIO ctxCore state
  let (allConsts, _) ← (collectLocalDepsRec `Tests.Fixtures.StructureSafety roots.toList roots).toIO ctxCore state

  let constNames := allConsts.toList.map (·.toString)

  -- Check if projection functions (e.g. GeometricSpace.dim) were collected as standalone items
  let leakedProjections := constNames.filter (fun c =>
    c == "Tests.Fixtures.StructureSafety.GeometricSpace.dim" ||
    c == "Tests.Fixtures.StructureSafety.GeometricSpace.is_positive" ||
    c == "Tests.Fixtures.StructureSafety.GeometricSpace.volume_form")

  if !leakedProjections.isEmpty then
    IO.println s!"[FAIL] Structure projections collected as standalone decls: {leakedProjections}"
    return 1

  IO.println "Success: Structure safety and projection filtering passed."
  return 0

#eval show IO Unit from do
  let res ← main
  if res != 0 then
    throw (IO.userError "Structure safety assertions failed.")
