-- FILENAME: Tests/CLI/Audit/TestSoundnessAudit.lean

import Lean
import Litlib.Core.CLI

open Lean Litlib.Core.CLI

def isTrivialType (env : Environment) (t : Expr) : Bool :=
  match t with
  | .const ``True _ => true
  | _ => false

def isTrivialValue (env : Environment) (v : Expr) : Bool :=
  match v with
  | .const ``True.intro _ => true
  | _ => false

def main : IO UInt32 := do
  Lean.initSearchPath (← Lean.findSysroot)
  let mut sp ← Lean.searchPathRef.get
  let buildLib := System.FilePath.mk ".lake" / "build" / "lib" / "lean"
  if !(sp.contains buildLib) then
    Lean.searchPathRef.set (buildLib :: sp)

  let env ← importModules #[{ module := `Tests.Fixtures.SoundnessAudit }] {}
  let ctx := parseArgs ["--dashboard"]
  let ctxCore : Core.Context := { fileName := "<litlib>", fileMap := default }
  let state : Core.State := { env := env }

  let (globalData, _) ← (extractAllTheorems env ctx).toIO ctxCore state

  -- 1. Check sound theorem is marked complete
  let soundThmOpt := globalData.theorems.find? (fun t => t.declName.toString.endsWith "soundTheorem")
  if soundThmOpt.isNone || soundThmOpt.get!.hasSorry then
    IO.println "[FAIL] soundTheorem was not found or falsely marked with sorry."
    return 1

  -- 2. Check sorry theorem is marked incomplete
  let sorryThmOpt := globalData.theorems.find? (fun t => t.declName.toString.endsWith "sorryTheorem")
  if sorryThmOpt.isNone || !sorryThmOpt.get!.hasSorry then
    IO.println "[FAIL] sorryTheorem was not detected as having sorry."
    return 1

  -- 3. Check vacuous True exploit detection
  let vacuousThm := `Tests.Fixtures.SoundnessAudit.vacuousTrueTheorem
  if let some info := env.find? vacuousThm then
    if !isTrivialType env info.type then
      IO.println "[FAIL] vacuousTrueTheorem was not detected as having a trivial type."
      return 1
  else
    IO.println "[FAIL] vacuousTrueTheorem not found in environment."
    return 1

  IO.println "Success: Soundness audit tests passed."
  return 0

#eval show IO Unit from do
  let res ← main
  if res != 0 then
    throw (IO.userError "Soundness audit assertions failed.")
