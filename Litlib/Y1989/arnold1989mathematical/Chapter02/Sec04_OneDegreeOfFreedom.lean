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
class EnergyConservation1D (f U : ℝ → ℝ) where
  /--
  Energy Conservation Law (1D): Equation 1, page 16.
  Establishes that for a conservative one-dimensional Newtonian system, the total 
  mechanical energy (kinetic plus potential) is an exact invariant of the motion.
  The potential field `U` must be globally differentiable to prevent singularities 
  that would mathematically break the conservation law during trajectory evaluation.
  -/
  U_diff : Differentiable ℝ U
  pot_grad : ∀ q, deriv U q = - f q
  energy_conserved : ∀ (x : ℝ → ℝ),
    Differentiable ℝ x →
    Differentiable ℝ (deriv x) →
    (∀ t, deriv (deriv x) t = f (x t)) →
    ∀ t₁ t₂,
      (deriv x t₁)^2 / 2 + U (x t₁) = (deriv x t₂)^2 / 2 + U (x t₂)

end Litlib.Y1989.arnold1989mathematical
