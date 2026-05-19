-- FILENAME: Litlib/Y1989/arnold1989mathematical/Chapter02/Sec04_OneDegreeOfFreedom.lean

import Litlib.Core
import Litlib.Y1989.arnold1989mathematical.Paper
import Mathlib.Data.Real.Basic
import Mathlib.Analysis.Calculus.Deriv.Basic

namespace Litlib.Y1989.arnold1989mathematical

Litlib.equation "arnold1989mathematical"
  eq "1"
  page "16"
  kind "theorem"
class EnergyConservation1D
    (x : ℝ → ℝ)
    (f : ℝ → ℝ)
    (U : ℝ → ℝ) where
  x_diff : Differentiable ℝ x
  dx_diff : Differentiable ℝ (deriv x)
  U_diff : Differentiable ℝ U
  pot_grad : ∀ q, deriv U q = - f q
  newton_eq : ∀ t, deriv (deriv x) t = f (x t)
  energy_conserved : ∀ t₁ t₂,
    (deriv x t₁)^2 / 2 + U (x t₁) = (deriv x t₂)^2 / 2 + U (x t₂)

end Litlib.Y1989.arnold1989mathematical
