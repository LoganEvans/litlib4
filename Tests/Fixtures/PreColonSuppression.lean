-- FILENAME: Tests/Fixtures/PreColonSuppression.lean

import Litlib.Core

namespace Tests.Fixtures.PreColonSuppression

variable (a b c : Nat)

/-- Theorem where a, b, c are in a variable block but quantified by ∀ in the statement -/
@[litlib_track "Multi-Variable Post-Colon Quantifier"]
theorem testMultiQuantifier (n : Nat) : ∀ (a b c : Nat), a + b + c = a + b + c := by
  intros
  rfl

end Tests.Fixtures.PreColonSuppression
