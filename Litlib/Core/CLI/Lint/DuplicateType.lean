-- FILENAME: Litlib/Core/CLI/Lint/DuplicateType.lean

import Lean
import Litlib.Core.CLI.Lint.Types

open Lean

namespace Litlib.Core.CLI

/-- Normalizes binder names and metadata so alpha-equivalent expressions have identical hashes. -/
private def eraseBinderNames : Expr → Expr
  | .forallE _ d b bi => .forallE .anonymous (eraseBinderNames d) (eraseBinderNames b) bi
  | .lam _ d b bi => .lam .anonymous (eraseBinderNames d) (eraseBinderNames b) bi
  | .letE _ t v b nd => .letE .anonymous (eraseBinderNames t) (eraseBinderNames v) (eraseBinderNames b) nd
  | .app f a => .app (eraseBinderNames f) (eraseBinderNames a)
  | .mdata _ e => eraseBinderNames e
  | .proj t i s => .proj t i (eraseBinderNames s)
  | e => e

def duplicateTypeLinter : Linter where
  name := "duplicate-type"
  description := "Detects pairs or groups of theorems proving alpha-equivalent propositions (Expr.eqv)."
  run := fun lctx => do
    let mut candidates : Array (Name × Expr × UInt64) := #[]
    for (declName, info) in lctx.env.constants.toList do
      if isDeclInLintScope lctx declName then
        if !(← Lean.getProjectionFnInfo? declName).isSome then
          match info with
          | .thmInfo t =>
            let normType := eraseBinderNames t.type
            candidates := candidates.push (declName, t.type, normType.hash)
          | _ => pure ()

    candidates := candidates.qsort fun a b => a.1.toString < b.1.toString
    let mut visited : NameSet := {}
    let mut issues : Array LintIssue := #[]

    for i in [0:candidates.size] do
      let (nameA, typeA, hashA) := candidates[i]!
      if !visited.contains nameA then
        let mut group : Array Name := #[nameA]
        for j in [i + 1:candidates.size] do
          let (nameB, typeB, hashB) := candidates[j]!
          if hashA == hashB && Expr.eqv typeA typeB then
            group := group.push nameB
            visited := visited.insert nameB
        if group.size > 1 then
          visited := visited.insert nameA
          let (lineOpt, _) ← getDeclLineSpan nameA
          let groupStr := String.intercalate ", " (group.map (·.toString)).toList
          issues := issues.push {
            linterName := "duplicate-type"
            file := getDeclFileStr lctx nameA
            line := lineOpt
            declName := some nameA
            message := s!"Alpha-equivalent theorem types shared by: {groupStr}"
          }

    return issues

end Litlib.Core.CLI
