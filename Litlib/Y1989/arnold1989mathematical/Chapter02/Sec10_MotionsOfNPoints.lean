-- FILENAME: Litlib/Y1989/arnold1989mathematical/Chapter02/Sec10_MotionsOfNPoints.lean

import Litlib.Core
import Litlib.Y1989.arnold1989mathematical.Paper
import Mathlib.Data.Real.Basic
import Mathlib.Analysis.Calculus.Deriv.Basic
import Mathlib.Algebra.BigOperators.Group.Finset.Basic
import Mathlib.Data.Fintype.Basic

open scoped BigOperators

namespace Litlib.Y1989.arnold1989mathematical

Litlib.equation "arnold1989mathematical"
  eq "Corollary 1"
  page "45"
  kind "theorem"
class MomentumConservationNBody
    {I : Type} [Fintype I] [Nonempty I]
    (m : I → ℝ)
    (F_int₁ F_int₂ F_int₃ : I → I → ℝ → ℝ) where
  /--
  Physical Mass Bound: Ensures all particle masses are strictly positive to prevent 
  unphysical infinite accelerations or trivial zero-momentum states.
  -/
  mass_pos : ∀ i, m i > 0
  /--
  Newton's Third Law Constraint: 
  Enforces the strong form of Newton's third law for internal interaction forces 
  between pairs of particles.
  -/
  third_law : ∀ i j t, 
    F_int₁ i j t = - F_int₁ j i t ∧ 
    F_int₂ i j t = - F_int₂ j i t ∧ 
    F_int₃ i j t = - F_int₃ j i t
  /--
  Total Momentum Conservation (N-Body): Corollary 1, page 45.
  Establishes that the total mechanical momentum of an isolated N-body system 
  is exactly conserved. The index set `I` is bound to be non-empty to prevent 
  the vacuous satisfaction of the theorem by a zero-particle universe.
  -/
  momentum_conserved : ∀ (r₁ r₂ r₃ : I → ℝ → ℝ),
    (∀ i, Differentiable ℝ (r₁ i) ∧ Differentiable ℝ (r₂ i) ∧ Differentiable ℝ (r₃ i)) →
    (∀ i, Differentiable ℝ (deriv (r₁ i)) ∧ Differentiable ℝ (deriv (r₂ i)) ∧ Differentiable ℝ (deriv (r₃ i))) →
    (∀ i t, m i * deriv (deriv (r₁ i)) t = ∑ j, F_int₁ i j t) →
    (∀ i t, m i * deriv (deriv (r₂ i)) t = ∑ j, F_int₂ i j t) →
    (∀ i t, m i * deriv (deriv (r₃ i)) t = ∑ j, F_int₃ i j t) →
    ∀ t₁ t₂,
      (∑ i, m i * deriv (r₁ i) t₁) = (∑ i, m i * deriv (r₁ i) t₂) ∧
      (∑ i, m i * deriv (r₂ i) t₁) = (∑ i, m i * deriv (r₂ i) t₂) ∧
      (∑ i, m i * deriv (r₃ i) t₁) = (∑ i, m i * deriv (r₃ i) t₂)

end Litlib.Y1989.arnold1989mathematical
