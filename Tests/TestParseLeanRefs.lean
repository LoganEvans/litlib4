-- FILENAME: Tests/TestParseLeanRefs.lean

import Litlib.Core.CLI
import Lean

def main : IO UInt32 := do
  let fakeDir := "Tests/Artifacts"
  IO.FS.createDirAll fakeDir
  let fakeFile := s!"{fakeDir}/litlib.leanrefs"

  -- Simulating a dirty LaTeX environment with Windows carriage returns
  let content :=
    "\\relax\r\n" ++
    "CGK.Gravity.algebraicYangMillsEquivalence\r\n" ++
    "% A commented theorem\n"

  IO.FS.writeFile fakeFile content

  let refs ← Litlib.Core.CLI.parseLeanRefs (System.FilePath.mk fakeFile)

  if refs.length != 1 || refs.head! != "CGK.Gravity.algebraicYangMillsEquivalence" then
    IO.println "================ PARSE ERROR ================"
    IO.println s!"parseLeanRefs failed to extract the exact name properly! Got: {refs}"
    IO.println "==========================================="
    return 1

  if !Litlib.Core.CLI.matchesAnyGlob refs "CGK.Gravity.algebraicYangMillsEquivalence" then
    IO.println "================ GLOB MATCH ERROR ================"
    IO.println "matchesAnyGlob failed to validate the exact string match!"
    IO.println "==========================================="
    return 1

  IO.println "Success: parseLeanRefs works correctly."
  return 0

#eval show IO Unit from do
  let res ← main
  if res != 0 then
    throw (IO.userError "Test failed due to string parsing error.")
