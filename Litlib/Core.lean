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
  bibtex : String
  doi : String
  authors : List String
  status : String
  granularity : String
  deriving Inhabited, Repr

initialize litlibExt : MapDeclarationExtension LitlibData ←
  mkMapDeclarationExtension

-- ==========================================
-- 2. Custom Attributes
-- ==========================================

syntax (name := Litlib.status) "Litlib.status " ident : attr

initialize litlibStatusAttr : ParametricAttribute Name ←
  registerParametricAttribute {
    name := `Litlib.status
    descr := "Status of a litlib theorem (e.g., Retracted, Verified)"
    getParam := fun _ stx => do
      match stx with
      | `(attr| Litlib.status $id:ident) => return id.getId
      | _ => throwError "Invalid Litlib.status attribute syntax."
  }

declare_syntax_cat litlibStatus
syntax ident : litlibStatus
syntax str : litlibStatus

-- NEW: Dashboard Headline Theorem Attribute
syntax (name := litlib_theorem) "litlib_theorem " str : attr

initialize litlibTheoremAttr : ParametricAttribute String ←
  registerParametricAttribute {
    name := `litlib_theorem
    descr := "Flags a headline theorem for the Litlib Dashboard report. Requires a friendly name string."
    getParam := fun _ stx => do
      match stx with
      | `(attr| litlib_theorem $s:str) => return s.getString
      | _ => throwError "Invalid litlib_theorem attribute syntax. Expected a string."
  }

-- ==========================================
-- 3. Syntax Definition
-- ==========================================

syntax (name := literatureAxiom) 
  "Litlib.reference" ident
  "bibtex" str
  ("doi" str)?
  "authors" "[" str,* "]"
  "status" litlibStatus
  ("granularity" str)?
  command : command

-- ==========================================
-- 4. The Elaborator (AST Keyword Extraction)
-- ==========================================

@[command_elab literatureAxiom]
def elabLiteratureAxiom : CommandElab := fun stx => do
  let args := stx.getArgs
  
  -- The Identifier is always the second element
  let nameId := args[1]!.getId
  
  -- The underlying class command is always the very last element of the syntax tree
  let classCmd := args[args.size - 1]!

  -- Initialize default values
  let mut bibStr := ""
  let mut doiStr := ""
  let mut authStrs : List String := []
  let mut statusStr := "Standard"
  let mut granStr := "default"

  -- Iterate through the syntax tree to find the keywords
  for i in [0:args.size] do
    let node := args[i]!
    let nodeStr := node.reprint.getD ""
    
    -- Lean's reprint might append spaces (e.g. "bibtex "), so we check the start of the string
    if nodeStr.startsWith "bibtex" then
      bibStr := args[i+1]!.isStrLit?.getD ""
    else if nodeStr.startsWith "doi" then
      let doiNode := args[i+1]!.getArgs
      if doiNode.size == 2 then doiStr := doiNode[1]!.isStrLit?.getD ""
    else if nodeStr.startsWith "authors" then
      authStrs := args[i+2]!.getArgs.filterMap (·.isStrLit?) |>.toList
    else if nodeStr.startsWith "status" then
      let rawStatus := args[i+1]!.reprint.getD "Standard"
      -- We manually strip potential trailing spaces from the status identifier without using .trim
      let chars := rawStatus.toList
      let cleanChars := chars.takeWhile (fun c => c != ' ' && c != '\n' && c != '\r')
      statusStr := String.ofList cleanChars
    else if nodeStr.startsWith "granularity" then
      let granNode := args[i+1]!.getArgs
      if granNode.size == 2 then granStr := granNode[1]!.isStrLit?.getD ""

  -- 1. Natively execute the underlying `class ... where` command
  elabCommand classCmd

  -- 2. Persist the metadata using the extracted identifier
  let data := LitlibData.mk bibStr doiStr authStrs statusStr granStr
  modifyEnv fun env => litlibExt.insert env nameId data
