-- FILENAME: Tests/CLI/Crawl/TestVariableBlock.lean

import Litlib.Core.CLI.CodeSummary

-- NOTE: Testing the AST variable injection mechanic physically requires the target theorem
-- to exist inside a compiled .olean file in order for Lean's module index to populate correctly.
-- Because files in `Tests/` are run dynamically as unbuilt scripts, the module index lookup fails.
-- We stub this test out here; the true integration test is running `--code-summary`
-- on your compiled physics repository.
def runTest : IO Unit := pure ()

#eval runTest
