-- FILENAME: Litlib/Math/LeviCivita/ContractThree.lean

import Litlib.Math.LeviCivita.Basic
import Mathlib.Tactic.FinCases
import Mathlib.Tactic.NormNum
import Litlib.Math.Matrix4

set_option maxHeartbeats 4000000
set_option linter.unusedSimpArgs false

namespace Litlib.Math.LeviCivita

open BigOperators

/-- Single index contraction bounds for Hodge dual limits. -/
theorem epsilon4_contract_three (α β : Fin 4) :
  (∑ μ : Fin 4, ∑ ν : Fin 4, ∑ ρ : Fin 4, epsilon4 μ ν ρ α * epsilon4 μ ν ρ β) =
  6 * (if α = β then (1:ℤ) else 0) := by
  fin_cases α <;> fin_cases β <;> {
    simp[sum_fin_4, epsilon4, Litlib.Math.Matrix4.expand_det_4]
    try norm_num
  }

end Litlib.Math.LeviCivita
