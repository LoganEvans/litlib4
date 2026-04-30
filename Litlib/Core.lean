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
  title : String
  doi : String
  authors : List String
  status : String
  granularity : String
  deriving Inhabited, Repr

initialize litlibExt : MapDeclarationExtension LitlibData ←
  mkMapDeclarationExtension

-- ==========================================
-- 2. Dashboard Tracker Extension
-- ==========================================

initialize litlibTheoremExt : MapDeclarationExtension String ←
  mkMapDeclarationExtension

-- ==========================================
-- 3. Syntax Definitions
-- ==========================================

declare_syntax_cat litlibStatus
syntax ident : litlibStatus
syntax str : litlibStatus

syntax (name := Litlib.status) "Litlib.status" ident : attr

initialize litlibStatusAttr : ParametricAttribute Name ←
  registerParametricAttribute {
    name := `Litlib.status
    descr := "Status of a litlib theorem (e.g., Retracted, Verified)"
    getParam := fun _ stx => do
      match stx with
      | `(attr| Litlib.status $id:ident) => return id.getId
      | _ => throwError "Invalid Litlib.status attribute syntax."
  }

-- FIX: Added the optional `title` parameter
syntax (name := literatureAxiom) 
  "Litlib.reference" ident
  "bibtex" str
  ("title" str)?
  ("doi" str)?
  "authors" "[" str,* "]"
  ("status" litlibStatus)?
  ("granularity" str)?
  command : command

-- Beautiful block syntax for downstream physics theorems
syntax (name := litlibTheoremCmd) 
  "Litlib.theorem"
  "description" str
  command : command

-- ==========================================
-- 4. The Elaborators
-- ==========================================

@[command_elab literatureAxiom]
def elabLiteratureAxiom : CommandElab := fun stx => do
  -- Strict, deterministic index mapping based on the syntax array
  let nameId := stx[1].getId
  let bibStr := stx[3].isStrLit?.getD ""
  
  let titleOptNode := stx[4]
  let titleStr := if titleOptNode.isNone then "" else titleOptNode[1].isStrLit?.getD ""
  
  let doiOptNode := stx[5]
  let doiStr := if doiOptNode.isNone then "" else doiOptNode[1].isStrLit?.getD ""
  
  let authStrs := stx[8].getSepArgs.filterMap (·.isStrLit?) |>.toList
  
  let statusOptNode := stx[10]
  let statusStr := if statusOptNode.isNone then "Transcribed" else
    let rawStatus := statusOptNode[1].reprint.getD "Transcribed"
    let chars := rawStatus.toList
    String.ofList (chars.takeWhile (fun c => c != ' ' && c != '\n' && c != '\r'))
    
  let granOptNode := stx[11]
  let granStr := if granOptNode.isNone then "default" else granOptNode[1].isStrLit?.getD ""
  
  let classCmd := stx[12]

  -- 1. Natively execute the underlying `class ... where` command
  elabCommand classCmd

  -- 2. Persist the metadata using the mathematically fully-qualified identifier
  let data := LitlibData.mk bibStr titleStr doiStr authStrs statusStr granStr
  
  let currNs ← getCurrNamespace
  
  -- If nameId has no dots (getRoot == nameId), it's a simple name, so prepend the namespace.
  let resolvedName := if nameId.getRoot == nameId then currNs ++ nameId else nameId
  
  modifyEnv fun env => litlibExt.insert env resolvedName data


/-- Recursively hunts an AST to find the first Name Identifier. -/
partial def findFirstIdent (s : Syntax) : Option Name :=
  if s.isIdent then
    some s.getId
  else
    s.getArgs.findSome? findFirstIdent

/-- Specifically looks for the declId node which contains the actual declaration name. -/
partial def findDeclId (s : Syntax) : Option Name :=
  if s.getKind == ``Lean.Parser.Command.declId then
    some s[0].getId
  else
    s.getArgs.findSome? findDeclId

@[command_elab litlibTheoremCmd]
def elabLitlibTheoremCmd : CommandElab := fun stx => do
  let args := stx.getArgs
  let desc := args[2]!.isStrLit?.getD ""
  let cmd := args[3]!

  -- 1. Execute the downstream command natively
  elabCommand cmd

  -- 2. Register it in the dashboard tracker
  let targetNameOpt := findDeclId cmd <|> findFirstIdent cmd
  
  if let some thmName := targetNameOpt then
    let currNs ← getCurrNamespace
    
    -- Same logic: if it's a simple name, prepend namespace
    let resolvedName := if thmName.getRoot == thmName then currNs ++ thmName else thmName
      
    modifyEnv fun e => litlibTheoremExt.insert e resolvedName desc
  else
    logWarning m!"Litlib.theorem: Could not extract theorem name from command."
