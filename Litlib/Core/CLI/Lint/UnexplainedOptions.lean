-- FILENAME: Litlib/Core/CLI/Lint/UnexplainedOptions.lean

import Lean
import Litlib.Core.CLI.Lint.Types

open Lean

namespace Litlib.Core.CLI

private def stringContains (s sub : String) : Bool :=
  (s.splitOn sub).length > 1

/-- Checks whether a line is a line comment or block comment line. -/
private def isCommentLine (line : String) : Bool :=
  let t := line.trimAscii.toString
  t.startsWith "--" || t.startsWith "/-" || t.endsWith "-/"

/-- Standard project-wide option overrides that do not require per-file explanation comments. -/
private def isStandardPermittedOption (trimmed : String) : Bool :=
  trimmed == "set_option autoImplicit false" ||
    trimmed == "set_option linter.unusedSimpArgs false"

def unexplainedOptionsLinter : Linter where
  name := "unexplained-options"
  description := "Flags non-standard `set_option` overrides that lack an inline or immediately preceding explanation comment."
  run := fun lctx => do
    let mut issues : Array LintIssue := #[]
    let sortedMods := lctx.moduleLines.toList.toArray.qsort fun a b => a.1.toString < b.1.toString
    for (_, (filePathStr, lines)) in sortedMods do
      for idx in [0:lines.size] do
        let line := lines[idx]!
        let trimmed := line.trimAscii.toString
        if trimmed.startsWith "set_option " && !isStandardPermittedOption trimmed then
          let hasInlineComment := stringContains trimmed "--" || stringContains trimmed "/-"
          let hasPrecedingComment :=
            if idx > 0 then
              isCommentLine lines[idx - 1]!
            else
              false
          if !hasInlineComment && !hasPrecedingComment then
            issues := issues.push {
              linterName := "unexplained-options"
              file := filePathStr
              line := some (idx + 1)
              declName := none
              message := s!"Unexplained option override '{trimmed}' (add an explanatory comment on the line before it)"
            }
    return issues

end Litlib.Core.CLI
