-- FILENAME: Litlib/Math/MatrixCalculus.lean

import Mathlib.Algebra.Lie.Classical
import Mathlib.Analysis.Calculus.FDeriv.Add
import Mathlib.Analysis.Calculus.FDeriv.Mul
import Mathlib.Analysis.Calculus.FDeriv.Comp
import Mathlib.Analysis.Calculus.FDeriv.Symmetric
import Mathlib.Tactic.Abel
import Mathlib.Tactic.Ring
import Mathlib.Data.Complex.Basic
import Mathlib.Data.Matrix.Basic
import Mathlib.Data.Real.Basic
import Mathlib.Analysis.Calculus.ContDiff.Basic
import Mathlib.Analysis.Complex.Basic
import Mathlib.Analysis.Matrix.Normed

set_option linter.unusedVariables false
set_option linter.unusedSimpArgs false

namespace Litlib.Math.MatrixCalculus

open Complex Matrix BigOperators

-- ==============================================================================
-- 1. BASE DEFINITIONS AND SPATIAL GEOMETRY
-- ==============================================================================

/-- Physical coordinate background equivalent to a flat Minkowski or R^4 manifold evaluation patch. -/
abbrev SpacetimePoint := Fin 4 → ℝ

/-- Computes the explicit directional derivative mapped along flat vector basis coordinates. -/
noncomputable def partialDeriv {E : Type*}[NormedAddCommGroup E][NormedSpace ℝ E] (μ : Fin 4) (f : SpacetimePoint → E) : SpacetimePoint → E :=
  fun x => fderiv ℝ f x (Pi.single μ (1 : ℝ))

/-- Computes the directional derivative of a topological spinor/connection matrix explicitly point-by-point. -/
noncomputable def partialDerivMat (μ : Fin 4) (f : SpacetimePoint → Matrix (Fin 2) (Fin 2) ℂ) (x : SpacetimePoint) : Matrix (Fin 2) (Fin 2) ℂ :=
  fun i j => partialDeriv μ (fun p => f p i j) x

-- ============================================================================
-- 2. ALGEBRAIC PRODUCT RULES
-- ============================================================================

/-- Distributes spatial derivatives over scalar function superpositions. -/
lemma partialDeriv_add (f g : SpacetimePoint → ℂ)
  (x : SpacetimePoint)
  (hf : DifferentiableAt ℝ f x) (hg : DifferentiableAt ℝ g x) (mu : Fin 4) :
  partialDeriv mu (fun p => f p + g p) x = partialDeriv mu f x + partialDeriv mu g x := by
  unfold partialDeriv
  have heq : (fun p => f p + g p) = f + g := by funext p; rfl
  rw [heq, fderiv_add hf hg]
  rfl

/-- Distributes spatial derivatives over scalar function subtractions. -/
lemma partialDeriv_sub (f g : SpacetimePoint → ℂ)
  (x : SpacetimePoint)
  (hf : DifferentiableAt ℝ f x) (hg : DifferentiableAt ℝ g x) (mu : Fin 4) :
  partialDeriv mu (fun p => f p - g p) x = partialDeriv mu f x - partialDeriv mu g x := by
  unfold partialDeriv
  have heq : (fun p => f p - g p) = f - g := by funext p; rfl
  rw [heq, fderiv_sub hf hg]
  rfl

/-- Evaluates the canonical Fréchet derivative product rule bound for interacting point fields. -/
lemma partialDeriv_mul (f g : SpacetimePoint → ℂ)
  (x : SpacetimePoint)
  (hf : DifferentiableAt ℝ f x) (hg : DifferentiableAt ℝ g x) (mu : Fin 4) :
  partialDeriv mu (fun p => f p * g p) x = partialDeriv mu f x * g x + f x * partialDeriv mu g x := by
  unfold partialDeriv
  have heq : (fun p => f p * g p) = f * g := by funext p; rfl
  rw [heq, fderiv_mul hf hg]
  simp [smul_eq_mul]
  ring

-- ============================================================================
-- 3. SCALAR & SUM LINEARITY LEMMAS
-- ============================================================================

/-- Coordinate selector evaluation index map. -/
def eval_ij (i j : Fin 2) : Matrix (Fin 2) (Fin 2) ℂ →+ ℂ where
  toFun M := M i j
  map_zero' := rfl
  map_add' M N := rfl

/-- Spacetime point base map evaluation operator. -/
def eval_pt (p : SpacetimePoint) : (SpacetimePoint → ℂ) →+ ℂ where
  toFun f := f p
  map_zero' := rfl
  map_add' f g := rfl

/-- Bounded linear extraction of global topological scalar values. -/
lemma partialDeriv_smul (c : ℂ) (f : SpacetimePoint → ℂ)
  (x : SpacetimePoint) (hf : DifferentiableAt ℝ f x) (mu : Fin 4) :
  partialDeriv mu (fun p => c * f p) x = c * partialDeriv mu f x := by
  have hc : DifferentiableAt ℝ (fun _ : SpacetimePoint => c) x := differentiableAt_const c
  rw [partialDeriv_mul (fun _ => c) f x hc hf mu]
  have hz : partialDeriv mu (fun _ => c) x = 0 := by
    unfold partialDeriv
    simp
  rw [hz]
  ring

/-- Linearity identity mapping fixed scalars identically across generic matrices. -/
lemma partialDerivMat_smul (c : ℂ) (f : SpacetimePoint → Matrix (Fin 2) (Fin 2) ℂ)
  (x : SpacetimePoint) (hf : ∀ i j, DifferentiableAt ℝ (fun p => (f p) i j) x) (mu : Fin 4) :
  partialDerivMat mu (fun p => c • f p) x = c • partialDerivMat mu f x := by
  ext i j
  unfold partialDerivMat
  change partialDeriv mu (fun p => c * (f p) i j) x = c * partialDeriv mu (fun p => (f p) i j) x
  exact partialDeriv_smul c (fun p => (f p) i j) x (hf i j) mu

/-- Evaluates explicit multilinear functional summations. -/
lemma partialDeriv_sum {ι : Type} (s : Finset ι) (f : ι → SpacetimePoint → ℂ)
  (x : SpacetimePoint) (hf : ∀ k ∈ s, DifferentiableAt ℝ (f k) x) (mu : Fin 4) :
  partialDeriv mu (fun p => ∑ k ∈ s, f k p) x = ∑ k ∈ s, partialDeriv mu (f k) x := by
  unfold partialDeriv
  have heq : (fun p => ∑ k ∈ s, f k p) = ∑ k ∈ s, f k := by 
    ext p
    exact (map_sum (eval_pt p) (fun k => f k) s).symm
  rw [heq]
  rw [fderiv_sum hf]
  let ev := ContinuousLinearMap.apply ℝ ℂ (Pi.single mu 1 : Fin 4 → ℝ)
  exact map_sum ev (fun k => fderiv ℝ (f k) x) s

/-- Matrix multilinear sum mappings. -/
lemma partialDerivMat_sum {ι : Type} (s : Finset ι) 
  (f : ι → SpacetimePoint → Matrix (Fin 2) (Fin 2) ℂ) (x : SpacetimePoint)
  (hf : ∀ k ∈ s, ∀ i j, DifferentiableAt ℝ (fun p => (f k p) i j) x) (mu : Fin 4) :
  partialDerivMat mu (fun p => ∑ k ∈ s, f k p) x = ∑ k ∈ s, partialDerivMat mu (f k) x := by
  ext i j
  have hLHS : (partialDerivMat mu (fun p => ∑ k ∈ s, f k p) x) i j = partialDeriv mu (fun p => (∑ k ∈ s, f k p) i j) x := rfl
  have hRHS : (∑ k ∈ s, partialDerivMat mu (f k) x) i j = ∑ k ∈ s, partialDeriv mu (fun p => (f k p) i j) x := by
    exact map_sum (eval_ij i j) (fun k => partialDerivMat mu (f k) x) s
  rw [hLHS, hRHS]
  have h_eq : (fun p => (∑ k ∈ s, f k p) i j) = (fun p => ∑ k ∈ s, (f k p) i j) := by
    ext p
    exact map_sum (eval_ij i j) (fun k => f k p) s
  rw [h_eq]
  exact partialDeriv_sum s (fun k p => (f k p) i j) x (fun k hk => hf k hk i j) mu

-- ============================================================================
-- 4. NON-COMMUTATIVE MATRIX PRODUCT RULES
-- ============================================================================

/-- Matrix product Fréchet bounds mapping logic. -/
lemma diff_mat_mul (M N : SpacetimePoint → Matrix (Fin 2) (Fin 2) ℂ) (x : SpacetimePoint)
  (hM : ∀ i j, DifferentiableAt ℝ (fun p => (M p) i j) x)
  (hN : ∀ i j, DifferentiableAt ℝ (fun p => (N p) i j) x)
  (i j : Fin 2) : DifferentiableAt ℝ (fun p => (M p * N p) i j) x := by
  have heq : (fun p => (M p * N p) i j) = fun p => (M p) i 0 * (N p) 0 j + (M p) i 1 * (N p) 1 j := by
    ext p
    simp only [Matrix.mul_apply, Fin.sum_univ_two]
  rw [heq]
  apply DifferentiableAt.add
  · exact DifferentiableAt.mul (hM i 0) (hN 0 j)
  · exact DifferentiableAt.mul (hM i 1) (hN 1 j)

/-- Additive continuous Fréchet constraints. -/
lemma diff_mat_add (M N : SpacetimePoint → Matrix (Fin 2) (Fin 2) ℂ) (x : SpacetimePoint)
  (hM : ∀ i j, DifferentiableAt ℝ (fun p => (M p) i j) x)
  (hN : ∀ i j, DifferentiableAt ℝ (fun p => (N p) i j) x)
  (i j : Fin 2) : DifferentiableAt ℝ (fun p => (M p + N p) i j) x := by
  have heq : (fun p => (M p + N p) i j) = fun p => (M p) i j + (N p) i j := by ext p; simp only [Matrix.add_apply]
  rw [heq]
  exact DifferentiableAt.add (hM i j) (hN i j)

/-- Subtractive boundary equivalence evaluations. -/
lemma diff_mat_sub (M N : SpacetimePoint → Matrix (Fin 2) (Fin 2) ℂ) (x : SpacetimePoint)
  (hM : ∀ i j, DifferentiableAt ℝ (fun p => (M p) i j) x)
  (hN : ∀ i j, DifferentiableAt ℝ (fun p => (N p) i j) x)
  (i j : Fin 2) : DifferentiableAt ℝ (fun p => (M p - N p) i j) x := by
  have heq : (fun p => (M p - N p) i j) = fun p => (M p) i j - (N p) i j := by ext p; simp only [Matrix.sub_apply]
  rw [heq]
  exact DifferentiableAt.sub (hM i j) (hN i j)

/-- Matrix function distributive equivalences mapping linearly. -/
lemma partialDerivMat_add (M N : SpacetimePoint → Matrix (Fin 2) (Fin 2) ℂ)
  (x : SpacetimePoint)
  (hM : ∀ i j, DifferentiableAt ℝ (fun p => (M p) i j) x)
  (hN : ∀ i j, DifferentiableAt ℝ (fun p => (N p) i j) x)
  (mu : Fin 4) :
  partialDerivMat mu (fun p => M p + N p) x = partialDerivMat mu M x + partialDerivMat mu N x := by
  ext i j
  unfold partialDerivMat
  have h : (fun p => (M p + N p) i j) = fun p => M p i j + N p i j := by ext p; simp only [Matrix.add_apply]
  rw [h]
  exact partialDeriv_add _ _ x (hM i j) (hN i j) mu

/-- Destructive difference field calculations in bounded domains. -/
lemma partialDerivMat_sub (M N : SpacetimePoint → Matrix (Fin 2) (Fin 2) ℂ)
  (x : SpacetimePoint)
  (hM : ∀ i j, DifferentiableAt ℝ (fun p => (M p) i j) x)
  (hN : ∀ i j, DifferentiableAt ℝ (fun p => (N p) i j) x)
  (mu : Fin 4) :
  partialDerivMat mu (fun p => M p - N p) x = partialDerivMat mu M x - partialDerivMat mu N x := by
  ext i j
  unfold partialDerivMat
  have h : (fun p => (M p - N p) i j) = fun p => M p i j - N p i j := by ext p; simp only [Matrix.sub_apply]
  rw [h]
  exact partialDeriv_sub _ _ x (hM i j) (hN i j) mu

/-- 
Physical Interpretation:
The exact analytical continuous field evaluation representing the Product Rule (Leibniz Rule) mapping strictly onto arbitrary gauge-field matrix contractions dynamically. 

Mathematical Boundaries:
Applicable to all topological continuous vector spaces.
-/
lemma partialDerivMat_mul (M N : SpacetimePoint → Matrix (Fin 2) (Fin 2) ℂ)
  (x : SpacetimePoint)
  (hM : ∀ i j, DifferentiableAt ℝ (fun p => (M p) i j) x)
  (hN : ∀ i j, DifferentiableAt ℝ (fun p => (N p) i j) x)
  (mu : Fin 4) :
  partialDerivMat mu (fun p => M p * N p) x = partialDerivMat mu M x * N x + M x * partialDerivMat mu N x := by
  ext i j
  unfold partialDerivMat
  have h0 : (fun p => (M p * N p) i j) = fun p => (M p i 0 * N p 0 j) + (M p i 1 * N p 1 j) := by 
    ext p; simp only [Matrix.mul_apply, Fin.sum_univ_two]
  rw [h0]
  have h1 : partialDeriv mu (fun p => (M p i 0 * N p 0 j) + (M p i 1 * N p 1 j)) x =
    partialDeriv mu (fun p => M p i 0 * N p 0 j) x + partialDeriv mu (fun p => M p i 1 * N p 1 j) x := by
    apply partialDeriv_add
    · exact DifferentiableAt.mul (hM i 0) (hN 0 j)
    · exact DifferentiableAt.mul (hM i 1) (hN 1 j)
  rw [h1]
  rw [partialDeriv_mul _ _ x (hM i 0) (hN 0 j)]
  rw [partialDeriv_mul _ _ x (hM i 1) (hN 1 j)]
  simp only [Matrix.add_apply, Matrix.mul_apply, Fin.sum_univ_two]
  ring

-- ============================================================================
-- 5. THE SCHWARZ INTEGRABILITY / COMMUTATION THEOREM
-- ============================================================================

/--
Physical Interpretation:
The Schwarz Integrability Theorem (Clairaut's Theorem) evaluating directly over coordinate matrix fields. Ensuring that mixed partial coordinate derivatives mathematically commute physically maps to the absence of induced manifold torsion within the respective base geometric coordinates.

Mathematical Boundaries:
Requires the continuous gauge field functions to be smooth (infinitely differentiable) and is strictly confined to an inherent flat 4D spacetime base topological manifold. 

Literature:
Schwarz's integrability limits in gauge bundle formulations (e.g., Nakahara, Geometry, Topology and Physics).
-/
lemma schwarz_commute_mat (U : SpacetimePoint → Matrix (Fin 2) (Fin 2) ℂ)
  (h_smooth : ∀ i j, ContDiff ℝ ⊤ (fun x => (U x) i j))
  (α β : Fin 4) (x : SpacetimePoint) :
  partialDerivMat α (fun p => partialDerivMat β U p) x = partialDerivMat β (fun p => partialDerivMat α U p) x := by
  ext i j
  let f := fun p' => (U p') i j
  have hf : ContDiff ℝ ⊤ f := h_smooth i j
  have h_diff_f : Differentiable ℝ f := hf.differentiable (by decide)
  have hF : ContDiff ℝ ⊤ (fun (p : SpacetimePoint × SpacetimePoint) => f p.2) := hf.comp contDiff_snd
  have h_fderiv_cont : ContDiff ℝ ⊤ (fun p => fderiv ℝ f p) := ContDiff.fderiv hF contDiff_id le_top
  have h_diff_fderiv : Differentiable ℝ (fderiv ℝ f) := h_fderiv_cont.differentiable (by decide)
  have hf' : ∀ y, HasFDerivAt f (fderiv ℝ f y) y := fun y => (h_diff_f y).hasFDerivAt
  have hf'' : HasFDerivAt (fderiv ℝ f) (fderiv ℝ (fderiv ℝ f) x) x := (h_diff_fderiv x).hasFDerivAt
  have h_symm := second_derivative_symmetric hf' hf'' (Pi.single β 1 : Fin 4 → ℝ) (Pi.single α 1 : Fin 4 → ℝ)
  let L_beta := ContinuousLinearMap.apply ℝ ℂ (Pi.single β 1 : Fin 4 → ℝ)
  let L_alpha := ContinuousLinearMap.apply ℝ ℂ (Pi.single α 1 : Fin 4 → ℝ)
  have h_fderiv_L_beta : fderiv ℝ (fun p => L_beta (fderiv ℝ f p)) x = L_beta.comp (fderiv ℝ (fderiv ℝ f) x) := (L_beta.hasFDerivAt.comp x hf'').fderiv
  have h_fderiv_L_alpha : fderiv ℝ (fun p => L_alpha (fderiv ℝ f p)) x = L_alpha.comp (fderiv ℝ (fderiv ℝ f) x) := (L_alpha.hasFDerivAt.comp x hf'').fderiv
  change (fderiv ℝ (fun p => L_beta (fderiv ℝ f p)) x) (Pi.single α 1 : Fin 4 → ℝ) = (fderiv ℝ (fun p => L_alpha (fderiv ℝ f p)) x) (Pi.single β 1 : Fin 4 → ℝ)
  rw [h_fderiv_L_beta, h_fderiv_L_alpha]
  exact h_symm.symm

end Litlib.Math.MatrixCalculus
