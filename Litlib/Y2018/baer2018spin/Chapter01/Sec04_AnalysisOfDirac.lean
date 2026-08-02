-- FILENAME: Litlib/Y2018/baer2018spin/Chapter01/Sec04_AnalysisOfDirac.lean

import Litlib.Core
import Mathlib.Data.Real.Basic

namespace Litlib.Y2018.baer2018spin

Litlib.equation "baer2018spin" eq "1.4.1" page "35" kind "proposition"
class Prop1_4_1
  (M E_fiber F_fiber : Type _)
  (norm_H1 : (M → E_fiber) → ℝ)
  (norm_H0_E : (M → E_fiber) → ℝ)
  (norm_H0_F : (M → F_fiber) → ℝ)
  (D : (M → E_fiber) → (M → F_fiber))
  (is_dirac_type : ((M → E_fiber) → (M → F_fiber)) → Prop) : Prop where
  garding : is_dirac_type D →
    ∃ (C : ℝ), C > 0 ∧ ∀ (u : M → E_fiber),
      norm_H1 u ≤ C * (norm_H0_F (D u) + norm_H0_E u)

end Litlib.Y2018.baer2018spin
