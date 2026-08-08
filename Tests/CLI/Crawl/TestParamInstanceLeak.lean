-- FILENAME: Tests/CLI/Crawl/TestParamInstanceLeak.lean

import Litlib.Core.CLI.Engine
import Litlib.Core.CLI.CodeSummary
import Litlib.Core
open Litlib.Core.CLI Lean

class MockParamClass (A : Type) (n : Nat)

-- 1. An untracked instance with a parameter (creates a ∀ signature)
instance mock_param_instance {n : Nat} : MockParamClass Nat n := ⟨⟩

@[litlib_track]
def mock_def_using_param_inst : Nat :=
  let _ := mock_param_instance (n := 4)
  1

def runTest : CoreM Unit := do
  let env ← getEnv
  let ctx : CliContext := { litlibTheoremsOnly := true, targetTheorems := true, theoremGlobs := ["all"], targetReferences := true, referenceGlobs := ["all"] }
  let data ← extractAllTheorems env ctx
  let roots ← gatherRoots `Tests data ctx
  let deps ← collectLocalDepsRec `Tests roots.toList roots

  -- NEGATIVE CHECK: Parameterized instances must NOT be crawled
  if deps.contains ``mock_param_instance then
    throwError "FAIL: Crawler bypassed the instance check because of a parameterized ∀ signature!"

#eval runTest
