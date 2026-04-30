-- FILENAME: Litlib/Core/CLI/Dashboard.lean

import Lean
import Litlib.Core.CLI.Engine

open Lean

namespace Litlib.Core.CLI

def runDashboard (rootModule : Name) (globalData : GlobalData) (ctx : CliContext) : IO UInt32 := do
  IO.println "\n===================================================================="
  IO.println s!"                        {rootModule.toString.toUpper} DASHBOARD"
  IO.println "===================================================================="

  if ctx.targetTheorems then
    if globalData.theorems.isEmpty then
      IO.println "\n  [No proven theorems matching filter found.]\n"
    else
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
            IO.println s!"    • {authDisplay} ({refInfo.data.year}) - {refInfo.name.toString}"

      IO.println "\n--------------------------------------------------------------------"
      IO.println s!"Total Matching Theorems: {globalData.theorems.size}  |  Fully Proved: {fullyProved}  |  Incomplete: {incomplete}\n"

  if ctx.targetReferences then
    if globalData.litRefs.isEmpty then
      IO.println "\n  [No literature references matching filter found.]\n"
    else
      IO.println s!"\n[LITERATURE AXIOMS ({globalData.litRefs.size})]"
      for ref in globalData.litRefs do
        let authDisplay := if ref.data.authors.isEmpty then "Unknown" else ref.data.authors.head!
        let titleDisplay := if ref.data.title.isEmpty then "<No Title provided>" else ref.data.title
        IO.println s!"\n  📖 {ref.name.toString}"
        IO.println s!"     Title:   {titleDisplay}"
        IO.println s!"     Authors: {authDisplay} et al."
        if !ref.data.bibtex.isEmpty then IO.println s!"     BibTeX:  {ref.data.bibtex}"
        if !ref.data.doi.isEmpty then IO.println s!"     DOI:     {ref.data.doi}"
      IO.println ""

  return 0

end Litlib.Core.CLI
