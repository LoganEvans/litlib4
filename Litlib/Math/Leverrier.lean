-- FILENAME: Litlib/Math/Leverrier.lean

import Litlib.Math.Matrix4
import Mathlib.LinearAlgebra.Matrix.Trace
import Mathlib.Tactic.Ring

set_option linter.unusedVariables false
set_option linter.unusedSimpArgs false

open Matrix BigOperators

namespace Litlib.Math.Leverrier

lemma sum_fin_4 {α} [AddCommMonoid α] (f : Fin 4 → α) :
  (∑ i : Fin 4, f i) = f 0 + f 1 + f 2 + f 3 := by
  simp[Fin.sum_univ_succ, Fin.sum_univ_zero, add_assoc]

/-- 🔵 ALGEBRAIC: Newton's Identities for 4x4 Matrices (Leverrier's Algorithm) -/
theorem newtons_identities_det {K : Type*} [Field K] [CharZero K] (M : Matrix (Fin 4) (Fin 4) K) :
  M.det = (1 / 24 : K) * (
    (Matrix.trace M)^4
    - 6 * Matrix.trace (M^2) * (Matrix.trace M)^2
    + 3 * (Matrix.trace (M^2))^2
    + 8 * Matrix.trace (M^3) * Matrix.trace M
    - 6 * Matrix.trace (M^4)
  ) := by
  -- Explicitly unroll the exponents into matrix multiplications
  have h2 : M^2 = M * M := by simp [sq]
  have h3 : M^3 = M * M * M := by simp [pow_succ, sq, mul_assoc]
  have h4 : M^4 = M * M * M * M := by simp[pow_succ, mul_assoc]
  rw [h2, h3, h4]
  
  -- Expand the determinant and unroll all matrix multiplications and traces into raw Fin 4 sums
  -- `sum_fin_4` strictly evaluates the loops into `0, 1, 2, 3` to bypass `Fin.succ` matching failures in `ring`
  rw [Litlib.Math.Matrix4.expand_det_4]
  simp only[Matrix.trace, Matrix.diag, Matrix.mul_apply, sum_fin_4]
  
  -- Crush the resulting 4th-degree polynomials
  ring

end Litlib.Math.Leverrier
