-- FILENAME: Litlib/Math/CalculusBridges.lean

import Mathlib.Analysis.Calculus.Deriv.Basic
import Mathlib.Analysis.Calculus.FDeriv.Basic
import Mathlib.Analysis.Calculus.FDeriv.Linear
import Mathlib.Analysis.Calculus.FDeriv.Add
import Mathlib.Analysis.Calculus.FDeriv.Comp
import Mathlib.Analysis.Matrix.Normed

namespace Litlib.Math.CalculusBridges

/-- 
Physical Interpretation:
Universal mathematical bridge projecting n-dimensional Fréchet variations along physical basis vectors to 1D scalar limits. This allows multidimensional field variations (such as the variation of a metric or action) to be rigorously evaluated as 1D parameterized paths without loss of generality.

Mathematical Boundaries:
Evaluated over generic `Fin n → ℝ` topological spaces. Requires the function `f` to be Fréchet differentiable at the base coordinate `x`.

Literature:
Standard calculus of variations technique used in establishing the Euler-Lagrange equations (e.g., Nakahara, Geometry, Topology and Physics).
-/
lemma fderiv_basis_eq_deriv {n : ℕ} {E : Type*} [NormedAddCommGroup E] [NormedSpace ℝ E] 
  (μ : Fin n) (f : (Fin n → ℝ) → E) (x : Fin n → ℝ)
  (hf : DifferentiableAt ℝ f x) :
  (fderiv ℝ f x) (Pi.single μ 1) = deriv (fun t : ℝ => f (fun i => if i = μ then x i + t else x i)) 0 := by
  let d : Fin n → ℝ := Pi.single μ (1 : ℝ)
  let g := fun (t : ℝ) => x + t • d
  
  have h_eq : (fun t : ℝ => f (fun i => if i = μ then x i + t else x i)) = f ∘ g := by
    ext t
    congr 1
    ext i
    dsimp [g, d]
    by_cases hi : i = μ
    · subst hi
      simp
    · simp [hi]
    
  rw [h_eq]
  
  let L : ℝ →L[ℝ] (Fin n → ℝ) := ContinuousLinearMap.smulRight (ContinuousLinearMap.id ℝ ℝ) d
  
  have hg_has : HasFDerivAt g L 0 := by
    have h1 : HasFDerivAt (fun _ : ℝ => x) (0 : ℝ →L[ℝ] (Fin n → ℝ)) 0 := hasFDerivAt_const x 0
    have h2 : HasFDerivAt L L 0 := L.hasFDerivAt
    have h3 : HasFDerivAt (fun t => x + L t) (0 + L) 0 := h1.add h2
    have h4 : (fun t => x + L t) = g := rfl
    have h5 : (0 : ℝ →L[ℝ] (Fin n → ℝ)) + L = L := zero_add L
    rw[h4, h5] at h3
    exact h3

  have hf_has : HasFDerivAt f (fderiv ℝ f x) (g 0) := by
    have hg0 : g 0 = x := by
      dsimp [g]
      simp
    rw[hg0]
    exact hf.hasFDerivAt
    
  have h_comp : HasFDerivAt (f ∘ g) ((fderiv ℝ f x).comp L) 0 :=
    hf_has.comp 0 hg_has
    
  have h_has_deriv : HasDerivAt (f ∘ g) (((fderiv ℝ f x).comp L) 1) 0 :=
    h_comp.hasDerivAt
    
  have h_deriv_eq : deriv (f ∘ g) 0 = ((fderiv ℝ f x).comp L) 1 :=
    h_has_deriv.deriv
    
  rw [h_deriv_eq]
  change (fderiv ℝ f x) d = (fderiv ℝ f x) (L 1)
  have hL1 : L 1 = d := by
    dsimp [L]
    simp
  rw [hL1]

end Litlib.Math.CalculusBridges
