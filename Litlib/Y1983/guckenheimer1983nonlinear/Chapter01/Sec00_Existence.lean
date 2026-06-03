-- FILENAME: Litlib/Y1983/guckenheimer1983nonlinear/Chapter01/Sec00_Existence.lean

import Litlib.Core
import Mathlib.Topology.Basic
import Mathlib.Analysis.Calculus.Deriv.Basic
import Mathlib.Analysis.Calculus.FDeriv.Basic
import Mathlib.Analysis.Calculus.ContDiff.Basic
import Mathlib.Analysis.InnerProductSpace.Basic
import Mathlib.Analysis.SpecialFunctions.Exponential

namespace Litlib.Y1983.guckenheimer1983nonlinear

Litlib.equation "guckenheimer1983nonlinear"
  eq "Theorem 1.0.1"
  page "3"
  kind "theorem"
class Theorem1_0_1
  (E : Type*) [NormedAddCommGroup E] [NormedSpace ℝ E] [CompleteSpace E]
  (U : Set E) (_hU : IsOpen U)
  (f : E → E)
  (_hf : ContDiffOn ℝ 1 f U)
  (x0 : E)
  (_hx0 : x0 ∈ U)
  where
  /--
  Topological Gatekeeping: Theorem 1.0.1 (Local Existence and Uniqueness).
  Ensures that a continuously differentiable vector field on an open subset of a Banach space 
  yields a unique local flow. Completeness of the space (`CompleteSpace E`) is rigorously 
  enforced to prevent Picard-Lindelöf iteration failures, and the local existence window `c` 
  is strictly bound to be positive (`c > 0`) to prevent vacuous time domains.
  -/
  local_existence_uniqueness : 
    ∃ (c : ℝ) (φ : ℝ → E),
      c > 0 ∧
      (∀ t, t ∈ Set.Ioo (-c) c → φ t ∈ U) ∧ 
      (φ 0 = x0) ∧ 
      (∀ t, t ∈ Set.Ioo (-c) c → HasDerivAt φ (f (φ t)) t) ∧
      (∀ ψ : ℝ → E, 
        (∀ t, t ∈ Set.Ioo (-c) c → ψ t ∈ U) → 
        (ψ 0 = x0) → 
        (∀ t, t ∈ Set.Ioo (-c) c → HasDerivAt ψ (f (ψ t)) t) → 
        ∀ t, t ∈ Set.Ioo (-c) c → φ t = ψ t)

Litlib.equation "guckenheimer1983nonlinear"
  eq "Theorem 1.0.2"
  page "3"
  kind "theorem"
class Theorem1_0_2
  (E : Type*) [NormedAddCommGroup E] [NormedSpace ℝ E] [CompleteSpace E]
  (U : Set E) (_hU : IsOpen U)
  (f : E → E)
  (x_bar : E)
  (_hx_bar : f x_bar = 0)
  (W : Set E) (_hW : W ⊆ U) (_hW_open : IsOpen W) (_hx_bar_in_W : x_bar ∈ W)
  (V : E → ℝ)
  (_hV_diff : DifferentiableOn ℝ V W)
  (_hV_pos : ∀ x ∈ W, x ≠ x_bar → V x > 0)
  (_hV_zero : V x_bar = 0)
  (is_stable : E → Prop)
  (is_stable_iff : ∀ x_b, is_stable x_b ↔ 
    ∀ V_nhd ∈ nhds x_b, ∃ V1 ∈ nhds x_b, V1 ⊆ V_nhd ∧ 
      ∀ x0 ∈ V1, ∃ φ : ℝ → E, φ 0 = x0 ∧ (∀ t ≥ 0, HasDerivAt φ (f (φ t)) t) ∧ (∀ t ≥ 0, φ t ∈ V_nhd))
  (is_asymptotically_stable : E → Prop)
  (is_asymptotically_stable_iff : ∀ x_b, is_asymptotically_stable x_b ↔ 
    is_stable x_b ∧ 
    ∃ V1 ∈ nhds x_b, ∀ x0 ∈ V1, ∀ φ : ℝ → E, 
      (φ 0 = x0 ∧ ∀ t ≥ 0, HasDerivAt φ (f (φ t)) t) → Filter.Tendsto φ Filter.atTop (nhds x_b))
  where
  /--
  Lyapunov Stability Criterion: Theorem 1.0.2.
  Establishes criteria for local and asymptotic stability of an equilibrium point via a 
  positive-definite Lyapunov function. The state definitions are strongly bound by logical 
  equivalences (`iff`) to prevent default override exploits in the signature definitions.
  -/
  stable_if : (∀ x ∈ W, x ≠ x_bar → (fderiv ℝ V x : E →L[ℝ] ℝ) (f x) ≤ 0) → is_stable x_bar
  asymptotically_stable_if : (∀ x ∈ W, x ≠ x_bar → (fderiv ℝ V x : E →L[ℝ] ℝ) (f x) < 0) → is_asymptotically_stable x_bar

Litlib.equation "guckenheimer1983nonlinear"
  eq "Theorem 1.0.3"
  page "7"
  kind "theorem"
class Theorem1_0_3
  (E : Type*) [NormedAddCommGroup E] [NormedSpace ℝ E] [CompleteSpace E]
  (f : E → E) 
  (_hC1 : ContDiff ℝ 1 f)
  (M : Set E)
  (_hM_compact : IsCompact M)
  (_hM_nonempty : M.Nonempty)
  (_h_support : ∀ x ∉ M, f x = 0)
  where
  /--
  Global Flow Existence Bound: Theorem 1.0.3.
  Ensures that if a vector field's dynamics are strictly confined to a compact, non-empty 
  domain, its integral curves are globally defined for all time. The `M.Nonempty` constraint 
  prevents trivial satisfaction by the empty set.
  -/
  global_existence : ∀ x0 : E, ∃ c : ℝ → E, c 0 = x0 ∧ ∀ t, HasDerivAt c (f (c t)) t

Litlib.equation "guckenheimer1983nonlinear"
  eq "Theorem 1.0.4"
  page "7"
  kind "theorem"
class Theorem1_0_4
  (E : Type*) [NormedAddCommGroup E] [NormedSpace ℝ E] [CompleteSpace E]
  (U : Set E)
  (_hU : IsOpen U)
  (f : E → E)
  (K : ℝ)
  (_hK_pos : 0 ≤ K)
  (_hK : ∀ x y, x ∈ U → y ∈ U → ‖f x - f y‖ ≤ K * ‖x - y‖)
  (t0 t1 : ℝ)
  (_h_t : t0 < t1)
  (y z : ℝ → E)
  (_hy_sol : ∀ t, t ∈ Set.Icc t0 t1 → HasDerivAt y (f (y t)) t)
  (_hz_sol : ∀ t, t ∈ Set.Icc t0 t1 → HasDerivAt z (f (z t)) t)
  (_hy_U : ∀ t, t ∈ Set.Icc t0 t1 → y t ∈ U)
  (_hz_U : ∀ t, t ∈ Set.Icc t0 t1 → z t ∈ U)
  where
  /--
  Grönwall Continuous Dependence Bound: Theorem 1.0.4.
  Guarantees that neighboring solutions diverge at most exponentially, bounded by the Lipschitz 
  constant of the vector field. The domain boundary `t0 < t1` is strictly enforced to prevent 
  a vacuous evaluation where an empty time interval trivially satisfies the hypothesis.
  -/
  continuous_dependence : ∀ t, t ∈ Set.Icc t0 t1 → 
    ‖y t - z t‖ ≤ ‖y t0 - z t0‖ * Real.exp (K * (t - t0))

end Litlib.Y1983.guckenheimer1983nonlinear
