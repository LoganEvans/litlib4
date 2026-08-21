-- FILENAME: Litlib/Math/Dirac.lean

import Litlib.Core
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

/--
Transforms a direct sum of 2-spinors (left/right chiral components) into a unified 4-dimensional Dirac index.
A pure type bijection applicable only to 4D index spaces.
-/
def chiralIsoTo (x : Fin 2 ⊕ Fin 2) : Fin 4 :=
  match x with | Sum.inl i => if i.val = 0 then 0 else 1 | Sum.inr i => if i.val = 0 then 2 else 3

/--
Inverse map splitting a 4D index into its constituent left and right 2-spinor spaces.
-/
def chiralIsoInv (k : Fin 4) : Fin 2 ⊕ Fin 2 :=
  match k.val with | 0 => Sum.inl 0 | 1 => Sum.inl 1 | 2 => Sum.inr 0 | _ => Sum.inr 1

/--
Full equivalence structure mapping chiral spinors to a Dirac vector index.
-/
def chiralIso : Fin 2 ⊕ Fin 2 ≃ Fin 4 where
  toFun := chiralIsoTo
  invFun := chiralIsoInv
  left_inv := by intro x; cases x with | inl i => fin_cases i <;> rfl | inr i => fin_cases i <;> rfl
  right_inv := by intro k; fin_cases k <;> rfl

/--
Categorizes indices into light-like/chiral representations (left-handed) versus heavy ones (right-handed).
-/
def isLight (k : Fin 4) : Bool :=
  match chiralIsoInv k with
  | Sum.inl _ => true
  | Sum.inr _ => false

/--
A matrix operator is "Even" if it preserves the chiral parity of the spinor it acts upon (e.g., maps left-to-left and right-to-right).
-/
def isEven (M : Matrix (Fin 4) (Fin 4) Complex) : Prop :=
  ∀ i j, isLight i ≠ isLight j → M i j = 0

/--
A matrix operator is "Odd" if it flips the chiral parity of the spinor it acts upon (e.g., mapping left-to-right).
-/
def isOdd (M : Matrix (Fin 4) (Fin 4) Complex) : Prop :=
  ∀ i j, isLight i = isLight j → M i j = 0

/--
Promotes a 3D index into its respective 2x2 Pauli matrix.
-/
noncomputable def sigmaToMatrix (i : Fin 3) : Matrix (Fin 2) (Fin 2) Complex :=
  match i with
  | 0 => s1
  | 1 => s2
  | 2 => s3

/--
The temporal Dirac Gamma matrix $\gamma^0$ in the Weyl/Chiral basis. Flips parity.
-/
noncomputable def gamma0 : Matrix (Fin 4) (Fin 4) Complex :=
  let m : Matrix (Fin 2 ⊕ Fin 2) (Fin 2 ⊕ Fin 2) Complex :=
    Matrix.fromBlocks 0 1 1 0
  Matrix.reindex chiralIso chiralIso m

/--
The spatial Dirac Gamma matrices $\gamma^i$ in the Weyl/Chiral basis.
-/
noncomputable def gammaSpatial (i : Fin 3) : Matrix (Fin 4) (Fin 4) Complex :=
  let sigma := sigmaToMatrix i
  let m : Matrix (Fin 2 ⊕ Fin 2) (Fin 2 ⊕ Fin 2) Complex :=
    Matrix.fromBlocks 0 sigma (-sigma) 0
  Matrix.reindex chiralIso chiralIso m

/--
The covariant 4-vector of Gamma matrices $\gamma^\mu$.
-/
noncomputable def gammaVec (mu : Fin 4) : Matrix (Fin 4) (Fin 4) Complex :=
  match mu.val with
  | 0 => gamma0
  | 1 => gammaSpatial 0
  | 2 => gammaSpatial 1
  | 3 => gammaSpatial 2
  | _ => 0

/--
The Feynman slash operator $\not{A} = A_\mu \gamma^\mu$, representing the contraction of a 4-vector with the Clifford algebra.
-/
noncomputable def aSlash (A : Fin 4 → Complex) : Matrix (Fin 4) (Fin 4) Complex :=
  A 0 • gammaVec 0 + A 1 • gammaVec 1 + A 2 • gammaVec 2 + A 3 • gammaVec 3

-- ==============================================================================
-- 2. HESTENES PARITY THEOREMS
-- ==============================================================================

/--
Algebraic parity conservation. The product of an Odd chiral operator and an Even chiral operator is Odd.
-/
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

/--
Algebraic parity conservation. The product of an Even chiral operator and an Odd chiral operator is Odd.
-/
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

/--
The temporal Gamma matrix flips chirality, acting as an Odd operator.
-/
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

/--
The spatial Gamma matrices flip chirality, acting as Odd operators.
-/
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

/--
Algebraic parity classification. Evaluates that all Dirac Gamma matrices natively possess odd parity under chiral inversion in the Weyl basis.
-/
theorem gammaVec_isOdd (mu : Fin 4) :
  isOdd (gammaVec mu) := by
  fin_cases mu
  · change isOdd gamma0; exact is_odd_gamma0
  · change isOdd (gammaSpatial 0); exact is_odd_gamma_spatial 0
  · change isOdd (gammaSpatial 1); exact is_odd_gamma_spatial 1
  · change isOdd (gammaSpatial 2); exact is_odd_gamma_spatial 2

-- ==============================================================================
-- 3. ALGEBRAIC IDENTITIES
-- ==============================================================================

/-- Auxiliary lemma distributing traces. -/
lemma trace_add_lemma (A B : Matrix (Fin 4) (Fin 4) Complex) : Matrix.trace (A + B) = Matrix.trace A + Matrix.trace B :=
  Finset.sum_add_distrib

/-- Auxiliary lemma factoring scalars from traces. -/
lemma trace_smul_lemma (c : Complex) (M : Matrix (Fin 4) (Fin 4) Complex) : Matrix.trace (c • M) = c * Matrix.trace M :=
  (Finset.mul_sum Finset.univ (fun i => M i i) c).symm

/-- Auxiliary lemma confirming individual Gamma matrices are traceless. -/
lemma trace_gamma_vec (mu : Fin 4) : Matrix.trace (gammaVec mu) = 0 := by
  dsimp [Matrix.trace]
  rw [Fin.sum_univ_four]
  fin_cases mu <;>
  simp [gammaVec, gammaSpatial, gamma0, sigmaToMatrix,
        Matrix.reindex, Matrix.fromBlocks, chiralIso, chiralIsoInv]

/--
Trace of any single contraction of Gamma matrices with a 4-vector field (Feynman slash) vanishes.
Valid for all continuous 4-vector fields evaluated over the complex numbers.
-/
theorem trace_aSlash_eq_zero (A : Fin 4 → Complex) :
  Matrix.trace (aSlash A) = 0 := by
  dsimp [aSlash]
  rw [trace_add_lemma, trace_add_lemma, trace_add_lemma]
  rw [trace_smul_lemma, trace_smul_lemma, trace_smul_lemma, trace_smul_lemma]
  rw [trace_gamma_vec 0, trace_gamma_vec 1, trace_gamma_vec 2, trace_gamma_vec 3]
  simp

private lemma sum_fin_4 (f : Fin 4 → Complex) : ∑ i : Fin 4, f i = f 0 + f 1 + f 2 + f 3 := by
  rw [Fin.sum_univ_castSucc, Fin.sum_univ_castSucc, Fin.sum_univ_castSucc, Fin.sum_univ_castSucc]
  simp

/-- Evaluates explicit 4x4 matrix multiplications to bypass kernel timeouts. -/
lemma eval_mul_4x4 (A B : Matrix (Fin 4) (Fin 4) Complex) (i j : Fin 4) :
  (A * B) i j = A i 0 * B 0 j + A i 1 * B 1 j + A i 2 * B 2 j + A i 3 * B 3 j := by
  rw [Matrix.mul_apply, sum_fin_4]

set_option linter.unusedSimpArgs false
set_option maxHeartbeats 2000000

/--
The Clifford relation for the Weyl-basis gamma matrices: {γᵃ, γᵇ} = 2ηᵃᵇ.
-/
@[litlib_track "Clifford Algebra relation for Gamma Matrices"]
theorem gamma_clifford (eta : Fin 4 → Fin 4 → ℂ)
    (h_eta : ∀ a b, eta a b = if a = 0 ∧ b = 0 then 1 else if a = b then -1 else 0)
    (a b : Fin 4) :
    gammaVec a * gammaVec b + gammaVec b * gammaVec a =
    (2 * eta a b) • (1 : Matrix (Fin 4) (Fin 4) ℂ) := by
  ext i j
  fin_cases a <;> fin_cases b <;> fin_cases i <;> fin_cases j
  all_goals {
    rw [h_eta]
    simp [gammaVec, gammaSpatial, gamma0, sigmaToMatrix, s1, s2, s3,
          Matrix.fromBlocks, Matrix.reindex, chiralIso, chiralIsoTo, chiralIsoInv,
          Matrix.submatrix, Sum.elim, eval_mul_4x4, Matrix.one_apply,
          Matrix.smul_apply, Matrix.add_apply]
    try norm_num
  }

end Litlib.Math.Dirac
