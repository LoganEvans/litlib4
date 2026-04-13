-- FILENAME: Litlib/Math/Dirac.lean

import Litlib.Math.SU2
import Mathlib.Data.Matrix.Basic
import Mathlib.Data.Matrix.Block
import Mathlib.Data.Complex.Basic
import Mathlib.LinearAlgebra.Matrix.Trace
import Mathlib.Tactic.Ring
import Mathlib.Tactic.FinCases
import Mathlib.Algebra.BigOperators.Group.Finset.Basic

open Complex Matrix BigOperators Litlib.Math.SU2

namespace Litlib.Math.Dirac

-- ==============================================================================
-- 1. CLIFFORD ALGEBRA DEFINITIONS
-- ==============================================================================

def chiralIsoTo (x : Fin 2 ⊕ Fin 2) : Fin 4 :=
  match x with | Sum.inl i => if i.val = 0 then 0 else 1 | Sum.inr i => if i.val = 0 then 2 else 3

def chiralIsoInv (k : Fin 4) : Fin 2 ⊕ Fin 2 :=
  match k.val with | 0 => Sum.inl 0 | 1 => Sum.inl 1 | 2 => Sum.inr 0 | _ => Sum.inr 1

def chiralIso : Fin 2 ⊕ Fin 2 ≃ Fin 4 where
  toFun := chiralIsoTo
  invFun := chiralIsoInv
  left_inv := by intro x; cases x with | inl i => fin_cases i <;> rfl | inr i => fin_cases i <;> rfl
  right_inv := by intro k; fin_cases k <;> rfl

def isLight (k : Fin 4) : Bool :=
  match chiralIsoInv k with
  | Sum.inl _ => true
  | Sum.inr _ => false

def isEven (M : Matrix (Fin 4) (Fin 4) Complex) : Prop :=
  ∀ i j, isLight i ≠ isLight j → M i j = 0

def isOdd (M : Matrix (Fin 4) (Fin 4) Complex) : Prop :=
  ∀ i j, isLight i = isLight j → M i j = 0

noncomputable def sigmaToMatrix (i : Fin 3) : Matrix (Fin 2) (Fin 2) Complex :=
  match i with
  | 0 => s1
  | 1 => s2
  | 2 => s3

noncomputable def gamma0 : Matrix (Fin 4) (Fin 4) Complex :=
  let m : Matrix (Fin 2 ⊕ Fin 2) (Fin 2 ⊕ Fin 2) Complex :=
    Matrix.fromBlocks 0 1 1 0
  Matrix.reindex chiralIso chiralIso m

noncomputable def gammaSpatial (i : Fin 3) : Matrix (Fin 4) (Fin 4) Complex :=
  let sigma := sigmaToMatrix i
  let m : Matrix (Fin 2 ⊕ Fin 2) (Fin 2 ⊕ Fin 2) Complex :=
    Matrix.fromBlocks 0 sigma (-sigma) 0
  Matrix.reindex chiralIso chiralIso m

noncomputable def gammaVec (mu : Fin 4) : Matrix (Fin 4) (Fin 4) Complex :=
  match mu.val with
  | 0 => gamma0
  | 1 => gammaSpatial 0
  | 2 => gammaSpatial 1
  | 3 => gammaSpatial 2
  | _ => 0

noncomputable def aSlash (A : Fin 4 → Complex) : Matrix (Fin 4) (Fin 4) Complex :=
  A 0 • gammaVec 0 + A 1 • gammaVec 1 + A 2 • gammaVec 2 + A 3 • gammaVec 3

-- ==============================================================================
-- 2. HESTENES PARITY THEOREMS
-- ==============================================================================

lemma odd_mul_even (A B : Matrix (Fin 4) (Fin 4) Complex) (hA : isOdd A) (hB : isEven B) : isOdd (A * B) := by
  intros i j hij
  rw [Matrix.mul_apply]
  apply Finset.sum_eq_zero
  intros k _
  by_cases hk : isLight i = isLight k
  · have : A i k = 0 := hA i k hk
    rw [this, zero_mul]
  · have hk_j : isLight k ≠ isLight j := by
      intro h_contra
      rw [← h_contra] at hij
      exact hk hij
    have : B k j = 0 := hB k j hk_j
    rw [this, mul_zero]

lemma even_mul_odd (A B : Matrix (Fin 4) (Fin 4) Complex) (hA : isEven A) (hB : isOdd B) : isOdd (A * B) := by
  intros i j hij
  rw [Matrix.mul_apply]
  apply Finset.sum_eq_zero
  intros k _
  by_cases hk : isLight i = isLight k
  · have hk_j : isLight k = isLight j := by
      rw [← hk]
      exact hij
    have : B k j = 0 := hB k j hk_j
    rw [this, mul_zero]
  · have : A i k = 0 := hA i k hk
    rw [this, zero_mul]

lemma is_odd_gamma0 : isOdd gamma0 := by
  intros i j hij
  have h_val : gamma0 i j = (Matrix.fromBlocks 0 1 1 0) (chiralIsoInv i) (chiralIsoInv j) := rfl
  rw [h_val]
  cases h_i : chiralIsoInv i <;> cases h_j : chiralIsoInv j
  · rfl
  · have h_light_i : isLight i = true := by unfold isLight; rw [h_i]
    have h_light_j : isLight j = false := by unfold isLight; rw [h_j]
    rw [h_light_i, h_light_j] at hij
    contradiction
  · have h_light_i : isLight i = false := by unfold isLight; rw [h_i]
    have h_light_j : isLight j = true := by unfold isLight; rw [h_j]
    rw [h_light_i, h_light_j] at hij
    contradiction
  · rfl

lemma is_odd_gamma_spatial (idx : Fin 3) : isOdd (gammaSpatial idx) := by
  intros i j hij
  have h_val : gammaSpatial idx i j = (Matrix.fromBlocks 0 (sigmaToMatrix idx) (-sigmaToMatrix idx) 0) (chiralIsoInv i) (chiralIsoInv j) := rfl
  rw [h_val]
  cases h_i : chiralIsoInv i <;> cases h_j : chiralIsoInv j
  · rfl
  · have h_light_i : isLight i = true := by unfold isLight; rw [h_i]
    have h_light_j : isLight j = false := by unfold isLight; rw [h_j]
    rw [h_light_i, h_light_j] at hij
    contradiction
  · have h_light_i : isLight i = false := by unfold isLight; rw [h_i]
    have h_light_j : isLight j = true := by unfold isLight; rw [h_j]
    rw [h_light_i, h_light_j] at hij
    contradiction
  · rfl

theorem hestenesIsomorphism (mu : Fin 4) :
  isOdd (gammaVec mu) := by
  fin_cases mu
  · change isOdd gamma0; exact is_odd_gamma0
  · change isOdd (gammaSpatial 0); exact is_odd_gamma_spatial 0
  · change isOdd (gammaSpatial 1); exact is_odd_gamma_spatial 1
  · change isOdd (gammaSpatial 2); exact is_odd_gamma_spatial 2

-- ==============================================================================
-- 3. ALGEBRAIC IDENTITIES
-- ==============================================================================

lemma trace_add_lemma (A B : Matrix (Fin 4) (Fin 4) Complex) : Matrix.trace (A + B) = Matrix.trace A + Matrix.trace B :=
  Finset.sum_add_distrib

lemma trace_smul_lemma (c : Complex) (M : Matrix (Fin 4) (Fin 4) Complex) : Matrix.trace (c • M) = c * Matrix.trace M :=
  (Finset.mul_sum Finset.univ (fun i => M i i) c).symm

lemma trace_gamma_vec (mu : Fin 4) : Matrix.trace (gammaVec mu) = 0 := by
  dsimp [Matrix.trace]
  rw [Fin.sum_univ_four]
  fin_cases mu <;>
  simp [gammaVec, gammaSpatial, gamma0, sigmaToMatrix,
        Matrix.reindex, Matrix.fromBlocks, chiralIso, chiralIsoInv]

theorem leptonUniversality (A : Fin 4 → Complex) :
  Matrix.trace (aSlash A) = 0 := by
  dsimp [aSlash]
  rw [trace_add_lemma, trace_add_lemma, trace_add_lemma]
  rw [trace_smul_lemma, trace_smul_lemma, trace_smul_lemma, trace_smul_lemma]
  rw [trace_gamma_vec 0, trace_gamma_vec 1, trace_gamma_vec 2, trace_gamma_vec 3]
  simp

private lemma sum_fin_4 (f : Fin 4 → Complex) : ∑ i : Fin 4, f i = f 0 + f 1 + f 2 + f 3 := by
  rw [Fin.sum_univ_castSucc, Fin.sum_univ_castSucc, Fin.sum_univ_castSucc, Fin.sum_univ_castSucc]
  simp

lemma eval_mul_4x4 (A B : Matrix (Fin 4) (Fin 4) Complex) (i j : Fin 4) :
  (A * B) i j = A i 0 * B 0 j + A i 1 * B 1 j + A i 2 * B 2 j + A i 3 * B 3 j := by
  rw [Matrix.mul_apply, sum_fin_4]

set_option linter.unusedSimpArgs false

theorem gFactorIsTwo :
  let g1 := gammaVec 1
  let g2 := gammaVec 2
  let comm := g1 * g2 - g2 * g1
  let S_12 := (1 / 2 : Complex) • (g1 * g2)
  comm = 4 • S_12 := by
  intros g1 g2 comm S_12

  have h_anti : g2 * g1 = - (g1 * g2) := by
    ext i j
    fin_cases i <;> fin_cases j
    all_goals {
      simp [g1, g2, gammaVec, gammaSpatial, sigmaToMatrix, s1, s2,
            Matrix.fromBlocks, Matrix.reindex, chiralIso, chiralIsoTo, chiralIsoInv,
            Matrix.submatrix, Sum.elim, eval_mul_4x4]
    }

  have h_comm : comm = 2 • (g1 * g2) := by
    dsimp [comm]
    rw [h_anti]
    ext i j
    simp [Matrix.sub_apply, Matrix.smul_apply, Matrix.neg_apply]
    ring

  have h_S : 4 • S_12 = 2 • (g1 * g2) := by
    dsimp [S_12]
    ext i j
    simp [Matrix.smul_apply]
    ring

  rw [h_comm, h_S]

end Litlib.Math.Dirac
