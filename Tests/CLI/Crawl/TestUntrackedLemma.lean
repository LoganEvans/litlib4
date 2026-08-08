-- FILENAME: Tests/CLI/Crawl/TestUntrackedLemma.lean

import Litlib.Core.CLI.Engine
import Litlib.Core.CLI.CodeSummary
import Litlib.Core
open Litlib.Core.CLI Lean

-- 1. An untracked lemma (Using theorem keyword for Lean 4 compatibility)
theorem mock_untracked_lemma : 1 + 1 = 2 := rfl

-- 2. A tracked definition that uses the lemma in its body
@[litlib_track]
def mock_def_using_lemma : Nat :=
  let _ := mock_untracked_lemma
  1

def runTest : CoreM Unit := do
  let env ← getEnv
  let ctx : CliContext := { litlibTheoremsOnly := true, targetTheorems := true, theoremGlobs := ["all"], targetReferences := true, referenceGlobs := ["all"] }
  let data ← extractAllTheorems env ctx
  let roots ← gatherRoots `Tests data ctx
  let deps ← collectLocalDepsRec `Tests roots.toList roots

  -- NEGATIVE CHECK: Untracked lemmas must NOT be crawled, even if used in definitions
  if deps.contains ``mock_untracked_lemma then
    throwError "FAIL: Crawler captured an untracked lemma!"

#eval runTest
