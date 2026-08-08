-- FILENAME: Tests/CLI/Crawl/TestPositive.lean

import Litlib.Core.CLI.Engine
import Litlib.Core.CLI.CodeSummary
import Litlib.Core
open Litlib.Core.CLI Lean

@[litlib_track]
def mock_positive_tracked_thm : Nat := 42

def runTest : CoreM Unit := do
  let env ← getEnv
  let ctx : CliContext := {
    litlibTheoremsOnly := true, targetTheorems := true, theoremGlobs := ["all"],
    targetReferences := true, referenceGlobs := ["all"]
  }
  let data ← extractAllTheorems env ctx
  let roots ← gatherRoots `Tests data ctx

  if !roots.contains ``mock_positive_tracked_thm then
    throwError "FAIL: Missing explicitly tracked theorem in root extraction."

#eval runTest
