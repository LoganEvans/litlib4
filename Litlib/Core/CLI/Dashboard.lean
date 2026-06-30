-- FILENAME: Litlib/Core/CLI/Dashboard.lean

import Lean
import Litlib.Core.CLI.Engine

open Lean

namespace Litlib.Core.CLI

def runDashboard (rootModule : Name) (globalData : GlobalData) (_ctx : CliContext) : IO UInt32 := do
  IO.println "\n===================================================================="
  IO.println s!"                        {rootModule.toString.toUpper} DASHBOARD"
  IO.println "===================================================================="

  if globalData.papers.isEmpty && globalData.theorems.isEmpty then
    IO.println "\n  [No tracked papers, theorems, or definitions found matching the filter.]\n"
    return 0

  if !globalData.papers.isEmpty then
    IO.println "\n[LITERATURE AND EQUATIONS]"
    for paper in globalData.papers do
      let authDisplay := if paper.data.authors.isEmpty then "Unknown" else paper.data.authors.head!
      IO.println s!"\n📖 {paper.paperId.toString} - {paper.data.title}"
      IO.println s!"   ├─ Authors: {authDisplay} et al. ({paper.data.year})"
      if !paper.data.doi.isEmpty then 
        IO.println s!"   ├─ DOI: {paper.data.doi}"

      if paper.equations.isEmpty then
        IO.println s!"   └─ Equations: [None tracked]"
      else
        IO.println s!"   └─ Equations:"
        let sortedEqs := paper.equations.qsort fun a b => a.data.eqNum < b.data.eqNum
        let maxEqIdx := sortedEqs.size - 1
        let mut eqIdx := 0
        for eq in sortedEqs do
          let isProved := !eq.proofs.isEmpty && eq.proofs.any (fun p => !p.hasSorry)
          let icon := if isProved then "✔" else "⚠"
          let branch := if eqIdx == maxEqIdx then "└─" else "├─"
          let eqName := if eq.data.eqNum.isEmpty then "Unknown" else eq.data.eqNum
          
          IO.println s!"      {branch} {icon} Equation {eqName} ({eq.declName})"
          eqIdx := eqIdx + 1

  if !globalData.theorems.isEmpty then
    let onlyDefs := globalData.theorems.filter (fun t => t.isDef)
    let onlyTheorems := globalData.theorems.filter (fun t => !t.isDef)
    
    if !onlyDefs.isEmpty then
      IO.println "\n--------------------------------------------------------------------"
      IO.println "[STANDALONE DEFINITIONS]"
      let sortedDefs := onlyDefs.qsort fun a b => a.declName.toString < b.declName.toString
      
      let mut complete := 0
      let mut incomplete := 0
      for defn in sortedDefs do
        if defn.hasSorry then incomplete := incomplete + 1 else complete := complete + 1
        let icon := if defn.hasSorry then "⚠" else "✔"
        
        IO.println s!"\n {icon} {defn.desc} ({defn.declName})"
        
        if !defn.deps.isEmpty then
          let sortedDeps := defn.deps.qsort fun a b => a.paperId < b.paperId
          let maxDepIdx := sortedDeps.size - 1
          let mut depIdx := 0
          for dep in sortedDeps do
            let branch := if depIdx == maxDepIdx then "└─" else "├─"
            let eqName := if dep.eqNum.isEmpty then "Unknown" else dep.eqNum
            let depIcon := if dep.isProved then "✔" else "⚠"
            let formalizedStr := if dep.isProved then "Formalized" else "Unformalized"
            IO.println s!"    {branch} Depends on: {dep.paperId} Eq {eqName} ({depIcon} {formalizedStr})"
            depIdx := depIdx + 1

      IO.println s!"\nTotal Standalone Definitions: {onlyDefs.size}  |  Complete: {complete}  |  Incomplete: {incomplete}"

    if !onlyTheorems.isEmpty then
      IO.println "\n--------------------------------------------------------------------"
      IO.println "[STANDALONE THEOREMS]"
      let mut fullyProved := 0
      let mut incomplete := 0
      
      let sortedTheorems := onlyTheorems.qsort fun a b => a.declName.toString < b.declName.toString
      
      for thm in sortedTheorems do
        if thm.hasSorry then incomplete := incomplete + 1 else fullyProved := fullyProved + 1
        let icon := if thm.hasSorry then "⚠" else "✔"
        
        IO.println s!"\n {icon} {thm.desc} ({thm.declName})"
        
        if !thm.deps.isEmpty then
          let sortedDeps := thm.deps.qsort fun a b => a.paperId < b.paperId
          let maxDepIdx := sortedDeps.size - 1
          let mut depIdx := 0
          for dep in sortedDeps do
            let branch := if depIdx == maxDepIdx then "└─" else "├─"
            let eqName := if dep.eqNum.isEmpty then "Unknown" else dep.eqNum
            let depIcon := if dep.isProved then "✔" else "⚠"
            let formalizedStr := if dep.isProved then "Formalized" else "Unformalized"
            IO.println s!"    {branch} Depends on: {dep.paperId} Eq {eqName} ({depIcon} {formalizedStr})"
            depIdx := depIdx + 1

      IO.println s!"\nTotal Standalone Theorems: {onlyTheorems.size}  |  Fully Proved: {fullyProved}  |  Incomplete: {incomplete}"

  IO.println "\n====================================================================\n"
  return 0

end Litlib.Core.CLI
