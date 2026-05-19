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
    {I : Type} [Fintype I]
    (m : I → ℝ)
    (F_int₁ F_int₂ F_int₃ : I → I → ℝ → ℝ) where
  third_law : ∀ i j t, 
    F_int₁ i j t = - F_int₁ j i t ∧ 
    F_int₂ i j t = - F_int₂ j i t ∧ 
    F_int₃ i j t = - F_int₃ j i t
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
