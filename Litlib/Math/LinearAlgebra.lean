-- FILENAME: Litlib/Math/LinearAlgebra.lean

import Mathlib.LinearAlgebra.Matrix.Determinant.Basic
import Mathlib.LinearAlgebra.Dimension.Finrank
import Mathlib.Data.Complex.Basic
import Mathlib.LinearAlgebra.Matrix.ToLin
import Mathlib.LinearAlgebra.Matrix.Rank
import Mathlib.LinearAlgebra.Span.Basic
import Mathlib.Data.Finset.Card
import Mathlib.Algebra.Module.Pi
import Mathlib.Tactic.NormNum
import Mathlib.Tactic.FinCases
import Mathlib.Tactic.Linarith

open Matrix FiniteDimensional

namespace Litlib.Math.LinearAlgebra

-- ==============================================================================
-- 1. RANK DEFICIENCY LEMMA
-- ==============================================================================

/--
The "Pigeonhole Principle" for Matrices:
If the rows of an n x n matrix span a space of dimension < n, the determinant is 0.
-/
theorem detZeroOfRowSpanLtDim
    {n : Type*}[Fintype n] [DecidableEq n]
    {K : Type*} [Field K]
    (M : Matrix n n K)
    (h_dim : Module.finrank K (Submodule.span K (Set.range M.row)) < Fintype.card n) :
    M.det = 0 := by
  rw[← Matrix.rank_eq_finrank_span_row] at h_dim
  by_contra h_det
  have h_mat_unit : IsUnit M := (Matrix.isUnit_iff_isUnit_det M).mpr (isUnit_iff_ne_zero.mpr h_det)
  have h_full_rank : M.rank = Fintype.card n := Matrix.rank_of_isUnit M h_mat_unit
  rw[h_full_rank] at h_dim
  exact lt_irrefl _ h_dim

-- ==============================================================================
-- 2. BLOCK RANK LOGIC (4x4 SPECIAL CASE)
-- ==============================================================================

section BlockRankCombinatorics
variable {K : Type*}[DecidableEq K]

/-- The set of spatial rows (1, 2, 3) for a 4x4 matrix. -/
def spatialRows (M : Matrix (Fin 4) (Fin 4) K) : Finset (Fin 4 → K) :=
  insert (M.row 1) (insert (M.row 2) {M.row 3})

lemma card_spatial_rows_le_three (M : Matrix (Fin 4) (Fin 4) K) :
  (spatialRows M).card ≤ 3 := by
  dsimp [spatialRows]
  let s3 : Finset (Fin 4 → K) := {M.row 3}
  have h3 : s3.card ≤ 1 := Finset.card_singleton (M.row 3) ▸ le_refl _
  let s2 : Finset (Fin 4 → K) := insert (M.row 2) s3
  have h2 : s2.card ≤ s3.card + 1 := Finset.card_insert_le (M.row 2) s3
  let s1 : Finset (Fin 4 → K) := insert (M.row 1) s2
  have h1 : s1.card ≤ s2.card + 1 := Finset.card_insert_le (M.row 1) s2
  linarith

lemma range_row_subset_insert_spatial (M : Matrix (Fin 4) (Fin 4) K) :
  Set.range M.row ⊆ insert (M.row 0) (spatialRows M : Set (Fin 4 → K)) := by
  intro v hv
  obtain ⟨i, rfl⟩ := Set.mem_range.mp hv
  simp only[spatialRows, Finset.coe_insert, Finset.coe_singleton, Set.mem_insert_iff]
  fin_cases i <;> simp

end BlockRankCombinatorics

section BlockRankAlgebra
variable {K : Type*} [Field K] [DecidableEq K]

lemma span_le_span_spatial_of_row0_zero (M : Matrix (Fin 4) (Fin 4) K) (h0 : M.row 0 = 0) :
  Submodule.span K (Set.range M.row) ≤ Submodule.span K (spatialRows M : Set (Fin 4 → K)) := by
  rw [Submodule.span_le]
  intro v hv
  have h_mem := range_row_subset_insert_spatial M hv
  rcases h_mem with (rfl | h_spatial)
  · rw [h0]; exact Submodule.zero_mem _
  · exact Submodule.subset_span h_spatial

/--
Theorem: If the Electric components (Row 0) are zero, Rank <= 3.
-/
theorem rankLeThreeOfElectricZero (M : Matrix (Fin 4) (Fin 4) K) (h_row0 : ∀ j, M 0 j = 0) :
  M.rank ≤ 3 := by
  have h_row0_vec : M.row 0 = 0 := by ext j; simp[Matrix.row, h_row0]
  have h_span_le := span_le_span_spatial_of_row0_zero M h_row0_vec
  rw[Matrix.rank_eq_finrank_span_row]
  apply le_trans (Submodule.finrank_mono h_span_le)
  apply le_trans (finrank_span_finset_le_card (spatialRows M))
  exact card_spatial_rows_le_three M

end BlockRankAlgebra

-- ==============================================================================
-- 3. STRUCTURE RANK LOGIC (SPATIAL ZERO)
-- ==============================================================================

section StructureRankProps
variable {K : Type*} [Field K]

/-- If M_ij = 0 for all i!=0, j!=0, then M_i is a scalar multiple of e_0. -/
lemma row_proportional_to_e0_of_spatial_zero
  (M : Matrix (Fin 4) (Fin 4) K)
  (h : ∀ i j : Fin 4, i ≠ 0 → j ≠ 0 → M i j = 0)
  (i : Fin 4) (hi : i ≠ 0) :
  M.row i = (M i 0) • (Pi.single 0 1 : Fin 4 → K) := by
  ext k
  by_cases hk : k = 0
  · rw [hk]; simp only[Matrix.row_apply, Pi.smul_apply, Pi.single_eq_same]; rw[smul_eq_mul, mul_one]
  · simp only[Matrix.row_apply, Pi.smul_apply]; rw[Pi.single_eq_of_ne hk]; simp only[smul_zero]; rw [h i k hi hk]

end StructureRankProps

section StructureRankMain
variable {K : Type*} [Field K] [DecidableEq K]

/-- The generating set for the row space of a "Spatial Zero" matrix. -/
def spatialGenSet (M : Matrix (Fin 4) (Fin 4) K) : Finset (Fin 4 → K) :=
  insert (M 0) {Pi.single 0 1}

lemma spatial_gen_set_card_le_two (M : Matrix (Fin 4) (Fin 4) K) :
  (spatialGenSet M).card ≤ 2 := by
  dsimp[spatialGenSet]
  apply le_trans (Finset.card_insert_le (M 0) {Pi.single 0 1})
  simp only [Finset.card_singleton]; norm_num

/--
Theorem: If the "spatial" (non-zero index) block is zero, Rank <= 2.
-/
theorem rankLeTwoOfSpatialZero
  (M : Matrix (Fin 4) (Fin 4) K)
  (h_spatial : ∀ i j : Fin 4, i ≠ 0 → j ≠ 0 → M i j = 0) :
  Matrix.rank M ≤ 2 := by
  let S := spatialGenSet M
  have h_span_le : Submodule.span K (Set.range M.row) ≤ Submodule.span K (S : Set (Fin 4 → K)) := by
    rw [Submodule.span_le]; intro v hv
    obtain ⟨i, hi⟩ := Set.mem_range.mp hv; rw[← hi]
    by_cases h_idx : i = 0
    · rw [h_idx]; dsimp [Matrix.row]
      apply Submodule.subset_span;
      simp[S, spatialGenSet]
    · rw[row_proportional_to_e0_of_spatial_zero M h_spatial i h_idx]
      apply Submodule.smul_mem
      apply Submodule.subset_span;
      simp [S, spatialGenSet]

  rw[Matrix.rank_eq_finrank_span_row]
  exact le_trans (Submodule.finrank_mono h_span_le) (le_trans (finrank_span_finset_le_card S) (spatial_gen_set_card_le_two M))

end StructureRankMain

-- ==============================================================================
-- 4. SCALAR IDENTITY MATRICES AND LORENTZIAN SIGNATURE
-- ==============================================================================

section IdentitySignature
open Complex

lemma det_smul_id_fin4 (c : Complex) :
  Matrix.det (c • (1 : Matrix (Fin 4) (Fin 4) Complex)) = c^4 := by
  have h_smul : c • (1 : Matrix (Fin 4) (Fin 4) Complex) = Matrix.diagonal (fun _ => c) := by
    ext i j
    by_cases h : i = j
    · rw [h]; simp
    · simp [h]
  rw[h_smul, Matrix.det_diagonal, Finset.prod_const]
  rfl

lemma c_real_of_smul_id_real (c : Complex)
  (h_real : ∀ i j, (c • (1 : Matrix (Fin 4) (Fin 4) Complex) i j).im = 0) :
  c.im = 0 := by
  have h00 := h_real 0 0
  have heval : c • (1 : Matrix (Fin 4) (Fin 4) Complex) 0 0 = c := by simp
  rw [heval] at h00
  exact h00

lemma sq_sq_re_nonneg (c : Complex) (hc : c.im = 0) :
  0 ≤ (c^4).re := by
  have h_re : c = ↑c.re := by
    calc c = ↑c.re + ↑c.im * I := by exact (Complex.re_add_im c).symm
         _ = ↑c.re + ↑(0 : ℝ) * I := by rw [hc]
         _ = ↑c.re := by simp
  rw[h_re]
  have h_pow : ((c.re : Complex)^4).re = c.re^4 := by
    have h_cast : ((c.re : Complex)^4) = ↑(c.re^4) := by exact_mod_cast rfl
    rw[h_cast, Complex.ofReal_re]
  rw [h_pow]
  have h_sq : c.re^4 = (c.re^2)^2 := by ring
  rw [h_sq]
  exact sq_nonneg (c.re^2)

/-- A structural rank/signature lemma: A matrix proportional to the identity cannot have a Lorentzian signature. -/
theorem detNotLorentzianOfProportionalToId (c : Complex) (g : Matrix (Fin 4) (Fin 4) Complex)
  (h_g : g = c • 1) :
  ¬ ( (∀ i j, (g i j).im = 0) ∧ g.det.re < 0 ∧ g.det.im = 0 ) := by
  intro h_lor
  rcases h_lor with ⟨h_real, h_det_re, h_det_im⟩
  have h_c_real : c.im = 0 := by
    rw [h_g] at h_real
    exact c_real_of_smul_id_real c h_real
  have h_det : g.det = c^4 := by
    rw [h_g]
    exact det_smul_id_fin4 c
  rw [h_det] at h_det_re
  have h_nonneg := sq_sq_re_nonneg c h_c_real
  linarith

end IdentitySignature

end Litlib.Math.LinearAlgebra
