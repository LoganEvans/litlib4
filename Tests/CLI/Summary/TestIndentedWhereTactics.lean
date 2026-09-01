-- FILENAME: Tests/CLI/Summary/TestIndentedWhereTactics.lean

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

  let env ← importModules #[{ module := `Tests.Fixtures.IndentedWhereTactics }] {}
  let mut ok := true

  let sNested ← ppDecl env `Tests.Fixtures.IndentedWhereTactics.testNestedWhereProof

  -- Must contain the stripped summary
  if !stringContains sNested "field_proof n := by ..." then
    IO.println s!"[FAIL] Where block missing stripped field_proof summary:\n  {sNested}"
    ok := false

  -- Must NOT leak nested `have` lines
  if stringContains sNested "h_inner" || stringContains sNested "h_eq" then
    IO.println s!"[FAIL] Where block leaked internal have tactic lines:\n  {sNested}"
    ok := false

  if ok then
    IO.println "Success: Indented where tactics tests passed."
    return 0
  else
    return 1

#eval show IO Unit from do
  let res ← main
  if res != 0 then
    throw (IO.userError "Indented where tactics assertions failed.")
