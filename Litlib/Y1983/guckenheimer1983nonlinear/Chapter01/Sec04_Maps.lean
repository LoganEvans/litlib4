-- FILENAME: Litlib/Y1983/guckenheimer1983nonlinear/Chapter01/Sec04_Maps.lean

import Litlib.Core
import Mathlib.Topology.Basic
import Mathlib.Analysis.InnerProductSpace.Basic
import Mathlib.Analysis.Calculus.FDeriv.Basic
import Mathlib.Analysis.Calculus.ContDiff.Basic

namespace Litlib.Y1983.guckenheimer1983nonlinear

Litlib.equation "guckenheimer1983nonlinear"
  eq "Theorem 1.4.1"
  page "18"
  kind "theorem"
class Theorem1_4_1
  (E : Type*) [NormedAddCommGroup E] [NormedSpace ℝ E]
  (G : E → E)
  (is_C1_diffeomorphism : (E → E) → Prop)
  (x_bar : E)
  (is_hyperbolic_fixed_point : E → (E → E) → Prop)
  (DG : E → (E →L[ℝ] E))
  (_h_diff : is_C1_diffeomorphism G)
  (_h_fixed : is_hyperbolic_fixed_point x_bar G)
  (is_homeomorphism_on : (E → E) → Set E → Prop)
  where
  hartman_grobman_map : ∃ (U : Set E), IsOpen U ∧ x_bar ∈ U ∧
    ∃ (h : E → E),
    is_homeomorphism_on h U ∧
    ∀ ξ, ξ ∈ U → h (G ξ) = DG x_bar (h ξ)

Litlib.equation "guckenheimer1983nonlinear"
  eq "Theorem 1.4.2"
  page "18"
  kind "theorem"
class Theorem1_4_2
  (E : Type*) [NormedAddCommGroup E] [NormedSpace ℝ E]
  (r : ℕ∞) (_hr : 1 ≤ r)
  (G : E → E)
  (_h_diff : ContDiff ℝ r G)
  (x_bar : E)
  (_hx_bar : G x_bar = x_bar)
  (is_hyperbolic_fixed_point : E → (E → E) → Prop)
  (_h_hyperbolic : is_hyperbolic_fixed_point x_bar G)
  (Ws_loc Wu_loc : Set E)
  (Es Eu : Submodule ℝ E)
  where
  stable_manifold_map_exists : 
    ∃ (V_s : Set Es) (psi_s : Es → E) (incl_s : Es →L[ℝ] E), 
      IsOpen V_s ∧ (0 : Es) ∈ V_s ∧
      (∀ v, incl_s v = (v : E)) ∧
      ContDiff ℝ r psi_s ∧
      psi_s 0 = x_bar ∧
      HasFDerivAt psi_s incl_s 0 ∧
      Ws_loc = psi_s '' V_s
  unstable_manifold_map_exists : 
    ∃ (V_u : Set Eu) (psi_u : Eu → E) (incl_u : Eu →L[ℝ] E), 
      IsOpen V_u ∧ (0 : Eu) ∈ V_u ∧
      (∀ v, incl_u v = (v : E)) ∧
      ContDiff ℝ r psi_u ∧
      psi_u 0 = x_bar ∧
      HasFDerivAt psi_u incl_u 0 ∧
      Wu_loc = psi_u '' V_u

end Litlib.Y1983.guckenheimer1983nonlinear
