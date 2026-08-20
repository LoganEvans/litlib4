-- FILENAME: Tests/CLI/Crawl/TestProjMissing.lean

import Litlib.Core.CLI.Engine
import Litlib.Core.CLI.CodeSummary
import Litlib.Core
open Litlib.Core.CLI Lean

class MockDiracAlgebra where
  mock_gamma_vec : Nat → Nat

-- Untracked instance, so it won't be crawled natively, severing the type link
instance mock_inst : MockDiracAlgebra := ⟨fun x => x⟩

@[litlib_track]
def mock_emergent_thm : Nat := MockDiracAlgebra.mock_gamma_vec 4

def runTest : CoreM Unit := do
  let env ← getEnv
  let ctx : CliContext := { litlibTheoremsOnly := true, targetTheorems := true, theoremGlobs := ["all"], targetReferences := true, referenceGlobs := ["all"] }
  let data ← extractAllTheorems env ctx
  let roots ← gatherRoots `Tests data ctx
  let deps ← collectLocalDepsRec `Tests roots.toList roots

  if !deps.contains ``MockDiracAlgebra then
    throwError "FAIL: Crawler completely missed the parent class of a projection!"

#eval runTest
