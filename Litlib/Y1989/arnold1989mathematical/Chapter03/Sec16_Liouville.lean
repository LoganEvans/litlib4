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
    (g : ℝ → (ℝ × ℝ) → (ℝ × ℝ))
    [MeasureTheory.MeasureSpace (ℝ × ℝ)] where
  H_diff_p : ∀ q, Differentiable ℝ (fun p => H (p, q))
  H_diff_q : ∀ p, Differentiable ℝ (fun q => H (p, q))
  g_diff_p : ∀ x, Differentiable ℝ (fun t => (g t x).1)
  g_diff_q : ∀ x, Differentiable ℝ (fun t => (g t x).2)
  flow_zero : ∀ x, g 0 x = x
  flow_add : ∀ t₁ t₂ x, g (t₁ + t₂) x = g t₁ (g t₂ x)
  hamilton_eq_p : ∀ (t : ℝ) (x : ℝ × ℝ),
    deriv (fun t' => (g t' x).1) t =
    - deriv (fun q => H ((g t x).1, q)) (g t x).2
  hamilton_eq_q : ∀ (t : ℝ) (x : ℝ × ℝ),
    deriv (fun t' => (g t' x).2) t =
    deriv (fun p => H (p, (g t x).2)) (g t x).1
  preserves_volume : ∀ (t : ℝ) (s : Set (ℝ × ℝ)),
    MeasurableSet s → MeasureTheory.volume (g t '' s) = MeasureTheory.volume s

Litlib.equation "arnold1989mathematical"
  eq "Theorem 2"
  page "69"
  kind "theorem"
class LiouvilleTheoremND
    {n : ℕ}
    (f : (Fin n → ℝ) → (Fin n → ℝ))
    (g : ℝ → (Fin n → ℝ) → (Fin n → ℝ))
    [MeasureTheory.MeasureSpace (Fin n → ℝ)] where
  f_partial_diff : ∀ (x : Fin n → ℝ) (i j : Fin n),
    Differentiable ℝ (fun (y : ℝ) => f (Function.update x j y) i)
  g_diff_t : ∀ (x : Fin n → ℝ) (i : Fin n),
    Differentiable ℝ (fun (t : ℝ) => g t x i)
  flow_zero : ∀ x, g 0 x = x
  flow_add : ∀ t₁ t₂ x, g (t₁ + t₂) x = g t₁ (g t₂ x)
  ode : ∀ (t : ℝ) (x : Fin n → ℝ) (i : Fin n),
    deriv (fun t' => g t' x i) t = f (g t x) i
  div_zero : ∀ (x : Fin n → ℝ),
    (∑ i : Fin n, deriv (fun y => f (Function.update x i y) i) (x i)) = 0
  preserves_volume : ∀ (t : ℝ) (s : Set (Fin n → ℝ)),
    MeasurableSet s → MeasureTheory.volume (g t '' s) = MeasureTheory.volume s

end Litlib.Y1989.arnold1989mathematical
