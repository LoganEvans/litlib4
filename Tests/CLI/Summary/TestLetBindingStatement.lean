-- FILENAME: Tests/CLI/Summary/TestLetBindingStatement.lean

import Lean
import Litlib.Core.CLI

open Lean Litlib.Core.CLI

def stringContains (s sub : String) : Bool :=
  (s.splitOn sub).length > 1

def main : IO UInt32 := do
  Lean.initSearchPath (← Lean.findSysroot)
  let mut sp ← Lean.searchPathRef.get
  let buildLib := System.FilePath.mk ".lake" / "build" / "lib" / "lean"
  if !(sp.contains buildLib) then
    Lean.searchPathRef.set (buildLib :: sp)

  let env ← importModules #[{ module := `Tests.Fixtures.LetBindingStatement }] {}
  let mut ok := true

  -- 1. Theorem with `let` and `:= by` must preserve the full equation `y = x + 1`
  let sBy ← ppDecl env `Tests.Fixtures.LetBindingStatement.testLetInStatement
  if !stringContains sBy "y = x + 1" then
    IO.println s!"[FAIL] Theorem with let statement was prematurely truncated at 'let':\n  {sBy}"
    ok := false
  if stringContains sBy "rfl" then
    IO.println s!"[FAIL] Theorem with let statement leaked proof:\n  {sBy}"
    ok := false

  -- 2. Term mode theorem with `let` must preserve the full equation `y = x`
  let sTerm ← ppDecl env `Tests.Fixtures.LetBindingStatement.testTermModeLetInStatement
  if !stringContains sTerm "y = x" then
    IO.println s!"[FAIL] Term-mode theorem with let statement was truncated at 'let':\n  {sTerm}"
    ok := false
  if stringContains sTerm "rfl" then
    IO.println s!"[FAIL] Term-mode theorem with let statement leaked proof:\n  {sTerm}"
    ok := false

  if ok then
    IO.println "Success: Let binding statement tests passed."
    return 0
  else
    return 1

#eval show IO Unit from do
  let res ← main
  if res != 0 then
    throw (IO.userError "Let binding statement assertions failed.")
