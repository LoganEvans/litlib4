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
    else if arg.startsWith "--code-summary" then
      ctx := { ctx with action := "code-summary" }
      let val := if arg.contains "=" then 
        let parts := arg.splitOn "="
        if parts.length >= 2 then parts[1]! else "all"
      else "all"
      
      if val == "all" || val == "" then
        ctx := { ctx with targetTheorems := true, theoremGlobs := ["all"], targetReferences := true, referenceGlobs := ["all"] }
      else if val == "theorem" || val == "theorems" then
        ctx := { ctx with targetTheorems := true, theoremGlobs := ["all"], targetReferences := false }
      else if val == "reference" || val == "references" then
        ctx := { ctx with targetTheorems := false, targetReferences := true, referenceGlobs := ["all"] }
      else
        let globs := val.splitOn "," |>.map myTrim
        ctx := { ctx with targetTheorems := true, theoremGlobs := globs, targetReferences := true, referenceGlobs := globs }
    else if arg == "--bibtex" then
      ctx := { ctx with action := "bibtex" }
    else if arg.startsWith "--bibtex=" then
      let globs := (arg.drop 9).toString.splitOn "," |>.map myTrim
      ctx := { ctx with action := "bibtex", targetReferences := true, referenceGlobs := globs }
    else if arg.startsWith "--theorem=" then
      let globs := (arg.drop 10).toString.splitOn "," |>.map myTrim
      ctx := { ctx with targetTheorems := true, theoremGlobs := globs }
    else if arg == "--theorem" then
      ctx := { ctx with targetTheorems := true, theoremGlobs := ["all"] }
    else if arg.startsWith "--reference=" then
      let globs := (arg.drop 12).toString.splitOn "," |>.map myTrim
      ctx := { ctx with targetReferences := true, referenceGlobs := globs }
    else if arg == "--reference" then
      ctx := { ctx with targetReferences := true, referenceGlobs := ["all"] }
    else if arg == "--all" then
      ctx := { ctx with targetTheorems := true, theoremGlobs := ["all"], targetReferences := true, referenceGlobs := ["all"] }

  -- Default filtering behaviors
  if !ctx.targetTheorems && !ctx.targetReferences then
    if ctx.action == "bibtex" then
      ctx := { ctx with targetReferences := true, referenceGlobs := ["all"] }
    else if ctx.action == "code-summary" then
      ctx := { ctx with targetTheorems := true, theoremGlobs := ["all"], targetReferences := true, referenceGlobs := ["all"] }
    else
      ctx := { ctx with targetTheorems := true, theoremGlobs := ["all"] }
      
  return ctx

def runCli (rootModule : Name) (args : List String) : IO UInt32 := do
  -- 1. Universally populate the search path so that downstream CLI wrappers don't fail
  Lean.initSearchPath (← Lean.findSysroot)
  let mut sp ← Lean.searchPathRef.get
  
  let candidates := #[
    System.FilePath.mk ".lake" / "build" / "lib",
    System.FilePath.mk "build" / "lib"
  ]
  for c in candidates do
    if ← c.isDir then
      if !sp.contains c then sp := c :: sp

  let packagesDir := System.FilePath.mk ".lake" / "packages"
  if ← packagesDir.isDir then
    for entry in ← packagesDir.readDir do
      let pkgLib1 := entry.path / "build" / "lib"
      let pkgLib2 := entry.path / ".lake" / "build" / "lib"
      if ← pkgLib1.isDir then
        if !sp.contains pkgLib1 then sp := pkgLib1 :: sp
      if ← pkgLib2.isDir then
        if !sp.contains pkgLib2 then sp := pkgLib2 :: sp

  Lean.searchPathRef.set sp

  -- 2. Execute CLI engine
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
