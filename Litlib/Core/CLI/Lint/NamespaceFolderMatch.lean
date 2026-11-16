-- FILENAME: Litlib/Core/CLI/Lint/NamespaceFolderMatch.lean

import Lean
import Litlib.Core.CLI.Lint.Types

open Lean

namespace Litlib.Core.CLI

/-- Checks if `actualNs` resolves to an existing declaration/type in the environment (for dot-notation). -/
private def isTypeOrDeclNamespace (rootModule : Name) (env : Environment)
    (expectedNs actualNs : Name) : Bool :=
  (actualNs.getRoot == rootModule && env.contains actualNs) ||
    match actualNs with
    | .str _ tail => env.contains (expectedNs ++ Name.mkSimple tail)
    | _ => false

/-- Checks if `actualNs` matches `expectedNs` or any non-root ancestor prefix of `modName`. -/
private def isValidNamespacePrefix (expectedNs modName actualNs : Name) : Bool :=
  actualNs == expectedNs ||
    (actualNs != .anonymous && actualNs.getPrefix != .anonymous && actualNs.isPrefixOf modName)

def namespaceFolderMatchLinter : Linter where
  name := "namespace-folder-match"
  description := "Verifies that declaration namespaces match their folder/ancestor prefix (or an existing type/declaration)."
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
        let valid :=
          isValidNamespacePrefix expectedNs modName actualNs ||
            isTypeOrDeclNamespace lctx.rootModule lctx.env expectedNs actualNs
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
