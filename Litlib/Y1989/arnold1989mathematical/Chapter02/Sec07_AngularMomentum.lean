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
class AngularMomentumConservation2D where
  /--
  Angular Momentum Conservation: Theorem, page 31.
  Proves that for a particle moving in a central force field (where the acceleration 
  is strictly collinear with the position vector), the areal velocity and angular 
  momentum are exactly conserved quantities. Trajectories are bound to be twice 
  differentiable to rigorously support the kinematic acceleration definition.
  -/
  momentum_conserved : ∀ (r0 r1 c : ℝ → ℝ),
    Differentiable ℝ r0 → Differentiable ℝ (deriv r0) →
    Differentiable ℝ r1 → Differentiable ℝ (deriv r1) →
    (∀ t, deriv (deriv r0) t = c t * r0 t) →
    (∀ t, deriv (deriv r1) t = c t * r1 t) →
    ∀ t₁ t₂,
      r0 t₁ * deriv r1 t₁ - r1 t₁ * deriv r0 t₁ =
      r0 t₂ * deriv r1 t₂ - r1 t₂ * deriv r0 t₂

end Litlib.Y1989.arnold1989mathematical
