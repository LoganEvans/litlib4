-- FILENAME: Tests/CLI/Outline/TestOutline.lean

import Lean
import Litlib.Core.CLI
import Litlib.Core.CLI.Outline

open Lean Litlib.Core.CLI

def stringContains (s sub : String) : Bool :=
  (s.splitOn sub).length > 1

def main : IO UInt32 := do
  Lean.initSearchPath (← Lean.findSysroot)
  let mut sp ← Lean.searchPathRef.get
  let buildLib := System.FilePath.mk ".lake" / "build" / "lib" / "lean"
  if !(sp.contains buildLib) then
    Lean.searchPathRef.set (buildLib :: sp)

  let env ← importModules #[
    { module := `Tests.Fixtures.LeafAndLintFixture },
    { module := `Tests.Fixtures.DependencyGraph.BaseDefs }
  ] {}

  let ctxCore : Core.Context := { fileName := "<litlib>", fileMap := default }
  let state : Core.State := { env := env }

  -- 1. Test `--outline=LeafAndLintFixture`
  let ctxOutline := parseArgs ["--outline=LeafAndLintFixture"]
  let (dataOutline, _) ← (extractAllTheorems env ctxOutline).toIO ctxCore state
  let outlineStr ← formatOutline `Tests env dataOutline ctxOutline

  -- Must include file header with line count
  if !stringContains outlineStr "-- Tests/Fixtures/LeafAndLintFixture.lean (" then
    IO.println s!"[FAIL] Outline missing file header with line count:\n{outlineStr}"
    return 1

  -- Must NOT include BaseDefs since filter was LeafAndLintFixture
  if stringContains outlineStr "BaseDefs.lean" then
    IO.println s!"[FAIL] Outline leaked unselected module BaseDefs.lean:\n{outlineStr}"
    return 1

  -- Check single-line formatting and accurate uses/tracking tags
  let lines := outlineStr.splitOn "\n"
  let trackedHelperLine := lines.find? (fun l => stringContains l "] trackedNonLeafHelper ")
  match trackedHelperLine with
  | none =>
    IO.println s!"[FAIL] Outline missing trackedNonLeafHelper:\n{outlineStr}"
    return 1
  | some l =>
    if !stringContains l "[def, uses=1]" || !stringContains l "[TRACK]" then
      IO.println s!"[FAIL] trackedNonLeafHelper line has wrong metadata: {l}"
      return 1

  let trackedLeafLine := lines.find? (fun l => stringContains l "] trackedCulminationLeaf ")
  match trackedLeafLine with
  | none =>
    IO.println s!"[FAIL] Outline missing trackedCulminationLeaf:\n{outlineStr}"
    return 1
  | some l =>
    if !stringContains l "[thm, uses=0]" || !stringContains l "[TRACK]" || stringContains l "UNTRACKED-LEAF" then
      IO.println s!"[FAIL] trackedCulminationLeaf line has wrong metadata: {l}"
      return 1

  let untrackedLeafLine := lines.find? (fun l => stringContains l "] untrackedDeadLeaf ")
  match untrackedLeafLine with
  | none =>
    IO.println s!"[FAIL] Outline missing untrackedDeadLeaf:\n{outlineStr}"
    return 1
  | some l =>
    if !stringContains l "[thm, uses=0, UNTRACKED-LEAF]" then
      IO.println s!"[FAIL] untrackedDeadLeaf line missing [thm, uses=0, UNTRACKED-LEAF]: {l}"
      return 1

  -- Check that `def` bodies (`:= n + 99`) and `structure` fields (`where val : Nat`) are stripped in `--outline`
  let deadHelperLine := lines.find? (fun l => stringContains l "] deadHelperOnlyUsedByDeadLeaf ")
  match deadHelperLine with
  | none =>
    IO.println s!"[FAIL] Outline missing deadHelperOnlyUsedByDeadLeaf:\n{outlineStr}"
    return 1
  | some l =>
    if stringContains l "n + 99" || stringContains l ":=" then
      IO.println s!"[FAIL] Outline leaked def body in deadHelperOnlyUsedByDeadLeaf: {l}"
      return 1

  let structLine := lines.find? (fun l => stringContains l "] FixtureStruct")
  match structLine with
  | none =>
    IO.println s!"[FAIL] Outline missing FixtureStruct:\n{outlineStr}"
    return 1
  | some l =>
    if stringContains l "val : Nat" || stringContains l "where" then
      IO.println s!"[FAIL] Outline leaked structure fields in FixtureStruct: {l}"
      return 1

  -- 2. Test `--code-summary=litlib_track,leaf` marks untracked leaves with `-- [UNTRACKED LEAF]`
  --    and does NOT include "TRACK OR DELETE"
  let ctxSummary := parseArgs ["--code-summary=LeafAndLintFixture,leaf", "--glob-mode=all"]
  let (dataSummary, _) ← (extractAllTheorems env ctxSummary).toIO ctxCore state
  let summaryStr ← formatCodeSummary `Tests env dataSummary ctxSummary

  if !stringContains summaryStr "-- [UNTRACKED LEAF]" then
    IO.println s!"[FAIL] Code summary missing '-- [UNTRACKED LEAF]' marker:\n{summaryStr}"
    return 1
  if stringContains summaryStr "TRACK OR DELETE" then
    IO.println s!"[FAIL] Code summary must not contain policy instruction 'TRACK OR DELETE':\n{summaryStr}"
    return 1

  IO.println "Success: Outline and untracked leaf summary formatting tests passed."
  return 0

#eval show IO Unit from do
  let res ← main
  if res != 0 then
    throw (IO.userError "Outline assertions failed.")
