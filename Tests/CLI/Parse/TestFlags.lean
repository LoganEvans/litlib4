-- FILENAME: Tests/CLI/Parse/TestFlags.lean

import Litlib.Core.CLI
open Litlib.Core.CLI

#guard (parseArgs ["--theorem=A,B", "--theorem=C"]).theoremGlobs == ["A", "B", "C"]
#guard (parseArgs ["--theorem=A,B", "--theorem=C"]).explicitFilters == true
