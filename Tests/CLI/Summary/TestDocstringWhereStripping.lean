-- FILENAME: Tests/CLI/Summary/TestDocstringWhereStripping.lean

import Lean
import Litlib.Core.CLI

open Lean Litlib.Core.CLI

def stringContains (s sub : String) : Bool :=
  (s.splitOn sub).length > 1

/-- Strips docstring header to isolate theorem statement -/
def stripDocstring (s : String) : String := Id.run do
  let parts := s.splitOn "-/"
  if parts.length > 1 then parts.getLast! else s

def main : IO UInt32 := do
  Lean.initSearchPath (← Lean.findSysroot)
  let mut sp ← Lean.searchPathRef.get
  let buildLib := System.FilePath.mk ".lake" / "build" / "lib" / "lean"
  if !(sp.contains buildLib) then
    Lean.searchPathRef.set (buildLib :: sp)

  let env ← importModules #[{ module := `Tests.Fixtures.DocstringWhere }] {}
  let sThm ← ppDecl env `Tests.Fixtures.DocstringWhere.testDocstringWithWhere
  let codeOnly := stripDocstring sThm

  -- 1. Signature must be preserved
  if !stringContains codeOnly "theorem testDocstringWithWhere (x : Nat) : x + 0 = x" then
    IO.println s!"[FAIL] Theorem signature was mangled:\n  {sThm}"
    return 1

  -- 2. Internal proofs (have, calc, rfl, by) must be completely stripped from the statement
  if stringContains codeOnly "have h_inner" || stringContains codeOnly "calc" || stringContains codeOnly ":= by" then
    IO.println s!"[FAIL] Theorem proof leaked because docstring contained 'where':\n  {sThm}"
    return 1

  IO.println "Success: Docstring where stripping regression test passed."
  return 0

#eval show IO Unit from do
  let res ← main
  if res != 0 then
    throw (IO.userError "Docstring where stripping regression test failed.")
