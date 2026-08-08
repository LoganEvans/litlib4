-- FILENAME: Litlib/Core/CLI/Basic.lean

import Lean

open Lean

namespace Litlib.Core.CLI

structure CliContext where
  action : String := "dashboard"
  targetTheorems : Bool := false
  targetReferences : Bool := false
  theoremGlobs : List String := []
  referenceGlobs : List String := []
  litlibTheoremsOnly : Bool := false
  latexDir : Option String := none
  explicitFilters : Bool := false
  deriving Inhabited, Repr, BEq

def sanitizePathToModule (val : String) : String :=
  let cleanVal := val.replace "'" "" |>.replace "\"" ""
  let cleanVal := cleanVal.replace "\\" "/"
  let cleanVal := if cleanVal.endsWith ".lean" then (cleanVal.dropEnd 5).toString else cleanVal
  cleanVal.replace "/" "."

def parseArgs (args : List String) : CliContext := Id.run do
  let mut ctx : CliContext := {}
  for arg in args do
    if arg == "--help" || arg == "-h" then
      ctx := { ctx with action := "help" }
    else if arg == "--dashboard" then
      ctx := { ctx with action := "dashboard" }
    else if arg.startsWith "--dashboard=" then
      let globs := (arg.drop 12).toString.splitOn "," |>.map (fun s => sanitizePathToModule s.trimAscii.toString)
      ctx := { ctx with action := "dashboard", targetTheorems := true, theoremGlobs := ctx.theoremGlobs ++ globs, targetReferences := true, referenceGlobs := ctx.referenceGlobs ++ globs, explicitFilters := true }
    else if arg.startsWith "--latex=" then
      let dir := (arg.drop 8).toString
      ctx := { ctx with action := "code-summary", latexDir := some dir }
    else if arg == "--latex" then
      ctx := { ctx with action := "code-summary", latexDir := some "latex-artifacts" }
    else if arg.startsWith "--code-summary=" then
      ctx := { ctx with action := "code-summary" }
      let val := sanitizePathToModule (arg.drop 15).toString
      if val == "all" || val == "" then
        ctx := { ctx with targetTheorems := true, theoremGlobs := ["all"], targetReferences := true, referenceGlobs := ["all"] }
      else if val == "litlib_track" then
        ctx := { ctx with litlibTheoremsOnly := true, targetTheorems := true, theoremGlobs := ["all"], targetReferences := true, referenceGlobs := ["all"] }
      else if val == "theorem" || val == "theorems" then
        ctx := { ctx with targetTheorems := true, theoremGlobs := ["all"], targetReferences := false, explicitFilters := true }
      else if val == "reference" || val == "references" then
        ctx := { ctx with targetTheorems := false, targetReferences := true, referenceGlobs := ["all"], explicitFilters := true }
      else
        let globs := val.splitOn "," |>.map (fun s => s.trimAscii.toString)
        ctx := { ctx with targetTheorems := true, theoremGlobs := ctx.theoremGlobs ++ globs, targetReferences := true, referenceGlobs := ctx.referenceGlobs ++ globs, explicitFilters := true }
    else if arg == "--code-summary" then
      ctx := { ctx with action := "code-summary" }
    else if arg == "--bibtex" then
      ctx := { ctx with action := "bibtex" }
    else if arg.startsWith "--bibtex=" then
      let globs := (arg.drop 9).toString.splitOn "," |>.map (fun s => sanitizePathToModule s.trimAscii.toString)
      ctx := { ctx with action := "bibtex", targetReferences := true, referenceGlobs := ctx.referenceGlobs ++ globs, explicitFilters := true }
    else if arg.startsWith "--theorem=" then
      let globs := (arg.drop 10).toString.splitOn "," |>.map (fun s => sanitizePathToModule s.trimAscii.toString)
      ctx := { ctx with targetTheorems := true, theoremGlobs := ctx.theoremGlobs ++ globs, explicitFilters := true }
    else if arg == "--theorem" then
      ctx := { ctx with targetTheorems := true, theoremGlobs := ctx.theoremGlobs ++ ["all"], explicitFilters := true }
    else if arg.startsWith "--reference=" then
      let globs := (arg.drop 12).toString.splitOn "," |>.map (fun s => sanitizePathToModule s.trimAscii.toString)
      ctx := { ctx with targetReferences := true, referenceGlobs := ctx.referenceGlobs ++ globs, explicitFilters := true }
    else if arg == "--reference" then
      ctx := { ctx with targetReferences := true, referenceGlobs := ctx.referenceGlobs ++ ["all"], explicitFilters := true }
    else if arg == "--all" then
      ctx := { ctx with targetTheorems := true, theoremGlobs := ["all"], targetReferences := true, referenceGlobs := ["all"], explicitFilters := true }

  if ctx.action == "code-summary" && !ctx.targetTheorems && !ctx.targetReferences then
    if ctx.latexDir.isSome || ctx.litlibTheoremsOnly then
      ctx := { ctx with litlibTheoremsOnly := true, targetTheorems := true, theoremGlobs := ["all"], targetReferences := true, referenceGlobs := ["all"] }
    else
      ctx := { ctx with targetTheorems := true, theoremGlobs := ["all"], targetReferences := true, referenceGlobs := ["all"] }

  if !ctx.targetTheorems && !ctx.targetReferences then
    if ctx.action == "bibtex" then
      ctx := { ctx with targetReferences := true, referenceGlobs := ["all"] }
    else if ctx.action == "dashboard" then
      ctx := { ctx with targetTheorems := true, theoremGlobs := ["all"], targetReferences := true, referenceGlobs := ["all"] }

  return ctx

def myDropRight (s : String) (n : Nat) : String :=
  let chars := s.toList
  if chars.length <= n then "" else String.ofList (chars.take (chars.length - n))

def myDropLeft (s : String) (n : Nat) : String :=
  String.ofList (s.toList.drop n)

def globMatch (pat target : String) : Bool :=
  let p := pat.trimAscii.toString.replace ".*" "*"
  if p == "" then false
  else if p == "*" || p == "all" then true
  else if p.startsWith "^" && p.endsWith "$" then
    target == (myDropRight (myDropLeft p 1) 1).replace "*" ""
  else if p.startsWith "^" then
    target.startsWith ((myDropLeft p 1).replace "*" "")
  else if p.endsWith "$" then
    target.endsWith ((myDropRight p 1).replace "*" "")
  else Id.run do
    let parts := p.splitOn "*" |>.filter (· ≠ "")
    let mut curr := target
    let mut ok := true
    for part in parts do
      let splitted := curr.splitOn part
      if splitted.length <= 1 then
        ok := false
        break
      else
        curr := String.intercalate part (splitted.drop 1)
    return ok

def matchesAnyGlob (globs : List String) (target : String) : Bool :=
  if globs.isEmpty then false
  else if globs.length == 1 && globs.head! == "all" then true
  else globs.any (fun pat => globMatch pat target)

/-- Strictly pattern matches the tail of the Lean 4 Name to filter auto-generated junk -/
def isAuto (n : Name) : Bool :=
  n.isInternal ||
  match n with
  | .str _ s =>
    s == "mk" || s == "rec" || s == "casesOn" || s == "recOn" ||
    s == "noConfusion" || s == "noConfusionType" || s == "injEq" ||
    s.startsWith "match_" || s.startsWith "proof_" || s.startsWith "eq_" ||
    s.startsWith "sizeOf" || s.startsWith "inst" || s.startsWith "_aux" ||
    s.endsWith "inj" || s.endsWith "ext" || s.endsWith "ext_iff"
  | _ => false

end Litlib.Core.CLI
