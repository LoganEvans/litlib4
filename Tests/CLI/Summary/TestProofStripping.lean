-- FILENAME: Tests/CLI/Summary/TestProofStripping.lean

import Lean
import Litlib.Core.CLI

open Lean Litlib.Core.CLI

def stringContains (s sub : String) : Bool :=
  (s.splitOn sub).length > 1

/-- Strips docstrings (`/-- ... -/`) and line comments before checking for proof tokens -/
def stripDocstringsAndComments (s : String) : String := Id.run do
  let parts := s.splitOn "-/"
  let codeWithoutDoc := if parts.length > 1 then parts.getLast! else s
  let lines := codeWithoutDoc.splitOn "\n"
  let nonCommentLines := lines.filter (fun l => !l.trimAscii.toString.startsWith "--")
  String.intercalate "\n" nonCommentLines

def checkStripped (env : Environment) (name : Name) (forbidden : List String) : IO Bool := do
  let s ← ppDecl env name
  let cleanCode := stripDocstringsAndComments s
  for f in forbidden do
    if stringContains cleanCode f then
      IO.println s!"[FAIL] Declaration '{name}' contains forbidden proof substring '{f}':\n  {s}"
      return false
  return true

def checkMustContain (env : Environment) (name : Name) (expected : List String) : IO Bool := do
  let s ← ppDecl env name
  for e in expected do
    if !stringContains s e then
      IO.println s!"[FAIL] Declaration '{name}' missing expected signature substring '{e}':\n  {s}"
      return false
  return true

def main : IO UInt32 := do
  Lean.initSearchPath (← Lean.findSysroot)
  let mut sp ← Lean.searchPathRef.get
  let buildLib := System.FilePath.mk ".lake" / "build" / "lib" / "lean"
  if !(sp.contains buildLib) then
    Lean.searchPathRef.set (buildLib :: sp)

  let env ← importModules #[{ module := `Tests.Fixtures.ProofStripping }] {}
  let mut ok := true

  -- P1: Inline By must have proof stripped
  if !(← checkStripped env `Tests.Fixtures.ProofStripping.testInlineBy ["by", "rfl"]) then
    ok := false

  -- P2: Multiline By must have proof stripped
  if !(← checkStripped env `Tests.Fixtures.ProofStripping.testMultilineBy ["by", "rfl"]) then
    ok := false

  -- P3: Term Mode proof (:= rfl) must have := rfl stripped
  let sTerm ← ppDecl env `Tests.Fixtures.ProofStripping.testTermMode
  if stringContains sTerm "rfl" || stringContains sTerm ":=" then
    IO.println s!"[FAIL] Term-mode proof was not stripped:\n  {sTerm}"
    ok := false

  -- P6: Default parameter with `by` must keep signature intact and only strip trailing proof
  let sParamBy ← ppDecl env `Tests.Fixtures.ProofStripping.testParamDefaultBy
  if !stringContains sParamBy "x + 0 = x" then
    IO.println s!"[FAIL] Parameter default 'by' prematurely truncated signature:\n  {sParamBy}"
    ok := false
  if stringContains sParamBy "rfl" then
    IO.println s!"[FAIL] Trailing proof 'rfl' was not stripped from parameter default theorem:\n  {sParamBy}"
    ok := false

  if ok then
    IO.println "Success: Proof stripping tests passed."
    return 0
  else
    return 1

#eval show IO Unit from do
  let res ← main
  if res != 0 then
    throw (IO.userError "Proof stripping assertions failed.")
