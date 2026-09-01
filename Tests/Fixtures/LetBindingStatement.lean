-- FILENAME: Tests/Fixtures/LetBindingStatement.lean

import Litlib.Core

namespace Tests.Fixtures.LetBindingStatement

/-- Theorem whose statement contains a let binding before the final equation -/
@[litlib_track "Theorem With Let Statement"]
theorem testLetInStatement (x : Nat) :
    let y := x + 1;
    y = x + 1 := by
  intro y
  rfl

/-- Term-mode theorem whose statement contains a let binding -/
@[litlib_track "Term Mode Theorem With Let Statement"]
theorem testTermModeLetInStatement (x : Nat) :
    let y := x + 0;
    y = x := rfl

end Tests.Fixtures.LetBindingStatement
