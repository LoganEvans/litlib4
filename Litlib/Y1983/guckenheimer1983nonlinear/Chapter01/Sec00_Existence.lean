-- FILENAME: Litlib/Y1983/guckenheimer1983nonlinear/Chapter01/Sec00_Existence.lean

import Litlib.Core
import Mathlib.Topology.Basic
import Mathlib.Analysis.Calculus.Deriv.Basic
import Mathlib.Analysis.InnerProductSpace.Basic
import Mathlib.Analysis.SpecialFunctions.Exponential

namespace Litlib.Y1983.guckenheimer1983nonlinear

Litlib.equation "guckenheimer1983nonlinear"
  eq "Theorem 1.0.1"
  page "3"
  kind "theorem"
class Theorem1_0_1
  (E : Type*) [NormedAddCommGroup E] [NormedSpace ℝ E]
  (U : Set E) (_hU : IsOpen U)
  (f : E → E)
  (is_C1 : (E → E) → Set E → Prop)
  (_hf : is_C1 f U)
  (x0 : E)
  (_hx0 : x0 ∈ U)
  where
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
  (E : Type*) [NormedAddCommGroup E] [NormedSpace ℝ E]
  (U : Set E) (_hU : IsOpen U)
  (f : E → E)
  (x_bar : E)
  (_hx_bar : f x_bar = 0)
  (W : Set E) (_hW : W ⊆ U) (_hW_open : IsOpen W) (_hx_bar_in_W : x_bar ∈ W)
  (V : E → ℝ)
  (is_differentiable_on : (E → ℝ) → Set E → Prop)
  (_hV_diff : is_differentiable_on V W)
  (_hV_pos : ∀ x ∈ W, x ≠ x_bar → V x > 0)
  (_hV_zero : V x_bar = 0)
  (V_dot : E → ℝ)
  (is_stable : E → Prop)
  (is_asymptotically_stable : E → Prop)
  where
  stable_if : (∀ x ∈ W, x ≠ x_bar → V_dot x ≤ 0) → is_stable x_bar
  asymptotically_stable_if : (∀ x ∈ W, x ≠ x_bar → V_dot x < 0) → is_asymptotically_stable x_bar

Litlib.equation "guckenheimer1983nonlinear"
  eq "Theorem 1.0.3"
  page "7"
  kind "theorem"
class Theorem1_0_3
  (M : Type*) [TopologicalSpace M] [CompactSpace M]
  (f : M → M) 
  (is_C1 : (M → M) → Prop)
  (is_solution : (ℝ → M) → (M → M) → Prop) 
  (_hC1 : is_C1 f)
  where
  global_existence : ∀ x0 : M, ∃ c : ℝ → M, c 0 = x0 ∧ is_solution c f

Litlib.equation "guckenheimer1983nonlinear"
  eq "Theorem 1.0.4"
  page "7"
  kind "theorem"
class Theorem1_0_4
  (E : Type*) [NormedAddCommGroup E] [NormedSpace ℝ E]
  (U : Set E)
  (_hU : IsOpen U)
  (f : E → E)
  (K : ℝ)
  (_hK_pos : 0 ≤ K)
  (_hK : ∀ x y, x ∈ U → y ∈ U → ‖f x - f y‖ ≤ K * ‖x - y‖)
  (t0 t1 : ℝ)
  (_h_t : t0 ≤ t1)
  (y z : ℝ → E)
  (_hy_sol : ∀ t, t ∈ Set.Icc t0 t1 → HasDerivAt y (f (y t)) t)
  (_hz_sol : ∀ t, t ∈ Set.Icc t0 t1 → HasDerivAt z (f (z t)) t)
  (_hy_U : ∀ t, t ∈ Set.Icc t0 t1 → y t ∈ U)
  (_hz_U : ∀ t, t ∈ Set.Icc t0 t1 → z t ∈ U)
  where
  continuous_dependence : ∀ t, t ∈ Set.Icc t0 t1 → 
    ‖y t - z t‖ ≤ ‖y t0 - z t0‖ * Real.exp (K * (t - t0))

end Litlib.Y1983.guckenheimer1983nonlinear
