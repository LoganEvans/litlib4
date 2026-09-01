-- FILENAME: Tests/Fixtures/IndentedWhereTactics.lean

import Litlib.Core

namespace Tests.Fixtures.IndentedWhereTactics

structure NestedProofStruct where
  toFun : Nat → Nat
  field_proof : ∀ n : Nat, toFun n = n

/-- Definition with where syntax and nested internal have := by tactics -/
@[litlib_track "Nested Have Proof In Where Block"]
def testNestedWhereProof : NestedProofStruct where
  toFun n := n
  field_proof n := by
    have h_inner : n + 0 = n := by
      rfl
    have h_eq : n = n := by
      exact rfl
    exact h_eq

end Tests.Fixtures.IndentedWhereTactics
