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

literature_citation Thm1_3
  bibtex_key "uhlenbeck1982connections"
  doi "10.1007/BF01206014"
  authors ["Uhlenbeck, Karen K."]
  status Standard
class Thm1_3 where
  /--
  Theorem 1.3: Local existence of a Coulomb gauge.
  If the L^{n/2} norm of the curvature is sufficiently small (≤ κ), there exists a 
  gauge transformation mapping the connection to one satisfying the Coulomb 
  gauge condition (d*A = 0).
  -/
  exists_coulomb_gauge
    (Connection GaugeTransform Form : Type*) [Zero Form]
    (curvature_Ln2_norm : Connection → ℝ)
    (applyGauge : GaugeTransform → Connection → Connection)
    (d_star : Connection → Form) :
    ∃ (κ : ℝ), κ > 0 ∧
    ∀ (A : Connection),
      curvature_Ln2_norm A ≤ κ →
      ∃ (g : GaugeTransform), d_star (applyGauge g A) = 0

literature_citation Thm1_5
  bibtex_key "uhlenbeck1982connections"
  doi "10.1007/BF01206014"
  authors ["Uhlenbeck, Karen K."]
  status Standard
class Thm1_5 where
  /--
  Theorem 1.5 (Uhlenbeck Weak Compactness):
  Let D(i) be a sequence of connections with uniformly bounded L^p curvature norms.
  Then there exists a subsequence and a sequence of gauge transformations such that
  the gauge-transformed subsequence converges weakly.
  -/
  uhlenbeck_compactness 
    (Connection GaugeTransform : Type*) [TopologicalSpace Connection]
    (curvature_Lp_norm : Connection → ℝ)
    (applyGauge : GaugeTransform → Connection → Connection) :
    ∀ (D : ℕ → Connection) (B : ℝ),
      (∀ i, curvature_Lp_norm (D i) ≤ B) →
      ∃ (A_infty : Connection) (subseq : ℕ → ℕ) (s : ℕ → GaugeTransform),
        StrictMono subseq ∧
        Tendsto (fun i => applyGauge (s i) (D (subseq i))) atTop (𝓝 A_infty)

literature_citation ConnectionTopology
  bibtex_key "uhlenbeck1982connections"
  doi "10.1007/BF01206014"
  authors ["Uhlenbeck, Karen K."]
  status Standard
class ConnectionTopology where
  /--
  Capstone Theorem for CGD: Connection Topology.
  Uhlenbeck establishes that the space of W^{1,p} connections modulo gauge 
  transformations forms a metric space. We enforce the existence of a metric 
  that separates points iff they are not gauge-equivalent.
  -/
  exists_gauge_metric
    (Connection GaugeTransform : Type*)
    (applyGauge : GaugeTransform → Connection → Connection) :
    ∃ (dist : Connection → Connection → ℝ),
      (∀ a b, dist a b ≥ 0) ∧
      (∀ a b, dist a b = 0 ↔ ∃ g, applyGauge g a = b) ∧
      (∀ a b, dist a b = dist b a) ∧
      (∀ a b c, dist a c ≤ dist a b + dist b c)

literature_citation YangMillsActionDifferentiable
  bibtex_key "uhlenbeck1982connections"
  doi "10.1007/BF01206014"
  authors ["Uhlenbeck, Karen K."]
  status Standard
class YangMillsActionDifferentiable where
  /--
  Capstone Theorem for CGD: Yang-Mills Action Differentiability.
  The Yang-Mills action is Fréchet differentiable with respect to W^{1,p} variations.
  -/
  is_frechet_differentiable
    (Connection : Type*) [NormedAddCommGroup Connection] [NormedSpace ℝ Connection]
    (Action : Connection → ℝ) :
    Differentiable ℝ Action

literature_citation YangMillsFunctionalDerivative
  bibtex_key "uhlenbeck1982connections"
  doi "10.1007/BF01206014"
  authors ["Uhlenbeck, Karen K."]
  status Standard
class YangMillsFunctionalDerivative where
  /--
  Capstone Theorem for CGD: Yang-Mills Functional Derivative.
  If a connection is a stationary point of the action (Fréchet derivative is 0), 
  it mathematically implies the local continuous Euler-Lagrange (Yang-Mills) PDEs.
  -/
  stationary_implies_euler_lagrange
    (Connection Form : Type*) [NormedAddCommGroup Connection] [NormedSpace ℝ Connection] [Zero Form]
    (Action : Connection → ℝ)
    (F : Connection → Form) (d_star : Form → Form) :
    ∀ (A : Connection),
      HasFDerivAt Action (0 : Connection →L[ℝ] ℝ) A → d_star (F A) = 0

end Litlib.Y1982.uhlenbeck1982connections
