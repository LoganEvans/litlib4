-- FILENAME: Litlib/Y1989/duck1989sense/Signature.lean


import Litlib.Core
import Mathlib.Data.Real.Basic
import Mathlib.Data.Complex.Basic
import Mathlib.Data.Matrix.Basic
import Mathlib.Analysis.SpecialFunctions.Exp
import Mathlib.Analysis.SpecialFunctions.Trigonometric.Basic
import Mathlib.Algebra.BigOperators.Group.Finset.Basic
import Mathlib.Algebra.BigOperators.Ring.Finset

namespace Litlib.Y1989.duck1989sense

noncomputable section

open scoped BigOperators Matrix
open Finset Matrix

Litlib.paper "duck1989sense"
  type "article"
  title
    "The sense in which a \"weak measurement\" of a spin-1/2 particle's spin component yields a value 100"
  authors ["Duck, I. M.", "Stevenson, P. M.", "Sudarshan, E. C. G."]
  journal "Physical Review D"
  volume "40"
  issue "6"
  pages "2112--2117"
  year "1989"

Litlib.equation "duck1989sense" eq "12" page "2113" kind "definition"
/-- The Aharonov-Albert-Vaidman weak value of an observable operator A on a finite-dimensional
state space, conditioned on pre-selection |ψ_in⟩ and post-selection |ψ_f⟩ with non-zero overlap:
A_w = ⟨ψ_f | A | ψ_in⟩ / ⟨ψ_f | ψ_in⟩. -/
class Eq12_WeakValueDefinition
    (dim : ℕ) [NeZero dim]
    (psiIn psiF : Fin dim → ℂ)
    (A : Matrix (Fin dim) (Fin dim) ℂ)
    (Aw : ℂ) where
  overlap_nonzero : (∑ i : Fin dim, star (psiF i) * psiIn i) ≠ 0
  weak_value_def :
    Aw = (∑ i : Fin dim, ∑ j : Fin dim, star (psiF i) * A i j * psiIn j) /
         (∑ i : Fin dim, star (psiF i) * psiIn i)

Litlib.equation "duck1989sense" eq "17" page "2113" kind "theorem"
/-- In the weak measurement regime (Δ ≪ 1 / |A_w|), the post-selected pointer wave function
in momentum/pointer space is a single broad Gaussian shifted by the weak value A_w:
Φ_f(p) ≈ ⟨ψ_f|ψ_in⟩ exp(-Δ² (p - A_w)²).
The physical pointer reading (mean value of p) is shifted by Re(A_w). -/
class Eq17_WeakPointerShift
    (delta : ℝ) (hdelta_pos : 0 < delta)
    (Aw : ℂ)
    (h_weak_regime : delta^2 * Complex.normSq Aw < 1)
    (pointerMeanShift : ℝ) where
  pointer_shift_def : pointerMeanShift = Aw.re

Litlib.equation "duck1989sense" eq "26" page "2114" kind "theorem"
/-- For a spin-1/2 particle with initial spin pointing in the xz plane at angle α to the x-axis,
and post-selected in the +1 eigenstate of σ_x, the weak value of the spin component λ σ_z is:
A_w = (λ σ_z)_w = λ tan(α / 2).
As α → π, tan(α / 2) → ∞, producing arbitrarily large pointer shifts far outside the eigenvalue
spectrum {+λ, -λ}. -/
class Eq26_SpinHalfWeakValue
    (alpha lambda : ℝ)
    (h_alpha_not_pi : Real.cos (alpha / 2) ≠ 0)
    (Aw : ℝ) where
  weak_value_spin_half : Aw = lambda * Real.tan (alpha / 2)

Litlib.equation "duck1989sense" eq "33" page "2115" kind "definition"
/-- The exact post-selected pointer wave function for spin-1/2 with α = π - 2ε, showing that
the large weak value shift arises from destructive interference between two Gaussians centered
at the eigenvalues p = +λ and p = -λ:
φ(p; ε, Δ, λ) = (1/2) [(1 + ε) exp(-Δ² (p - λ)²) - (1 - ε) exp(-Δ² (p + λ)²)]. -/
class Eq33_ExactInterferenceWaveFunction
    (epsilon delta lambda : ℝ)
    (phi : ℝ → ℝ) where
  wavefunction_def : ∀ p,
    phi p = (1 / 2 : ℝ) * (
      (1 + epsilon) * Real.exp (- delta^2 * (p - lambda)^2) -
      (1 - epsilon) * Real.exp (- delta^2 * (p + lambda)^2)
    )

Litlib.equation "duck1989sense" eq "35" page "2116" kind "theorem"
/-- Generalization to arbitrary pre-selection angle α and post-selection angle β in the xz plane:
The effective parameter ε = cos((α - β)/2) / sin((α + β)/2), giving weak value A_w = λ / ε.
When λ Δ ≪ min(ε, 1/ε), the final pointer distribution is centered at p = λ / ε = A_w. -/
class Eq35_GeneralAngleWeakPointerShift
    (alpha beta lambda delta : ℝ)
    (h_denom : Real.sin ((alpha + beta) / 2) ≠ 0)
    (epsilon Aw : ℝ)
    (PhiF : ℝ → ℝ) where
  epsilon_def :
    epsilon = Real.cos ((alpha - beta) / 2) / Real.sin ((alpha + beta) / 2)
  Aw_def :
    Aw = lambda / epsilon
  gaussian_approx : ∀ p,
    PhiF p = Real.cos ((alpha - beta) / 2) *
      Real.exp (- delta^2 * (p - lambda / epsilon)^2)

end

end Litlib.Y1989.duck1989sense
