-- FILENAME: Tests/CLI/Lint/TestLinters.lean

import Lean
import Litlib.Core.CLI
import Litlib.Core.CLI.Lint

open Lean Litlib.Core.CLI

def stringContains (s sub : String) : Bool :=
  (s.splitOn sub).length > 1

def main : IO UInt32 := do
  Lean.initSearchPath (← Lean.findSysroot)
  let mut sp ← Lean.searchPathRef.get
  let buildLib := System.FilePath.mk ".lake" / "build" / "lib" / "lean"
  if !(sp.contains buildLib) then
    Lean.searchPathRef.set (buildLib :: sp)

  let env ← importModules #[{ module := `Tests.Fixtures.LeafAndLintFixture }] {}

  let ctx := parseArgs ["--lint", "--theorem=LeafAndLintFixture"]
  let ctxCore : Core.Context := { fileName := "<litlib>", fileMap := default }
  let state : Core.State := { env := env }
  let (globalData, _) ← (extractAllTheorems env ctx).toIO ctxCore state

  let issues ← runLinters `Tests env globalData ctx

  -- 1. untracked-leaf linter
  let leafIssues := issues.filter (fun i => i.linterName == "untracked-leaf")
  if !leafIssues.any (fun i => i.declName == some `Tests.Fixtures.untrackedDeadLeaf) then
    IO.println "[FAIL] untracked-leaf linter missed untrackedDeadLeaf"
    return 1
  if leafIssues.any (fun i => i.declName == some `Tests.Fixtures.trackedCulminationLeaf) then
    IO.println "[FAIL] untracked-leaf linter falsely flagged trackedCulminationLeaf"
    return 1
  if leafIssues.any (fun i => i.declName == some `Tests.Fixtures.untrackedUsedHelper) then
    IO.println "[FAIL] untracked-leaf linter falsely flagged untrackedUsedHelper (uses=1)"
    return 1
  -- Check that transitive dead helper `deadHelperOnlyUsedByDeadLeaf` is reported in the issue message
  let deadLeafIssue := leafIssues.find? (fun i => i.declName == some `Tests.Fixtures.untrackedDeadLeaf)
  if deadLeafIssue.isNone || !stringContains deadLeafIssue.get!.message "deadHelperOnlyUsedByDeadLeaf" then
    IO.println "[FAIL] untracked-leaf linter did not report transitive dead helper deadHelperOnlyUsedByDeadLeaf"
    return 1

  -- 2. duplicate-type linter
  let dupIssues := issues.filter (fun i => i.linterName == "duplicate-type")
  if !dupIssues.any (fun i =>
      stringContains i.message "dupTheoremAlpha" && stringContains i.message "dupTheoremBeta") then
    IO.println "[FAIL] duplicate-type linter missed alpha-equivalent dupTheoremAlpha / dupTheoremBeta"
    return 1
  if dupIssues.any (fun i =>
      stringContains i.message "FixtureStruct" || stringContains i.message "AnotherFixtureStruct") then
    IO.println "[FAIL] duplicate-type linter falsely flagged structures with Type sort"
    return 1

  -- 3. namespace-folder-match linter
  let nsIssues := issues.filter (fun i => i.linterName == "namespace-folder-match")
  if !nsIssues.any (fun i => i.declName == some `Tests.Fixtures.LeafAndLintFixture.badFilenameNsDecl) then
    IO.println "[FAIL] namespace-folder-match linter missed badFilenameNsDecl (filename included in namespace)"
    return 1
  if !nsIssues.any (fun i => i.declName == some `WrongFolder.Sub.badFolderNsDecl) then
    IO.println "[FAIL] namespace-folder-match linter missed badFolderNsDecl (wrong folder namespace)"
    return 1
  if nsIssues.any (fun i => i.declName == some `Tests.Fixtures.FixtureStruct.double) then
    IO.println "[FAIL] namespace-folder-match linter falsely flagged valid structure method FixtureStruct.double"
    return 1
  if nsIssues.any (fun i => i.declName == some `Tests.Fixtures.trackedCulminationLeaf) then
    IO.println "[FAIL] namespace-folder-match linter falsely flagged valid folder namespace declaration"
    return 1

  -- 4. line-length linter (> 100 chars)
  let lineLenIssues := issues.filter (fun i => i.linterName == "line-length")
  if lineLenIssues.isEmpty then
    IO.println "[FAIL] line-length linter missed >100 character line in LeafAndLintFixture.lean"
    return 1

  -- 5. unexplained-options linter
  let optIssues := issues.filter (fun i => i.linterName == "unexplained-options")
  if optIssues.size != 1 then
    IO.println s!"[FAIL] unexplained-options linter expected exactly 1 issue (the unexplained 300000 bump), got {optIssues.size}"
    return 1
  if !stringContains optIssues[0]!.message "300000" then
    IO.println s!"[FAIL] unexplained-options flagged wrong line: {optIssues[0]!.message}"
    return 1

  -- 6. Check selective linter filtering (`--lint=namespace-folder-match`)
  let ctxOnlyNs := parseArgs ["--lint=namespace-folder-match", "--theorem=LeafAndLintFixture"]
  let nsOnlyIssues ← runLinters `Tests env globalData ctxOnlyNs
  if nsOnlyIssues.isEmpty || nsOnlyIssues.any (fun i => i.linterName != "namespace-folder-match") then
    IO.println "[FAIL] --lint=namespace-folder-match did not filter exclusively to namespace-folder-match"
    return 1

  -- 7. Check `runLint` exits with code 0
  let exitCode ← runLint `Tests env globalData ctxOnlyNs
  if exitCode != 0 then
    IO.println s!"[FAIL] runLint returned non-zero exit code: {exitCode}"
    return 1

  IO.println "Success: All modular linter assertions passed."
  return 0

#eval show IO Unit from do
  let res ← main
  if res != 0 then
    throw (IO.userError "Modular linter assertions failed.")
