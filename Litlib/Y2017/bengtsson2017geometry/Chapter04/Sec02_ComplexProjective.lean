-- FILENAME: Litlib/Y2017/bengtsson2017geometry/Chapter04/Sec02_ComplexProjective.lean

import Litlib.Core
import Mathlib.Data.Complex.Basic
import Litlib.Y2017.bengtsson2017geometry.Paper

namespace Litlib.Y2017.bengtsson2017geometry

Litlib.equation "bengtsson2017geometry"
  eq "4.5"
  page "98"
  kind "definition"
class Eq4_5 (n : ℕ)
    (ProjectiveEquiv : (Fin (n + 1) → ℂ) → (Fin (n + 1) → ℂ) → Prop) where
  equiv_iff : ∀ Z W, ProjectiveEquiv Z W ↔ ∃ (c : ℂ), c ≠ 0 ∧ ∀ i, Z i = c * W i

Litlib.equation "bengtsson2017geometry"
  eq "4.7"
  page "98"
  kind "definition"
class Eq4_7 (n : ℕ)
    (InfinityHyperplane : Set (Fin (n + 1) → ℂ)) where
  def_infinity_hyperplane :
    InfinityHyperplane = { Z | Z 0 = 0 }

end Litlib.Y2017.bengtsson2017geometry
