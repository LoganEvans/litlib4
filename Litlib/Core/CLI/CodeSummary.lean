-- FILENAME: Litlib/Core/CLI/CodeSummary.lean

import Lean
import Litlib.Core.CLI.Engine

open Lean

namespace Litlib.Core.CLI

def runCodeSummary (globalData : GlobalData) : IO UInt32 := do
  if globalData.summaryItems.isEmpty then
    IO.println "No tracked theorems or definitions found for the given filters."
    return 0

  let mut modules : Lean.NameSet := {}
  for item in globalData.summaryItems do
    modules := modules.insert item.moduleName

  let mut modArray := modules.toList.toArray
  modArray := modArray.qsort (fun a b => a.toString < b.toString)

  for modName in modArray do
    IO.println s!"\n===================================================================="
    IO.println s!"-- MODULE: {modName}"
    IO.println s!"===================================================================="
    IO.println s!"namespace {modName}\n"

    let items := globalData.summaryItems.filter (·.moduleName == modName)

    let litRefs := items.filter (·.type == "litRef")
    if !litRefs.isEmpty then
      IO.println "-- Literature Axioms\n"
      for item in litRefs do
        IO.println item.codeStr
        IO.println ""

    let localDefs := items.filter (·.type == "localDef")
    if !localDefs.isEmpty then
      IO.println "-- Local Definitions\n"
      for item in localDefs do
        IO.println item.codeStr
        IO.println ""

    let theorems := items.filter (·.type == "theorem")
    if !theorems.isEmpty then
      IO.println "-- Tracked Theorems\n"
      for item in theorems do
        if !item.desc.isEmpty then
          IO.println s!"/- {item.desc} -/"
        IO.println item.codeStr
        IO.println ""

    IO.println s!"end {modName}\n"

  return 0

end Litlib.Core.CLI
