-- FILENAME: Tests/CLI/Crawl/TestTransitive.lean

import Litlib.Core.CLI.Engine
import Litlib.Core.CLI.CodeSummary
import Litlib.Core
open Litlib.Core.CLI Lean

def mock_hidden_base_dep : Nat := 1
def mock_visible_mid_dep : Nat := mock_hidden_base_dep + 1

@[litlib_track]
def mock_transitive_tracked_thm : Nat := mock_visible_mid_dep + 1

def runTest : CoreM Unit := do
  let env ← getEnv
  let ctx : CliContext := { litlibTheoremsOnly := true, targetTheorems := true, theoremGlobs := ["all"], targetReferences := true, referenceGlobs := ["all"] }
  let data ← extractAllTheorems env ctx
  let roots ← gatherRoots `Tests data ctx
  let deps ← collectLocalDepsRec `Tests roots.toList roots

  if !deps.contains ``mock_visible_mid_dep then
    throwError "FAIL: Crawler failed to find first-level transitive dependency."
  if !deps.contains ``mock_hidden_base_dep then
    throwError "FAIL: Crawler failed to dig into value bodies for deep transitive dependencies."

#eval runTest
