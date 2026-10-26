-- FILENAME: Litlib/Core/CLI/Lint/FileLength.lean

import Lean
import Litlib.Core.CLI.Lint.Types

open Lean

namespace Litlib.Core.CLI

def maxRecommendedFileLines : Nat := 450

def fileLengthLinter : Linter where
  name := "file-length"
  description := "Flags Lean source files exceeding 450 lines."
  run := fun lctx => do
    let mut issues : Array LintIssue := #[]
    let sortedMods := lctx.moduleLines.toList.toArray.qsort fun a b => a.1.toString < b.1.toString
    for (_, (filePathStr, lines)) in sortedMods do
      if lines.size > maxRecommendedFileLines then
        issues := issues.push {
          linterName := "file-length"
          file := filePathStr
          line := some lines.size
          declName := none
          message := s!"File '{filePathStr}' has {lines.size} lines (exceeds {maxRecommendedFileLines}L threshold)"
        }
    return issues

end Litlib.Core.CLI
