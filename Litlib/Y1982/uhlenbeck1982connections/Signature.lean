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
    (curvatureLn2Integral curvatureLpHalfIntegral : Connection → ℝ)
    (sobolevLn21Norm sobolevLp1Norm : Connection → ℝ)
    (applyGauge : GaugeTransform → Connection → Connection)
    (dStar : Connection → Form)
    (normalTrace : Connection → BoundaryForm)
    (dimM : ℕ)
    (p : ℝ) where
  /--
  Theorem 2.1: Local existence of Coulomb gauge.
  Over a ball B^n, if the L^{n/2} integral of the curvature is sufficiently small,
  the connection is gauge equivalent to one satisfying the Coulomb condition
  d*A = 0 and the Neumann boundary condition x \cdot A = 0, with rigorous Sobolev bounds.
  -/
  theorem_2_1
    (hDim : (dimM : ℝ) > p ∧ p > (dimM : ℝ) / 2) :
    ∃ (κ : ℝ) (c : ℝ), κ > 0 ∧ c > 0 ∧
    ∀ (A : Connection),
      curvatureLn2Integral A ≤ κ →
      ∃ (g : GaugeTransform),
        let Ag := applyGauge g A
        dStar Ag = 0 ∧
        normalTrace Ag = 0 ∧
        sobolevLn21Norm Ag ≤ c * (curvatureLn2Integral A) ^ (2 / (dimM : ℝ)) ∧
        sobolevLp1Norm Ag ≤ c * (curvatureLpHalfIntegral A) ^ (1 / p)

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
  Theorem 1.5 (and 3.6): Global weak compactness.
  If 2p > dim M, a sequence of connections with bounded L^p curvature integrals
  has a subsequence that converges weakly modulo gauge transformations,
  and the limit obeys the same curvature bound.
  -/
  theorem_1_5
    (hDim : 2 * p > (dimM : ℝ))
    (D : ℕ → Connection) (B : ℝ)
    (hBound : ∀ i, curvatureLpIntegral (D i) ≤ B) :
    ∃ (DInfty : Connection) (subseq : ℕ → ℕ) (g : ℕ → GaugeTransform),
      StrictMono subseq ∧
      Tendsto (fun i => applyGauge (g i) (D (subseq i))) atTop (𝓝 DInfty) ∧
      curvatureLpIntegral DInfty ≤ B

end Litlib.Y1982.uhlenbeck1982connections
