-- FILENAME: Litlib/Y2017/bengtsson2017geometry/Chapter03/Sec01_Spheres.lean

import Litlib.Core
import Mathlib.Analysis.InnerProductSpace.Basic
import Mathlib.Analysis.InnerProductSpace.PiL2
import Mathlib.Analysis.Calculus.Deriv.Basic
import Mathlib.Analysis.SpecialFunctions.Trigonometric.Basic
import Litlib.Y2017.bengtsson2017geometry.Paper

namespace Litlib.Y2017.bengtsson2017geometry

Litlib.equation "bengtsson2017geometry"
  eq "3.14"
  page "62"
  kind "theorem"
class Eq3_14
    (N : ℕ)
    (X : ℝ → EuclideanSpace ℝ (Fin N))
    (d : EuclideanSpace ℝ (Fin N) → EuclideanSpace ℝ (Fin N) → ℝ)
    (isGeodesic : (ℝ → EuclideanSpace ℝ (Fin N)) → Prop) where
  N_pos : N > 0
  geodesic_distance_cos : 
    Differentiable ℝ X →
    (∀ τ, ‖X τ‖ = 1) → 
    (∀ τ, ‖deriv X τ‖ = 1) → 
    isGeodesic X →
    ∀ τ₁ τ₂ : ℝ, Real.cos (d (X τ₁) (X τ₂)) = inner ℝ (X τ₁) (X τ₂)

end Litlib.Y2017.bengtsson2017geometry
