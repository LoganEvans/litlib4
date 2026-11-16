-- FILENAME: Litlib/Core/CLI/Lint/UnusedHypothesis.lean

import Lean
import Litlib.Core.CLI.Lint.Types

open Lean

namespace Litlib.Core.CLI

/--
Checks whether loose bound variable `idx` is genuinely used in `e`
(ignoring dead `let _ := ...` or `(fun _ ↦ body) arg` dummy bindings used to silence linters).
-/
private partial def usesBVarGenuinely (idx : Nat) (e : Expr) : Bool :=
  if !e.hasLooseBVar idx then
    false
  else
    match e with
    | .bvar i => i == idx
    | .letE _ ty val body _ =>
      usesBVarGenuinely idx ty ||
        usesBVarGenuinely (idx + 1) body ||
        (usesBVarGenuinely 0 body && usesBVarGenuinely idx val)
    | .app (.lam _ ty body _) arg =>
      usesBVarGenuinely idx ty ||
        usesBVarGenuinely (idx + 1) body ||
        (usesBVarGenuinely 0 body && usesBVarGenuinely idx arg)
    | .app f a => usesBVarGenuinely idx f || usesBVarGenuinely idx a
    | .lam _ ty body _ => usesBVarGenuinely idx ty || usesBVarGenuinely (idx + 1) body
    | .forallE _ ty body _ => usesBVarGenuinely idx ty || usesBVarGenuinely (idx + 1) body
    | .mdata _ b => usesBVarGenuinely idx b
    | .proj _ _ b => usesBVarGenuinely idx b
    | _ => false

/--
Collects explicit binder names in a theorem (including nested `And` conjunction arms)
that are unused in both downstream types and the proof term.
-/
private partial def findUnusedTheoremBinders (curType curVal : Expr) : Array String := Id.run do
  let mut unused : Array String := #[]
  let mut t := curType
  let mut v := curVal
  while true do
    match t, v with
    | .forallE bName _ nextType bi, .lam vName _ nextVal _ =>
      if bi == .default then
        let usedInType := nextType.hasLooseBVar 0
        let usedInProof := usesBVarGenuinely 0 nextVal
        if !usedInType && !usedInProof then
          let rawName := if !bName.hasMacroScopes && bName != .anonymous then bName else vName
          let disp := if rawName.hasMacroScopes || rawName == .anonymous then "<anonymous>" else rawName.toString
          unused := unused.push disp
      t := nextType
      v := nextVal
    | _, _ => break
  -- Also inspect nested conjunction branches `(P ∧ Q, And.intro p q)` common in multi-part theorems
  if t.isAppOfArity ``And 2 && v.isAppOfArity ``And.intro 4 then
    let pType := t.getArg! 0
    let qType := t.getArg! 1
    let pVal := v.getArg! 2
    let qVal := v.getArg! 3
    unused := unused ++ findUnusedTheoremBinders pType pVal ++ findUnusedTheoremBinders qType qVal
  return unused

def unusedHypothesisLinter : Linter where
  name := "unused-hypothesis"
  description := "Detects theorem parameters/hypotheses that are unused in both conclusion and proof term."
  run := fun lctx => do
    let mut issues : Array LintIssue := #[]
    let mut decls : Array (Name × TheoremVal) := #[]

    for (declName, info) in lctx.env.constants.toList do
      if isDeclInLintScope lctx declName then
        match info with
        | .thmInfo tval =>
          let rec getRetHead (e : Expr) : Option Name :=
            match e with
            | .forallE _ _ b _ => getRetHead b
            | _ => e.getAppFn.constName?
          let isClassInst := match getRetHead tval.type with
            | some tn => Lean.isClass lctx.env tn
            | none => false
          if !isClassInst then
            decls := decls.push (declName, tval)
        | _ => pure ()

    decls := decls.qsort fun a b => a.1.toString < b.1.toString

    for (declName, tval) in decls do
      let unusedBinders := findUnusedTheoremBinders tval.type tval.value
      if !unusedBinders.isEmpty then
        let (lineOpt, _) ← getDeclLineSpan declName
        let namesStr := String.intercalate ", " unusedBinders.toList
        issues := issues.push {
          linterName := "unused-hypothesis"
          file := getDeclFileStr lctx declName
          line := lineOpt
          declName := some declName
          message := s!"Theorem '{declName}' has unused parameter(s)/hypothesis(es) [{namesStr}] (discharge and remove from signature)"
        }

    return issues

end Litlib.Core.CLI
