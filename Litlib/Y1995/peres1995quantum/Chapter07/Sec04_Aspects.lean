-- FILENAME: Litlib/Y1995/peres1995quantum/Chapter07/Sec04_Aspects.lean


import Litlib.Core
import Mathlib.Data.Real.Basic
import Mathlib.Data.Real.Sqrt
import Mathlib.Data.Complex.Basic
import Mathlib.Data.Matrix.Basic
import Mathlib.LinearAlgebra.Matrix.Trace
import Mathlib.Analysis.SpecialFunctions.Trigonometric.Basic
import Mathlib.Algebra.BigOperators.Group.Finset.Basic

namespace Litlib.Y1995.peres1995quantum

noncomputable section

open scoped BigOperators

Litlib.equation "peres1995quantum" eq "7.31" page "202" kind "definition"
/-- Real 2x2 projection operator P_θ = (1 + σ_x sin θ + σ_z cos θ)/2. -/
class Eq7_31_ProjectorTheta
    (θ : ℝ)
    (Pθ : Matrix (Fin 2) (Fin 2) ℝ) where
  pθ_def : ∀ i j, Pθ i j = match i.val, j.val with
    | 0, 0 => (1 + Real.cos θ) / 2
    | 0, 1 => Real.sin θ / 2
    | 1, 0 => Real.sin θ / 2
    | 1, 1 => (1 - Real.cos θ) / 2
    | _, _ => 0
  is_projector : Pθ * Pθ = Pθ ∧ Matrix.transpose Pθ = Pθ
  unit_trace : Matrix.trace Pθ = 1

Litlib.equation "peres1995quantum" eq "7.32" page "203" kind "theorem"
/-- Compatibility of bipartite tests: [ (1 + m · σ_1)/2, (1 + n · σ_2)/2 ] = 0. -/
class Eq7_32_BipartiteSpinCommutator
    (P1 P2 : Matrix (Fin 2 × Fin 2) (Fin 2 × Fin 2) ℂ) where
  commute : P1 * P2 = P2 * P1

Litlib.equation "peres1995quantum" eq "7.33" page "203" kind "theorem"
/-- Compatibility of spin 1 projectors for orthogonal vectors:
[ 1 - (m · J)^2, 1 - (n · J)^2 ] = 0 when m · n = 0. -/
class Eq7_33_OrthogonalSpinOneProjectorsCommute
    (Pm Pn : Matrix (Fin 3) (Fin 3) ℂ)
    (m n : Fin 3 → ℝ)
    (hm : (∑ r, m r * m r) = 1)
    (hn : (∑ r, n r * n r) = 1)
    (h_ortho : (∑ r, m r * n r) = 0) where
  commute : Pm * Pn = Pn * Pm

Litlib.equation "peres1995quantum" eq "7.34" page "204" kind "theorem"
/-- Non-transitivity of compatibility for spin 1 observables:
[A, B] = 0 and [A, C] = 0, but [B, C] ≠ 0. -/
class Eq7_34_SpinOneNonTransitiveCompatibility
    (A B C : Matrix (Fin 3) (Fin 3) ℂ) where
  comm_ab : A * B = B * A
  comm_ac : A * C = C * A
  not_comm_bc : B * C ≠ C * B

Litlib.equation "peres1995quantum" eq "7.35" page "204" kind "theorem"
/-- Non-transitivity of compatibility for two spin-1/2 observables:
[A, B] = [A, C] = 0, but [B, C] ≠ 0. -/
class Eq7_35_TwoSpinNonTransitiveCompatibility
    (A B C : Matrix (Fin 2 × Fin 2) (Fin 2 × Fin 2) ℂ) where
  comm_ab : A * B = B * A
  comm_ac : A * C = C * A
  not_comm_bc : B * C ≠ C * B

Litlib.equation "peres1995quantum" eq "7.36" page "204" kind "theorem"
/-- Projector resolution of the identity for an orthogonal triad: P_m + P_n + P_r = 1. -/
class Eq7_36_TriadProjectorSum
    (Pm Pn Pr : Matrix (Fin 3) (Fin 3) ℂ) where
  sum_identity : Pm + Pn + Pr = 1

Litlib.equation "peres1995quantum" eq "7.37" page "204" kind "theorem"
/-- Outcome constraint for predictable triad tests: p_m + p_n + p_r = 1. -/
class Eq7_37_TriadOutcomeSum
    (pm pn pr : ℕ) where
  pm_binary : pm = 0 ∨ pm = 1
  pn_binary : pn = 0 ∨ pn = 1
  pr_binary : pr = 0 ∨ pr = 1
  sum_is_one : pm + pn + pr = 1

Litlib.equation "peres1995quantum" eq "7.38" page "205" kind "theorem"
/-- Dispersion-free sum of outcomes for a complete set of orthogonal projectors. -/
class Eq7_38_DispersionFreeSum
    (d N : ℕ)
    (P : Fin N → Matrix (Fin d) (Fin d) ℂ)
    (expVal : Matrix (Fin d) (Fin d) ℂ → ℝ)
    (h_ortho : ∀ i j, P i * P j = if i = j then P i else 0)
    (h_sum : (∑ i, P i) = 1) where
  variance_zero :
    expVal ((∑ i, P i) * (∑ i, P i)) - (expVal (∑ i, P i)) ^ 2 = 0

Litlib.equation "peres1995quantum" eq "7.39" page "205" kind "theorem"
/-- Spin correlation in the singlet state: ⟨p_{1α} p_{2β}⟩ = (1 - α · β)/4. -/
class Eq7_39_SingletCorrelationBeta
    (α β : Fin 3 → ℝ)
    (hα : (∑ k, α k * α k) = 1)
    (hβ : (∑ k, β k * β k) = 1)
    (corr : ℝ) where
  corr_eq : corr = (1 - ∑ k, α k * β k) / 4

Litlib.equation "peres1995quantum" eq "7.40" page "206" kind "theorem"
/-- Spin correlation in the singlet state: ⟨p_{1α} p_{2δ}⟩ = (1 - α · δ)/4. -/
class Eq7_40_SingletCorrelationDelta
    (α δ : Fin 3 → ℝ)
    (hα : (∑ k, α k * α k) = 1)
    (hδ : (∑ k, δ k * δ k) = 1)
    (corr : ℝ) where
  corr_eq : corr = (1 - ∑ k, α k * δ k) / 4

Litlib.equation "peres1995quantum" eq "7.41" page "207" kind "theorem"
/-- Triad constraint in context 1: p_m + p_n + p_r = 1. -/
class Eq7_41_Context1TriadSum
    (pm pn pr : ℕ)
    (hpm : pm = 0 ∨ pm = 1)
    (hpn : pn = 0 ∨ pn = 1)
    (hpr : pr = 0 ∨ pr = 1) where
  sum_one : pm + pn + pr = 1

Litlib.equation "peres1995quantum" eq "7.42" page "207" kind "theorem"
/-- Triad constraint in context 2: p_m + p_s + p_t = 1. -/
class Eq7_42_Context2TriadSum
    (pm ps pt : ℕ)
    (hpm : pm = 0 ∨ pm = 1)
    (hps : ps = 0 ∨ ps = 1)
    (hpt : pt = 0 ∨ pt = 1) where
  sum_one : pm + ps + pt = 1

Litlib.equation "peres1995quantum" eq "7.43" page "207" kind "theorem"
/-- Single-shot Clauser-Horne / Bell quantity for binary outcomes is always 0 or 1. -/
class Eq7_43_ClauserHorneIdentity
    (p1α p1γ p2β p2δ : ℝ)
    (h1α : p1α = 0 ∨ p1α = 1)
    (h1γ : p1γ = 0 ∨ p1γ = 1)
    (h2β : p2β = 0 ∨ p2β = 1)
    (h2δ : p2δ = 0 ∨ p2δ = 1) where
  algebraic_bound :
    let val := p1γ + p2β + p1α * p2δ - p1α * p2β - p1γ * p2β - p1γ * p2δ
    val = 0 ∨ val = 1

Litlib.equation "peres1995quantum" eq "7.44" page "207" kind "theorem"
/-- Quantum violation of the Clauser-Horne inequality in the singlet state:
1/2 + 1/2 + 1/4 (1 + 1/√2) - 3/4 (1 - 1/√2) = 1/2 + 1/√2 > 1. -/
class Eq7_44_SingletViolationCH
    (val : ℝ) where
  quantum_expectation :
    val = (1 : ℝ) / 2 + (1 : ℝ) / 2 +
          (1 : ℝ) / 4 * (1 + 1 / Real.sqrt 2) -
          (3 : ℝ) / 4 * (1 - 1 / Real.sqrt 2)
  simplified_value : val = 1 / 2 + 1 / Real.sqrt 2
  strictly_greater_than_one : 1 < val

Litlib.equation "peres1995quantum" eq "7.45" page "212" kind "theorem"
/-- Penrose spin-3/2 orthogonality condition: eigenvectors with eigenvalue 1/2
along unit vectors m and n are orthogonal if m · n = 1/3. -/
class Eq7_45_PenroseSpinThreeHalves
    (m n : Fin 3 → ℝ)
    (hm : (∑ k, m k * m k) = 1)
    (hn : (∑ k, n k * n k) = 1)
    (h_dot : (∑ k, m k * n k) = 1 / 3)
    (mDotJ nDotJ : Matrix (Fin 4) (Fin 4) ℂ)
    (ψ φ : Fin 4 → ℂ)
    (hψ : Matrix.mulVec mDotJ ψ = (1 / 2 : ℂ) • ψ)
    (hφ : Matrix.mulVec nDotJ φ = (1 / 2 : ℂ) • φ)
    (hψ_ne : ψ ≠ 0)
    (hφ_ne : φ ≠ 0) where
  orthogonal_states : ∑ k, star (ψ k) * φ k = 0

end

end Litlib.Y1995.peres1995quantum
