-- FILENAME: Litlib/Core/CLI.lean

import Lean
import Litlib.Core.CLI.Engine
import Litlib.Core.CLI.Bibtex
import Litlib.Core.CLI.CodeSummary
import Litlib.Core.CLI.Dashboard

open Lean

namespace Litlib.Core.CLI

def parseArgs (args : List String) : CliContext := Id.run do
  let mut ctx : CliContext := {}
  for arg in args do
    if arg == "--dashboard" then ctx := { ctx with action := "dashboard" }
    else if arg == "--code-summary" then ctx := { ctx with action := "code-summary" }
    else if arg == "--bibtex" then ctx := { ctx with action := "bibtex" }
    else if arg.startsWith "--theorems=" then
      let globs := (arg.drop 11).toString.splitOn "," |>.map myTrim
      ctx := { ctx with targetTheorems := true, theoremGlobs := globs }
    else if arg == "--theorems" then
      ctx := { ctx with targetTheorems := true, theoremGlobs := ["all"] }
    else if arg.startsWith "--references=" then
      let globs := (arg.drop 13).toString.splitOn "," |>.map myTrim
      ctx := { ctx with targetReferences := true, referenceGlobs := globs }
    else if arg == "--references" then
      ctx := { ctx with targetReferences := true, referenceGlobs := ["all"] }
    else if arg == "--all" then
      ctx := { ctx with targetTheorems := true, theoremGlobs := ["all"], targetReferences := true, referenceGlobs := ["all"] }

  if !ctx.targetTheorems && !ctx.targetReferences then
    ctx := { ctx with targetTheorems := true, theoremGlobs := ["all"] }
  return ctx

def runCli (rootModule : Name) (args : List String) : IO UInt32 := do
  let ctx := parseArgs args
  let modules ← discoverModules rootModule

  if modules.isEmpty then
    IO.println s!"No compiled modules found for {rootModule}. Did you run 'lake build'?"
    return 1

  let env ← Lean.importModules (modules.map (fun m => { module := m })) {}
  let (globalData, _) ← (extractAllTheorems env ctx).toIO { fileName := "<litlib>", fileMap := default } { env := env }

  if ctx.action == "dashboard" then
    return ← runDashboard rootModule globalData ctx
  else if ctx.action == "code-summary" then
    return ← runCodeSummary globalData
  else if ctx.action == "bibtex" then
    return ← runBibtex globalData
  else
    IO.println s!"Unknown action: {ctx.action}"
    return 1

end Litlib.Core.CLI
