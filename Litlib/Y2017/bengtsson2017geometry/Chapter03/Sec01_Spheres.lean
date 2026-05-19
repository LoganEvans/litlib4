-- FILENAME: Litlib/Y2017/bengtsson2017geometry/Chapter03/Sec01_Spheres.lean

import Litlib.Core
import Mathlib.Analysis.InnerProductSpace.Basic
import Mathlib.Analysis.InnerProductSpace.PiL2
import Mathlib.Analysis.Calculus.Deriv.Basic
import Mathlib.Analysis.SpecialFunctions.Trigonometric.Basic
import Mathlib.Topology.MetricSpace.Basic
import Litlib.Y2017.bengtsson2017geometry.Paper

namespace Litlib.Y2017.bengtsson2017geometry

Litlib.equation "bengtsson2017geometry"
  eq "3.14"
  page "62"
  kind "theorem"
class Eq3_14
    (N : ℕ)
    (X : ℝ → EuclideanSpace ℝ (Fin N))
    (isGeodesic : (ℝ → EuclideanSpace ℝ (Fin N)) → Prop) where
  N_pos : 0 < N
  isGeodesic_iff : ∀ X, isGeodesic X ↔ ∃ (k l : EuclideanSpace ℝ (Fin N)),
    inner ℝ k k = (1 : ℝ) ∧ inner ℝ l l = (1 : ℝ) ∧ inner ℝ k l = (0 : ℝ) ∧
    ∀ τ, X τ = (Real.cos τ) • k + (Real.sin τ) • l
  geodesic_distance_cos : 
    isGeodesic X →
    ∀ τ₁ τ₂ : ℝ, Real.cos (dist (X τ₁) (X τ₂)) = inner ℝ (X τ₁) (X τ₂)

end Litlib.Y2017.bengtsson2017geometry
