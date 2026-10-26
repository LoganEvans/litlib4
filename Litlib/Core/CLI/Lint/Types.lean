-- FILENAME: Litlib/Core/CLI/Lint/Types.lean

import Lean
import Litlib.Core.CLI.Engine
import Litlib.Core.CLI.CodeSummary

open Lean

namespace Litlib.Core.CLI

structure LintIssue where
  linterName : String
  file : String
  line : Option Nat := none
  declName : Option Name := none
  message : String
  deriving Inhabited, Repr

structure LinterContext where
  rootModule : Name
  env : Environment
  globalData : GlobalData
  cliCtx : CliContext
  usesMap : NameMap Nat
  depsMap : NameMap NameSet
  eqProofDecls : NameSet
  moduleLines : NameMap (String × Array String)

structure Linter where
  name : String
  description : String
  run : LinterContext → CoreM (Array LintIssue)

/-- Checks if a declaration matches the user's `--theorem` / filter globs for linting. -/
def isDeclInLintScope (lctx : LinterContext) (declName : Name) : Bool :=
  if !isLocalToRoot lctx.rootModule lctx.env declName || isAuto declName then
    false
  else if (litlibPaperExt.find? lctx.env declName).isSome then
    false
  else
    let modNameStr := match lctx.env.getModuleIdxFor? declName with
      | some idx => lctx.env.header.moduleNames[idx.toNat]!.toString
      | none => lctx.rootModule.toString
    let globs := lctx.cliCtx.theoremGlobs.filter (fun g => g != "all" && g != "")
    if globs.isEmpty then
      true
    else
      matchesAnyGlob globs declName.toString || matchesAnyGlob globs modNameStr

/-- Returns the `(startLine, lineSpan)` of a declaration if available. -/
def getDeclLineSpan (declName : Name) : CoreM (Option Nat × Nat) := do
  if let some ranges ← Lean.findDeclarationRanges? declName then
    let startL := ranges.range.pos.line
    let endL := ranges.range.endPos.line
    let span := if endL >= startL then endL - startL + 1 else 1
    return (some startL, span)
  return (none, 1)

/-- Returns the module file path string (e.g. `CGD/Spacetime/Gravity.lean`) for a declaration. -/
def getDeclFileStr (lctx : LinterContext) (declName : Name) : String :=
  match lctx.env.getModuleIdxFor? declName with
  | some idx =>
    let modName := lctx.env.header.moduleNames[idx.toNat]!
    s!"{modName.toString.replace "." "/"}.lean"
  | none =>
    s!"{lctx.rootModule.toString.replace "." "/"}.lean"

end Litlib.Core.CLI
