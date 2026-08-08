-- FILENAME: Tests/CLI/Crawl/TestUntrackedInstance.lean

import Litlib.Core.CLI.Engine
import Litlib.Core.CLI.CodeSummary
import Litlib.Core
open Litlib.Core.CLI Lean

class MockClass (A : Type)

-- 1. An untracked, manually named instance
instance mock_manual_instance : MockClass Nat := ⟨⟩

-- 2. A tracked definition that explicitly uses the instance
@[litlib_track]
def mock_def_using_instance : Nat :=
  let _ := mock_manual_instance
  1

def runTest : CoreM Unit := do
  let env ← getEnv
  let ctx : CliContext := { litlibTheoremsOnly := true, targetTheorems := true, theoremGlobs := ["all"], targetReferences := true, referenceGlobs := ["all"] }
  let data ← extractAllTheorems env ctx
  let roots ← gatherRoots `Tests data ctx
  let deps ← collectLocalDepsRec `Tests roots.toList roots

  -- NEGATIVE CHECK: Untracked instances must NOT be crawled
  if deps.contains ``mock_manual_instance then
    throwError "FAIL: Crawler captured an untracked instance!"

#eval runTest
