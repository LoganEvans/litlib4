-- FILENAME: Litlib/Y2017/bengtsson2017geometry/Chapter03/Sec05_HopfFibration.lean

import Litlib.Core
import Mathlib.Data.Complex.Basic
import Mathlib.Data.Matrix.Basic
import Mathlib.Analysis.SpecialFunctions.Exponential
import Mathlib.Analysis.SpecialFunctions.Trigonometric.Basic
import Mathlib.LinearAlgebra.Matrix.Determinant.Basic
import Litlib.Y2017.bengtsson2017geometry.Paper

namespace Litlib.Y2017.bengtsson2017geometry

Litlib.equation "bengtsson2017geometry"
  eq "3.96"
  page "79"
  kind "definition"
class Eq3_96
    (Z1 Z2 : ℝ → ℝ → ℝ → ℂ) where
  hopf_Z1 : ∀ τ θ φ, Z1 τ θ φ = Complex.exp (Complex.I * ((τ + φ) : ℂ) / 2) * (Real.cos (θ / 2) : ℂ)
  hopf_Z2 : ∀ τ θ φ, Z2 τ θ φ = Complex.exp (Complex.I * ((τ - φ) : ℂ) / 2) * (Real.sin (θ / 2) : ℂ)

Litlib.equation "bengtsson2017geometry"
  eq "3.98"
  page "79"
  kind "definition"
class Eq3_98
    (g : ℝ → ℝ → ℝ → Matrix (Fin 3) (Fin 3) ℝ) where
  -- The coordinates in the Fin 3 basis are 0=τ, 1=θ, 2=φ
  metric_00 : ∀ τ θ φ, g τ θ φ 0 0 = 1 / 4
  metric_11 : ∀ τ θ φ, g τ θ φ 1 1 = 1 / 4
  metric_22 : ∀ τ θ φ, g τ θ φ 2 2 = 1 / 4
  metric_02 : ∀ τ θ φ, g τ θ φ 0 2 = (Real.cos θ) / 4
  metric_20 : ∀ τ θ φ, g τ θ φ 2 0 = (Real.cos θ) / 4
  metric_01 : ∀ τ θ φ, g τ θ φ 0 1 = 0
  metric_10 : ∀ τ θ φ, g τ θ φ 1 0 = 0
  metric_12 : ∀ τ θ φ, g τ θ φ 1 2 = 0
  metric_21 : ∀ τ θ φ, g τ θ φ 2 1 = 0
  
  -- The metric patch is non-degenerate inside the bounds 0 < θ < π
  metric_non_degenerate : ∀ τ θ φ, 0 < θ → θ < Real.pi → Matrix.det (g τ θ φ) ≠ 0

end Litlib.Y2017.bengtsson2017geometry
