-- FILENAME: Tests/CLI/Summary/TestInductiveDeriving.lean

import Lean
import Litlib.Core.CLI

open Lean Litlib.Core.CLI

def stringContains (s sub : String) : Bool :=
  (s.splitOn sub).length > 1

def countOccurrences (s sub : String) : Nat :=
  let parts := s.splitOn sub
  if parts.isEmpty then 0 else parts.length - 1

def main : IO UInt32 := do
  Lean.initSearchPath (← Lean.findSysroot)
  let mut sp ← Lean.searchPathRef.get
  let buildLib := System.FilePath.mk ".lake" / "build" / "lib" / "lean"
  if !(sp.contains buildLib) then
    Lean.searchPathRef.set (buildLib :: sp)

  let env ← importModules #[{ module := `Tests.Fixtures.InductiveDeriving }] {}
  let mut ok := true

  -- Test 1: Crawling dependencies from a tracked definition
  let ctxTracked : CliContext := {
    action := "code-summary",
    litlibTheoremsOnly := true,
    targetTheorems := true,
    theoremGlobs := ["Tests.Fixtures.InductiveDeriving.mockOutcomeUser"],
    explicitFilters := true
  }
  let ctxCore : Core.Context := { fileName := "<litlib>", fileMap := default }
  let state : Core.State := { env := env }

  let (dataTracked, _) ← (extractAllTheorems env ctxTracked).toIO ctxCore state
  let (rootsTracked, _) ←
    (gatherRoots `Tests.Fixtures.InductiveDeriving dataTracked ctxTracked).toIO ctxCore state
  let (depsTracked, _) ←
    (collectLocalDepsRec `Tests.Fixtures.InductiveDeriving rootsTracked.toList rootsTracked).toIO
      ctxCore state

  let depNames := depsTracked.toList.map (·.toString)

  -- Inductive type should be present
  if !depNames.contains "Tests.Fixtures.InductiveDeriving.MockOutcome" then
    IO.println "[FAIL] Parent inductive type 'MockOutcome' was not collected as dependency."
    ok := false

  -- Constructors must NOT leak as standalone dependencies
  let leakedCtors := depNames.filter (fun c =>
    c == "Tests.Fixtures.InductiveDeriving.MockOutcome.plusOne" ||
    c == "Tests.Fixtures.InductiveDeriving.MockOutcome.minusOne")
  if !leakedCtors.isEmpty then
    IO.println s!"[FAIL] Constructors leaked as standalone dependencies: {leakedCtors}"
    ok := false

  -- Test 2: Glob filter / root gathering must not collect derived boilerplate or constructors
  let ctxGlob : CliContext := {
    action := "code-summary",
    theoremGlobs := ["Tests.Fixtures.InductiveDeriving.*"],
    referenceGlobs := ["Tests.Fixtures.InductiveDeriving.*"],
    explicitFilters := true
  }
  let (dataGlob, _) ← (extractAllTheorems env ctxGlob).toIO ctxCore state
  let (rootsGlob, _) ←
    (gatherRoots `Tests.Fixtures.InductiveDeriving dataGlob ctxGlob).toIO ctxCore state
  let (allConstsGlob, _) ←
    (collectLocalDepsRec `Tests.Fixtures.InductiveDeriving rootsGlob.toList rootsGlob).toIO
      ctxCore state

  let allNames := allConstsGlob.toList.map (·.toString)

  -- Derived boilerplate functions (decEq, beq, etc.) must not leak
  let leakedBoilerplate := allNames.filter (fun c =>
    c.endsWith ".decEq" || c.endsWith ".beq" || c.endsWith ".ctorElim" ||
    c.endsWith ".ctorIdx" || c.endsWith ".ctorElimType")
  if !leakedBoilerplate.isEmpty then
    IO.println s!"[FAIL] Derived boilerplate leaked into declarations: {leakedBoilerplate}"
    ok := false

  -- Test 3: Rendered summary must not contain duplicate inductive blocks or bare constructor lines
  let mut renderedOutput := ""
  for n in allConstsGlob.toList do
    let s ← ppDecl env n
    let trimmed := s.trimAscii.toString
    if trimmed == "| plusOne" || trimmed == "| minusOne" then
      IO.println s!"[FAIL] Declaration '{n}' rendered as bare constructor fragment: {s}"
      ok := false
    renderedOutput := renderedOutput ++ s ++ "\n\n"

  let countInductive := countOccurrences renderedOutput "inductive MockOutcome"
  if countInductive > 1 then
    IO.println s!"[FAIL] 'inductive MockOutcome' rendered {countInductive} times (expected 1)."
    ok := false

  if ok then
    IO.println "Success: Inductive deriving tests passed."
    return 0
  else
    return 1

#eval show IO Unit from do
  let res ← main
  if res != 0 then
    throw (IO.userError "Inductive deriving assertions failed.")
