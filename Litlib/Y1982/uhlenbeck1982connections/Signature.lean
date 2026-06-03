-- FILENAME: Litlib/Y1982/uhlenbeck1982connections/Signature.lean

import Litlib.Core
import Mathlib.Topology.Basic
import Mathlib.Order.Monotone.Basic
import Mathlib.Data.Real.Basic
import Mathlib.Order.Filter.Basic
import Mathlib.Analysis.SpecialFunctions.Pow.Real

open Filter Topology

namespace Litlib.Y1982.uhlenbeck1982connections

Litlib.paper "uhlenbeck1982connections"
  type "article"
  title "Connections with Lp bounds on curvature"
  authors ["Uhlenbeck, Karen K."]
  journal "Communications in Mathematical Physics"
  volume "83"
  issue "1"
  pages "31--42"
  year "1982"
  publisher "Springer"
  doi "10.1007/BF01206014"

Litlib.equation "uhlenbeck1982connections"
  eq "Theorem 2.1"
  page "34"
  kind "Theorem"
class LocalCoulombGauge
    (Connection GaugeTransform Form BoundaryForm : Type*) [Zero Form] [Zero BoundaryForm]
    (curvatureLn2Integral curvatureLpIntegral : Connection → ℝ)
    (sobolevLn21Norm sobolevLp1Norm : Connection → ℝ)
    (applyGauge : GaugeTransform → Connection → Connection)
    (dStar : Connection → Form)
    (normalTrace : Connection → BoundaryForm)
    (dimM : ℕ)
    (p : ℝ) where
  /--
  Geometric and Analytical Bounds: Theorem 2.1 establishes the local existence of the Coulomb gauge
  (also known as the Lorentz or Hodge gauge) under strictly bounded curvature conditions.
  Over a local ball $B^n$, if the $L^{n/2}$ norm of the field strength is bounded by a sufficiently
  small, strictly positive $\kappa$, the connection is gauge-equivalent to one satisfying the Coulomb
  condition $d^*A = 0$ and the Neumann boundary condition $x \cdot A = 0$. 
  To prevent pathological evaluation of fractional powers (`Real.rpow`), the abstract integrals 
  are explicitly gated to mathematically valid non-negative domains.
  -/
  theorem_2_1
    (hDim : (dimM : ℝ) > p ∧ p > (dimM : ℝ) / 2) :
    ∃ (κ : ℝ) (c : ℝ), κ > 0 ∧ c > 0 ∧
    ∀ (A : Connection),
      curvatureLn2Integral A ≥ 0 →
      curvatureLpIntegral A ≥ 0 →
      curvatureLn2Integral A ≤ κ →
      ∃ (g : GaugeTransform),
        let Ag := applyGauge g A
        dStar Ag = 0 ∧
        normalTrace Ag = 0 ∧
        sobolevLn21Norm Ag ≤ c * (curvatureLn2Integral A) ^ (2 / (dimM : ℝ)) ∧
        sobolevLp1Norm Ag ≤ c * (curvatureLpIntegral A) ^ (1 / p)

Litlib.equation "uhlenbeck1982connections"
  eq "Theorem 1.5, 3.6"
  page "34"
  kind "Theorem"
class WeakCompactness
    (Connection GaugeTransform : Type*)
    [TopologicalSpace Connection]
    (curvatureLpIntegral : Connection → ℝ)
    (applyGauge : GaugeTransform → Connection → Connection)
    (dimM : ℕ)
    (p : ℝ) where
  /--
  Topological Gatekeeping and Weak Compactness: Theorems 1.5 and 3.6 prove global weak compactness
  for gauge fields over a compact manifold $M$ with a compact structure group. The dimensional
  constraint $2p > \dim M$ mathematically ensures that the Sobolev gauge transformations embed 
  compactly into continuous mappings, preventing topological divergences in the weak limit. 
  The sequence's $L^p$ bound $B$ is explicitly gated to be non-negative to prevent the hypotheses 
  from being vacuously satisfied by unphysical negative norms.
  -/
  theorem_1_5
    (hDim : 2 * p > (dimM : ℝ))
    (D : ℕ → Connection) (B : ℝ)
    (hNonDegenerate : B ≥ 0)
    (hCurvNonNeg : ∀ i, curvatureLpIntegral (D i) ≥ 0)
    (hBound : ∀ i, curvatureLpIntegral (D i) ≤ B) :
    ∃ (DInfty : Connection) (subseq : ℕ → ℕ) (g : ℕ → GaugeTransform),
      StrictMono subseq ∧
      Tendsto (fun i => applyGauge (g i) (D (subseq i))) atTop (𝓝 DInfty) ∧
      curvatureLpIntegral DInfty ≤ B

end Litlib.Y1982.uhlenbeck1982connections
