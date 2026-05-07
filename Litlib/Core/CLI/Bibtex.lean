-- FILENAME: Litlib/Core/CLI/Bibtex.lean

import Lean
import Litlib.Core.CLI.Engine

open Lean

namespace Litlib.Core.CLI

def runBibtex (globalData : GlobalData) : IO UInt32 := do
  for paper in globalData.papers do
    let bib := if paper.data.bibtex.isEmpty then paper.paperId.toString else paper.data.bibtex
    let t := paper.data.entryType
    IO.println s!"@{t}\{{bib},"
    
    if !paper.data.title.isEmpty then IO.println s!"  title = \{{paper.data.title}},"
    if !paper.data.authors.isEmpty then IO.println s!"  author = \{{String.intercalate " and " paper.data.authors}},"
    if !paper.data.journal.isEmpty then IO.println s!"  journal = \{{paper.data.journal}},"
    if !paper.data.volume.isEmpty then IO.println s!"  volume = \{{paper.data.volume}},"
    if !paper.data.issue.isEmpty then IO.println s!"  number = \{{paper.data.issue}},"
    if !paper.data.pages.isEmpty then IO.println s!"  pages = \{{paper.data.pages}},"
    if !paper.data.year.isEmpty then IO.println s!"  year = \{{paper.data.year}},"
    if !paper.data.publisher.isEmpty then IO.println s!"  publisher = \{{paper.data.publisher}},"
    if !paper.data.doi.isEmpty then IO.println s!"  doi = \{{paper.data.doi}},"
    
    IO.println "}"
    IO.println ""
      
  return 0

end Litlib.Core.CLI
