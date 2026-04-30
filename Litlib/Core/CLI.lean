-- FILENAME: Litlib/Core/CLI.lean

import Lean
import Litlib.Core.CLI.Engine
import Litlib.Core.CLI.Dashboard
import Litlib.Core.CLI.Bibtex
import Litlib.Core.CLI.CodeSummary

open Lean

namespace Litlib.Core.CLI

/-- Core entry point for the Litlib CLI. -/
def runCli (rootModule : Name) (args : List String) : IO UInt32 := do
  Lean.initSearchPath (← Lean.findSysroot)
  
  -- 1. Scan for all valid non-stale files
  let allMods ← discoverModules rootModule
  IO.println s!"[Info] Discovered {allMods.size} module(s). Processing..."
  
  -- 2. Load the mathematically sound, unified environment
  let imports := allMods.map (fun m => { module := m : Import })
  let env ← try
    Lean.importModules imports Options.empty
  catch e =>
    IO.println ""
    IO.println "===================================================================="
    IO.println "             FATAL ERROR: NAMESPACE COLLISION DETECTED"
    IO.println "===================================================================="
    IO.println "Lean's C++ kernel requires a mathematically unified environment to"
    IO.println "build the project dependency graph. It looks like you have a duplicate"
    IO.println "global definition across your files."
    IO.println ""
    IO.println s!"Details: {e.toString}"
    IO.println ""
    IO.println "Please deduplicate the offending definition and try again."
    IO.println "===================================================================="
    return (1 : UInt32)

  -- 3. Extract the theorems securely inside a single optimized CoreM run
  let ctx : Core.Context := { fileName := "<cli>", fileMap := default }
  let state : Core.State := { env := env }
  let (globalData, _) ← (extractAllTheorems env).toIO ctx state

  -- 4. Dispatch to the presentation logic
  match args with
  | ["--bibtex"] | ["--litlib-bibtex"] => 
    runBibtex globalData
  | ["--dashboard"] | ["--litlib-dashboard"] => 
    runDashboard rootModule globalData
  | ["--code-summary"] | ["--litlib-code-summary"] => 
    runCodeSummary globalData
  | _ =>
    IO.println "Usage: [exe] [--litlib-bibtex | --litlib-dashboard | --litlib-code-summary]"
    return (1 : UInt32)

end Litlib.Core.CLI
