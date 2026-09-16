-- FILENAME: Litlib/Y1974/guillemin1974differential/Chapter03/Sec05_PoincareHopf.lean

import Mathlib.Analysis.Calculus.Deriv.Basic
import Mathlib.Analysis.Calculus.ContDiff.Basic
import Mathlib.Data.Fintype.Card
import Mathlib.Data.Fintype.BigOperators
import Mathlib.Data.Real.Basic
import Mathlib.LinearAlgebra.Determinant
import Litlib.Core

namespace Litlib.Y1974.guillemin1974differential

/-!
# Chapter 3, Section 5: Vector Fields and the Poincaré-Hopf Theorem (pp. 132–141)

Defines indices of isolated zeros of vector fields, establishes the Poincaré-Hopf Index Theorem
$\sum_{v(x)=0} \operatorname{ind}_x(v) = \chi(X)$, connects flow tangency to local Lefschetz
numbers, and characterises nondegenerate zeros via $\operatorname{sign}\det(dv_x)$.
-/

Litlib.equation "guillemin1974differential"
  eq "Lemma_TaylorSecondOrder" page "135" kind "lemma"
/-- Taylor Second Order Remainder Lemma: If $g : \mathbb{R} \to \mathbb{R}$ is smooth, then
$g(t) = g(0) + t g'(0) + t^2 r(t)$ for a smooth function $r(t)$. -/
class Lemma_TaylorSecondOrder
    (g : ℝ → ℝ) (g'₀ : ℝ)
    (r : ℝ → ℝ)
    (h_smooth_g : ContDiff ℝ ⊤ g)
    (h_deriv : g'₀ = deriv g 0) where
  taylor_expansion : ∀ t, g t = g 0 + t * g'₀ + t ^ 2 * r t
  r_smooth : ContDiff ℝ ⊤ r

Litlib.equation "guillemin1974differential"
  eq "Proposition_Tangency" page "135" kind "proposition"
/-- Proposition: If a family of maps $\{f_t\}$ is tangent to a vector field $v$ at time zero,
then for small $t > 0$, the local Lefschetz number $L_0(f_t)$ equals the index $\operatorname{ind}_0(v)$. -/
class Proposition_Tangency
    (indexV : ℤ)
    (localLefschetzFt : ℤ) where
  tangency_index_eq_lefschetz : indexV = localLefschetzFt

Litlib.equation "guillemin1974differential"
  eq "Theorem_PoincareHopfIndex" page "134" kind "theorem"
/-- Poincaré-Hopf Index Theorem: If $v$ is a smooth vector field on a compact, oriented
manifold $X$ with only finitely many zeros, then the sum of the indices of $v$ equals the
Euler characteristic of $X$. -/
class Theorem_PoincareHopfIndex
    (ZeroPoints : Type*) [Fintype ZeroPoints]
    (index : ZeroPoints → ℤ)
    (eulerChar : ℤ) where
  poincare_hopf_sum : (∑ x : ZeroPoints, index x) = eulerChar

Litlib.equation "guillemin1974differential"
  eq "NondegenerateZeroIndex" page "139" kind "theorem"
/-- Exercise 5: A zero $x$ of $v$ is nondegenerate iff $dv_x : T_x X \to T_x X$ is bijective.
At a nondegenerate zero $x$, $\operatorname{ind}_x(v) = \operatorname{sign}\det(dv_x)$. -/
class NondegenerateZeroIndex
    (k : ℕ)
    (detDv : ℝ)
    (h_bijective : detDv ≠ 0)
    (index : ℤ) where
  index_eq_sign_det : index = if 0 < detDv then 1 else -1

Litlib.equation "guillemin1974differential"
  eq "MorseEulerCharacteristic" page "141" kind "theorem"
/-- Exercise 17: For a Morse function $f$ on a compact manifold $X$, the sum of the indices
at its critical points equals the Euler characteristic of $X$. -/
class MorseEulerCharacteristic
    (CritPoints : Type*) [Fintype CritPoints]
    (morseIndex : CritPoints → ℤ)
    (eulerChar : ℤ) where
  morse_sum_eq_euler : (∑ x : CritPoints, morseIndex x) = eulerChar

end Litlib.Y1974.guillemin1974differential
