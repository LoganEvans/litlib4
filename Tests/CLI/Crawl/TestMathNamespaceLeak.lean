-- FILENAME: Tests/CLI/Crawl/TestMathNamespaceLeak.lean

import Litlib.Core.CLI.Engine
import Litlib.Core.CLI.CodeSummary
import Litlib.Core
open Litlib.Core.CLI Lean

-- 1. We simulate a math plumbing definition by putting it in a .Math. namespace
namespace CGK.Math
  def mock_plumbing : Nat := 1
end CGK.Math

-- 2. A tracked physical definition that relies on the plumbing
@[litlib_track]
def mock_physical_def : Nat := CGK.Math.mock_plumbing

def runTest : CoreM Unit := do
  let env ← getEnv
  let ctx : CliContext := { litlibTheoremsOnly := true, targetTheorems := true, theoremGlobs := ["all"], targetReferences := true, referenceGlobs := ["all"] }
  let data ← extractAllTheorems env ctx
  let roots ← gatherRoots `Tests data ctx
  let deps ← collectLocalDepsRec `Tests roots.toList roots

  -- NEGATIVE CHECK: The crawler must block any dependency with .Math. in its name
  if deps.contains ``CGK.Math.mock_plumbing then
    throwError "FAIL: Crawler captured a plumbing definition from a Math namespace!"

#eval runTest
