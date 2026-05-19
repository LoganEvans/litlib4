-- FILENAME: Litlib/Y1983/guckenheimer1983nonlinear/Chapter01/Sec08_TwoDim.lean

import Litlib.Core
import Mathlib.Topology.Basic
import Mathlib.Analysis.Calculus.Deriv.Basic
import Litlib.Y1983.guckenheimer1983nonlinear.Chapter01.Sec06_Asymptotic

namespace Litlib.Y1983.guckenheimer1983nonlinear

def is_separatrix {E : Type*} [TopologicalSpace E] (flow : ℝ → E → E) (S A B : Set E) : Prop :=
  S ⊆ frontier (basin_of_attraction flow A) ∧ 
  S ⊆ frontier (basin_of_attraction flow B) ∧ 
  A ≠ B

Litlib.equation "guckenheimer1983nonlinear"
  eq "Theorem 1.8.1"
  page "44"
  kind "theorem"
class Theorem1_8_1
  (Flow : ℝ → (ℝ × ℝ) → (ℝ × ℝ))
  (LimitSet : Set (ℝ × ℝ))
  (is_omega_or_alpha_limit_set : Set (ℝ × ℝ) → Prop)
  (is_closed_orbit : Set (ℝ × ℝ) → Prop)
  (has_fixed_points : Set (ℝ × ℝ) → Prop)
  (_h_limit : is_omega_or_alpha_limit_set LimitSet)
  (_h_compact : IsCompact LimitSet)
  (_h_nonempty : LimitSet.Nonempty)
  (_h_no_fixed : ¬ has_fixed_points LimitSet)
  where
  is_closed : is_closed_orbit LimitSet

Litlib.equation "guckenheimer1983nonlinear"
  eq "Theorem 1.8.2"
  page "44"
  kind "theorem"
class Theorem1_8_2
  (D : Set (ℝ × ℝ))
  (is_simply_connected : Set (ℝ × ℝ) → Prop)
  (_h_simply_connected : is_simply_connected D)
  (f g : ℝ × ℝ → ℝ)
  (div : ℝ × ℝ → ℝ)
  (_h_div : ∀ p, div p = (deriv (fun x => f (x, p.2)) p.1) + (deriv (fun y => g (p.1, y)) p.2))
  (_h_not_identically_zero : ∃ p ∈ D, div p ≠ 0)
  (_h_does_not_change_sign : (∀ p ∈ D, div p ≥ 0) ∨ (∀ p ∈ D, div p ≤ 0))
  (has_closed_orbit_in : Set (ℝ × ℝ) → Prop)
  where
  no_closed_orbits : ¬ has_closed_orbit_in D

Litlib.equation "guckenheimer1983nonlinear"
  eq "Theorem 1.8.3"
  page "49"
  kind "theorem"
class Theorem1_8_3
  (V : Type*)
  (is_gradient_system : V → Prop)
  (all_fixed_points_hyperbolic : V → Prop)
  (all_manifold_intersections_transversal : V → Prop)
  (is_structurally_stable : V → Prop)
  where
  gradient_structural_stability : ∀ v : V,
    is_gradient_system v → 
    all_fixed_points_hyperbolic v → 
    all_manifold_intersections_transversal v → 
    is_structurally_stable v

Litlib.equation "guckenheimer1983nonlinear"
  eq "Proposition 1.8.4"
  page "51"
  kind "proposition"
class Proposition1_8_4
  (V : Type*)
  (Point : Type*)
  (Curve : Type*)
  (index_pt : V → Point → ℤ)
  (index_curve : V → Curve → ℤ)
  (is_sink_source_center : V → Point → Prop)
  (is_hyperbolic_saddle : V → Point → Prop)
  (is_closed_orbit : V → Curve → Prop)
  (contains_no_fixed_points : V → Curve → Prop)
  (points_within : Curve → Set Point)
  where
  index_sink_source_center : ∀ v p, is_sink_source_center v p → index_pt v p = 1
  index_hyperbolic_saddle : ∀ v p, is_hyperbolic_saddle v p → index_pt v p = -1
  index_closed_orbit : ∀ v c, is_closed_orbit v c → index_curve v c = 1
  index_empty_curve : ∀ v c, contains_no_fixed_points v c → index_curve v c = 0
  sum_of_indices : (V → Set Point → ℤ)
  index_sum_theorem : ∀ v c, index_curve v c = sum_of_indices v (points_within c)

Litlib.equation "guckenheimer1983nonlinear"
  eq "Corollary 1.8.5"
  page "51"
  kind "corollary"
class Corollary1_8_5
  (V : Type*)
  (Curve : Type*)
  (Point : Type*)
  (is_closed_orbit : V → Curve → Prop)
  (points_within : Curve → Set Point)
  (is_fixed_point : V → Point → Prop)
  (is_sink_or_source : V → Point → Prop)
  (is_hyperbolic : V → Point → Prop)
  (is_saddle : V → Point → Prop)
  (count_set : Set Point → ℕ)
  where
  at_least_one : ∀ v γ, is_closed_orbit v γ → ∃ p ∈ points_within γ, is_fixed_point v p
  if_one_then_sink_source : ∀ v γ, is_closed_orbit v γ → count_set (points_within γ) = 1 → 
    ∀ p ∈ points_within γ, is_fixed_point v p → is_sink_or_source v p
  if_all_hyperbolic : ∀ v γ, is_closed_orbit v γ → 
    (∀ p ∈ points_within γ, is_hyperbolic v p) → 
    ∃ n : ℕ, 
      count_set (points_within γ) = 2 * n + 1 ∧
      count_set {p ∈ points_within γ | is_saddle v p} = n ∧
      count_set {p ∈ points_within γ | is_sink_or_source v p} = n + 1

end Litlib.Y1983.guckenheimer1983nonlinear
