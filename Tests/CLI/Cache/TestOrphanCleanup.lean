-- FILENAME: Tests/CLI/Cache/TestOrphanCleanup.lean

import Lean
import Litlib.Core.CLI

open Lean Litlib.Core.CLI

def main : IO UInt32 := do
  Lean.initSearchPath (← Lean.findSysroot)
  let mut sp ← Lean.searchPathRef.get
  let buildLib := System.FilePath.mk ".lake" / "build" / "lib" / "lean"
  if !(sp.contains buildLib) then
    Lean.searchPathRef.set (buildLib :: sp)

  -- Create a fake orphaned .olean module
  let fakeDir := buildLib / "Tests" / "Fixtures" / "OrphanTest"
  IO.FS.createDirAll fakeDir
  let fakeOlean := fakeDir / "GhostModule.olean"
  IO.FS.writeFile fakeOlean "FAKE CONTENT"

  -- discoverModules should filter out modules whose .lean source file does not exist
  let discovered ← discoverModules `Tests
  let discoveredNames := discovered.toList.map (·.toString)

  let containsGhost := discoveredNames.contains "Tests.Fixtures.OrphanTest.GhostModule"

  -- Clean up fake directory
  try IO.FS.removeFile fakeOlean catch _ => pure ()
  try IO.FS.removeDir fakeDir catch _ => pure ()

  if containsGhost then
    IO.println "[FAIL] discoverModules returned orphaned module 'GhostModule' that has no .lean source."
    return 1

  IO.println "Success: Orphan cache filtering passed."
  return 0

#eval show IO Unit from do
  let res ← main
  if res != 0 then
    throw (IO.userError "Orphan cleanup assertions failed.")
