-- FILENAME: Litlib/Core/CLI/Lint.lean

import Lean
import Litlib.Core.CLI.Lint.Types
import Litlib.Core.CLI.Lint.UntrackedLeaf
import Litlib.Core.CLI.Lint.DuplicateType
import Litlib.Core.CLI.Lint.NamespaceFolderMatch
import Litlib.Core.CLI.Lint.FileLength
import Litlib.Core.CLI.Lint.LineLength
import Litlib.Core.CLI.Lint.UnexplainedOptions

open Lean

namespace Litlib.Core.CLI

/-- Registry of all modular linters. Add new linter files here to register them automatically. -/
def allLinters : Array Linter := #[
  untrackedLeafLinter,
  duplicateTypeLinter,
  namespaceFolderMatchLinter,
  fileLengthLinter,
  lineLengthLinter,
  unexplainedOptionsLinter
]

/-- Builds the shared `LinterContext` for a linter run. -/
def buildLinterContext (rootModule : Name) (env : Environment) (globalData : GlobalData)
    (ctx : CliContext) : IO LinterContext := do
  let ctxCore : Core.Context := { fileName := "<litlib>", fileMap := default }
  let state : Core.State := { env := env }
  let ((usesMap, depsMap), _) ← (computeUsesAndDeps rootModule env).toIO ctxCore state
  let eqProofDecls := collectEqProofDecls env

  let globs := ctx.theoremGlobs.filter (fun g => g != "all" && g != "")
  let mut modSet : NameSet := {}
  for (declName, _) in env.constants.toList do
    if isLocalToRoot rootModule env declName then
      if let some idx := env.getModuleIdxFor? declName then
        let modName := env.header.moduleNames[idx.toNat]!
        if globs.isEmpty || matchesAnyGlob globs modName.toString then
          modSet := modSet.insert modName

  let mut moduleLines : NameMap (String × Array String) := {}
  for modName in modSet.toList do
    if let some srcPath ← findSourceFile modName then
      let lines ← IO.FS.lines srcPath
      let fileStr := s!"{modName.toString.replace "." "/"}.lean"
      moduleLines := moduleLines.insert modName (fileStr, lines)

  return {
    rootModule := rootModule
    env := env
    globalData := globalData
    cliCtx := ctx
    usesMap := usesMap
    depsMap := depsMap
    eqProofDecls := eqProofDecls
    moduleLines := moduleLines
  }

/-- Runs all enabled linters and returns the collected `LintIssue` array. -/
def runLinters (rootModule : Name) (env : Environment) (globalData : GlobalData)
    (ctx : CliContext) : IO (Array LintIssue) := do
  let lctx ← buildLinterContext rootModule env globalData ctx
  let ctxCore : Core.Context := { fileName := "<litlib>", fileMap := default }
  let state : Core.State := { env := env }

  let enabledNames := if ctx.linters.isEmpty then ["all"] else ctx.linters
  let runAll := enabledNames.contains "all"

  let mut allIssues : Array LintIssue := #[]
  for linter in allLinters do
    if runAll || enabledNames.contains linter.name then
      let (issues, _) ← (linter.run lctx).toIO ctxCore state
      allIssues := allIssues ++ issues

  return allIssues

/-- Formats lint issues into a human- and LLM-readable report. -/
def formatLintReport (issues : Array LintIssue) : String := Id.run do
  let mut out := "\n====================================================================\n"
  out := out ++ "                        LITLIB4 LINT REPORT\n"
  out := out ++ "====================================================================\n"

  if issues.isEmpty then
    out := out ++ "\n  ✔ No lint issues found.\n"
    out := out ++ "\n====================================================================\n"
    return out

  for linter in allLinters do
    let lIssues := issues.filter (fun i => i.linterName == linter.name)
    if !lIssues.isEmpty then
      out := out ++ s!"\n[{linter.name.toUpper}] ({lIssues.size} issue(s))\n"
      out := out ++ "--------------------------------------------------------------------\n"
      for iss in lIssues do
        let locStr := match iss.line with
          | some l => s!"{iss.file}:{l}"
          | none => iss.file
        out := out ++ s!"  • {locStr} — {iss.message}\n"

  out := out ++ s!"\nTotal Lint Issues: {issues.size}\n"
  out := out ++ "====================================================================\n"
  return out

/-- CLI entrypoint for `--lint`. Always exits with code 0 after printing the report. -/
def runLint (rootModule : Name) (env : Environment) (globalData : GlobalData)
    (ctx : CliContext) : IO UInt32 := do
  let issues ← runLinters rootModule env globalData ctx
  IO.print (formatLintReport issues)
  return 0

end Litlib.Core.CLI
