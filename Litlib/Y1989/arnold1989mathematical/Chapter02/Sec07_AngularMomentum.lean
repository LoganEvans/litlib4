-- FILENAME: Litlib/Y1989/arnold1989mathematical/Chapter02/Sec07_AngularMomentum.lean

import Litlib.Core
import Litlib.Y1989.arnold1989mathematical.Paper
import Mathlib.Data.Real.Basic
import Mathlib.Analysis.Calculus.Deriv.Basic

namespace Litlib.Y1989.arnold1989mathematical

Litlib.equation "arnold1989mathematical"
  eq "Theorem (The law of conservation of angular momentum)"
  page "31"
  kind "theorem"
class AngularMomentumConservation2D
    (r0 : ℝ → ℝ)
    (r1 : ℝ → ℝ) where
  r0_diff : Differentiable ℝ r0
  dr0_diff : Differentiable ℝ (deriv r0)
  r1_diff : Differentiable ℝ r1
  dr1_diff : Differentiable ℝ (deriv r1)
  is_central : ∃ c : ℝ → ℝ, ∀ t, 
    deriv (deriv r0) t = c t * r0 t ∧ 
    deriv (deriv r1) t = c t * r1 t
  momentum_conserved : ∀ t₁ t₂,
    r0 t₁ * deriv r1 t₁ - r1 t₁ * deriv r0 t₁ =
    r0 t₂ * deriv r1 t₂ - r1 t₂ * deriv r0 t₂

end Litlib.Y1989.arnold1989mathematical
