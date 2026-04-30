-- FILENAME: Litlib/Core/CLI/Dashboard.lean

import Lean
import Litlib.Core.CLI.Engine

open Lean

namespace Litlib.Core.CLI

structure RefGroup where
  key : String
  data : LitlibData
  signatures : Array Name
  deriving Inhabited

def getAuthor (d : LitlibData) : String :=
  if d.authors.isEmpty then "Unknown" else d.authors.head!

def sortLitRefs (refs : Array LitRefData) : Array LitRefData :=
  refs.qsort (fun a b =>
    let authA := getAuthor a.data
    let authB := getAuthor b.data
    if authA != authB then authA < authB
    else if a.data.year != b.data.year then a.data.year < b.data.year
    else if a.data.title != b.data.title then a.data.title < b.data.title
    else a.data.bibtex < b.data.bibtex
  )

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

      -- Sort theorems by Author -> Year -> Title of their primary literature reference
      let sortedTheorems := globalData.theorems.qsort (fun a b =>
        let authA := if a.litRefs.isEmpty then "" else getAuthor a.litRefs[0]!.data
        let authB := if b.litRefs.isEmpty then "" else getAuthor b.litRefs[0]!.data
        let yearA := if a.litRefs.isEmpty then "" else a.litRefs[0]!.data.year
        let yearB := if b.litRefs.isEmpty then "" else b.litRefs[0]!.data.year
        let titleA := if a.litRefs.isEmpty then "" else a.litRefs[0]!.data.title
        let titleB := if b.litRefs.isEmpty then "" else b.litRefs[0]!.data.title
        
        if authA != authB then authA < authB
        else if yearA != yearB then yearA < yearB
        else if titleA != titleB then titleA < titleB
        else a.name.toString < b.name.toString
      )

      for info in sortedTheorems do
        if info.hasSorry then incomplete := incomplete + 1 else fullyProved := fullyProved + 1
        let statusIcon := if info.hasSorry then "[⚠ SORRY ]" else "[✔ PROVED]"
        
        IO.println s!"\n{statusIcon} {info.desc}"
        IO.println s!"  ↳ Lean: {info.name}"
        
        if !info.litRefs.isEmpty then
          IO.println "  ↳ Literature Dependencies:"
          let sortedDeps := sortLitRefs info.litRefs
          for refInfo in sortedDeps do
            let authDisplay := getAuthor refInfo.data
            IO.println s!"    • {authDisplay} ({refInfo.data.year}) - {refInfo.name.toString}"

      IO.println "\n--------------------------------------------------------------------"
      IO.println s!"Total Matching Theorems: {globalData.theorems.size}  |  Fully Proved: {fullyProved}  |  Incomplete: {incomplete}\n"

  if ctx.targetReferences then
    if globalData.litRefs.isEmpty then
      IO.println "\n  [No literature references matching filter found.]\n"
    else
      -- Group references by their BibTeX key (or namespace if BibTeX is missing)
      let mut groups : Array RefGroup := #[]
      for ref in globalData.litRefs do
        let key := if ref.data.bibtex.isEmpty then 
                     match ref.name with
                     | .str p _ => p.toString
                     | _ => ref.name.toString
                   else ref.data.bibtex
                   
        if let some idx := groups.findIdx? (fun g => g.key == key) then
          let g := groups[idx]!
          groups := groups.set! idx { g with signatures := g.signatures.push ref.name }
        else
          groups := groups.push { key := key, data := ref.data, signatures := #[ref.name] }

      -- Sort the groupings by Author -> Year -> Title
      let sortedGroups := groups.qsort (fun a b =>
        let authA := getAuthor a.data
        let authB := getAuthor b.data
        if authA != authB then authA < authB
        else if a.data.year != b.data.year then a.data.year < b.data.year
        else if a.data.title != b.data.title then a.data.title < b.data.title
        else a.key < b.key
      )

      IO.println s!"\n[LITERATURE SOURCES ({sortedGroups.size} sources, {globalData.litRefs.size} signatures)]"
      for g in sortedGroups do
        let authDisplay := getAuthor g.data
        let titleDisplay := if g.data.title.isEmpty then "<No Title provided>" else g.data.title
        
        -- Extract the base parent namespace for display (e.g. Litlib.Y1989.capovilla1989general)
        let parentNameStr := match g.signatures[0]! with
          | .str p _ => p.toString
          | n => n.toString

        IO.println s!"\n  📖 {parentNameStr}"
        IO.println s!"     Title:   {titleDisplay}"
        IO.println s!"     Authors: {authDisplay} et al."
        IO.println s!"     Year:    {g.data.year}"
        if !g.data.bibtex.isEmpty then IO.println s!"     BibTeX:  {g.data.bibtex}"
        if !g.data.doi.isEmpty then IO.println s!"     DOI:     {g.data.doi}"
        
        IO.println s!"     Signatures:"
        -- Sort the sub-signatures alphabetically for neatness
        let sortedSigs := g.signatures.qsort (fun x y => x.toString < y.toString)
        for sig in sortedSigs do
          -- Only print the final class name
          let sigNameStr := match sig with
            | .str _ s => s
            | _ => sig.toString
          IO.println s!"       ⊢ {sigNameStr}"
      IO.println ""

  return 0

end Litlib.Core.CLI
