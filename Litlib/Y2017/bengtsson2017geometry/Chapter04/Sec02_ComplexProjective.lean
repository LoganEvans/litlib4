-- FILENAME: Litlib/Y2017/bengtsson2017geometry/Chapter04/Sec02_ComplexProjective.lean

import Litlib.Core
import Mathlib.Data.Complex.Basic
import Litlib.Y2017.bengtsson2017geometry.Paper

namespace Litlib.Y2017.bengtsson2017geometry

Litlib.equation "bengtsson2017geometry"
  eq "4.5"
  page "98"
  kind "definition"
/--
Physical Interpretation: Defines the equivalence of complex vectors describing the same pure state in a projective Hilbert space. States differing only by a non-zero complex scalar factor represent the same physical configuration.
Mathematical Boundaries: The coordinate vectors must be strictly non-zero to define a valid projective coordinate, preventing topological collapse.
-/
class Eq4_5 (n : ℕ)
    (ProjectiveEquiv : (Fin (n + 1) → ℂ) → (Fin (n + 1) → ℂ) → Prop) where
  -- Non-Degeneracy Constraint: The zero vector is not a valid state in projective geometry.
  equiv_iff : ∀ Z W, ProjectiveEquiv Z W ↔ (Z ≠ 0 ∧ W ≠ 0 ∧ ∃ (c : ℂ), c ≠ 0 ∧ ∀ i, Z i = c * W i)

Litlib.equation "bengtsson2017geometry"
  eq "4.7"
  page "98"
  kind "definition"
/--
Physical Interpretation: Defines the hyperplane at infinity in affine coordinates, separating the generic part of the projective space from asymptotic states.
Mathematical Boundaries: Evaluated strictly where the 0-th homogeneous coordinate vanishes.
-/
class Eq4_7 (n : ℕ)
    (InfinityHyperplane : Set (Fin (n + 1) → ℂ)) where
  def_infinity_hyperplane :
    InfinityHyperplane = { Z | Z 0 = 0 }

end Litlib.Y2017.bengtsson2017geometry
