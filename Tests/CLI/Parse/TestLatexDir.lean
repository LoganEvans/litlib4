-- FILENAME: Tests/CLI/Parse/TestLatexDir.lean

import Litlib.Core.CLI
open Litlib.Core.CLI

#guard (parseArgs ["--latex=my_paper_dir"]).latexDir == some "my_paper_dir"
#guard (parseArgs ["--latex=my_paper_dir"]).litlibTheoremsOnly == true
