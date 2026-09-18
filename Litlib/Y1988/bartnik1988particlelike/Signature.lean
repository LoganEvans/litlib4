-- FILENAME: Litlib/Y1988/bartnik1988particlelike/Signature.lean

import Mathlib.Analysis.Calculus.Deriv.Basic
import Mathlib.Analysis.SpecialFunctions.Pow.Real
import Mathlib.Analysis.SpecialFunctions.Trigonometric.Basic
import Mathlib.Topology.MetricSpace.Basic
import Litlib.Core

open BigOperators

namespace Litlib.Y1988.bartnik1988particlelike

Litlib.paper "bartnik1988particlelike"
  type "article"
  title "Particlelike Solutions of the Einstein-Yang-Mills Equations"
  authors ["Bartnik, Robert", "McKinnon, John"]
  journal "Physical Review Letters"
  year "1988"

-- Spherically symmetric static metric ansatz (Eq. 2, p. 141):
-- ds² = -T(r)⁻² dt² + R(r)² dr² + r² (dθ² + sin²θ dφ²)
Litlib.equation "bartnik1988particlelike" eq "2" page "141" kind "definition"
class Eq2 (T R : ℝ → ℝ) (m : ℝ → ℝ) where
  metric_R : ∀ r > 0, R r = (1 - 2 * m r / r) ^ (-(1 : ℝ) / 2)
  R_pos : ∀ r > 0, R r > 0
  T_pos : ∀ r > 0, T r > 0
  metric_tensor : ℝ → ℝ → (Fin 4 → Fin 4 → ℝ)
  metric_tensor_def : ∀ (r θ : ℝ), r > 0 → 0 < θ → θ < Real.pi →
    metric_tensor r θ = fun i j ↦
      if i = j then
        match i with
        | 0 => -(1 / (T r) ^ 2)
        | 1 => (R r) ^ 2
        | 2 => r ^ 2
        | 3 => r ^ 2 * (Real.sin θ) ^ 2
      else 0
  metric_inv : ℝ → ℝ → (Fin 4 → Fin 4 → ℝ)
  metric_inv_def : ∀ (r θ : ℝ), r > 0 → 0 < θ → θ < Real.pi →
    ∀ i k : Fin 4, (∑ j : Fin 4, metric_tensor r θ i j * metric_inv r θ j k) =
      if i = k then 1 else 0

-- First reduced EYM equation for the mass function m(r) (Eq. 3, p. 142)
Litlib.equation "bartnik1988particlelike" eq "3" page "142" kind "definition"
class Eq3 (m w : ℝ → ℝ) where
  m_diff : DifferentiableOn ℝ m (Set.Ioi 0)
  w_diff : DifferentiableOn ℝ w (Set.Ioi 0)
  m_eq : ∀ r > 0, deriv m r =
    (1 - 2 * m r / r) * (deriv w r) ^ 2 + (1 - (w r) ^ 2) ^ 2 / (2 * r ^ 2)

-- Second reduced EYM equation for the gauge field amplitude w(r) (Eq. 4, p. 142)
Litlib.equation "bartnik1988particlelike" eq "4" page "142" kind "definition"
class Eq4 (m w : ℝ → ℝ) where
  w_diff : DifferentiableOn ℝ w (Set.Ioi 0)
  w_diff2 : DifferentiableOn ℝ (deriv w) (Set.Ioi 0)
  w_eq : ∀ r > 0,
    r ^ 2 * (1 - 2 * m r / r) * deriv (deriv w) r +
      (2 * m r - (1 - (w r) ^ 2) ^ 2 / r) * deriv w r +
      (1 - (w r) ^ 2) * w r = 0

-- Supplementary Einstein equation for the lapse function T(r) (Eq. 5, p. 142)
Litlib.equation "bartnik1988particlelike" eq "5" page "142" kind "definition"
class Eq5 (m w T : ℝ → ℝ) where
  T_diff : DifferentiableOn ℝ T (Set.Ioi 0)
  T_pos : ∀ r > 0, T r > 0
  T_eq : ∀ r > 0,
    2 * r * (1 - 2 * m r / r) * (deriv T r / T r) =
      (1 - (w r) ^ 2) ^ 2 / r - 2 * (1 - 2 * m r / r) * (deriv w r) ^ 2 - 2 * m r / r

-- Yang-Mills magnetic curvature components (Eq. 6 and text, p. 142)
Litlib.equation "bartnik1988particlelike" eq "6" page "142" kind "definition"
class Eq6 (w R : ℝ → ℝ) (BL BT : ℝ → ℝ) where
  radial_curvature : ∀ r > 0, BL r = (1 - (w r) ^ 2) / (r ^ 2)
  angular_curvature : ∀ r > 0, BT r = deriv w r / (r * R r)

-- Local energy density T₀₀ of the Yang-Mills field (Eq. 7, p. 142)
Litlib.equation "bartnik1988particlelike" eq "7" page "142" kind "definition"
class Eq7 (m BL BT : ℝ → ℝ) (T00 : ℝ → ℝ) where
  density_eq : ∀ r > 0, 4 * Real.pi * T00 r = (BT r) ^ 2 + (1 / 2) * (BL r) ^ 2
  density_mass : ∀ r > 0, 4 * Real.pi * T00 r = deriv m r / (r ^ 2)

-- Boundary conditions for globally regular, horizon-free solutions at r = 0
-- and asymptotic flatness at r → ∞ (Eqs. 8-9 and text, p. 142)
Litlib.equation "bartnik1988particlelike" eq "8_9" page "142" kind "definition"
class BoundaryConditions (m w T : ℝ → ℝ) (M : ℝ) where
  origin_m : Filter.Tendsto (fun r ↦ m r / r ^ 2) (nhdsWithin 0 (Set.Ioi 0)) (nhds 0)
  origin_w : Filter.Tendsto w (nhdsWithin 0 (Set.Ioi 0)) (nhds 1)
  origin_w_deriv : Filter.Tendsto (deriv w) (nhdsWithin 0 (Set.Ioi 0)) (nhds 0)
  origin_T_deriv : Filter.Tendsto (deriv T) (nhdsWithin 0 (Set.Ioi 0)) (nhds 0)
  no_horizon : ∀ r > 0, 1 - 2 * m r / r > 0
  asymptotic_m : Filter.Tendsto m Filter.atTop (nhds M)
  asymptotic_w : Filter.Tendsto (fun r ↦ |w r|) Filter.atTop (nhds 1)
  asymptotic_T : Filter.Tendsto T Filter.atTop (nhds 1)
  positive_mass : M > 0

-- The complete static spherically symmetric Einstein-Yang-Mills system
structure BartnikMcKinnonSystem (m w T R BL BT T00 : ℝ → ℝ) (M : ℝ) where
  eq2 : Eq2 T R m
  eq3 : Eq3 m w
  eq4 : Eq4 m w
  eq5 : Eq5 m w T
  eq6 : Eq6 w R BL BT
  eq7 : Eq7 m BL BT T00
  boundaryConditions : BoundaryConditions m w T M
