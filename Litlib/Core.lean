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

/-- The core data structure storing literature metadata for axioms. -/
structure LitlibData where
  bibtex_key : String
  doi : String
  authors : List String
  status : String
  granularity : String
  deriving Inhabited, Repr

/-- 
Environment extension to persist `LitlibData` across modules. 
We use `MapDeclarationExtension` because it is perfectly suited for 
mapping Lean declaration names (like `Eq11`) to arbitrary data.
-/
initialize litlibExt : MapDeclarationExtension LitlibData ←
  mkMapDeclarationExtension

-- ==========================================
-- 2. Custom Attributes
-- ==========================================

/- 
Note: The prompt specified using `Lean.registerTagAttribute` for tags like 
`@[litlib_difficulty intractable]`. However, in Lean 4, Tag Attributes 
cannot accept parameters (they are purely binary flags like `@[inline]`). 
To satisfy the requirement of passing an argument (e.g., `intractable` or `Retracted`),
we define custom syntaxes and use `registerParametricAttribute` instead.
-/

syntax (name := litlibDifficultyAttrStx) "litlib_difficulty " ident : attr
syntax (name := litlibStatusAttrStx) "litlib_status " ident : attr

/-- Attribute indicating the difficulty of a proof instance. -/
initialize litlibDifficultyAttr : ParametricAttribute Name ←
  registerParametricAttribute {
    name := `litlib_difficulty
    descr := "Difficulty level of a litlib proof instance (e.g., intractable)"
    getParam := fun _ stx => do
      match stx with
      | `(attr| litlib_difficulty $id:ident) => return id.getId
      | _ => throwError "Invalid litlib_difficulty attribute syntax. Expected an identifier."
  }

/-- Attribute indicating the status of a litlib theorem. -/
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
-- 3. The `literature_axiom` Macro
-- ==========================================

/-- 
Parser definition for the `literature_axiom` command.
Requires standard literature metadata and a `where` block 
containing the Lean signatures.
-/
syntax (name := literatureAxiom) "literature_axiom " ident " : " term
  "bibtex_key " str
  "doi " str
  "authors " "[" str,* "]"
  "status " ident
  ("granularity " str)?
  "where"
  (colGt ident (Parser.Term.bracketedBinder)* " : " term)* : command

/-- 
Elaborator for the `literature_axiom` command.
1. Generates the equivalent `class` declaration.
2. Extracts the metadata and stores it in the `litlibExt` environment extension.
-/
@[command_elab literatureAxiom]
def elabLiteratureAxiom : CommandElab := fun stx => do
  match stx with
  | `(command| literature_axiom $name:ident : $ty:term
       bibtex_key $bib:str
       doi $doi:str
       authors [ $authors,* ]
       status $status:ident
       $[granularity $gran:str]?
       where
       $[$meths:ident $binders* : $mty:term]*) => do
       
     -- Step 1: Generate and execute the underlying `class` definition
     let classCmd ← `(command| 
       class $name:ident : $ty:term where
         $[$meths:ident $binders* : $mty:term]*
     )
     elabCommand classCmd

     -- Step 2: Extract string representations of the metadata
     let bibStr := bib.getString
     let doiStr := doi.getString
     let authorStrs := authors.getElems.toList.map (·.getString)
     let statusStr := status.getId.toString
     let granStr := match gran with
                    | some g => g.getString
                    | none => "default" -- Fallback if granularity is omitted
     
     let data : LitlibData := {
       bibtex_key := bibStr
       doi := doiStr
       authors := authorStrs
       status := statusStr
       granularity := granStr
     }

     -- Step 3: Insert the parsed data into the environment extension keyed by the axiom name
     modifyEnv fun env => litlibExt.insert env name.getId data
     
  | _ => throwUnsupportedSyntax
