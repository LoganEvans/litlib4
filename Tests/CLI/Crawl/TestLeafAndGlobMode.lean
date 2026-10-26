-- FILENAME: Tests/CLI/Crawl/TestLeafAndGlobMode.lean

import Lean
import Litlib.Core.CLI

open Lean Litlib.Core.CLI

def main : IO UInt32 := do
  Lean.initSearchPath (← Lean.findSysroot)
  let mut sp ← Lean.searchPathRef.get
  let buildLib := System.FilePath.mk ".lake" / "build" / "lib" / "lean"
  if !(sp.contains buildLib) then
    Lean.searchPathRef.set (buildLib :: sp)

  let env ← importModules #[
    { module := `Tests.Fixtures.LeafAndLintFixture },
    { module := `Tests.Fixtures.DependencyGraph.BaseDefs },
    { module := `Tests.Fixtures.DependencyGraph.MidDefs }
  ] {}

  let ctxCore : Core.Context := { fileName := "<litlib>", fileMap := default }
  let state : Core.State := { env := env }

  -- Case 1: `--code-summary=leaf` selects declarations with uses == 0 (tracked or untracked)
  let ctxLeaf := parseArgs ["--code-summary=leaf"]
  let (dataLeaf, _) ← (extractAllTheorems env ctxLeaf).toIO ctxCore state
  let (rootsLeaf, _) ← (gatherRoots `Tests dataLeaf ctxLeaf).toIO ctxCore state

  if !rootsLeaf.contains `Tests.Fixtures.trackedCulminationLeaf then
    IO.println "[FAIL] --code-summary=leaf missed trackedCulminationLeaf (uses=0)"
    return 1
  if !rootsLeaf.contains `Tests.Fixtures.untrackedDeadLeaf then
    IO.println "[FAIL] --code-summary=leaf missed untrackedDeadLeaf (uses=0)"
    return 1
  if rootsLeaf.contains `Tests.Fixtures.trackedNonLeafHelper then
    IO.println "[FAIL] --code-summary=leaf falsely included trackedNonLeafHelper (uses > 0)"
    return 1
  if rootsLeaf.contains `Tests.Fixtures.untrackedUsedHelper then
    IO.println "[FAIL] --code-summary=leaf falsely included untrackedUsedHelper (uses > 0)"
    return 1
  if rootsLeaf.contains `Tests.Fixtures.deadHelperOnlyUsedByDeadLeaf then
    IO.println "[FAIL] --code-summary=leaf falsely included deadHelperOnlyUsedByDeadLeaf (uses = 1)"
    return 1

  -- Case 2: `--code-summary=litlib_track,leaf` (default glob-mode=any -> union)
  let ctxUnion := parseArgs ["--code-summary=litlib_track,leaf"]
  let (dataUnion, _) ← (extractAllTheorems env ctxUnion).toIO ctxCore state
  let (rootsUnion, _) ← (gatherRoots `Tests dataUnion ctxUnion).toIO ctxCore state

  if !rootsUnion.contains `Tests.Fixtures.trackedNonLeafHelper then
    IO.println "[FAIL] --code-summary=litlib_track,leaf missed trackedNonLeafHelper"
    return 1
  if !rootsUnion.contains `Tests.Fixtures.untrackedDeadLeaf then
    IO.println "[FAIL] --code-summary=litlib_track,leaf missed untrackedDeadLeaf"
    return 1
  if rootsUnion.contains `Tests.Fixtures.untrackedUsedHelper then
    IO.println "[FAIL] --code-summary=litlib_track,leaf falsely included untrackedUsedHelper"
    return 1

  -- Case 3: `--code-summary=LeafAndLintFixture,litlib_track --glob-mode=all` (intersection)
  let ctxInterTrack := parseArgs ["--code-summary=LeafAndLintFixture,litlib_track", "--glob-mode=all"]
  let (dataInterTrack, _) ← (extractAllTheorems env ctxInterTrack).toIO ctxCore state
  let (rootsInterTrack, _) ← (gatherRoots `Tests dataInterTrack ctxInterTrack).toIO ctxCore state

  if !rootsInterTrack.contains `Tests.Fixtures.trackedCulminationLeaf then
    IO.println "[FAIL] glob-mode=all (LeafAndLintFixture,litlib_track) missed trackedCulminationLeaf"
    return 1
  if !rootsInterTrack.contains `Tests.Fixtures.trackedNonLeafHelper then
    IO.println "[FAIL] glob-mode=all (LeafAndLintFixture,litlib_track) missed trackedNonLeafHelper"
    return 1
  if rootsInterTrack.contains `Tests.Fixtures.untrackedDeadLeaf then
    IO.println "[FAIL] glob-mode=all (LeafAndLintFixture,litlib_track) falsely included untrackedDeadLeaf"
    return 1
  if rootsInterTrack.contains `Tests.Fixtures.DependencyGraph.BaseDefs.baseTheoremZ then
    IO.println "[FAIL] glob-mode=all (LeafAndLintFixture,litlib_track) leaked BaseDefs.baseTheoremZ"
    return 1

  -- Case 4: `--code-summary=LeafAndLintFixture,leaf --glob-mode=all` (intersection)
  let ctxInterLeaf := parseArgs ["--code-summary=LeafAndLintFixture,leaf", "--glob-mode=all"]
  let (dataInterLeaf, _) ← (extractAllTheorems env ctxInterLeaf).toIO ctxCore state
  let (rootsInterLeaf, _) ← (gatherRoots `Tests dataInterLeaf ctxInterLeaf).toIO ctxCore state

  if !rootsInterLeaf.contains `Tests.Fixtures.untrackedDeadLeaf then
    IO.println "[FAIL] glob-mode=all (LeafAndLintFixture,leaf) missed untrackedDeadLeaf"
    return 1
  if rootsInterLeaf.contains `Tests.Fixtures.trackedNonLeafHelper then
    IO.println "[FAIL] glob-mode=all (LeafAndLintFixture,leaf) falsely included trackedNonLeafHelper (uses=1)"
    return 1
  if rootsInterLeaf.contains `Tests.Fixtures.DependencyGraph.MidDefs.midTheoremA then
    IO.println "[FAIL] glob-mode=all (LeafAndLintFixture,leaf) leaked MidDefs.midTheoremA"
    return 1

  IO.println "Success: Leaf and glob-mode root crawling tests passed."
  return 0

#eval show IO Unit from do
  let res ← main
  if res != 0 then
    throw (IO.userError "Leaf and glob-mode root crawling assertions failed.")
