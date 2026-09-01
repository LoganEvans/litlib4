-- FILENAME: Tests/CLI/Summary/TestBinderHygiene.lean

import Lean
import Litlib.Core.CLI

open Lean Litlib.Core.CLI

def stringContains (s sub : String) : Bool :=
  (s.splitOn sub).length > 1

def substringIndex (s sub : String) : Option Nat :=
  let parts := s.splitOn sub
  if parts.length > 1 then some parts[0]!.length else none

def main : IO UInt32 := do
  Lean.initSearchPath (← Lean.findSysroot)
  let mut sp ← Lean.searchPathRef.get
  let buildLib := System.FilePath.mk ".lake" / "build" / "lib" / "lean"
  if !(sp.contains buildLib) then
    Lean.searchPathRef.set (buildLib :: sp)

  let env ← importModules #[{ module := `Tests.Fixtures.BinderHygiene }] {}
  let mut ok := true

  -- B1: Anonymous Typeclass Binder must not contain compiler hygiene hashes (inst._@...)
  let sAnon ← ppDecl env `Tests.Fixtures.BinderHygiene.testAnonTypeclass
  if stringContains sAnon "inst._@" || stringContains sAnon "_hyg" then
    IO.println s!"[FAIL] Anonymous typeclass has hygiene pollution:\n  {sAnon}"
    ok := false

  -- B3: Return type function arrows must not inject ghost parameters (a._@...)
  let sArrows ← ppDecl env `Tests.Fixtures.BinderHygiene.testReturnArrows
  if stringContains sArrows "a._@" || stringContains sArrows "_internal" then
    IO.println s!"[FAIL] Return arrows injected ghost parameters:\n  {sArrows}"
    ok := false

  -- B4: Dependent Binder Ordering (n must precede i : Fin n)
  let sDep ← ppDecl env `Tests.Fixtures.BinderHygiene.testDependentOrder
  let posN := substringIndex sDep "n : Nat"
  let posFin := substringIndex sDep "i : Fin n"
  match posN, posFin with
  | some pn, some pf =>
    if pf < pn then
      IO.println s!"[FAIL] Dependent binders out of order:\n  {sDep}"
      ok := false
  | _, _ =>
    IO.println s!"[FAIL] Missing expected binders in dependent signature:\n  {sDep}"
    ok := false

  if ok then
    IO.println "Success: Binder hygiene tests passed."
    return 0
  else
    return 1

#eval show IO Unit from do
  let res ← main
  if res != 0 then
    throw (IO.userError "Binder hygiene assertions failed.")
