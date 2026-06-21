-- FILENAME: Litlib/Core/CLI/Bibtex.lean

import Lean
import Litlib.Core.CLI.Engine

open Lean

namespace Litlib.Core.CLI

/-- Scans a directory for existing .bib files and extracts their defined keys. -/
def scanForExistingBibKeys (dir : System.FilePath) : IO (Array String) := do
  let mut keys := #[]
  try
    for entry in ← dir.readDir do
      if (entry.path.extension == some "bib") && (entry.fileName != some "litlib-references.bib") then
        let content ← IO.FS.readFile entry.path
        let parts := content.splitOn "@"
        for part in parts.drop 1 do
          let subparts := part.splitOn "{"
          if subparts.length > 1 then
            let afterBrace := String.intercalate "{" (subparts.drop 1)
            let keyParts := afterBrace.splitOn ","
            if !keyParts.isEmpty then
              let key := keyParts.head!.trimAscii.toString
              let entryType := subparts.head!.trimAscii.toString.map Char.toLower
              if entryType != "string" && entryType != "comment" && entryType != "preamble" then
                if !key.isEmpty then
                  keys := keys.push key
  catch _ => pure ()
  return keys

def generateBibtexString (globalData : GlobalData) (existingKeys : Array String) : IO String := do
  let mut out := ""
  let mut generatedKeys : Array String := #[]
  
  for paper in globalData.papers do
    let bib := if paper.data.bibtex.isEmpty then paper.paperId.toString else paper.data.bibtex
    
    -- Check against user's manual .bib files
    if existingKeys.contains bib then
      IO.println s!"  [BibTeX] Suppressed '{bib}' (already defined in user .bib file)"
      continue
      
    -- Deduplicate internally
    if generatedKeys.contains bib then
      continue
    generatedKeys := generatedKeys.push bib
    
    let t := paper.data.entryType
    out := out ++ "@" ++ t ++ "{" ++ bib ++ "},\n"
    
    if !paper.data.title.isEmpty then out := out ++ "  title = {" ++ paper.data.title ++ "},\n"
    if !paper.data.authors.isEmpty then out := out ++ "  author = {" ++ String.intercalate " and " paper.data.authors ++ "},\n"
    if !paper.data.journal.isEmpty then out := out ++ "  journal = {" ++ paper.data.journal ++ "},\n"
    if !paper.data.volume.isEmpty then out := out ++ "  volume = {" ++ paper.data.volume ++ "},\n"
    if !paper.data.issue.isEmpty then out := out ++ "  number = {" ++ paper.data.issue ++ "},\n"
    if !paper.data.pages.isEmpty then out := out ++ "  pages = {" ++ paper.data.pages ++ "},\n"
    if !paper.data.year.isEmpty then out := out ++ "  year = {" ++ paper.data.year ++ "},\n"
    if !paper.data.publisher.isEmpty then out := out ++ "  publisher = {" ++ paper.data.publisher ++ "},\n"
    if !paper.data.doi.isEmpty then out := out ++ "  doi = {" ++ paper.data.doi ++ "},\n"
    
    out := out ++ "}\n\n"
      
  return out

def runBibtex (globalData : GlobalData) : IO UInt32 := do
  let str ← generateBibtexString globalData #[]
  IO.print str
  return 0

end Litlib.Core.CLI
