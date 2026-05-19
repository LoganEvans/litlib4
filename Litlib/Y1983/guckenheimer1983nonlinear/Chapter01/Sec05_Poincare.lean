-- FILENAME: Litlib/Y1983/guckenheimer1983nonlinear/Chapter01/Sec05_Poincare.lean

import Litlib.Core
import Mathlib.Data.Real.Basic

namespace Litlib.Y1983.guckenheimer1983nonlinear

Litlib.equation "guckenheimer1983nonlinear"
  eq "Proposition 1.5.1"
  page "32"
  kind "proposition"
class Proposition1_5_1
  (is_neutrally_stable : ℝ → ℝ → Prop)
  (is_saddle_type : ℝ → ℝ → Prop)
  where
  neutrally_stable_0 : ∀ α, (∀ n : ℤ, α ≠ (n : ℝ) / 2) → 
    ∃ β_max > 0, ∀ β, 0 < abs β → abs β < β_max → is_neutrally_stable α β
  saddle_type_pi : ∀ α, α ≠ 0 → 
    ∃ β_max > 0, ∀ β, 0 < abs β → abs β < β_max → is_saddle_type α β

end Litlib.Y1983.guckenheimer1983nonlinear
