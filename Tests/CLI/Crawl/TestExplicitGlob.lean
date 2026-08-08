-- FILENAME: Tests/CLI/Crawl/TestExplicitGlob.lean

import Litlib.Core.CLI.Engine
import Litlib.Core.CLI.CodeSummary
import Litlib.Core
open Litlib.Core.CLI Lean

@[litlib_track]
def specific_tracked_thm : Nat := 42

@[litlib_track]
def ignored_tracked_thm : Nat := 43

def runTest : CoreM Unit := do
  let env ← getEnv
  let ctx : CliContext := {
    litlibTheoremsOnly := false, targetTheorems := true, theoremGlobs := ["specific_tracked_thm"],
    targetReferences := false, referenceGlobs := []
  }
  let data ← extractAllTheorems env ctx
  let roots ← gatherRoots `Tests data ctx

  if !roots.contains ``specific_tracked_thm then
    throwError "FAIL: Explicit glob failed to find its target."
  if roots.contains ``ignored_tracked_thm then
    throwError "FAIL: Explicit glob accidentally included unrequested tracked theorems."

#eval runTest
