-- FILENAME: Litlib/Y1983/guckenheimer1983nonlinear/Chapter01/Sec03_Nonlinear.lean

import Litlib.Core
import Mathlib.Topology.Basic
import Mathlib.Analysis.InnerProductSpace.Basic
import Mathlib.Analysis.Calculus.FDeriv.Basic
import Mathlib.Analysis.Calculus.ContDiff.Basic

namespace Litlib.Y1983.guckenheimer1983nonlinear

Litlib.equation "guckenheimer1983nonlinear"
  eq "Theorem 1.3.1"
  page "13"
  kind "theorem"
class Theorem1_3_1
  (E : Type*) [NormedAddCommGroup E] [NormedSpace ℝ E]
  (f : E → E)
  (x_bar : E)
  (_hx_bar : f x_bar = 0)
  (Df : E → (E →L[ℝ] E))
  (has_no_zero_or_purely_imaginary_eigenvalues : (E →L[ℝ] E) → Prop)
  (_h_hyperbolic : has_no_zero_or_purely_imaginary_eigenvalues (Df x_bar))
  (flow_nonlinear : ℝ → E → E)
  (flow_linear : ℝ → E → E)
  (is_homeomorphism_on : (E → E) → Set E → Prop)
  where
  hartman_grobman : ∃ (U : Set E), IsOpen U ∧ x_bar ∈ U ∧
    ∃ (h : E → E),
    is_homeomorphism_on h U ∧
    ∀ (t : ℝ) (x : E), x ∈ U → h (flow_nonlinear t x) = flow_linear t (h x)

Litlib.equation "guckenheimer1983nonlinear"
  eq "Theorem 1.3.2"
  page "13"
  kind "theorem"
class Theorem1_3_2
  (E : Type*) [NormedAddCommGroup E] [NormedSpace ℝ E]
  (r : ℕ∞) (_hr : 1 ≤ r)
  (f : E → E)
  (_h_diff : ContDiff ℝ r f)
  (x_bar : E)
  (_hx_bar : f x_bar = 0)
  (is_hyperbolic_fixed_point : E → (E → E) → Prop)
  (_h_hyperbolic : is_hyperbolic_fixed_point x_bar f)
  (Ws_loc Wu_loc : Set E)
  (Es Eu : Submodule ℝ E)
  where
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
