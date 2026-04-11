-- FILENAME: Litlib/Y1976/rudin1976principles/Proofs/FrechetToScalar.lean

import Litlib.Y1976.rudin1976principles.Signature
import Mathlib.Analysis.Calculus.FDeriv.Linear
import Mathlib.Analysis.Calculus.FDeriv.Add
import Mathlib.Analysis.Calculus.FDeriv.Comp

namespace Litlib.Y1976.rudin1976principles.Proofs

open ContinuousLinearMap

/--
The rigorous functional analysis proof linking multi-dimensional Fréchet 
derivatives to 1D scalar limits, adapted from the CGD bridges.
-/
@[litlib_status Verified]
instance : FrechetToScalarProjection where
  project_frechet_to_1d V W _ _ _ _ f x u hf := by
    let g := fun (t : ℝ) => x + t • u
    
    have h_eq : (fun t : ℝ => f (x + t • u)) = f ∘ g := rfl
    rw [h_eq]
    
    -- Fully qualified to prevent collision with _root_.id
    let L : ℝ →L[ℝ] V := smulRight (ContinuousLinearMap.id ℝ ℝ) u
    
    have hg_has : HasFDerivAt g L 0 := by
      have h1 : HasFDerivAt (fun _ : ℝ => x) (0 : ℝ →L[ℝ] V) 0 := hasFDerivAt_const x 0
      have h2 : HasFDerivAt L L 0 := L.hasFDerivAt
      have h3 : HasFDerivAt (fun t => x + L t) (0 + L) 0 := h1.add h2
      have h4 : (fun t => x + L t) = g := rfl
      have h5 : (0 : ℝ →L[ℝ] V) + L = L := zero_add L
      rw[h4, h5] at h3
      exact h3

    have hf_has : HasFDerivAt f (fderiv ℝ f x) (g 0) := by
      have hg0 : g 0 = x := by
        dsimp[g]
        simp
      rw [hg0]
      exact hf.hasFDerivAt
      
    -- Chain Rule
    have h_comp : HasFDerivAt (f ∘ g) ((fderiv ℝ f x).comp L) 0 :=
      hf_has.comp 0 hg_has
      
    have h_has_deriv : HasDerivAt (f ∘ g) (((fderiv ℝ f x).comp L) 1) 0 :=
      h_comp.hasDerivAt
      
    have h_deriv_eq : deriv (f ∘ g) 0 = ((fderiv ℝ f x).comp L) 1 :=
      h_has_deriv.deriv
      
    rw [h_deriv_eq]
    change (fderiv ℝ f x) u = (fderiv ℝ f x) (L 1)
    have hL1 : L 1 = u := by
      dsimp [L]
      simp
    rw[hL1]

end Litlib.Y1976.rudin1976principles.Proofs
