-- FILENAME: Litlib/Math/Matrix4.lean

import Mathlib.Data.Matrix.Basic
import Mathlib.LinearAlgebra.Matrix.Determinant.Basic
import Mathlib.Data.Complex.Basic
import Mathlib.Tactic.Ring

/-!
# 4x4 Matrix Determinant Expansion

Mathlib natively provides `Matrix.det_fin_two` and `Matrix.det_fin_three`.
However, computing 4x4 determinants using the default Leibniz permutation 
definition often causes the kernel to time out.

This file provides `expand_det_4`, an explicit, flattened algebraic
Laplace expansion for 4x4 complex matrices.
-/

namespace Litlib.Math.Matrix4

open Matrix Complex

-- ============================================================================
-- FINITE INDEX LOOKUP TABLES (PREVENTS KERNEL TIMEOUTS)
-- ============================================================================

@[simp] lemma sA4_0_0 : Fin.succAbove (0 : Fin 4) (0 : Fin 3) = 1 := rfl
@[simp] lemma sA4_0_1 : Fin.succAbove (0 : Fin 4) (1 : Fin 3) = 2 := rfl
@[simp] lemma sA4_0_2 : Fin.succAbove (0 : Fin 4) (2 : Fin 3) = 3 := rfl
@[simp] lemma sA4_1_0 : Fin.succAbove (1 : Fin 4) (0 : Fin 3) = 0 := rfl
@[simp] lemma sA4_1_1 : Fin.succAbove (1 : Fin 4) (1 : Fin 3) = 2 := rfl
@[simp] lemma sA4_1_2 : Fin.succAbove (1 : Fin 4) (2 : Fin 3) = 3 := rfl
@[simp] lemma sA4_2_0 : Fin.succAbove (2 : Fin 4) (0 : Fin 3) = 0 := rfl
@[simp] lemma sA4_2_1 : Fin.succAbove (2 : Fin 4) (1 : Fin 3) = 1 := rfl
@[simp] lemma sA4_2_2 : Fin.succAbove (2 : Fin 4) (2 : Fin 3) = 3 := rfl
@[simp] lemma sA4_3_0 : Fin.succAbove (3 : Fin 4) (0 : Fin 3) = 0 := rfl
@[simp] lemma sA4_3_1 : Fin.succAbove (3 : Fin 4) (1 : Fin 3) = 1 := rfl
@[simp] lemma sA4_3_2 : Fin.succAbove (3 : Fin 4) (2 : Fin 3) = 2 := rfl

@[simp] lemma fs_0_3 : Fin.succ (0 : Fin 3) = 1 := rfl
@[simp] lemma fs_1_3 : Fin.succ (1 : Fin 3) = 2 := rfl
@[simp] lemma fs_2_3 : Fin.succ (2 : Fin 3) = 3 := rfl

-- ============================================================================
-- THE 4x4 DETERMINANT THEOREM
-- ============================================================================

/--
Explicitly expands a 4x4 matrix determinant into its 24 algebraic terms.
Bypasses the timeout-prone `O(N!)` combinatorial search.
-/
lemma expand_det_4 (M : Matrix (Fin 4) (Fin 4) ℂ) :
  M.det =
    M 0 0 * (M 1 1 * (M 2 2 * M 3 3 - M 2 3 * M 3 2) - M 1 2 * (M 2 1 * M 3 3 - M 2 3 * M 3 1) + M 1 3 * (M 2 1 * M 3 2 - M 2 2 * M 3 1))
  - M 0 1 * (M 1 0 * (M 2 2 * M 3 3 - M 2 3 * M 3 2) - M 1 2 * (M 2 0 * M 3 3 - M 2 3 * M 3 0) + M 1 3 * (M 2 0 * M 3 2 - M 2 2 * M 3 0))
  + M 0 2 * (M 1 0 * (M 2 1 * M 3 3 - M 2 3 * M 3 1) - M 1 1 * (M 2 0 * M 3 3 - M 2 3 * M 3 0) + M 1 3 * (M 2 0 * M 3 1 - M 2 1 * M 3 0))
  - M 0 3 * (M 1 0 * (M 2 1 * M 3 2 - M 2 2 * M 3 1) - M 1 1 * (M 2 0 * M 3 2 - M 2 2 * M 3 0) + M 1 2 * (M 2 0 * M 3 1 - M 2 1 * M 3 0)) := by
  rw[Matrix.det_succ_row_zero]
  simp only[Fin.sum_univ_succ, Fin.sum_univ_zero]

  -- Defeq instantly collapses all Fin chains into numbers 0, 1, 2, 3
  change (-1 : ℂ) ^ 0 * M 0 0 * (M.submatrix Fin.succ (Fin.succAbove 0)).det +
         ((-1 : ℂ) ^ 1 * M 0 1 * (M.submatrix Fin.succ (Fin.succAbove 1)).det +
         ((-1 : ℂ) ^ 2 * M 0 2 * (M.submatrix Fin.succ (Fin.succAbove 2)).det +
         ((-1 : ℂ) ^ 3 * M 0 3 * (M.submatrix Fin.succ (Fin.succAbove 3)).det +
         0))) = _

  simp only[Matrix.det_fin_three, Matrix.submatrix_apply]
  simp only[sA4_0_0, sA4_0_1, sA4_0_2, sA4_1_0, sA4_1_1, sA4_1_2, sA4_2_0, sA4_2_1, sA4_2_2, sA4_3_0, sA4_3_1, sA4_3_2, fs_0_3, fs_1_3, fs_2_3]
  ring

end Litlib.Math.Matrix4
