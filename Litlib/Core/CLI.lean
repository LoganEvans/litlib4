-- FILENAME: Litlib/Core/CLI.lean

import Lean
import Litlib.Core.CLI.Engine
import Litlib.Core.CLI.Bibtex
import Litlib.Core.CLI.CodeSummary
import Litlib.Core.CLI.Dashboard
import Litlib.Core.CLI.Help

open Lean

namespace Litlib.Core.CLI

def sanitizePathToModule (val : String) : String :=
  let cleanVal := val.replace "'" "" |>.replace "\"" ""
  let cleanVal := cleanVal.replace "\\" "/"
  let cleanVal := if cleanVal.endsWith ".lean" then (cleanVal.dropEnd 5).toString else cleanVal
  cleanVal.replace "/" "."

def parseArgs (args : List String) : CliContext := Id.run do
  let mut ctx : CliContext := {}
  for arg in args do
    if arg == "--help" || arg == "-h" then
      ctx := { ctx with action := "help" }
    else if arg == "--dashboard" then
      ctx := { ctx with action := "dashboard" }
    else if arg.startsWith "--dashboard=" then
      let globs := (arg.drop 12).toString.splitOn "," |>.map (fun s => sanitizePathToModule s.trimAscii.toString)
      ctx := { ctx with action := "dashboard", targetTheorems := true, theoremGlobs := ctx.theoremGlobs ++ globs, targetReferences := true, referenceGlobs := ctx.referenceGlobs ++ globs, explicitFilters := true }
    else if arg.startsWith "--latex=" then
      let dir := (arg.drop 8).toString
      ctx := { ctx with action := "code-summary", latexDir := some dir }
    else if arg == "--latex" then
      ctx := { ctx with action := "code-summary", latexDir := some "latex-artifacts" }
    else if arg.startsWith "--code-summary=" then
      ctx := { ctx with action := "code-summary" }
      let val := sanitizePathToModule (arg.drop 15).toString
      if val == "all" || val == "" then
        ctx := { ctx with targetTheorems := true, theoremGlobs := ["all"], targetReferences := true, referenceGlobs := ["all"] }
      else if val == "litlib_track" then
        ctx := { ctx with litlibTheoremsOnly := true, targetTheorems := true, theoremGlobs := ["all"], targetReferences := true, referenceGlobs := ["all"] }
      else if val == "theorem" || val == "theorems" then
        ctx := { ctx with targetTheorems := true, theoremGlobs := ["all"], targetReferences := false, explicitFilters := true }
      else if val == "reference" || val == "references" then
        ctx := { ctx with targetTheorems := false, targetReferences := true, referenceGlobs := ["all"], explicitFilters := true }
      else
        let globs := val.splitOn "," |>.map (fun s => s.trimAscii.toString)
        ctx := { ctx with targetTheorems := true, theoremGlobs := ctx.theoremGlobs ++ globs, targetReferences := true, referenceGlobs := ctx.referenceGlobs ++ globs, explicitFilters := true }
    else if arg == "--code-summary" then
      ctx := { ctx with action := "code-summary" }
    else if arg == "--bibtex" then
      ctx := { ctx with action := "bibtex" }
    else if arg.startsWith "--bibtex=" then
      let globs := (arg.drop 9).toString.splitOn "," |>.map (fun s => sanitizePathToModule s.trimAscii.toString)
      ctx := { ctx with action := "bibtex", targetReferences := true, referenceGlobs := ctx.referenceGlobs ++ globs, explicitFilters := true }
    else if arg.startsWith "--theorem=" then
      let globs := (arg.drop 10).toString.splitOn "," |>.map (fun s => sanitizePathToModule s.trimAscii.toString)
      ctx := { ctx with targetTheorems := true, theoremGlobs := ctx.theoremGlobs ++ globs, explicitFilters := true }
    else if arg == "--theorem" then
      ctx := { ctx with targetTheorems := true, theoremGlobs := ctx.theoremGlobs ++ ["all"], explicitFilters := true }
    else if arg.startsWith "--reference=" then
      let globs := (arg.drop 12).toString.splitOn "," |>.map (fun s => sanitizePathToModule s.trimAscii.toString)
      ctx := { ctx with targetReferences := true, referenceGlobs := ctx.referenceGlobs ++ globs, explicitFilters := true }
    else if arg == "--reference" then
      ctx := { ctx with targetReferences := true, referenceGlobs := ctx.referenceGlobs ++ ["all"], explicitFilters := true }
    else if arg == "--all" then
      ctx := { ctx with targetTheorems := true, theoremGlobs := ["all"], targetReferences := true, referenceGlobs := ["all"], explicitFilters := true }

  if ctx.action == "code-summary" && !ctx.targetTheorems && !ctx.targetReferences then
    if ctx.latexDir.isSome || ctx.litlibTheoremsOnly then
      ctx := { ctx with litlibTheoremsOnly := true, targetTheorems := true, theoremGlobs := ["all"], targetReferences := true, referenceGlobs := ["all"] }
    else
      ctx := { ctx with targetTheorems := true, theoremGlobs := ["all"], targetReferences := true, referenceGlobs := ["all"] }

  if !ctx.targetTheorems && !ctx.targetReferences then
    if ctx.action == "bibtex" then
      ctx := { ctx with targetReferences := true, referenceGlobs := ["all"] }
    else if ctx.action == "dashboard" then
      ctx := { ctx with targetTheorems := true, theoremGlobs := ["all"], targetReferences := true, referenceGlobs := ["all"] }

  return ctx

def nameToFilePath : Name → System.FilePath
  | .anonymous => System.FilePath.mk "."
  | .str .anonymous s => System.FilePath.mk s
  | .str p s => nameToFilePath p / s
  | .num p _ => nameToFilePath p

partial def findOleans (dir : System.FilePath) (pref : Name) : IO (Array Name) := do
  let mut arr := #[]
  try
    for entry in ← dir.readDir do
      if ← entry.path.isDir then
        let nextPref := if pref == Name.anonymous then Name.mkSimple entry.fileName else pref ++ Name.mkSimple entry.fileName
        arr := arr ++ (← findOleans entry.path nextPref)
      else if entry.path.extension == some "olean" then
        if let some stem := entry.path.fileStem then
          let modName := if pref == Name.anonymous then Name.mkSimple stem else pref ++ Name.mkSimple stem
          arr := arr.push modName
  catch _ => pure ()
  return arr

def discoverModules (rootModule : Name) : IO (Array Name) := do
  let sp ← Lean.searchPathRef.get
  let mut allMods := #[]

  let targetRoots := if rootModule == `Litlib then #[`Litlib] else #[`Litlib, rootModule]

  for targetRoot in targetRoots do
    for p in sp do
      let rootOlean := p / s!"{targetRoot}.olean"
      if ← rootOlean.pathExists then
        if !allMods.contains targetRoot then allMods := allMods.push targetRoot

      let rootDir := p / targetRoot.toString
      if ← rootDir.isDir then
        let mods ← findOleans rootDir targetRoot
        for m in mods do
          if !allMods.contains m then allMods := allMods.push m

  if allMods.isEmpty then return #[rootModule] else return allMods

/-- Safely extracts lean identifiers from either raw text or LaTeX markup in a .leanrefs file -/
def parseLeanRefs (path : System.FilePath) : IO (List String) := do
  let mut refs : List String := []
  if ← path.pathExists then
    try
      let lines ← IO.FS.lines path
      for line in lines do
        let cleanLine := if line.contains "\\detokenize{" then
          let parts := line.splitOn "\\detokenize{"
          if parts.length > 1 then
            let subparts := parts[1]!.splitOn "}"
            subparts[0]!
          else line
        else line
        let trimmed := cleanLine.trimAscii.toString
        if !trimmed.isEmpty && !trimmed.startsWith "\\" && !trimmed.startsWith "%" then
          refs := refs ++ [trimmed]
    catch _ => pure ()
  return refs

def runCli (rootModule : Name) (args : List String) : IO UInt32 := do
  let mut ctx := parseArgs args

  if ctx.action == "help" then
    return ← printHelp

  -- Consult .leanrefs file ONLY if in LaTeX mode to gracefully filter cited theorems
  if let some dirStr := ctx.latexDir then
    let dir := System.FilePath.mk dirStr
    if ← dir.isDir then
      try
        for entry in ← dir.readDir do
          if entry.path.extension == some "leanrefs" then
            let refs ← parseLeanRefs entry.path
            if !refs.isEmpty then
              ctx := { ctx with
                targetTheorems := true, theoremGlobs := refs,
                targetReferences := true, referenceGlobs := refs,
                litlibTheoremsOnly := false, explicitFilters := true
              }
            break
      catch _ => pure ()

  Lean.initSearchPath (← Lean.findSysroot)
  let mut sp ← Lean.searchPathRef.get

  let candidates := #[
    System.FilePath.mk ".lake" / "build" / "lib" / "lean",
    System.FilePath.mk ".lake" / "build" / "lib",
    System.FilePath.mk "build" / "lib" / "lean",
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
      let pkgLib3 := entry.path / ".lake" / "build" / "lib" / "lean"
      if ← pkgLib1.isDir then if !sp.contains pkgLib1 then sp := pkgLib1 :: sp
      if ← pkgLib2.isDir then if !sp.contains pkgLib2 then sp := pkgLib2 :: sp
      if ← pkgLib3.isDir then if !sp.contains pkgLib3 then sp := pkgLib3 :: sp

  Lean.searchPathRef.set sp

  let modules ← discoverModules rootModule

  if modules.isEmpty then
    IO.println s!"No compiled modules found for {rootModule}. Did you run 'lake build'?"
    return 1

  let env ← Lean.importModules (modules.map (fun m => { module := m })) {}
  let (globalData, _) ← (extractAllTheorems env ctx).toIO { fileName := "<litlib>", fileMap := default } { env := env }

  if ctx.action == "dashboard" then
    return ← runDashboard rootModule globalData ctx
  else if ctx.action == "code-summary" then
    return ← runCodeSummary rootModule env globalData ctx
  else if ctx.action == "bibtex" then
    return ← runBibtex globalData
  else
    IO.println s!"Unknown action: {ctx.action}"
    return 1

end Litlib.Core.CLI
