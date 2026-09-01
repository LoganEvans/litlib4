-- FILENAME: Tests/Fixtures/SoundnessAudit.lean

import Litlib.Core

namespace Tests.Fixtures.SoundnessAudit

/-- Sound theorem with legitimate proof -/
@[litlib_track "Sound Verified Theorem"]
theorem soundTheorem (x : Nat) : x + 0 = x := rfl

/-- Intentionally incomplete theorem using sorryAx -/
@[litlib_track "Incomplete Sorry Theorem"]
theorem sorryTheorem (x : Nat) : x * 1 = x := by
  sorry

/-- Exploit: Trivial vacuous theorem -/
@[litlib_track "Vacuous Trivial Proposition"]
theorem vacuousTrueTheorem : True := trivial

/-- Exploit: Class with trivial proposition field -/
class TrivialClass where
  trivial_field : True

/-- Exploit: Instance satisfying class with trivial -/
instance : TrivialClass where
  trivial_field := trivial

end Tests.Fixtures.SoundnessAudit
