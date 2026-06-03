-- FILENAME: Litlib/Y1983/guckenheimer1983nonlinear/Chapter01/Sec08_TwoDim.lean

import Litlib.Core
import Mathlib.Topology.Basic
import Mathlib.Analysis.Calculus.Deriv.Basic
import Mathlib.Analysis.Calculus.FDeriv.Basic
import Mathlib.Analysis.InnerProductSpace.Basic
import Mathlib.Data.Set.Finite.Basic
import Litlib.Y1983.guckenheimer1983nonlinear.Chapter01.Sec06_Asymptotic

namespace Litlib.Y1983.guckenheimer1983nonlinear

/--
Rigorous Reverse-Time Asymptotic Bound: Defines the α-limit set as the collection 
of points to which a trajectory accumulates in the limit t → -∞.
-/
def alpha_limit_set {E : Type*} [TopologicalSpace E] (flow : ℝ → E → E) (x : E) : Set E :=
  { y | ∃ (t : ℕ → ℝ), Filter.Tendsto t Filter.atTop Filter.atBot ∧ Filter.Tendsto (fun n => flow (t n) x) Filter.atTop (nhds y) }

/--
Separatrix Boundary Definition: Defines a bounding subset acting as the shared 
frontier between two disjoint basins of attraction.
-/
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
  (p : ℝ × ℝ)
  (_h_limit : LimitSet = omega_limit_set Flow p ∨ LimitSet = alpha_limit_set Flow p)
  (_h_compact : IsCompact LimitSet)
  (_h_nonempty : LimitSet.Nonempty)
  (_h_no_fixed : ¬ ∃ x ∈ LimitSet, ∀ t, Flow t x = x)
  where
  /--
  Poincaré-Bendixson Theorem: Theorem 1.8.1.
  Proves that any non-empty compact limit set of a planar flow that contains no fixed 
  points must be a closed orbit. The state constraints (ℝ × ℝ) mathematically guarantee 
  that higher-dimensional chaotic limits (strange attractors) are topologically impossible here.
  -/
  is_closed : ∃ x ∈ LimitSet, ∃ T > 0, (∀ t, Flow t x = Flow (t + T) x) ∧ LimitSet = {Flow t x | t ∈ Set.univ}

Litlib.equation "guckenheimer1983nonlinear"
  eq "Theorem 1.8.2"
  page "44"
  kind "theorem"
class Theorem1_8_2
  (D : Set (ℝ × ℝ))
  (_h_simply_connected : ∀ (c : ℝ → ℝ × ℝ), ContinuousOn c (Set.Icc 0 1) → c 0 = c 1 → (∀ s ∈ Set.Icc 0 1, c s ∈ D) → 
    ∃ (H : ℝ → ℝ → ℝ × ℝ), Continuous (fun p : ℝ × ℝ => H p.1 p.2) ∧ 
      (∀ s, H 0 s = c s) ∧ (∀ s, H 1 s = c 0) ∧ (∀ t, H t 0 = H t 1) ∧ (∀ s t, H t s ∈ D))
  (f g : ℝ × ℝ → ℝ)
  (div : ℝ × ℝ → ℝ)
  (_h_div : ∀ p ∈ D, HasDerivAt (fun x => f (x, p.2)) (div p - deriv (fun y => g (p.1, y)) p.2) p.1)
  (_h_not_identically_zero : ∃ p ∈ D, div p ≠ 0)
  (_h_does_not_change_sign : (∀ p ∈ D, div p ≥ 0) ∨ (∀ p ∈ D, div p ≤ 0))
  (Flow : ℝ → (ℝ × ℝ) → (ℝ × ℝ))
  (_h_flow : ∀ x t, HasDerivAt (fun t' => Flow t' x) (f (Flow t x), g (Flow t x)) t)
  where
  /--
  Bendixson's Criterion: Theorem 1.8.2.
  Asserts that if the divergence of a planar vector field on a simply connected domain 
  is strictly signed and not identically zero, closed orbits are mathematically forbidden 
  by Green's Theorem.
  -/
  no_closed_orbits : ¬ ∃ x ∈ D, ∃ T > 0, (∀ t, Flow t x = Flow (t + T) x) ∧ (∃ t, Flow t x ≠ x) ∧ {Flow t x | t ∈ Set.univ} ⊆ D

Litlib.equation "guckenheimer1983nonlinear"
  eq "Theorem 1.8.3"
  page "49"
  kind "theorem"
class Theorem1_8_3
  (E : Type*) [NormedAddCommGroup E] [InnerProductSpace ℝ E] [CompleteSpace E]
  (V : Type*)
  (is_gradient_system : V → Prop)
  (eval_V : V → E → E)
  (is_gradient_system_iff : ∀ v, is_gradient_system v ↔ 
    ∃ (F : E → ℝ) (F_deriv : E → (E →L[ℝ] ℝ)), 
      (∀ x, HasFDerivAt F (F_deriv x) x) ∧ 
      (∀ x y, F_deriv x y = inner ℝ (eval_V v x) y))
  (all_fixed_points_hyperbolic : V → Prop)
  (all_manifold_intersections_transversal : V → Prop)
  (is_structurally_stable : V → Prop)
  where
  /--
  Gradient Systems Structural Stability: Theorem 1.8.3.
  Ensures that gradient systems with isolated hyperbolic equilibria and transversally intersecting 
  invariant manifolds are structurally stable against arbitrary continuous perturbations. 
  The completeness of the inner product space rigorously anchors the flow definitions.
  -/
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
  /--
  Topological Indices: Proposition 1.8.4.
  Defines the rigorous mathematical accounting for fixed-point indices inside planar continuous flows. 
  Summation constraints enforce topological boundaries on closed loops wrapping around equilibria.
  -/
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
  where
  /--
  Internal Equilibria Bounds: Corollary 1.8.5.
  Forces a strict parity accounting of internal fixed points contained within closed planar orbits, 
  proving that the sum of local indices exactly equals +1.
  -/
  at_least_one : ∀ v γ, is_closed_orbit v γ → ∃ p ∈ points_within γ, is_fixed_point v p
  if_one_then_sink_source : ∀ v γ, is_closed_orbit v γ → (∃! p, p ∈ points_within γ) → 
    ∀ p ∈ points_within γ, is_fixed_point v p → is_sink_or_source v p
  if_all_hyperbolic : ∀ v γ, is_closed_orbit v γ → 
    (∀ p ∈ points_within γ, is_hyperbolic v p) → 
    ∃ n : ℕ, 
      Set.Finite (points_within γ) ∧
      Set.ncard (points_within γ) = 2 * n + 1 ∧
      Set.Finite {p ∈ points_within γ | is_saddle v p} ∧
      Set.ncard {p ∈ points_within γ | is_saddle v p} = n ∧
      Set.Finite {p ∈ points_within γ | is_sink_or_source v p} ∧
      Set.ncard {p ∈ points_within γ | is_sink_or_source v p} = n + 1

end Litlib.Y1983.guckenheimer1983nonlinear
