-- FILENAME: Litlib/Core/CLI/Help.lean

import Lean

open Lean

namespace Litlib.Core.CLI

def printHelp : IO UInt32 := do
  IO.println "===================================================================="
  IO.println "                        LITLIB4 COMMAND LINE"
  IO.println "===================================================================="
  IO.println ""
  IO.println "Usage: litlib_report [OPTIONS]"
  IO.println ""
  IO.println "ACTIONS:"
  IO.println "  --dashboard              Print a hierarchical view of all tracked"
  IO.println "                           papers, equations, definitions, and theorems."
  IO.println "                           (This is the default action)."
  IO.println "  --code-summary           Print a flattened source code summary of"
  IO.println "                           the selected theorems and dependencies."
  IO.println "  --bibtex                 Print a generated BibTeX file of all"
  IO.println "                           tracked references."
  IO.println "  --latex[=DIR]            Generate a comprehensive LaTeX integration"
  IO.println "                           package in the specified directory"
  IO.println "                           (defaults to 'latex-artifacts/'). This"
  IO.println "                           includes a .sty package, a labeled .tex"
  IO.println "                           code summary, and a generated .bib file."
  IO.println "                           Automatically scans the target directory"
  IO.println "                           for any existing `.leanrefs` files to"
  IO.println "                           smartly filter the output to only include"
  IO.println "                           theorems actively cited in your paper."
  IO.println "  --help, -h               Show this help message."
  IO.println ""
  IO.println "FILTERS:"
  IO.println "  By default, actions operate on all discovered Litlib data."
  IO.println "  If using --latex, it defaults to all @[litlib_track] theorems"
  IO.println "  unless a .leanrefs file is found or explicit filters are passed."
  IO.println "  You can restrict operations using the following filters. You may"
  IO.println "  pass either declaration names or file paths (e.g. My/Path/To.lean)"
  IO.println ""
  IO.println "  --theorem[=GLOBS]        Filter by standalone theorem/definition names."
  IO.println "  --reference[=GLOBS]      Filter by paper/equation reference names."
  IO.println "  --all                    Apply action to everything."
  IO.println ""
  IO.println "  (Note: GLOBS is a comma-separated list of match patterns,"
  IO.println "  e.g. 'Litlib.Y2024.*,MyPaper.*')"
  IO.println ""
  IO.println "CODE SUMMARY SPECIFIC FLAGS:"
  IO.println "  --code-summary=litlib_track"
  IO.println "      Limits the root search exclusively to declarations tagged"
  IO.println "      via `@[litlib_track]` or `Litlib.equation`."
  IO.println ""
  return 0

end Litlib.Core.CLI
