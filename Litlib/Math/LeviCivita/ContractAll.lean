-- FILENAME: Litlib/Math/LeviCivita/ContractAll.lean

import Litlib.Math.LeviCivita.Basic
import Mathlib.Tactic.NormNum
import Litlib.Math.Matrix4

set_option maxHeartbeats 4000000
set_option linter.unusedSimpArgs false

namespace Litlib.Math.LeviCivita

open BigOperators

/--
Physical Interpretation:
Full geometric contraction of the spacetime volume forms yielding the invariant scalar factorial 4! = 24.
-/
theorem epsilon4_contract_all : (∑ i : Fin 4, ∑ j : Fin 4, ∑ k : Fin 4, ∑ l : Fin 4, epsilon4 i j k l * epsilon4 i j k l) = 24 := by
  simp[sum_fin_4, epsilon4, Litlib.Math.Matrix4.expand_det_4]
  try norm_num

end Litlib.Math.LeviCivita
