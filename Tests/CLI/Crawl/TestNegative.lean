-- FILENAME: Tests/CLI/Crawl/TestNegative.lean

import Litlib.Core.CLI.Engine
import Litlib.Core.CLI.CodeSummary
import Litlib.Core
open Litlib.Core.CLI Lean

def mock_completely_untracked : Nat := 100

@[litlib_track]
def mock_isolated_tracked_thm : Nat := 42

def runTest : CoreM Unit := do
  let env ← getEnv
  let ctx : CliContext := { litlibTheoremsOnly := true, targetTheorems := true, theoremGlobs := ["all"], targetReferences := true, referenceGlobs := ["all"] }
  let data ← extractAllTheorems env ctx
  let roots ← gatherRoots `Tests data ctx
  let deps ← collectLocalDepsRec `Tests roots.toList roots

  if roots.contains ``mock_completely_untracked then
    throwError "FAIL: GatherRoots pulled in an untracked, unrelated theorem."
  if deps.contains ``mock_completely_untracked then
    throwError "FAIL: Crawler pulled in an untracked, unrelated theorem."

#eval runTest
