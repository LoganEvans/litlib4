-- FILENAME: Litlib/Core/CLI/Lint/UntrackedLeaf.lean

import Lean
import Litlib.Core.CLI.Lint.Types

open Lean

namespace Litlib.Core.CLI

/--
Computes the exclusive transitive dead cone of an untracked leaf `rootLeaf`:
all untracked local declarations whose callers are exclusively inside the dead cone of `rootLeaf`.
-/
private def computeExclusiveDeadCone (lctx : LinterContext) (allNodes : Array Name)
    (rootLeaf : Name) : NameSet := Id.run do
  let mut deadSet : NameSet := NameSet.empty.insert rootLeaf
  let mut changed := true
  while changed do
    changed := false
    let rootDeps := deadSet.toList.foldl (fun acc d =>
      let ds := lctx.depsMap.find? d |>.getD {}
      ds.toList.foldl (fun a x => a.insert x) acc) NameSet.empty
    for cand in rootDeps.toList do
      if !deadSet.contains cand && !isTrackedDecl lctx.env lctx.eqProofDecls cand then
        let mut allCallersDead := true
        for caller in allNodes do
          if !deadSet.contains caller then
            let callerDeps := lctx.depsMap.find? caller |>.getD {}
            if callerDeps.contains cand then
              allCallersDead := false
              break
        if allCallersDead then
          deadSet := deadSet.insert cand
          changed := true
  return deadSet

def untrackedLeafLinter : Linter where
  name := "untracked-leaf"
  description := "Detects untracked leaves (uses == 0 without @[litlib_track]) and transitive dead helpers."
  run := fun lctx => do
    let mut issues : Array LintIssue := #[]
    let mut allNodes : Array Name := #[]
    for (declName, _) in lctx.usesMap.toList do
      allNodes := allNodes.push declName

    let sortedNodes := allNodes.qsort fun a b => a.toString < b.toString
    for declName in sortedNodes do
      if isDeclInLintScope lctx declName then
        let uses := lctx.usesMap.find? declName |>.getD 0
        let tracked := isTrackedDecl lctx.env lctx.eqProofDecls declName
        if uses == 0 && !tracked then
          let (lineOpt, selfSpan) ← getDeclLineSpan declName
          let deadCone := computeExclusiveDeadCone lctx allNodes declName
          let deadHelpers := deadCone.erase declName |>.toList.toArray.qsort fun a b => a.toString < b.toString
          let mut totalSpan := selfSpan
          for h in deadHelpers do
            let (_, hSpan) ← getDeclLineSpan h
            totalSpan := totalSpan + hSpan
          let helperNote :=
            if deadHelpers.isEmpty then
              ""
            else
              let helperNames := String.intercalate ", " (deadHelpers.map (·.toString)).toList
              s!" (transitive dead helpers: {helperNames}; ~{totalSpan}L total savings)"
          issues := issues.push {
            linterName := "untracked-leaf"
            file := getDeclFileStr lctx declName
            line := lineOpt
            declName := some declName
            message := s!"Untracked leaf '{declName}' has uses=0 (~{selfSpan}L){helperNote}"
          }
    return issues

end Litlib.Core.CLI
