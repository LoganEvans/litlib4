-- FILENAME: Tests/Fixtures/DefProofStripping.lean

import Litlib.Core

namespace Tests.Fixtures.DefProofStripping

/-- Definition implemented via multi-line tactic script -/
@[litlib_track "Tactic Mode Subtype Definition"]
def tacticModeSubtypeDef (x : Nat) : { n : Nat // n = x } := by
  have h_eq : x = x := by
    rfl
  exact ⟨x, h_eq⟩

end Tests.Fixtures.DefProofStripping
