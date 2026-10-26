-- FILENAME: Litlib/Core/CLI/Lint/NamespaceFolderMatch.lean

import Lean
import Litlib.Core.CLI.Lint.Types

open Lean

namespace Litlib.Core.CLI

/-- Checks if `ns` resolves to an inductive/structure/class in the environment. -/
private def isInductiveNamespace (env : Environment) (expectedNs actualNs : Name) : Bool :=
  match env.find? actualNs with
  | some (.inductInfo _) => true
  | _ =>
    if let .str _ tail := actualNs then
      match env.find? (expectedNs ++ Name.mkSimple tail) with
      | some (.inductInfo _) => true
      | _ => false
    else
      false

def namespaceFolderMatchLinter : Linter where
  name := "namespace-folder-match"
  description := "Verifies that declaration namespaces match their folder prefix (or an existing structure/inductive)."
  run := fun lctx => do
    let mut issues : Array LintIssue := #[]
    let mut decls : Array Name := #[]

    for (declName, info) in lctx.env.constants.toList do
      if isDeclInLintScope lctx declName then
        if !(← Lean.getProjectionFnInfo? declName).isSome then
          match info with
          | .ctorInfo _ => pure ()
          | _ => decls := decls.push declName

    decls := decls.qsort fun a b => a.toString < b.toString

    for declName in decls do
      if let some idx := lctx.env.getModuleIdxFor? declName then
        let modName := lctx.env.header.moduleNames[idx.toNat]!
        let expectedNs := if modName.getPrefix == .anonymous then modName else modName.getPrefix
        let actualNs := declName.getPrefix
        let valid := actualNs == expectedNs || isInductiveNamespace lctx.env expectedNs actualNs
        if !valid then
          let (lineOpt, _) ← getDeclLineSpan declName
          issues := issues.push {
            linterName := "namespace-folder-match"
            file := getDeclFileStr lctx declName
            line := lineOpt
            declName := some declName
            message := s!"Declaration '{declName}' has namespace '{actualNs}', expected folder namespace '{expectedNs}'"
          }

    return issues

end Litlib.Core.CLI
