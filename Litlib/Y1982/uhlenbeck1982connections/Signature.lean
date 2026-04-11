-- FILENAME: Litlib/Y1982/uhlenbeck1982connections/Signature.lean

import Litlib.Core
import Mathlib.Topology.Basic
import Mathlib.Order.Monotone.Basic
import Mathlib.Data.Real.Basic

namespace Litlib.Y1982.uhlenbeck1982connections

literature_axiom Thm1_3
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
    (Connection GaugeTransform : Type*)
    (curvature_Ln2_norm : Connection → ℝ)
    (applyGauge : GaugeTransform → Connection → Connection)
    (isCoulombGauge : Connection → Prop) :
    ∃ (κ : ℝ), κ > 0 ∧
    ∀ (A : Connection),
      curvature_Ln2_norm A ≤ κ →
      ∃ (g : GaugeTransform), isCoulombGauge (applyGauge g A)

literature_axiom Thm1_5
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
    (Connection GaugeTransform : Type*)
    (curvature_Lp_norm : Connection → ℝ)
    (applyGauge : GaugeTransform → Connection → Connection)
    (isWeaklyConvergent : (ℕ → Connection) → Prop) :
    ∀ (D : ℕ → Connection) (B : ℝ),
      (∀ i, curvature_Lp_norm (D i) ≤ B) →
      ∃ (subseq : ℕ → ℕ) (s : ℕ → GaugeTransform),
        StrictMono subseq ∧
        isWeaklyConvergent (fun i => applyGauge (s i) (D (subseq i)))
