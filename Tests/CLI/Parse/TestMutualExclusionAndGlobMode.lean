-- FILENAME: Tests/CLI/Parse/TestMutualExclusionAndGlobMode.lean

import Litlib.Core.CLI

open Litlib.Core.CLI

-- 1. Outline flag parsing
#guard (parseArgs ["--outline"]).action == "outline"
#guard (parseArgs ["--outline"]).theoremGlobs == ["all"]
#guard (parseArgs ["--outline=Measurement"]).action == "outline"
#guard (parseArgs ["--outline=Measurement,Spacetime/Gravity.lean"]).filterTokens ==
  ["Measurement", "Spacetime.Gravity"]

-- 2. Glob mode parsing (default = "any", explicit "any" or "all", invalid -> "error")
#guard (parseArgs ["--code-summary=Measurement,litlib_track"]).globMode == "any"
#guard (parseArgs ["--code-summary=Measurement,litlib_track", "--glob-mode=any"]).globMode == "any"
#guard (parseArgs ["--code-summary=Measurement,litlib_track", "--glob-mode=all"]).globMode == "all"
#guard (parseArgs ["--code-summary=Measurement", "--glob-mode=invalid"]).action == "error"

-- 3. Leaf and combined filter token parsing
#guard (parseArgs ["--code-summary=leaf"]).action == "code-summary"
#guard (parseArgs ["--code-summary=leaf"]).filterTokens == ["leaf"]
#guard (parseArgs ["--code-summary=litlib_track,leaf"]).filterTokens == ["litlib_track", "leaf"]

-- 4. Lint flag parsing
#guard (parseArgs ["--lint"]).action == "lint"
#guard (parseArgs ["--lint"]).linters == ["all"]
#guard (parseArgs ["--lint=untracked-leaf,duplicate-type,namespace-folder-match"]).action == "lint"
#guard (parseArgs ["--lint=untracked-leaf,duplicate-type,namespace-folder-match"]).linters ==
  ["untracked-leaf", "duplicate-type", "namespace-folder-match"]

-- 5. Mutual exclusion between primary actions
#guard (parseArgs ["--code-summary", "--outline"]).action == "error"
#guard (parseArgs ["--dashboard", "--outline"]).action == "error"
#guard (parseArgs ["--dashboard", "--code-summary"]).action == "error"
#guard (parseArgs ["--code-summary", "--lint"]).action == "error"
#guard (parseArgs ["--outline", "--lint"]).action == "error"
#guard (parseArgs ["--bibtex", "--outline"]).action == "error"
#guard (parseArgs ["--dependencies", "--lint"]).action == "error"
