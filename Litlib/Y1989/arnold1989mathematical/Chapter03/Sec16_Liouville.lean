-- FILENAME: Litlib/Y1989/arnold1989mathematical/Chapter03/Sec16_Liouville.lean

import Litlib.Core
import Litlib.Y1989.arnold1989mathematical.Paper
import Mathlib.Data.Real.Basic
import Mathlib.Analysis.Calculus.Deriv.Basic
import Mathlib.MeasureTheory.Measure.MeasureSpaceDef
import Mathlib.Algebra.BigOperators.Group.Finset.Basic
import Mathlib.Data.Fintype.Basic

open scoped BigOperators

namespace Litlib.Y1989.arnold1989mathematical

Litlib.equation "arnold1989mathematical"
  eq "Theorem 1"
  page "69"
  kind "theorem"
class LiouvilleTheorem1D
    (H : ℝ × ℝ → ℝ)
    [MeasureTheory.MeasureSpace (ℝ × ℝ)] where
  /--
  Hamiltonian Regularity Constraint: The Hamiltonian function must be differentiable 
  with respect to both position and momentum coordinates.
  -/
  H_diff_p : ∀ q, Differentiable ℝ (fun p => H (p, q))
  H_diff_q : ∀ p, Differentiable ℝ (fun q => H (p, q))
  /--
  Volume Non-Degeneracy Constraint: Prevents the "Garbage-In" exploit where the theorem 
  could be trivially and vacuously satisfied by equipping the phase space with a 
  degenerate zero measure. Ensures there exists at least one measurable set with non-zero volume.
  -/
  vol_non_trivial : ∃ s : Set (ℝ × ℝ), MeasurableSet s ∧ MeasureTheory.volume s ≠ 0
  /--
  Liouville's Theorem (1D Phase Space): Theorem 1, page 69.
  Demonstrates that the canonical phase flow of a Hamiltonian system preserves the 
  standard symplectic volume (the canonical measure volume).
  -/
  preserves_volume : ∀ (g : ℝ → (ℝ × ℝ) → (ℝ × ℝ)),
    (∀ x, Differentiable ℝ (fun t => (g t x).1)) →
    (∀ x, Differentiable ℝ (fun t => (g t x).2)) →
    (∀ x, g 0 x = x) →
    (∀ t₁ t₂ x, g (t₁ + t₂) x = g t₁ (g t₂ x)) →
    (∀ t x, deriv (fun t' => (g t' x).1) t = - deriv (fun q => H ((g t x).1, q)) (g t x).2) →
    (∀ t x, deriv (fun t' => (g t' x).2) t = deriv (fun p => H (p, (g t x).2)) (g t x).1) →
    ∀ t s, MeasurableSet s → MeasureTheory.volume (g t '' s) = MeasureTheory.volume s

Litlib.equation "arnold1989mathematical"
  eq "Theorem 2"
  page "69"
  kind "theorem"
class LiouvilleTheoremND
    {n : ℕ}
    [MeasureTheory.MeasureSpace (Fin n → ℝ)] where
  /--
  Volume Non-Degeneracy Constraint: Binds the phase space measure to a non-trivial measure,
  barring the vacuous satisfaction of the volume-preservation identity.
  -/
  vol_non_trivial : ∃ s : Set (Fin n → ℝ), MeasurableSet s ∧ MeasureTheory.volume s ≠ 0
  /--
  Liouville's Theorem (n-Dimensional Divergence Form): Theorem 2, page 69.
  Proves that any smooth vector field with identically zero divergence generates 
  a volume-preserving flow.
  -/
  preserves_volume : ∀ (f : (Fin n → ℝ) → (Fin n → ℝ)) (g : ℝ → (Fin n → ℝ) → (Fin n → ℝ)),
    (∀ x i j, Differentiable ℝ (fun y => f (Function.update x j y) i)) →
    (∀ x i, Differentiable ℝ (fun t => g t x i)) →
    (∀ x, g 0 x = x) →
    (∀ t₁ t₂ x, g (t₁ + t₂) x = g t₁ (g t₂ x)) →
    (∀ t x i, deriv (fun t' => g t' x i) t = f (g t x) i) →
    (∀ x, (∑ i : Fin n, deriv (fun y => f (Function.update x i y) i) (x i)) = 0) →
    ∀ t s, MeasurableSet s → MeasureTheory.volume (g t '' s) = MeasureTheory.volume s

end Litlib.Y1989.arnold1989mathematical
