-- FILENAME: Tests/CLI/Crawl/TestTheoremDependency.lean

import Litlib.Core.CLI.Engine
import Litlib.Core.CLI.CodeSummary
import Litlib.Core
open Litlib.Core.CLI Lean

-- 1. A helper theorem (Must NOT be crawled as a dependency)
theorem mock_helper_thm : 1 + 1 = 2 := rfl

-- 2. A tracked physical definition that uses the theorem to satisfy a constraint
@[litlib_track]
def mock_def_with_proof : { x : Nat // x = 2 } := ⟨2, mock_helper_thm⟩

def runTest : CoreM Unit := do
  let env ← getEnv
  let ctx : CliContext := { litlibTheoremsOnly := true, targetTheorems := true, theoremGlobs := ["all"], targetReferences := true, referenceGlobs := ["all"] }
  let data ← extractAllTheorems env ctx
  let roots ← gatherRoots `Tests data ctx
  let deps ← collectLocalDepsRec `Tests roots.toList roots

  -- NEGATIVE CHECK: Theorems must NEVER be crawled as dependencies, even if used in definitions
  if deps.contains ``mock_helper_thm then
    throwError "FAIL: Crawler captured a theorem as a dependency!"

#eval runTest
