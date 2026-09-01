-- FILENAME: Tests/CLI/Summary/TestDefTacticStripping.lean

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

  let env ← importModules #[{ module := `Tests.Fixtures.DefProofStripping }] {}
  let sDef ← ppDecl env `Tests.Fixtures.DefProofStripping.tacticModeSubtypeDef

  -- Must preserve signature
  if !stringContains sDef "def tacticModeSubtypeDef (x : Nat) : { n : Nat // n = x }" then
    IO.println s!"[FAIL] Signature of tactic-mode def was mangled:\n  {sDef}"
    return 1

  -- Must NOT leak internal tactic script
  if stringContains sDef "have h_eq" || stringContains sDef "exact ⟨x, h_eq⟩" then
    IO.println s!"[FAIL] Tactic script leaked inside definition body:\n  {sDef}"
    return 1

  IO.println "Success: Definition tactic proof stripping tests passed."
  return 0

#eval show IO Unit from do
  let res ← main
  if res != 0 then
    throw (IO.userError "Definition tactic proof stripping assertions failed.")
