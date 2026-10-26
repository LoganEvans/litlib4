-- FILENAME: @litlib4/Litlib/Core/CLI.lean

import Lean
import Litlib.Core.CLI.Engine
import Litlib.Core.CLI.Bibtex
import Litlib.Core.CLI.CodeSummary
import Litlib.Core.CLI.Dashboard
import Litlib.Core.CLI.Help
import Litlib.Core.CLI.Dependencies
import Litlib.Core.CLI.Outline
import Litlib.Core.CLI.Lint

open Lean

namespace Litlib.Core.CLI

def sanitizePathToModule (val : String) : String :=
  let cleanVal := val.replace "'" "" |>.replace "\"" ""
  let cleanVal := cleanVal.replace "\\" "/"
  let cleanVal := if cleanVal.endsWith ".lean" then (cleanVal.dropEnd 5).toString else cleanVal
  cleanVal.replace "/" "."

private def applyFilterTokens (ctx : CliContext) (rawVal : String) : CliContext := Id.run do
  let tokens := rawVal.splitOn "," |>.map (fun s => sanitizePathToModule s.trimAscii.toString) |>.filter (· != "")
  let mut c := { ctx with filterTokens := ctx.filterTokens ++ tokens }
  if tokens.isEmpty || tokens == ["all"] || tokens == ["*"] then
    c := { c with targetTheorems := true, theoremGlobs := ["all"], targetReferences := true, referenceGlobs := ["all"] }
  else if tokens == ["litlib_track"] then
    c := { c with litlibTheoremsOnly := true, targetTheorems := true, theoremGlobs := ["all"], targetReferences := true, referenceGlobs := ["all"] }
  else if tokens == ["leaf"] || tokens == ["leaves"] then
    c := { c with leafOnly := true, targetTheorems := true, theoremGlobs := ["all"], targetReferences := true, referenceGlobs := ["all"] }
  else if tokens == ["theorem"] || tokens == ["theorems"] then
    c := { c with targetTheorems := true, theoremGlobs := ["all"], targetReferences := false, explicitFilters := true }
  else if tokens == ["reference"] || tokens == ["references"] then
    c := { c with targetTheorems := false, targetReferences := true, referenceGlobs := ["all"], explicitFilters := true }
  else
    let hasLeaf := tokens.any (fun t => t == "leaf" || t == "leaves")
    let nonMagic := tokens.filter (fun t => !isMagicFilterToken t)
    let effGlobs := if nonMagic.isEmpty then ["all"] else tokens
    c := {
      c with
      leafOnly := c.leafOnly || hasLeaf
      targetTheorems := true
      theoremGlobs := c.theoremGlobs ++ effGlobs
      targetReferences := true
      referenceGlobs := c.referenceGlobs ++ effGlobs
      explicitFilters := !nonMagic.isEmpty
    }
  return c

def parseArgs (args : List String) : CliContext := Id.run do
  let mut ctx : CliContext := {}
  let mut explicitAction : Option String := none

  let setPrimaryAction (cur : Option String) (act : String) : Option String :=
    match cur with
    | none => some act
    | some prev => if prev == act then some act else some "error"

  for arg in args do
    if arg == "--help" || arg == "-h" then
      explicitAction := some "help"
      ctx := { ctx with action := "help" }
    else if arg == "--dashboard" then
      explicitAction := setPrimaryAction explicitAction "dashboard"
      ctx := { ctx with action := explicitAction.getD "dashboard" }
    else if arg.startsWith "--dashboard=" then
      explicitAction := setPrimaryAction explicitAction "dashboard"
      let globs := (arg.drop 12).toString.splitOn "," |>.map (fun s => sanitizePathToModule s.trimAscii.toString)
      ctx := { ctx with action := explicitAction.getD "dashboard", targetTheorems := true, theoremGlobs := ctx.theoremGlobs ++ globs, targetReferences := true, referenceGlobs := ctx.referenceGlobs ++ globs, filterTokens := ctx.filterTokens ++ globs, explicitFilters := true }
    else if arg.startsWith "--latex=" then
      explicitAction := setPrimaryAction explicitAction "code-summary"
      let dir := (arg.drop 8).toString
      ctx := { ctx with action := explicitAction.getD "code-summary", latexDir := some dir }
    else if arg == "--latex" then
      explicitAction := setPrimaryAction explicitAction "code-summary"
      ctx := { ctx with action := explicitAction.getD "code-summary", latexDir := some "latex-artifacts" }
    else if arg.startsWith "--code-summary=" then
      explicitAction := setPrimaryAction explicitAction "code-summary"
      ctx := { ctx with action := explicitAction.getD "code-summary" }
      ctx := applyFilterTokens ctx (arg.drop 15).toString
    else if arg == "--code-summary" then
      explicitAction := setPrimaryAction explicitAction "code-summary"
      ctx := { ctx with action := explicitAction.getD "code-summary" }
    else if arg.startsWith "--outline=" then
      explicitAction := setPrimaryAction explicitAction "outline"
      ctx := { ctx with action := explicitAction.getD "outline" }
      ctx := applyFilterTokens ctx (arg.drop 10).toString
    else if arg == "--outline" then
      explicitAction := setPrimaryAction explicitAction "outline"
      ctx := { ctx with action := explicitAction.getD "outline", targetTheorems := true, theoremGlobs := ["all"], targetReferences := true, referenceGlobs := ["all"], filterTokens := ["all"] }
    else if arg.startsWith "--lint=" then
      explicitAction := setPrimaryAction explicitAction "lint"
      let lintNames := (arg.drop 7).toString.splitOn "," |>.map (fun s => s.trimAscii.toString) |>.filter (· != "")
      ctx := { ctx with action := explicitAction.getD "lint", linters := ctx.linters ++ lintNames }
    else if arg == "--lint" then
      explicitAction := setPrimaryAction explicitAction "lint"
      ctx := { ctx with action := explicitAction.getD "lint", linters := ["all"] }
    else if arg.startsWith "--glob-mode=" then
      let mode := (arg.drop 12).trimAscii.toString
      if mode == "any" || mode == "all" then
        ctx := { ctx with globMode := mode }
      else
        explicitAction := some "error"
        ctx := { ctx with action := "error" }
    else if arg == "--bibtex" then
      explicitAction := setPrimaryAction explicitAction "bibtex"
      ctx := { ctx with action := explicitAction.getD "bibtex" }
    else if arg.startsWith "--bibtex=" then
      explicitAction := setPrimaryAction explicitAction "bibtex"
      let globs := (arg.drop 9).toString.splitOn "," |>.map (fun s => sanitizePathToModule s.trimAscii.toString)
      ctx := { ctx with action := explicitAction.getD "bibtex", targetReferences := true, referenceGlobs := ctx.referenceGlobs ++ globs, explicitFilters := true }
    else if arg.startsWith "--theorem=" then
      let globs := (arg.drop 10).toString.splitOn "," |>.map (fun s => sanitizePathToModule s.trimAscii.toString)
      ctx := { ctx with targetTheorems := true, theoremGlobs := ctx.theoremGlobs ++ globs, filterTokens := ctx.filterTokens ++ globs, explicitFilters := true }
    else if arg == "--theorem" then
      ctx := { ctx with targetTheorems := true, theoremGlobs := ctx.theoremGlobs ++ ["all"], explicitFilters := true }
    else if arg.startsWith "--reference=" then
      let globs := (arg.drop 12).toString.splitOn "," |>.map (fun s => sanitizePathToModule s.trimAscii.toString)
      ctx := { ctx with targetReferences := true, referenceGlobs := ctx.referenceGlobs ++ globs, explicitFilters := true }
    else if arg == "--reference" then
      ctx := { ctx with targetReferences := true, referenceGlobs := ctx.referenceGlobs ++ ["all"], explicitFilters := true }
    else if arg == "--all" then
      ctx := { ctx with targetTheorems := true, theoremGlobs := ["all"], targetReferences := true, referenceGlobs := ["all"], explicitFilters := true }
    else if arg == "--dependencies" then
      explicitAction := setPrimaryAction explicitAction "dependencies"
      ctx := { ctx with action := explicitAction.getD "dependencies", dependenciesOut := some "dependencies.dot", dependenciesFormat := "dot" }
    else if arg.startsWith "--dependencies=" then
      explicitAction := setPrimaryAction explicitAction "dependencies"
      let path := (arg.drop 15).toString
      if path.endsWith ".dot" then
        ctx := { ctx with action := explicitAction.getD "dependencies", dependenciesOut := some path, dependenciesFormat := "dot" }
      else if path.endsWith ".json" then
        ctx := { ctx with action := explicitAction.getD "dependencies", dependenciesOut := some path, dependenciesFormat := "json" }
      else
        explicitAction := some "error"
        ctx := { ctx with action := "error" }

  if explicitAction == some "error" then
    return { ctx with action := "error" }

  if ctx.action == "code-summary" && !ctx.targetTheorems && !ctx.targetReferences then
    if ctx.latexDir.isSome || ctx.litlibTheoremsOnly then
      ctx := { ctx with litlibTheoremsOnly := true, targetTheorems := true, theoremGlobs := ["all"], targetReferences := true, referenceGlobs := ["all"] }
    else
      ctx := { ctx with targetTheorems := true, theoremGlobs := ["all"], targetReferences := true, referenceGlobs := ["all"] }

  if !ctx.targetTheorems && !ctx.targetReferences then
    if ctx.action == "bibtex" then
      ctx := { ctx with targetReferences := true, referenceGlobs := ["all"] }
    else if ctx.action == "dashboard" || ctx.action == "dependencies" || ctx.action == "outline" || ctx.action == "lint" then
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
          let relPath := (nameToFilePath modName).withExtension "lean"
          let isPkg := dir.toString.contains ".lake/packages"
          let srcExists := (← relPath.pathExists) || (← (System.FilePath.mk "src" / relPath).pathExists) ||
                           (← (System.FilePath.mk "Tests" / relPath).pathExists) || isPkg
          if srcExists then
            arr := arr.push modName
  catch _ => pure ()
  return arr

def discoverModules (rootModule : Name) : IO (Array Name) := do
  let sp ← Lean.searchPathRef.get
  let mut allMods := #[]

  let targetRoots := if rootModule == `Litlib then #[`Litlib] else #[`Litlib, rootModule]

  for targetRoot in targetRoots do
    let rootPath := nameToFilePath targetRoot
    for p in sp do
      let rootOlean := (p / rootPath).withExtension "olean"
      if ← rootOlean.pathExists then
        if !allMods.contains targetRoot then allMods := allMods.push targetRoot

      let rootDir := p / rootPath
      if ← rootDir.isDir then
        let mods ← findOleans rootDir targetRoot
        for m in mods do
          if !allMods.contains m then allMods := allMods.push m

  if allMods.isEmpty then return #[rootModule] else return allMods

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

  if let some dirStr := ctx.latexDir then
    let dir := System.FilePath.mk dirStr
    if ← dir.isDir then
      try
        let mut aggregateRefs : List String := []
        for entry in ← dir.readDir do
          if entry.path.extension == some "leanrefs" then
            let refs ← parseLeanRefs entry.path
            if !refs.isEmpty then
              aggregateRefs := aggregateRefs ++ refs

        if !aggregateRefs.isEmpty then
          ctx := { ctx with
            targetTheorems := true, theoremGlobs := aggregateRefs,
            targetReferences := true, referenceGlobs := aggregateRefs,
            litlibTheoremsOnly := false, explicitFilters := true
          }
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
  else if ctx.action == "outline" then
    return ← runOutline rootModule env globalData ctx
  else if ctx.action == "lint" then
    return ← runLint rootModule env globalData ctx
  else if ctx.action == "bibtex" then
    return ← runBibtex globalData
  else if ctx.action == "dependencies" then
    return ← runDependencies rootModule env globalData ctx
  else if ctx.action == "error" then
    IO.println "Error: Invalid argument passed to CLI."
    return 1
  else
    IO.println s!"Unknown action: {ctx.action}"
    return 1

end Litlib.Core.CLI
