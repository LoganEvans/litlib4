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
  bibtex_key : String
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

syntax (name := litlibDifficultyAttrStx) "litlib_difficulty " ident : attr
syntax (name := litlibStatusAttrStx) "litlib_status " ident : attr

initialize litlibDifficultyAttr : ParametricAttribute Name ←
  registerParametricAttribute {
    name := `litlib_difficulty
    descr := "Difficulty level of a litlib proof instance (e.g., intractable)"
    getParam := fun _ stx => do
      match stx with
      | `(attr| litlib_difficulty $id:ident) => return id.getId
      | _ => throwError "Invalid litlib_difficulty attribute syntax. Expected an identifier."
  }

initialize litlibStatusAttr : ParametricAttribute Name ←
  registerParametricAttribute {
    name := `litlib_status
    descr := "Status of a litlib theorem (e.g., Retracted, Verified)"
    getParam := fun _ stx => do
      match stx with
      | `(attr| litlib_status $id:ident) => return id.getId
      | _ => throwError "Invalid litlib_status attribute syntax. Expected an identifier."
  }

-- ==========================================
-- 3. Syntax Definitions (Bypassing Internal Parsers)
-- ==========================================

-- We explicitly define binders to avoid "unknown parser declaration" errors
declare_syntax_cat litlibBinder
syntax "(" ident+ " : " term ")" : litlibBinder
syntax "{" ident+ " : " term "}" : litlibBinder
syntax "[" term "]"              : litlibBinder
syntax "[" ident " : " term "]"  : litlibBinder

declare_syntax_cat litlibField
syntax ident (litlibBinder)* " : " term : litlibField

syntax (name := literatureAxiom) "literature_axiom " ident " : " term
  "bibtex_key " str
  "doi " str
  "authors " "[" str,* "]"
  "status " ident
  ("granularity " str)?
  "where"
  (colGt litlibField)* : command

-- ==========================================
-- 4. The Elaborator
-- ==========================================

/-- 
Elaborator for the `literature_axiom` command.
We use direct AST array indexing to avoid Lean's macro compiler 
hijacking the `where` keyword.
-/
@[command_elab literatureAxiom]
def elabLiteratureAxiom : CommandElab := fun stx => do
  let args := stx.getArgs
  
  -- Extract basic definitions
  let nameId := args[1]!.getId
  let tyStr := args[3]!.reprint.getD "Prop"
  
  -- Extract string metadata
  let bibStr := args[5]!.isStrLit?.getD ""
  let doiStr := args[7]!.isStrLit?.getD ""
  
  -- Extract alternating strings from the `str,*` syntax
  let authorsStrs := args[10]!.getArgs.filterMap (·.isStrLit?)
  let statusStr := args[13]!.getId.toString
  
  -- Handle optional granularity (args[14] is a nullNode of size 0 or 2)
  let granArgs := args[14]!.getArgs
  let granStr := if granArgs.size == 2 then
                   granArgs[1]!.isStrLit?.getD "default"
                 else
                   "default"

  -- Extract and format fields (args[16] is the nullNode holding the fields)
  let fieldsStr := args[16]!.reprint.getD ""
  
  -- Reconstruct and execute the class
  let classCode := s!"class {nameId} : {tyStr} where\n{fieldsStr}"
  
  let env ← getEnv
  match Parser.runParserCategory env `command classCode "<litlib_macro>" with
  | Except.ok classStx => 
      elabCommand classStx
  | Except.error e => 
      throwError s!"Failed to generate underlying class. Parser error: {e}\nGenerated Code:\n{classCode}"

  -- Persist the metadata using the direct constructor to avoid keyword collisions
  let data := LitlibData.mk bibStr doiStr authorsStrs.toList statusStr granStr

  modifyEnv fun env => litlibExt.insert env nameId data
