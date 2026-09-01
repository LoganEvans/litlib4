-- FILENAME: Tests/CLI/Summary/TestTypeclassDependencyOrder.lean

import Lean
import Litlib.Core.CLI

open Lean Litlib.Core.CLI

def substringIndex (s sub : String) : Option Nat :=
  let parts := s.splitOn sub
  if parts.length > 1 then some parts[0]!.length else none

def countOccurrences (s sub : String) : Nat :=
  let parts := s.splitOn sub
  if parts.isEmpty then 0 else parts.length - 1

def main : IO UInt32 := do
  Lean.initSearchPath (← Lean.findSysroot)
  let mut sp ← Lean.searchPathRef.get
  let buildLib := System.FilePath.mk ".lake" / "build" / "lib" / "lean"
  if !(sp.contains buildLib) then
    Lean.searchPathRef.set (buildLib :: sp)

  let env ← importModules #[{ module := `Tests.Fixtures.TypeclassDependencyOrder }] {}
  let mut ok := true

  let sThm ← ppDecl env `Tests.Fixtures.TypeclassDependencyOrder.testDependentTypeclassOrder

  -- 1. Ensure α appears BEFORE [DummyTypeclass α]
  let posAlpha := substringIndex sThm "(α : Type)"
  let posTc := substringIndex sThm "[DummyTypeclass α]"
  match posAlpha, posTc with
  | some pa, some ptc =>
    if ptc < pa then
      IO.println s!"[FAIL] Typeclass [DummyTypeclass α] was placed BEFORE (α : Type):\n  {sThm}"
      ok := false
  | _, _ =>
    IO.println s!"[FAIL] Missing expected binders in signature:\n  {sThm}"
    ok := false

  -- 2. Ensure [DummyTypeclass α] is not duplicated
  let countTc := countOccurrences sThm "[DummyTypeclass α]"
  if countTc > 1 then
    IO.println s!"[FAIL] Typeclass instance [DummyTypeclass α] was duplicated:\n  {sThm}"
    ok := false

  if ok then
    IO.println "Success: Typeclass dependency ordering tests passed."
    return 0
  else
    return 1

#eval show IO Unit from do
  let res ← main
  if res != 0 then
    throw (IO.userError "Typeclass dependency ordering assertions failed.")
