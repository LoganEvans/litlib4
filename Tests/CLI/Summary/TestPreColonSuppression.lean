-- FILENAME: Tests/CLI/Summary/TestPreColonSuppression.lean

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

  let env ← importModules #[{ module := `Tests.Fixtures.PreColonSuppression }] {}
  let sThm ← ppDecl env `Tests.Fixtures.PreColonSuppression.testMultiQuantifier

  let parts := sThm.splitOn ":"
  let preColon := if parts.length > 1 then parts[0]! else sThm

  -- a, b, c are quantified after colon with `∀ (a b c : Nat)`, so they must NOT appear before colon
  if stringContains preColon "a : Nat" || stringContains preColon "b : Nat" || stringContains preColon "c : Nat" then
    IO.println s!"[FAIL] Post-colon quantified variables (a, b, c) injected before colon:\n  {sThm}"
    return 1

  IO.println "Success: Pre-colon quantifier suppression tests passed."
  return 0

#eval show IO Unit from do
  let res ← main
  if res != 0 then
    throw (IO.userError "Pre-colon quantifier suppression assertions failed.")
