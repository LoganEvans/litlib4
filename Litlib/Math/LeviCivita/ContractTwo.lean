-- FILENAME: Litlib/Math/LeviCivita/ContractTwo.lean

import Litlib.Math.LeviCivita.Basic
import Mathlib.Tactic.FinCases
import Mathlib.Tactic.NormNum
import Litlib.Math.Matrix4

set_option maxHeartbeats 4000000
set_option linter.unusedSimpArgs false

namespace Litlib.Math.LeviCivita

open BigOperators Matrix

/--
Physical Interpretation:
Dual contraction yielding the normalized antisymmetric delta generalized Kronecker symbol.
-/
theorem epsilon4_contract_two (k l m n : Fin 4) :
  (∑ i : Fin 4, ∑ j : Fin 4, epsilon4 i j k l * epsilon4 i j m n) =
  2 * ((if k = m then (1:ℤ) else 0) * (if l = n then (1:ℤ) else 0) - (if k = n then (1:ℤ) else 0) * (if l = m then (1:ℤ) else 0)) := by
  fin_cases k <;> fin_cases l <;> fin_cases m <;> fin_cases n <;> {
    simp[sum_fin_4, epsilon4, Litlib.Math.Matrix4.expand_det_4]
    try norm_num
  }

/-- Spatial cross-product volume equivalency bounds. -/
theorem epsilon3_contract_two (c f : Fin 3) :
  (∑ a : Fin 3, ∑ b : Fin 3, epsilon3 a b c * epsilon3 a b f) =
  2 * (if c = f then (1:ℤ) else 0) := by
  fin_cases c <;> fin_cases f <;> {
    simp[sum_fin_3, epsilon3, Matrix.det_fin_three]
    try norm_num
  }

end Litlib.Math.LeviCivita
