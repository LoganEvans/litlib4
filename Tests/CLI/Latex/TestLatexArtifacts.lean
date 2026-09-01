-- FILENAME: Tests/CLI/Latex/TestLatexArtifacts.lean

import Lean
import Litlib.Core.CLI
import Tests.Fixtures.LiteratureMock

open Lean Litlib.Core.CLI

def stringContains (s sub : String) : Bool :=
  (s.splitOn sub).length > 1

def main : IO UInt32 := do
  let fakeDir := System.FilePath.mk "Tests/Artifacts/LatexTest"
  IO.FS.createDirAll fakeDir

  Lean.initSearchPath (← Lean.findSysroot)
  let mut sp ← Lean.searchPathRef.get
  let buildLib := System.FilePath.mk ".lake" / "build" / "lib" / "lean"
  if !(sp.contains buildLib) then
    Lean.searchPathRef.set (buildLib :: sp)

  let env ← importModules #[{ module := `Tests.Fixtures.LiteratureMock }] {}
  let ctx : CliContext := {
    action := "code-summary",
    latexDir := some fakeDir.toString,
    litlibTheoremsOnly := true,
    targetTheorems := true,
    theoremGlobs := ["all"],
    targetReferences := true,
    referenceGlobs := ["all"]
  }

  let ctxCore : Core.Context := { fileName := "<litlib>", fileMap := default }
  let state : Core.State := { env := env }

  let (globalData, _) ← (extractAllTheorems env ctx).toIO ctxCore state
  let res ← runCodeSummary `Tests.Fixtures.LiteratureMock env globalData ctx
  if res != 0 then
    IO.println "[FAIL] runCodeSummary failed for LaTeX artifact generation."
    return 1

  let styFile := fakeDir / "litlib.sty"
  let texFile := fakeDir / "litlib-code-summary.tex"
  let bibFile := fakeDir / "litlib-references.bib"

  if !(← styFile.pathExists) then
    IO.println "[FAIL] litlib.sty was not generated."
    return 1
  if !(← texFile.pathExists) then
    IO.println "[FAIL] litlib-code-summary.tex was not generated."
    return 1
  if !(← bibFile.pathExists) then
    IO.println "[FAIL] litlib-references.bib was not generated."
    return 1

  let bibContent ← IO.FS.readFile bibFile
  if !stringContains bibContent "@article{mock1984spacetime" then
    IO.println s!"[FAIL] BibTeX missing mock1984spacetime entry:\n{bibContent}"
    return 1

  let texContent ← IO.FS.readFile texFile
  if !stringContains texContent "§\\phantomsection\\label{lean:" then
    IO.println "[FAIL] litlib-code-summary.tex missing LaTeX phantomsection labels."
    return 1

  IO.println "Success: LaTeX artifact tests passed."
  return 0

#eval show IO Unit from do
  let res ← main
  if res != 0 then
    throw (IO.userError "LaTeX artifact assertions failed.")
