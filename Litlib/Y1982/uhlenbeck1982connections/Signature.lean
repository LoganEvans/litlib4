-- FILENAME: Litlib/Y1982/uhlenbeck1982connections/Signature.lean

import Litlib.Core
import Mathlib.Topology.Basic
import Mathlib.Order.Monotone.Basic
import Mathlib.Data.Real.Basic
import Mathlib.Order.Filter.Basic
import Mathlib.Analysis.Calculus.FDeriv.Basic
import Mathlib.Analysis.Calculus.FDeriv.Add
import Mathlib.Analysis.Calculus.FDeriv.Linear

open Filter Topology

namespace Litlib.Y1982.uhlenbeck1982connections

Litlib.reference Thm1_3
  bibtex "uhlenbeck1982connections"
  doi "10.1007/BF01206014"
  authors ["Uhlenbeck, Karen K."]
  status Standard
class Thm1_3 
    (Connection GaugeTransform Form : Type*) [Zero Form]
    (curvatureLn2Norm : Connection → ℝ)
    (applyGauge : GaugeTransform → Connection → Connection)
    (dStar : Connection → Form) where
  /--
  Theorem 1.3: Local existence of a Coulomb gauge.
  If the L^{n/2} norm of the curvature is sufficiently small (≤ κ), there exists a 
  gauge transformation mapping the connection to one satisfying the Coulomb 
  gauge condition (d*A = 0).
  -/
  existsCoulombGauge :
    ∃ (κ : ℝ), κ > 0 ∧
    ∀ (A : Connection),
      curvatureLn2Norm A ≤ κ →
      ∃ (g : GaugeTransform), dStar (applyGauge g A) = 0

Litlib.reference Thm1_5
  bibtex "uhlenbeck1982connections"
  doi "10.1007/BF01206014"
  authors ["Uhlenbeck, Karen K."]
  status Standard
class Thm1_5 
    (Connection GaugeTransform : Type*) [TopologicalSpace Connection]
    (curvatureLpNorm : Connection → ℝ)
    (applyGauge : GaugeTransform → Connection → Connection) where
  /--
  Theorem 1.5 (Uhlenbeck Weak Compactness):
  Let D(i) be a sequence of connections with uniformly bounded L^p curvature norms.
  Then there exists a subsequence and a sequence of gauge transformations such that
  the gauge-transformed subsequence converges weakly.
  -/
  uhlenbeckCompactness :
    ∀ (D : ℕ → Connection) (B : ℝ),
      (∀ i, curvatureLpNorm (D i) ≤ B) →
      ∃ (aInfty : Connection) (subseq : ℕ → ℕ) (s : ℕ → GaugeTransform),
        StrictMono subseq ∧
        Tendsto (fun i => applyGauge (s i) (D (subseq i))) atTop (𝓝 aInfty)

Litlib.reference ConnectionTopology
  bibtex "uhlenbeck1982connections"
  doi "10.1007/BF01206014"
  authors ["Uhlenbeck, Karen K."]
  status Standard
class ConnectionTopology 
    (Connection GaugeTransform : Type*)
    (applyGauge : GaugeTransform → Connection → Connection) where
  /--
  Capstone Theorem for CGD: Connection Topology.
  Uhlenbeck establishes that the space of W^{1,p} connections modulo gauge 
  transformations forms a metric space. We enforce the existence of a metric 
  that separates points iff they are not gauge-equivalent.
  -/
  existsGaugeMetric :
    ∃ (dist : Connection → Connection → ℝ),
      (∀ a b, dist a b ≥ 0) ∧
      (∀ a b, dist a b = 0 ↔ ∃ g, applyGauge g a = b) ∧
      (∀ a b, dist a b = dist b a) ∧
      (∀ a b c, dist a c ≤ dist a b + dist b c)

Litlib.reference YangMillsActionDifferentiable
  bibtex "uhlenbeck1982connections"
  doi "10.1007/BF01206014"
  authors ["Uhlenbeck, Karen K."]
  status Standard
class YangMillsActionDifferentiable 
    (Connection : Type*) [NormedAddCommGroup Connection] [NormedSpace ℝ Connection]
    (Action : Connection → ℝ) where
  /--
  Capstone Theorem for CGD: Yang-Mills Action Differentiability.
  The Yang-Mills action is Fréchet differentiable with respect to W^{1,p} variations.
  -/
  isFrechetDifferentiable :
    Differentiable ℝ Action

Litlib.reference YangMillsFunctionalDerivative
  bibtex "uhlenbeck1982connections"
  doi "10.1007/BF01206014"
  authors ["Uhlenbeck, Karen K."]
  status Standard
class YangMillsFunctionalDerivative 
    (Connection Form : Type*) [NormedAddCommGroup Connection] [NormedSpace ℝ Connection] [Zero Form]
    (Action : Connection → ℝ)
    (F : Connection → Form) (dStar : Form → Form) where
  /--
  Capstone Theorem for CGD: Yang-Mills Functional Derivative.
  If a connection is a stationary point of the action (Fréchet derivative is 0), 
  it mathematically implies the local continuous Euler-Lagrange (Yang-Mills) PDEs.
  -/
  stationaryImpliesEOM :
    ∀ (A : Connection),
      HasFDerivAt Action (0 : Connection →L[ℝ] ℝ) A → dStar (F A) = 0

end Litlib.Y1982.uhlenbeck1982connections
