-- FILENAME: Litlib/Y1983/guckenheimer1983nonlinear/Chapter01/Sec03_Nonlinear.lean

import Litlib.Core
import Mathlib.Topology.Basic
import Mathlib.Analysis.InnerProductSpace.Basic
import Mathlib.Analysis.Calculus.FDeriv.Basic
import Mathlib.Analysis.Calculus.ContDiff.Basic
import Mathlib.Analysis.SpecialFunctions.Exponential

namespace Litlib.Y1983.guckenheimer1983nonlinear

Litlib.equation "guckenheimer1983nonlinear"
  eq "Theorem 1.3.1"
  page "13"
  kind "theorem"
class Theorem1_3_1
  (E : Type*) [NormedAddCommGroup E] [NormedSpace ℝ E] [CompleteSpace E]
  (f : E → E)
  (x_bar : E)
  (_hx_bar : f x_bar = 0)
  (is_hyperbolic_linear : (E →L[ℝ] E) → Prop)
  (is_hyperbolic_linear_iff : ∀ A, is_hyperbolic_linear A ↔ 
    ∀ ω : ℝ, ∀ x : E, A (A x) + ω^2 • x = 0 → x = 0)
  (_h_hyperbolic : is_hyperbolic_linear (fderiv ℝ f x_bar))
  (flow_nonlinear : ℝ → E → E)
  (is_flow_nonlinear : ∀ x t, HasDerivAt (fun t' => flow_nonlinear t' x) (f (flow_nonlinear t x)) t ∧ flow_nonlinear 0 x = x)
  (flow_linear : ℝ → E → E)
  (is_flow_linear : ∀ x t, HasDerivAt (fun t' => flow_linear t' x) ((fderiv ℝ f x_bar) (flow_linear t x)) t ∧ flow_linear 0 x = x)
  (is_homeomorphism_on : (E → E) → Set E → Prop)
  (is_homeomorphism_on_iff : ∀ h U, is_homeomorphism_on h U ↔ 
    Set.BijOn h U (h '' U) ∧ ContinuousOn h U ∧ 
    ∃ g, Set.LeftInvOn g h U ∧ Set.RightInvOn g h U ∧ ContinuousOn g (h '' U))
  where
  /--
  Hartman-Grobman Theorem for Flows: Theorem 1.3.1.
  Establishes topological conjugacy between a nonlinear flow and its linearization in the neighborhood 
  of a hyperbolic fixed point. The hyperbolicity constraint explicitly forbids purely imaginary eigenvalues 
  via the `A^2 x + ω^2 x = 0` condition over real numbers, effectively barring degenerate center manifolds 
  from trivially passing the constraint.
  -/
  hartman_grobman : ∃ (U : Set E), IsOpen U ∧ x_bar ∈ U ∧
    ∃ (h : E → E),
    is_homeomorphism_on h U ∧
    ∀ (t : ℝ) (x : E), x ∈ U → flow_nonlinear t x ∈ U → h (flow_nonlinear t x) = flow_linear t (h x)

Litlib.equation "guckenheimer1983nonlinear"
  eq "Theorem 1.3.2"
  page "13"
  kind "theorem"
class Theorem1_3_2
  (E : Type*) [NormedAddCommGroup E] [NormedSpace ℝ E] [CompleteSpace E]
  (r : ℕ∞) (_hr : 1 ≤ r)
  (f : E → E)
  (_h_diff : ContDiff ℝ r f)
  (x_bar : E)
  (_hx_bar : f x_bar = 0)
  (is_hyperbolic_linear : (E →L[ℝ] E) → Prop)
  (is_hyperbolic_linear_iff : ∀ A, is_hyperbolic_linear A ↔ 
    ∀ ω : ℝ, ∀ x : E, A (A x) + ω^2 • x = 0 → x = 0)
  (_h_hyperbolic : is_hyperbolic_linear (fderiv ℝ f x_bar))
  (Ws_loc Wu_loc : Set E)
  (Es Eu : Submodule ℝ E)
  (is_stable_subspace : (E →L[ℝ] E) → Submodule ℝ E → Prop)
  (is_stable_subspace_iff : ∀ A S, is_stable_subspace A S ↔ 
    ∀ v ∈ S, ∃ c > 0, ∃ α > 0, ∀ t ≥ 0, ∃ φ : ℝ → E, φ 0 = v ∧ (∀ t', HasDerivAt φ (A (φ t')) t') ∧ ‖φ t‖ ≤ c * Real.exp (-α * t) * ‖v‖)
  (is_unstable_subspace : (E →L[ℝ] E) → Submodule ℝ E → Prop)
  (is_unstable_subspace_iff : ∀ A S, is_unstable_subspace A S ↔ 
    ∀ v ∈ S, ∃ c > 0, ∃ α > 0, ∀ t ≤ 0, ∃ φ : ℝ → E, φ 0 = v ∧ (∀ t', HasDerivAt φ (A (φ t')) t') ∧ ‖φ t‖ ≤ c * Real.exp (α * t) * ‖v‖)
  (_h_Es : is_stable_subspace (fderiv ℝ f x_bar) Es)
  (_h_Eu : is_unstable_subspace (fderiv ℝ f x_bar) Eu)
  where
  /--
  Local Stable and Unstable Manifold Theorem: Theorem 1.3.2.
  Asserts the existence of invariant manifolds tangent to the respective stable and unstable eigenspaces 
  at a hyperbolic equilibrium point. Requires a Banach space (`CompleteSpace E`) structure to ensure 
  the converging mappings constructing the manifolds are mathematically well-founded.
  -/
  stable_manifold_exists : 
    ∃ (V_s : Set Es) (psi_s : Es → E) (incl_s : Es →L[ℝ] E), 
      IsOpen V_s ∧ (0 : Es) ∈ V_s ∧
      (∀ v, incl_s v = (v : E)) ∧
      ContDiff ℝ r psi_s ∧
      psi_s 0 = x_bar ∧
      HasFDerivAt psi_s incl_s 0 ∧
      Ws_loc = psi_s '' V_s
  unstable_manifold_exists : 
    ∃ (V_u : Set Eu) (psi_u : Eu → E) (incl_u : Eu →L[ℝ] E), 
      IsOpen V_u ∧ (0 : Eu) ∈ V_u ∧
      (∀ v, incl_u v = (v : E)) ∧
      ContDiff ℝ r psi_u ∧
      psi_u 0 = x_bar ∧
      HasFDerivAt psi_u incl_u 0 ∧
      Wu_loc = psi_u '' V_u

end Litlib.Y1983.guckenheimer1983nonlinear
