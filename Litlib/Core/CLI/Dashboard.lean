-- FILENAME: Litlib/Core/CLI/Dashboard.lean

import Lean
import Litlib.Core.CLI.Engine

open Lean

namespace Litlib.Core.CLI

def runDashboard (rootModule : Name) (globalData : GlobalData) : IO UInt32 := do
  IO.println "\n===================================================================="
  IO.println s!"                        {rootModule.toString.toUpper} DASHBOARD"
  IO.println "===================================================================="

  if globalData.theorems.isEmpty then
    IO.println "\n  (No theorems tracked with Litlib.theorem found.)"
    IO.println "  Ensure your theorems are built so we can auto-discover your .olean files!\n"
    return 0

  let mut fullyProved := 0
  let mut incomplete := 0

  for info in globalData.theorems do
    if info.hasSorry then incomplete := incomplete + 1 else fullyProved := fullyProved + 1
    let statusIcon := if info.hasSorry then "[⚠ SORRY ]" else "[✔ PROVED]"
    
    IO.println s!"\n{statusIcon} {info.desc}"
    IO.println s!"  ↳ Lean: {info.name}"
    
    if !info.litRefs.isEmpty then
      IO.println "  ↳ Literature Dependencies:"
      for refInfo in info.litRefs do
        let authDisplay := if refInfo.data.authors.isEmpty then "Unknown" else refInfo.data.authors.head!
        IO.println s!"    • {authDisplay} - {refInfo.name.toString}"

  IO.println "\n===================================================================="
  IO.println s!"Total Tracked Theorems: {globalData.theorems.size}  |  Fully Proved: {fullyProved}  |  Incomplete: {incomplete}\n"
  return 0

end Litlib.Core.CLI
