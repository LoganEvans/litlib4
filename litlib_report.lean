-- FILENAME: litlib_report.lean

import Lean
import Litlib.Core.CLI

open Lean

def main (args : List String) : IO UInt32 := do
  Lean.initSearchPath (← Lean.findSysroot)
  
  let lakePackageFile := System.FilePath.mk "lakefile.lean"
  if !(← lakePackageFile.pathExists) then
    IO.println "Error: Must be run from the root of a Lake project containing 'lakefile.lean'."
    return 1

  let lakefileContent ← IO.FS.readFile lakePackageFile
  let mut rootModuleName := "Unknown"
  
  -- Warning: never use String.trimLeft or String.trim in Lean 4 CLI code.
  -- They are deprecated and return String.Slice objects which cause massive compiler failures.
  -- Always use String.trimAsciiStart and String.trimAscii.
  for line in lakefileContent.splitOn "\n" do
    let trimLine := line.trimAsciiStart.toString
    if trimLine.startsWith "lean_lib " then
      let parts := trimLine.splitOn " "
      if parts.length >= 2 then
        -- Strip away the guillemets (« ») and quotes (")
        rootModuleName := parts[1]!.replace "«" "" |>.replace "»" "" |>.replace "\"" "" |>.trimAscii.toString
        break
  
  if rootModuleName == "Unknown" || rootModuleName == "" then
    IO.println "Error: Could not determine lean_lib name from lakefile.lean."
    return 1

  let rootModule := Name.mkSimple rootModuleName
  
  Litlib.Core.CLI.runCli rootModule args
