-- FILENAME: Tests/CLI/Summary/TestDefProofLeak.lean

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

  let env ← importModules #[{ module := `Tests.Fixtures.ProofStripping }] {}
  let mut ok := true

  -- P8: def ... where structures must strip tactic bodies into `:= by ...`
  let sWhereEquiv ← ppDecl env `Tests.Fixtures.ProofStripping.testDefWhereEquiv
  if stringContains sWhereEquiv "\n    rfl" || !stringContains sWhereEquiv "left_inv a := by ..." then
    IO.println s!"[FAIL] def ... where structure leaked tactical proof body:\n  {sWhereEquiv}"
    ok := false

  -- P7: def with inline have ... := by must preserve the clean definition signature
  let sHaveDef ← ppDecl env `Tests.Fixtures.ProofStripping.testDefInlineHave
  if !stringContains sHaveDef "testDefInlineHave (x : Nat)" then
    IO.println s!"[FAIL] def with inline have mangled signature:\n  {sHaveDef}"
    ok := false

  if ok then
    IO.println "Success: Definition proof leak test passed."
    return 0
  else
    return 1

#eval show IO Unit from do
  let res ← main
  if res != 0 then
    throw (IO.userError "Definition proof leak assertions failed.")
