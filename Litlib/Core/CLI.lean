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

def getFlagValue (arg : String) : String :=
  let parts := arg.splitOn "="
  if parts.length >= 2 then
    String.intercalate "=" (parts.drop 1)
  else
    ""

def parseArgs (args : List String) : CliContext := Id.run do
  let mut ctx : CliContext := {}
  for arg in args do
    if arg == "--help" || arg == "-h" then
      ctx := { ctx with action := "help" }
    else if arg == "--dashboard" then
      ctx := { ctx with action := "dashboard" }
    else if arg.startsWith "--dashboard=" then
      let globs := (getFlagValue arg).splitOn "," |>.map (fun s => sanitizePathToModule s.trimAscii.toString)
      ctx := { ctx with action := "dashboard", targetTheorems := true, theoremGlobs := globs, targetReferences := true, referenceGlobs := globs, explicitFilters := true }
    else if arg.startsWith "--latex" then
      let dir := if arg.startsWith "--latex=" then getFlagValue arg else "latex-artifacts"
      ctx := { ctx with action := "code-summary", latexDir := some dir }
    else if arg.startsWith "--code-summary" then
      ctx := { ctx with action := "code-summary" }
      let val := if arg.startsWith "--code-summary=" then getFlagValue arg else "all"
      let cleanVal := sanitizePathToModule val

      if cleanVal == "all" || cleanVal == "" then
        ctx := { ctx with targetTheorems := true, theoremGlobs := ["all"], targetReferences := true, referenceGlobs := ["all"], explicitFilters := true }
      else if cleanVal == "litlib_track" then
        ctx := { ctx with litlibTheoremsOnly := true, targetTheorems := true, theoremGlobs := ["all"], targetReferences := true, referenceGlobs := ["all"], explicitFilters := true }
      else if cleanVal == "theorem" || cleanVal == "theorems" then
        ctx := { ctx with targetTheorems := true, theoremGlobs := ["all"], targetReferences := false, explicitFilters := true }
      else if cleanVal == "reference" || cleanVal == "references" then
        ctx := { ctx with targetTheorems := false, targetReferences := true, referenceGlobs := ["all"], explicitFilters := true }
      else
        let globs := val.splitOn "," |>.map (fun s => sanitizePathToModule s.trimAscii.toString)
        ctx := { ctx with targetTheorems := true, theoremGlobs := globs, targetReferences := true, referenceGlobs := globs, explicitFilters := true }
    else if arg == "--bibtex" then
      ctx := { ctx with action := "bibtex" }
    else if arg.startsWith "--bibtex=" then
      let globs := (getFlagValue arg).splitOn "," |>.map (fun s => sanitizePathToModule s.trimAscii.toString)
      ctx := { ctx with action := "bibtex", targetReferences := true, referenceGlobs := globs, explicitFilters := true }
    else if arg.startsWith "--theorem=" then
      let globs := (getFlagValue arg).splitOn "," |>.map (fun s => sanitizePathToModule s.trimAscii.toString)
      ctx := { ctx with targetTheorems := true, theoremGlobs := ctx.theoremGlobs ++ globs, explicitFilters := true }
    else if arg == "--theorem" then
      ctx := { ctx with targetTheorems := true, theoremGlobs := ["all"], explicitFilters := true }
    else if arg.startsWith "--reference=" then
      let globs := (getFlagValue arg).splitOn "," |>.map (fun s => sanitizePathToModule s.trimAscii.toString)
      ctx := { ctx with targetReferences := true, referenceGlobs := ctx.referenceGlobs ++ globs, explicitFilters := true }
    else if arg == "--reference" then
      ctx := { ctx with targetReferences := true, referenceGlobs := ["all"], explicitFilters := true }
    else if arg == "--all" then
      ctx := { ctx with targetTheorems := true, theoremGlobs := ["all"], targetReferences := true, referenceGlobs := ["all"], explicitFilters := true }

  if ctx.action == "code-summary" && !ctx.explicitFilters then
    if ctx.latexDir.isSome then
      -- Handled in runCli by searching for .leanrefs
      pure ()
    else
      ctx := { ctx with targetTheorems := true, theoremGlobs := ["all"], targetReferences := true, referenceGlobs := ["all"] }

  if !ctx.targetTheorems && !ctx.targetReferences && !ctx.explicitFilters then
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

/-- Safely extracts bare names from both plain-text line endings and LaTeX-generated `.leanrefs` macros -/
def parseLeanrefLine (line : String) : Option String :=
  let trimmed := line.trimAscii.toString
  if trimmed == "" then none
  else if trimmed.startsWith "\\" then
    let parts := trimmed.splitOn "\\hyperref[lean:"
    if parts.length > 1 then
      let afterRef := parts[1]!
      let nameParts := afterRef.splitOn "]"
      if nameParts.length > 0 then
        some nameParts[0]!
      else none
    else none
  else
    some trimmed

def runCli (rootModule : Name) (args : List String) : IO UInt32 := do
  let mut ctx := parseArgs args

  if ctx.action == "help" then
    return ← printHelp

  if ctx.action == "code-summary" && ctx.latexDir.isSome && !ctx.explicitFilters then
    let dir := System.FilePath.mk ctx.latexDir.get!
    let mut foundRefs : Array String := #[]
    if ← dir.isDir then
      try
        for entry in ← dir.readDir do
          if entry.path.extension == some "leanrefs" then
            let content ← IO.FS.readFile entry.path
            let lines := content.splitOn "\n"
            for line in lines do
              if let some ref := parseLeanrefLine line then
                if !foundRefs.contains ref then
                  foundRefs := foundRefs.push ref
      catch _ => pure ()
    if !foundRefs.isEmpty then
      ctx := { ctx with targetTheorems := true, theoremGlobs := foundRefs.toList, targetReferences := true, referenceGlobs := foundRefs.toList, explicitFilters := true }
    else
      ctx := { ctx with litlibTheoremsOnly := true, targetTheorems := true, theoremGlobs := ["all"], targetReferences := true, referenceGlobs := ["all"], explicitFilters := true }

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
