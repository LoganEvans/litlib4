-- FILENAME: Tests/CLI/Summary/TestSignatureOnlyCrawl.lean

import Lean
import Litlib.Core.CLI
import Tests.Fixtures.SignatureOnlyCrawl

open Lean Litlib.Core.CLI

def main : IO UInt32 := do
  Lean.initSearchPath (← Lean.findSysroot)
  let mut sp ← Lean.searchPathRef.get
  let buildLib := System.FilePath.mk ".lake" / "build" / "lib" / "lean"
  if !(sp.contains buildLib) then
    Lean.searchPathRef.set (buildLib :: sp)

  let env ← importModules #[{ module := `Tests.Fixtures.SignatureOnlyCrawl }] {}
  let ctx : CliContext := {
    action := "code-summary",
    litlibTheoremsOnly := true,
    targetTheorems := true,
    theoremGlobs := ["Tests.Fixtures.SignatureOnlyCrawl.*"],
    explicitFilters := true
  }

  let ctxCore : Core.Context := { fileName := "<litlib>", fileMap := default }
  let state : Core.State := { env := env }

  let (globalData, _) ← (extractAllTheorems env ctx).toIO ctxCore state
  let (roots, _) ← (gatherRoots `Tests.Fixtures.SignatureOnlyCrawl globalData ctx).toIO ctxCore state
  let (allConsts, _) ← (collectLocalDepsRec `Tests.Fixtures.SignatureOnlyCrawl roots.toList roots).toIO ctxCore state

  let constNames := allConsts.toList.map (·.toString)

  -- Tracked theorem must be gathered
  if !constNames.contains "Tests.Fixtures.SignatureOnlyCrawl.trackedTheoremWithDef" then
    IO.println "[FAIL] Tracked theorem was not collected."
    return 1

  IO.println "Success: Signature-only crawling tests passed."
  return 0

#eval show IO Unit from do
  let res ← main
  if res != 0 then
    throw (IO.userError "Signature-only crawling assertions failed.")
