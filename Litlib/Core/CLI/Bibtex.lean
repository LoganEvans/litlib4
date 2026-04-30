-- FILENAME: Litlib/Core/CLI/Bibtex.lean

import Lean
import Litlib.Core.CLI.Engine

open Lean

namespace Litlib.Core.CLI

def runBibtex (globalData : GlobalData) : IO UInt32 := do
  let mut sortedRefs := globalData.litRefs
  
  -- Sort by first author, falling back to BibTeX key
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
      let t := ref.data.entryType
      IO.println s!"@{t}\{{bib},"
      
      if !ref.data.title.isEmpty then IO.println s!"  title = \{{ref.data.title}},"
      if !ref.data.authors.isEmpty then IO.println s!"  author = \{{String.intercalate " and " ref.data.authors}},"
      if !ref.data.journal.isEmpty then IO.println s!"  journal = \{{ref.data.journal}},"
      if !ref.data.booktitle.isEmpty then IO.println s!"  booktitle = \{{ref.data.booktitle}},"
      if !ref.data.volume.isEmpty then IO.println s!"  volume = \{{ref.data.volume}},"
      if !ref.data.issue.isEmpty then IO.println s!"  number = \{{ref.data.issue}},"
      if !ref.data.pages.isEmpty then IO.println s!"  pages = \{{ref.data.pages}},"
      if !ref.data.year.isEmpty then IO.println s!"  year = \{{ref.data.year}},"
      if !ref.data.publisher.isEmpty then IO.println s!"  publisher = \{{ref.data.publisher}},"
      if !ref.data.editor.isEmpty then IO.println s!"  editor = \{{ref.data.editor}},"
      if !ref.data.edition.isEmpty then IO.println s!"  edition = \{{ref.data.edition}},"
      if !ref.data.series.isEmpty then IO.println s!"  series = \{{ref.data.series}},"
      if !ref.data.address.isEmpty then IO.println s!"  address = \{{ref.data.address}},"
      if !ref.data.isbn.isEmpty then IO.println s!"  isbn = \{{ref.data.isbn}},"
      if !ref.data.doi.isEmpty then IO.println s!"  doi = \{{ref.data.doi}},"
      
      IO.println "}"
      IO.println ""
      
  return 0

end Litlib.Core.CLI
