-- FILENAME: Tests/Fixtures/PreColonVsPostColon.lean

import Litlib.Core

namespace Tests.Fixtures.PreColonVsPostColon

variable (x : Nat) (y : Nat)

/-- Theorem where y is quantified with ∀ after the colon -/
@[litlib_track "Quantified Post-Colon Binder"]
theorem testQuantifiedPostColon (x : Nat) : ∀ y : Nat, x + y = y + x := by
  intro y
  exact Nat.add_comm x y

/-- Theorem with variable x in scope where x is explicitly typed before the colon -/
@[litlib_track "Explicit Pre-Colon Binder"]
theorem testExplicitPreColon (x : Nat) : x = x := rfl

end Tests.Fixtures.PreColonVsPostColon
