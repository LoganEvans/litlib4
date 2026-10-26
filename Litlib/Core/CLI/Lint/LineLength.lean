-- FILENAME: Litlib/Core/CLI/Lint/LineLength.lean

import Lean
import Litlib.Core.CLI.Lint.Types

open Lean

namespace Litlib.Core.CLI

def maxRecommendedLineChars : Nat := 100

def lineLengthLinter : Linter where
  name := "line-length"
  description := "Flags source lines exceeding 100 characters."
  run := fun lctx => do
    let mut issues : Array LintIssue := #[]
    let sortedMods := lctx.moduleLines.toList.toArray.qsort fun a b => a.1.toString < b.1.toString
    for (_, (filePathStr, lines)) in sortedMods do
      for idx in [0:lines.size] do
        let line := lines[idx]!
        let charCount := line.toList.length
        if charCount > maxRecommendedLineChars then
          issues := issues.push {
            linterName := "line-length"
            file := filePathStr
            line := some (idx + 1)
            declName := none
            message := s!"Line {idx + 1} has {charCount} characters (exceeds {maxRecommendedLineChars} columns)"
          }
    return issues

end Litlib.Core.CLI
