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
  for line in lakefileContent.splitOn "\n" do
    if line.startsWith "package" || line.startsWith "lean_lib" then
      let parts := line.splitOn "\""
      if parts.length >= 3 then
        rootModuleName := parts[1]!.replace "«" "" |>.replace "»" ""
        break
  
  if rootModuleName == "Unknown" || rootModuleName == "" then
    IO.println "Error: Could not determine package/library name from lakefile.lean."
    return 1

  let rootModule := Name.mkSimple rootModuleName
  
  Litlib.Core.CLI.runCli rootModule args
