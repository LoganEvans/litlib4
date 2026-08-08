-- FILENAME: Tests/CLI/Parse/TestLitlibTrack.lean

import Litlib.Core.CLI
open Litlib.Core.CLI

#guard (parseArgs ["--code-summary=litlib_track"]).litlibTheoremsOnly == true
#guard (parseArgs ["--code-summary=litlib_track"]).action == "code-summary"
#guard (parseArgs ["--code-summary=litlib_track"]).theoremGlobs == ["all"]
