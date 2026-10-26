-- FILENAME: Litlib/Core/CLI/Help.lean

import Lean

open Lean

namespace Litlib.Core.CLI

def printHelp : IO UInt32 := do
  IO.println "===================================================================="
  IO.println "                        LITLIB4 COMMAND LINE"
  IO.println "===================================================================="
  IO.println ""
  IO.println "Usage: litlib_report [ACTION] [OPTIONS]"
  IO.println ""
  IO.println "PRIMARY ACTIONS (Mutually Exclusive):"
  IO.println "  --dashboard[=FILTERS]    Print a hierarchical view of tracked papers,"
  IO.println "                           equations, definitions, and theorems."
  IO.println "                           (Default action when no flag is provided)."
  IO.println "  --code-summary[=FILTERS] Print source signatures of selected roots"
  IO.println "                           and their local dependency cone. Marks any"
  IO.println "                           untracked leaf (uses=0) with:"
  IO.println "                             -- [UNTRACKED LEAF]"
  IO.println "  --outline[=FILTERS]      Print a compact 1-line-per-declaration"
  IO.println "                           repository map with file line counts,"
  IO.println "                           declaration kinds, reference counts (uses=N),"
  IO.println "                           and [TRACK] / UNTRACKED-LEAF markers."
  IO.println "  --lint[=LINTERS]         Run deterministic repository linters"
  IO.println "                           (defaults to 'all'). Available linters:"
  IO.println "                             • untracked-leaf"
  IO.println "                             • duplicate-type"
  IO.println "                             • namespace-folder-match"
  IO.println "                             • file-length"
  IO.println "                             • line-length"
  IO.println "                             • unexplained-options"
  IO.println "  --bibtex[=FILTERS]       Print a generated BibTeX file of references."
  IO.println "  --dependencies[=PATH]    Export dependency DAG (.dot or .json)."
  IO.println "  --latex[=DIR]            Generate LaTeX integration package in DIR"
  IO.println "                           (defaults to 'latex-artifacts/')."
  IO.println "  --help, -h               Show this help message."
  IO.println ""
  IO.println "FILTER TOKENS & GLOB MODES:"
  IO.println "  Filter lists (e.g. --code-summary=T1,T2 or --outline=T1,T2) accept"
  IO.println "  comma-separated path/identifier globs (e.g. 'Measurement') and"
  IO.println "  magic filter keywords:"
  IO.println "    • all (or *)           Match all project declarations"
  IO.println "    • litlib_track         Match @[litlib_track] and Litlib.equation items"
  IO.println "    • leaf                 Match declarations with in-degree uses=0"
  IO.println "    • theorem / reference  Match standalone theorems or paper equations"
  IO.println ""
  IO.println "  --glob-mode=any          (Default) Union of filter tokens: matches"
  IO.println "                           declarations satisfying ANY token"
  IO.println "                           (e.g. --code-summary=litlib_track,leaf)."
  IO.println "  --glob-mode=all          Intersection of filter tokens: matches"
  IO.println "                           declarations satisfying ALL tokens"
  IO.println "                           (e.g. --code-summary=Measurement,litlib_track --glob-mode=all)."
  IO.println "  --theorem[=GLOBS]        Additional declaration/module glob filters."
  IO.println "  --reference[=GLOBS]      Additional paper/equation glob filters."
  IO.println ""
  return 0

end Litlib.Core.CLI
