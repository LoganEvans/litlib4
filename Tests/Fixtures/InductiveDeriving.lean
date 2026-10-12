-- FILENAME: Tests/Fixtures/InductiveDeriving.lean

import Litlib.Core

namespace Tests.Fixtures.InductiveDeriving

/-- Canonical binary outcome states for testing inductive deriving and constructor crawling. -/
inductive MockOutcome : Type
  | plusOne
  | minusOne
  deriving DecidableEq, Repr, BEq

/-- Operational value evaluation function referencing constructors. -/
def outcomeVal : MockOutcome → Nat
  | MockOutcome.plusOne => 1
  | MockOutcome.minusOne => 0

/-- Tracked definition consuming the inductive type and value. -/
@[litlib_track "Mock Outcome Tracked User"]
def mockOutcomeUser : Nat := outcomeVal MockOutcome.plusOne

end Tests.Fixtures.InductiveDeriving
