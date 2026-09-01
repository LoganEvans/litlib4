-- FILENAME: Tests/CLI/Summary/TestPreColonVsPostColon.lean

import Lean
import Litlib.Core.CLI

open Lean Litlib.Core.CLI

def stringContains (s sub : String) : Bool :=
  (s.splitOn sub).length > 1

def countOccurrences (s sub : String) : Nat :=
  let parts := s.splitOn sub
  if parts.isEmpty then 0 else parts.length - 1

def main : IO UInt32 := do
  Lean.initSearchPath (← Lean.findSysroot)
  let mut sp ← Lean.searchPathRef.get
  let buildLib := System.FilePath.mk ".lake" / "build" / "lib" / "lean"
  if !(sp.contains buildLib) then
    Lean.searchPathRef.set (buildLib :: sp)

  let env ← importModules #[{ module := `Tests.Fixtures.PreColonVsPostColon }] {}
  let mut ok := true

  -- y is quantified via ∀ after the colon, so (y : Nat) must NOT appear before the colon
  let sQuant ← ppDecl env `Tests.Fixtures.PreColonVsPostColon.testQuantifiedPostColon
  let parts := sQuant.splitOn ":"
  let preColon := if parts.length > 1 then parts[0]! else sQuant

  if stringContains preColon "(y : Nat)" || stringContains preColon "y : Nat" then
    IO.println s!"[FAIL] Post-colon quantified variable 'y' was injected before colon:\n  {sQuant}"
    ok := false

  -- x is already in the signature, must not be duplicated
  let sExpl ← ppDecl env `Tests.Fixtures.PreColonVsPostColon.testExplicitPreColon
  let countX := countOccurrences sExpl "x : Nat"
  if countX > 1 then
    IO.println s!"[FAIL] Parameter 'x : Nat' was duplicated in signature:\n  {sExpl}"
    ok := false

  if ok then
    IO.println "Success: Pre-colon vs post-colon binder tests passed."
    return 0
  else
    return 1

#eval show IO Unit from do
  let res ← main
  if res != 0 then
    throw (IO.userError "Pre-colon vs post-colon binder assertions failed.")
