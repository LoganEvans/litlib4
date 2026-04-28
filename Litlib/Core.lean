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

-- FIX: Removed the trailing space from "Litlib.status"
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

syntax (name := literatureAxiom) 
  "Litlib.reference" ident
  "bibtex" str
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
  let args := stx.getArgs
  let nameId := args[1]!.getId
  let classCmd := args[args.size - 1]!

  let mut bibStr := ""
  let mut doiStr := ""
  let mut authStrs : List String := []
  let mut statusStr := "Transcribed"
  let mut granStr := "default"

  for i in [0:args.size] do
    let node := args[i]!
    let nodeStr := node.reprint.getD ""
    
    if nodeStr.startsWith "bibtex" then
      bibStr := args[i+1]!.isStrLit?.getD ""
    else if nodeStr.startsWith "doi" then
      let doiNode := args[i+1]!.getArgs
      if doiNode.size == 2 then doiStr := doiNode[1]!.isStrLit?.getD ""
    else if nodeStr.startsWith "authors" then
      authStrs := args[i+2]!.getArgs.filterMap (·.isStrLit?) |>.toList
    else if nodeStr.startsWith "status" then
      let rawStatus := args[i+1]!.reprint.getD "Transcribed"
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


/-- Recursively hunts an AST to find the first Name Identifier. -/
partial def findFirstIdent (s : Syntax) : Option Name :=
  if s.isIdent then
    some s.getId
  else
    s.getArgs.findSome? findFirstIdent

@[command_elab litlibTheoremCmd]
def elabLitlibTheoremCmd : CommandElab := fun stx => do
  let args := stx.getArgs
  let desc := args[2]!.isStrLit?.getD ""
  let cmd := args[3]!

  -- 1. Execute the downstream command natively
  elabCommand cmd

  -- 2. Register it in the dashboard tracker
  if let some thmName := findFirstIdent cmd then
    let env ← getEnv
    let currNs ← getCurrNamespace
    let fullNsName := currNs ++ thmName
    
    let mut resolvedName := Name.anonymous
    if env.contains fullNsName then
      resolvedName := fullNsName
    else if env.contains thmName then
      resolvedName := thmName
      
    if resolvedName != Name.anonymous then
      modifyEnv fun e => litlibTheoremExt.insert e resolvedName desc
    else
      logWarning m!"Litlib.theorem: Could not resolve theorem '{thmName}' for dashboard."
  else
    logWarning m!"Litlib.theorem: Could not extract theorem name from command."
