-- FILENAME: Litlib/Y1991/smoller1991smooth/Signature.lean


import Litlib.Core
import Mathlib.Analysis.Calculus.Deriv.Basic
import Mathlib.Topology.Basic
import Mathlib.Topology.Order.Basic
import Mathlib.Topology.MetricSpace.Basic
import Mathlib.Order.Filter.Basic

namespace Litlib.Y1991.smoller1991smooth

Litlib.paper "smoller1991smooth"
  type "article"
  title "Smooth Static Solutions of the Einstein/Yang-Mills Equations"
  authors ["Smoller, Joel A.", "Wasserman, Arthur G.", "Yau, S.-T.", "McLeod, J. B."]
  journal "Communications in Mathematical Physics"
  volume "143"
  issue "1"
  pages "115--147"
  year "1991"
  publisher "Springer-Verlag"
  doi "10.1007/BF02100288"

Litlib.equation "smoller1991smooth"
  eq "3.6"
  page "119"
  kind "definition"
class Eq3_6 where
  /--
  Auxiliary Function Definition: Equation (3.6) (page 119).
  Defines Φ(w, A, r) = r(1 - A(r)) - (1 - w(r)^2)^2 / r.
  -/
  phiDef (w A Φ : ℝ → ℝ) : Prop

  phiDef_iff : ∀ w A Φ,
    phiDef w A Φ ↔ ∀ r > 0, Φ r = r * (1 - A r) - (1 - (w r)^2)^2 / r

Litlib.equation "smoller1991smooth"
  eq "2.6"
  page "118"
  kind "definition"
class Eq2_6 where
  /--
  Radial Einstein Equation for A(r): Equation (2.6) (page 118).
  r A' + (2 w'^2 + 1) A = 1 - (1 - w^2)^2 / r^2.
  -/
  einsteinODE (w A : ℝ → ℝ) : Prop

  einsteinODE_iff : ∀ w A,
    einsteinODE w A ↔
      DifferentiableOn ℝ A (Set.Ioi 0) ∧
      DifferentiableOn ℝ w (Set.Ioi 0) ∧
      ∀ r > 0, r * deriv A r + (2 * (deriv w r)^2 + 1) * A r = 1 - (1 - (w r)^2)^2 / r^2

Litlib.equation "smoller1991smooth"
  eq "2.7"
  page "118"
  kind "definition"
class Eq2_7 where
  /--
  Metric Lapse Equation for T(r): Equation (2.7) (page 118).
  2 r A (T'/T) = (1 - w^2)^2 / r^2 + (1 - 2 w'^2) A - 1.
  -/
  lapseODE (w A T : ℝ → ℝ) : Prop

  lapseODE_iff : ∀ w A T,
    lapseODE w A T ↔
      DifferentiableOn ℝ T (Set.Ioi 0) ∧
      DifferentiableOn ℝ w (Set.Ioi 0) ∧
      (∀ r > 0, T r > 0) ∧
      ∀ r > 0, 2 * r * A r * (deriv T r / T r) =
        (1 - (w r)^2)^2 / r^2 + (1 - 2 * (deriv w r)^2) * A r - 1

Litlib.equation "smoller1991smooth"
  eq "2.8"
  page "118"
  kind "definition"
class Eq2_8 where
  /--
  Yang-Mills Profile Equation for w(r): Equation (2.8) (page 118).
  r^2 A w'' + [r(1 - A) - (1 - w^2)^2 / r] w' + w(1 - w^2) = 0.
  -/
  yangMillsODE (w A : ℝ → ℝ) : Prop

  yangMillsODE_iff : ∀ w A,
    yangMillsODE w A ↔
      DifferentiableOn ℝ w (Set.Ioi 0) ∧
      DifferentiableOn ℝ (deriv w) (Set.Ioi 0) ∧
      ∀ r > 0, r^2 * A r * deriv (deriv w) r +
        (r * (1 - A r) - (1 - (w r)^2)^2 / r) * deriv w r +
        w r * (1 - (w r)^2) = 0

Litlib.equation "smoller1991smooth"
  eq "2.11"
  page "118"
  kind "definition"
class Eq2_11 where
  /--
  Regularity Boundary Conditions at the Origin: Equation (2.11) (page 118).
  w(0) = 1, w'(0) = 0, A(0) = 1.
  -/
  regularOrigin (w A : ℝ → ℝ) : Prop

  regularOrigin_iff : ∀ w A,
    regularOrigin w A ↔ w 0 = 1 ∧ deriv w 0 = 0 ∧ A 0 = 1

Litlib.equation "smoller1991smooth"
  eq "2.12"
  page "118"
  kind "definition"
class Eq2_12 where
  /--
  Shooting Parameter at the Origin: Equation (2.12) (page 118).
  w''(0) = -lambda, with lambda > 0.
  -/
  initialCurvature (w : ℝ → ℝ) (lambda : ℝ) : Prop

  initialCurvature_iff : ∀ w lambda,
    initialCurvature w lambda ↔ lambda > 0 ∧ deriv (deriv w) 0 = -lambda

Litlib.equation "smoller1991smooth"
  eq "2.13"
  page "119"
  kind "definition"
class Eq2_13 where
  /--
  Total Mass Function: Equation (2.13) (page 119).
  μ(r) = r(1 - A(r)).
  -/
  massFunction (A μ : ℝ → ℝ) : Prop

  massFunction_iff : ∀ A μ,
    massFunction A μ ↔ ∀ r > 0, μ r = r * (1 - A r)

Litlib.equation "smoller1991smooth"
  eq "2.14"
  page "119"
  kind "theorem"
class Eq2_14 where
  /--
  Mass Derivative Identity: Equation (2.14) (page 119).
  μ' = 2 A w'^2 + (1 - w^2)^2 / r^2 ≥ 0.
  -/
  massDerivative
    (w A μ : ℝ → ℝ)
    (hA_diff : DifferentiableOn ℝ A (Set.Ioi 0))
    (hw_diff : DifferentiableOn ℝ w (Set.Ioi 0))
    (hA_ode : ∀ r > 0, r * deriv A r + (2 * (deriv w r)^2 + 1) * A r =
      1 - (1 - (w r)^2)^2 / r^2)
    (hμ_def : ∀ r > 0, μ r = r * (1 - A r)) :
    ∀ r > 0, deriv μ r = 2 * A r * (deriv w r)^2 + (1 - (w r)^2)^2 / r^2

Litlib.equation "smoller1991smooth"
  eq "4.1"
  page "123"
  kind "theorem"
class Theorem4_1 where
  /--
  Singularity for Large Shooting Parameter: Theorem 4.1 (page 123).
  For lambda > 2, the solution develops a singularity in w > 0 and cannot reach w = 0.
  -/
  large_lambda_singularity
    (w A : ℝ → ℝ) (lambda : ℝ)
    (h_lambda : lambda > 2)
    (h_init : w 0 = 1 ∧ deriv w 0 = 0 ∧ deriv (deriv w) 0 = -lambda ∧ A 0 = 1) :
    ¬ ∃ r > 0, w r = 0 ∧ (∀ s ∈ Set.Ioo 0 r, A s > 0)

Litlib.equation "smoller1991smooth"
  eq "6.1"
  page "141"
  kind "theorem"
class Proposition6_1 where
  /--
  Connecting Orbit Existence: Proposition 6.1 and Section 5 (pages 125, 141).
  Guarantees the existence of a shooting parameter lambda_bar ∈ (0, 2) yielding a global
  connecting orbit connecting w(0) = 1 to w(∞) = -1, with A(r) > 0 (no event horizon)
  and w'(r) < 0 everywhere on (0, ∞).
  -/
  connecting_orbit_exists :
    ∃ (w A : ℝ → ℝ) (lambda_bar : ℝ),
      0 < lambda_bar ∧ lambda_bar < 2 ∧
      DifferentiableOn ℝ w (Set.Ici 0) ∧
      DifferentiableOn ℝ (deriv w) (Set.Ici 0) ∧
      DifferentiableOn ℝ A (Set.Ici 0) ∧
      w 0 = 1 ∧
      deriv w 0 = 0 ∧
      deriv (deriv w) 0 = -lambda_bar ∧
      A 0 = 1 ∧
      (∀ r > 0, r * deriv A r + (2 * (deriv w r)^2 + 1) * A r =
        1 - (1 - (w r)^2)^2 / r^2) ∧
      (∀ r > 0, r^2 * A r * deriv (deriv w) r +
        (r * (1 - A r) - (1 - (w r)^2)^2 / r) * deriv w r +
        w r * (1 - (w r)^2) = 0) ∧
      (∀ r ≥ 0, A r > 0) ∧
      (∀ r > 0, -1 < w r ∧ w r < 1) ∧
      (∀ r > 0, deriv w r < 0) ∧
      (∃ r0 > 0, w r0 = 0) ∧
      Filter.Tendsto w Filter.atTop (nhds (-1)) ∧
      Filter.Tendsto (deriv w) Filter.atTop (nhds 0) ∧
      Filter.Tendsto A Filter.atTop (nhds 1)

Litlib.equation "smoller1991smooth"
  eq "6.3"
  page "143"
  kind "theorem"
class Theorem6_3 where
  /--
  Asymptotically Minkowskian Metric: Theorem 6.3 (page 143).
  Given the connecting orbit (w, A), the lapse function T(r) can be normalized at r = 0
  such that T(r) → 1 as r → ∞, proving asymptotic flatness.
  -/
  asymptotically_flat_lapse
    (w A : ℝ → ℝ)
    (hA_pos : ∀ r ≥ 0, A r > 0)
    (hA_lim : Filter.Tendsto A Filter.atTop (nhds 1))
    (hw_lim : Filter.Tendsto w Filter.atTop (nhds (-1)))
    (hw_deriv_lim : Filter.Tendsto (deriv w) Filter.atTop (nhds 0)) :
    ∃ T : ℝ → ℝ,
      DifferentiableOn ℝ T (Set.Ici 0) ∧
      (∀ r ≥ 0, T r > 0) ∧
      (∀ r > 0, 2 * r * A r * (deriv T r / T r) =
        (1 - (w r)^2)^2 / r^2 + (1 - 2 * (deriv w r)^2) * A r - 1) ∧
      Filter.Tendsto T Filter.atTop (nhds 1)

Litlib.equation "smoller1991smooth"
  eq "6.4"
  page "143"
  kind "theorem"
class Corollary6_4 where
  /--
  Finite and Positive Total Mass: Corollary 6.4 (page 143).
  The ADM mass m = lim_{r → ∞} r(1 - A(r)) exists, is finite, and is strictly positive.
  -/
  total_mass_finite_positive
    (w A : ℝ → ℝ)
    (hA_pos : ∀ r ≥ 0, A r > 0)
    (hw_zero : w 0 = 1)
    (hw_lim : Filter.Tendsto w Filter.atTop (nhds (-1)))
    (hw_decr : ∀ r > 0, deriv w r < 0) :
    ∃ m : ℝ, m > 0 ∧ Filter.Tendsto (fun r ↦ r * (1 - A r)) Filter.atTop (nhds m)

Litlib.equation "smoller1991smooth"
  eq "main"
  page "116"
  kind "theorem"
class Theorem_Smoller1991Existence where
  /--
  Main Existence Theorem (Smoller, Wasserman, Yau, and McLeod 1991, Theorem 1.1).
  Rigorous analytical existence of a globally defined smooth static solution (w, A, T)
  to the SU(2) Einstein-Yang-Mills equations with finite, strictly positive total ADM mass M > 0.
  The solution is horizon-free (A(r) > 0 for all r ≥ 0) and non-trivial (w crosses zero at an
  interior radius r0 > 0, connecting w(0) = 1 to w(∞) = -1).
  -/
  soliton_exists :
    ∃ (w A T : ℝ → ℝ) (M : ℝ),
      DifferentiableOn ℝ w (Set.Ici 0) ∧
      DifferentiableOn ℝ (deriv w) (Set.Ici 0) ∧
      DifferentiableOn ℝ A (Set.Ici 0) ∧
      DifferentiableOn ℝ T (Set.Ici 0) ∧
      w 0 = 1 ∧
      deriv w 0 = 0 ∧
      A 0 = 1 ∧
      (∀ r ≥ 0, A r > 0) ∧
      (∀ r ≥ 0, T r > 0) ∧
      (∀ r > 0, -1 < w r ∧ w r < 1) ∧
      (∀ r > 0, deriv w r < 0) ∧
      (∃ r0 > 0, w r0 = 0) ∧
      (∀ r > 0, r * deriv A r + (2 * (deriv w r)^2 + 1) * A r =
        1 - (1 - (w r)^2)^2 / r^2) ∧
      (∀ r > 0, r^2 * A r * deriv (deriv w) r +
        (r * (1 - A r) - (1 - (w r)^2)^2 / r) * deriv w r +
        w r * (1 - (w r)^2) = 0) ∧
      (∀ r > 0, 2 * r * A r * (deriv T r / T r) =
        (1 - (w r)^2)^2 / r^2 + (1 - 2 * (deriv w r)^2) * A r - 1) ∧
      Filter.Tendsto w Filter.atTop (nhds (-1)) ∧
      Filter.Tendsto A Filter.atTop (nhds 1) ∧
      Filter.Tendsto T Filter.atTop (nhds 1) ∧
      Filter.Tendsto (fun r ↦ r * (1 - A r) / 2) Filter.atTop (nhds M) ∧
      M > 0

end Litlib.Y1991.smoller1991smooth
