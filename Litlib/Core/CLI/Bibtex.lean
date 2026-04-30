-- FILENAME: Litlib/Core/CLI/Bibtex.lean

import Lean
import Litlib.Core.CLI.Engine

open Lean

namespace Litlib.Core.CLI

def runBibtex (globalData : GlobalData) : IO UInt32 := do
  let mut sortedRefs := globalData.litRefs
  
  -- Sort by first author, falling back to BibTeX key (which encapsulates the year)
  sortedRefs := sortedRefs.qsort (fun a b =>
    let authorA := if a.data.authors.isEmpty then "" else a.data.authors.head!
    let authorB := if b.data.authors.isEmpty then "" else b.data.authors.head!
    if authorA != authorB then authorA < authorB
    else a.data.bibtex < b.data.bibtex
  )

  let mut seenBibtex : Array String := #[]
  
  for ref in sortedRefs do
    let bib := ref.data.bibtex
    if !seenBibtex.contains bib then
      seenBibtex := seenBibtex.push bib
      IO.println s!"@article\{{bib},"
      
      let titleDisplay := if ref.data.title.isEmpty then ref.name.toString else ref.data.title
      IO.println s!"  title = \{{titleDisplay}},"
      
      IO.println s!"  author = \{{String.intercalate " and " ref.data.authors}},"
      if !ref.data.doi.isEmpty then
        IO.println s!"  doi = \{{ref.data.doi}},"
      IO.println "}"
      IO.println ""
      
  return 0

end Litlib.Core.CLI
