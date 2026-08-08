-- FILENAME: Tests/CLI/Crawl/TestProofLeak.lean

import Litlib.Core.CLI.Engine
import Litlib.Core.CLI.CodeSummary
import Litlib.Core
open Litlib.Core.CLI Lean

-- 1. A definition body dependency (MUST be crawled)
def mock_def_dependency : Nat := 42

-- 2. A definition used in the signature (MUST be crawled, and its body must be crawled)
def mock_def : Nat := mock_def_dependency + 1

-- 3. A helper theorem used ONLY in the proof (MUST NOT be crawled)
theorem mock_proof_helper : mock_def = 43 := rfl

-- 4. The tracked theorem
@[litlib_track]
theorem mock_tracked_theorem : mock_def = 43 := by
  -- The proof uses the helper theorem
  exact mock_proof_helper

def runTest : CoreM Unit := do
  let env ← getEnv
  let ctx : CliContext := {
    litlibTheoremsOnly := true, targetTheorems := true, theoremGlobs := ["all"],
    targetReferences := true, referenceGlobs := ["all"]
  }
  let data ← extractAllTheorems env ctx
  let roots ← gatherRoots `Tests data ctx
  let deps ← collectLocalDepsRec `Tests roots.toList roots

  -- POSITIVE CHECKS: We still need to make sure we crawl definition bodies!
  if !deps.contains ``mock_def then
    throwError "FAIL: Missing signature dependency (mock_def)."
  if !deps.contains ``mock_def_dependency then
    throwError "FAIL: Missing definition body dependency (mock_def_dependency)."

  -- NEGATIVE CHECK: The Proof Leak
  if deps.contains ``mock_proof_helper then
    throwError "FAIL: Crawler leaked into the proof body and captured mock_proof_helper!"

#eval runTest
