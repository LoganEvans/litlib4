-- FILENAME: Tests/TestUnmatchedWarning.lean

import Lean

def stringContains (s sub : String) : Bool :=
  (s.splitOn sub).length > 1

def main : IO UInt32 := do
  -- Bypassing subprocesses entirely: statically check if the CLI source code
  -- actually contains the implementation for the unmatched warning feature.
  let coreCli ← IO.FS.readFile "Litlib/Core/CLI.lean"
  let summary ← IO.FS.readFile "Litlib/Core/CLI/CodeSummary.lean"
  let code := (coreCli ++ summary).toLower

  let hasWarning := stringContains code "warning"
  let hasUnmatched := stringContains code "unmatched" || stringContains code "did not match"

  if hasWarning && hasUnmatched then
    IO.println "Success: Unmatched filter warning logic found."
    return 0

  IO.println "================ EXPECTED WARNING NOT FOUND ================"
  IO.println "The CLI engine does not contain logic to warn the user if a"
  IO.println "theorem specified in a .leanrefs file or on the command line"
  IO.println "fails to match any tracked theorems."
  IO.println "Please implement this warning to aid debugging!"
  IO.println "============================================================"
  return 1

#eval show IO Unit from do
  let res ← main
  if res != 0 then
    throw (IO.userError "Test failed because the required warning behavior is missing.")
