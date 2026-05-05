-- FILENAME: Litlib/Core.lean

import Lean

open Lean Elab Command Meta

/-!
# Litlib Core Metaprogramming

This module initializes the core metadata structures, environment extensions, 
custom attributes, and syntax macros used by `litlib4` to track scientific literature.
-/

-- ==========================================
-- 1. Metadata Record & Environment Extension
-- ==========================================

structure LitlibData where
  entryType : String := "article"
  bibtex : String := ""
  title : String := ""
  authors : List String := []
  journal : String := ""
  volume : String := ""
  issue : String := ""
  pages : String := ""
  year : String := ""
  publisher : String := ""
  booktitle : String := ""
  editor : String := ""
  address : String := ""
  edition : String := ""
  series : String := ""
  isbn : String := ""
  doi : String := ""
  deriving Inhabited, Repr

structure LitlibEqData where
  paperId : String
  eqNum : String := ""
  page : String := ""
  kind : String := ""
  deriving Inhabited, Repr

initialize litlibPaperExt : MapDeclarationExtension LitlibData ←
  mkMapDeclarationExtension

initialize litlibEqExt : MapDeclarationExtension LitlibEqData ←
  mkMapDeclarationExtension

-- ==========================================
-- 2. Dashboard Tracker Extension
-- ==========================================

initialize litlibTheoremExt : MapDeclarationExtension String ←
  mkMapDeclarationExtension

-- ==========================================
-- 3. Syntax Definitions
-- ==========================================

-- Define specific syntax rules for the values to ensure they parse as pure strings,
-- bypassing the Lean `term` wrapper which hides the string tokens from `isStrLit?`.
syntax litlibValStr := str
syntax litlibValArray := "[" str,* "]"

-- The parser consumes the field name (ident), then cleanly branches between a string or array
syntax litlibField := ident (litlibValStr <|> litlibValArray)

/-- 
Declares a literature source with standard BibTeX fields.
-/
syntax (name := litlibPaper) 
  "Litlib.paper" str
  litlibField*
  : command

/-- 
Decorates a signature class with equation metadata linked to a paper.
-/
syntax (name := litlibEquation) 
  "Litlib.equation" str
  litlibField*
  command : command

-- Beautiful block syntax for downstream physics theorems
syntax (name := litlibTheoremCmd) 
  "Litlib.theorem"
  "description" str
  command : command

-- ==========================================
-- 4. The Elaborators
-- ==========================================

/-- Recursively extracts all string literals embedded inside a Syntax node. -/
partial def extractStrings (stx : Syntax) : List String := Id.run do
  if let some s := stx.isStrLit? then
    return [s]
  else
    let mut arr := #[]
    for arg in stx.getArgs do
      for str in extractStrings arg do
        arr := arr.push str
    return arr.toList

@[command_elab litlibPaper]
def elabLitlibPaper : CommandElab := fun stx => do
  let paperIdStr := stx[1].isStrLit?.getD ""
  let fields := stx[2].getArgs

  let mut data : LitlibData := { bibtex := paperIdStr }

  for field in fields do
    let key := field[0].getId.toString
    let valStx := field[1]
    
    -- Extract the first string for singular fields, or all strings for list fields
    let strs := extractStrings valStx
    let firstStr := if strs.isEmpty then "" else strs.head!
    
    match key with
    | "type" => data := { data with entryType := firstStr }
    | "bibtex" => data := { data with bibtex := firstStr }
    | "title" => data := { data with title := firstStr }
    | "authors" => data := { data with authors := strs }
    | "journal" => data := { data with journal := firstStr }
    | "volume" => data := { data with volume := firstStr }
    | "number" => data := { data with issue := firstStr }
    | "issue" => data := { data with issue := firstStr }
    | "pages" => data := { data with pages := firstStr }
    | "year" => data := { data with year := firstStr }
    | "publisher" => data := { data with publisher := firstStr }
    | "booktitle" => data := { data with booktitle := firstStr }
    | "editor" => data := { data with editor := firstStr }
    | "address" => data := { data with address := firstStr }
    | "edition" => data := { data with edition := firstStr }
    | "series" => data := { data with series := firstStr }
    | "isbn" => data := { data with isbn := firstStr }
    | "doi" => data := { data with doi := firstStr }
    | _ => pure ()

  -- Persist the metadata using the string ID as a Name key
  modifyEnv fun env => litlibPaperExt.insert env (Name.mkSimple paperIdStr) data

/-- Specifically looks for the declId node which contains the actual declaration name. -/
partial def findDeclId (s : Syntax) : Option Name :=
  if s.getKind == ``Lean.Parser.Command.declId then
    some s[0].getId
  else
    s.getArgs.findSome? findDeclId

@[command_elab litlibEquation]
def elabLitlibEquation : CommandElab := fun stx => do
  let paperIdStr := stx[1].isStrLit?.getD ""
  let fields := stx[2].getArgs
  let classCmd := stx[3]

  let mut data : LitlibEqData := { paperId := paperIdStr }

  for field in fields do
    let key := field[0].getId.toString
    let valStx := field[1]
    
    let strs := extractStrings valStx
    let firstStr := if strs.isEmpty then "" else strs.head!
    
    match key with
    | "eq" => data := { data with eqNum := firstStr }
    | "page" => data := { data with page := firstStr }
    | "kind" => data := { data with kind := firstStr }
    | _ => pure ()

  -- 1. Natively execute the underlying `class ... where` command
  elabCommand classCmd

  -- 2. Extract the name of the defined class/theorem
  let targetNameOpt := findDeclId classCmd
  if let some nameId := targetNameOpt then
    let currNs ← getCurrNamespace
    let resolvedName := if nameId.getRoot == nameId then currNs ++ nameId else nameId
    modifyEnv fun env => litlibEqExt.insert env resolvedName data
  else
    logWarning m!"Litlib.equation: Could not extract target name from command."

@[command_elab litlibTheoremCmd]
def elabLitlibTheoremCmd : CommandElab := fun stx => do
  let args := stx.getArgs
  let desc := args[2]!.isStrLit?.getD ""
  let cmd := args[3]!

  -- 1. Execute the downstream command natively
  elabCommand cmd

  -- 2. Register it in the dashboard tracker
  let targetNameOpt := findDeclId cmd
  
  if let some thmName := targetNameOpt then
    let currNs ← getCurrNamespace
    let resolvedName := if thmName.getRoot == thmName then currNs ++ thmName else thmName
    modifyEnv fun e => litlibTheoremExt.insert e resolvedName desc
  else
    logWarning m!"Litlib.theorem: Could not extract theorem name from command."
