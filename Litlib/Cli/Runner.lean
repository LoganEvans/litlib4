-- FILENAME: Litlib/Cli/Runner.lean

import Lean
import Litlib.Core

open Lean

namespace Litlib.Cli.Runner

/-- Initializes the Lean environment with the given root module loaded. -/
def loadEnv (rootModule : Name) : IO Environment := do
  Lean.initSearchPath (← Lean.findSysroot)
  try
    Lean.importModules #[{ module := rootModule }] Options.empty
  catch e =>
    IO.eprintln s!"Error loading module {rootModule}: {e.toString}"
    throw e

/-- Executes a CoreM action against a pre-loaded environment. -/
def runCore (env : Environment) (x : CoreM Unit) : IO Unit := do
  let ctx : Core.Context := { fileName := "<cli>", fileMap := default }
  let state : Core.State := { env := env }
  let _ ← x.toIO ctx state
  return ()

/-- 
Core logic for litlib CLI. 
Loads the given downstream root module and runs the appropriate report. 
-/
def runCli (rootModule : Name) (args : List String) : IO UInt32 := do
  match args with
  | ["--bibtex"] | ["--litlib-bibtex"] =>
    let env ← loadEnv rootModule
    let _ ← runCore env do
      IO.println s!"[Stub] Crawling litlibExt in {rootModule} for dependencies to generate .bib file..."
    return 0

  | ["--dashboard"] | ["--litlib-dashboard"] =>
    let env ← loadEnv rootModule
    let _ ← runCore env do
      IO.println "\n===================================================================="
      IO.println s!"                        {rootModule.toString.toUpper} DASHBOARD"
      IO.println "===================================================================="
      
      let mut tagged := env.constants.fold (fun acc declName _ =>
        match litlibTheoremExt.find? env declName with
        | some desc => acc.push (declName, desc)
        | none => acc
      ) (#[] : Array (Name × String))

      tagged := tagged.qsort (fun a b => a.1.toString < b.1.toString)

      if tagged.isEmpty then
        IO.println "\n  (No theorems tracked with Litlib.theorem found.)\n"
        return ()

      let mut fullyProved := 0
      let mut incomplete := 0

      for (declName, desc) in tagged do
        -- Check for `sorry` to determine proof status
        let info := env.find? declName
        let hasSorry := match info with
          | some (ConstantInfo.thmInfo t) => t.value.hasSorry
          | some (ConstantInfo.defnInfo d) => d.value.hasSorry
          | _ => false
        
        if hasSorry then incomplete := incomplete + 1 else fullyProved := fullyProved + 1
        let statusIcon := if hasSorry then "[⚠ SORRY ]" else "[✔ PROVED]"
        
        IO.println s!"\n{statusIcon} {desc}"
        IO.println s!"  ↳ Lean: {declName}"
        
        -- Magically extract Literature Dependencies from the type signature
        let deps := if let some i := info then
          i.type.foldConsts (#[] : Array Name) fun n acc =>
            if (litlibExt.getState env).contains n && !acc.contains n then acc.push n else acc
        else #[]

        if deps.isEmpty then
          IO.println "  ↳ Literature Dependencies: None detected."
        else
          IO.println "  ↳ Literature Dependencies:"
          for dep in deps do
            -- FIX: Safely unwrapping the Option returned by .find?
            if let some data := (litlibExt.getState env).find? dep then
              let authDisplay := if data.authors.isEmpty then "Unknown" else data.authors.head!
              IO.println s!"    • {authDisplay} - {dep.getString!}"

      IO.println "\n===================================================================="
      IO.println s!"Total Tracked Theorems: {tagged.size}  |  Fully Proved: {fullyProved}  |  Incomplete: {incomplete}\n"
        
    return 0

  | _ =>
    IO.println "Usage: [exe] [--litlib-bibtex | --litlib-dashboard]"
    return 1

end Litlib.Cli.Runner
