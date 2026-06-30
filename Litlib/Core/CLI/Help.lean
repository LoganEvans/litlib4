-- FILENAME: Litlib/Core/CLI/Help.lean

import Lean

open Lean

namespace Litlib.Core.CLI

def printHelp : IO UInt32 := do
  IO.println "===================================================================="
  IO.println "                        LITLIB4 COMMAND LINE"
  IO.println "===================================================================="
  IO.println ""
  IO.println "Usage: cgd-report [OPTIONS]"
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
  IO.println "                           to suppress duplicate BibTeX keys."
  IO.println "  --help, -h               Show this help message."
  IO.println ""
  IO.println "FILTERS:"
  IO.println "  By default, actions operate on all discovered Litlib data."
  IO.println "  You can restrict operations using the following filters:"
  IO.println ""
  IO.println "  --theorem[=GLOBS]        Filter by standalone theorem/definition names."
  IO.println "  --reference[=GLOBS]      Filter by paper/equation reference names."
  IO.println "  --all                    Apply action to everything."
  IO.println ""
  IO.println "  (Note: GLOBS is a comma-separated list of match patterns,"
  IO.println "  e.g. 'Litlib.Y2024.*,MyPaper.*')"
  IO.println ""
  IO.println "CODE SUMMARY SPECIFIC FLAGS:"
  IO.println "  --code-summary=Litlib.theorem"
  IO.println "      Limits the root search exclusively to declarations tagged"
  IO.println "      via `Litlib.theorem`, `Litlib.definition`, or `Litlib.equation`."
  IO.println "      (This behavior is automatically enabled when using --latex)."
  IO.println ""
  return 0

end Litlib.Core.CLI
