-- FILENAME: Litlib/Y1982/uhlenbeck1982connections/Signature.lean

import Litlib.Core
import Litlib.Math.FermatStationary
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
    (applyGauge : GaugeTransform → Connection → Connection)
    (dimM : ℕ)
    (p : ℝ) where
  uhlenbeckCompactness
    (hDim : 2 * p > (dimM : ℝ))
    (hp : 1 ≤ p)
    (D : ℕ → Connection) (B : ℝ)
    (hBound : ∀ i, curvatureLpNorm (D i) ≤ B) :
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
    (Connection : Type*)
    (isValidVar : (ℝ → Connection) → Prop)
    (Action : Connection → ℝ) where
  is1DDifferentiable :
    ∀ (A : Connection) (var : ℝ → Connection),
      isValidVar var → var 0 = A →
      DifferentiableAt ℝ (fun t => Action (var t)) 0

Litlib.reference YangMillsFunctionalDerivative
  bibtex "uhlenbeck1982connections"
  doi "10.1007/BF01206014"
  authors ["Uhlenbeck, Karen K."]
  status Standard
class YangMillsFunctionalDerivative 
    (Connection Form : Type*) [Zero Form]
    (isValidVar : (ℝ → Connection) → Prop)
    (Action : Connection → ℝ)
    (F : Connection → Form) (dStar : Form → Form) where
  stationaryImpliesEOM :
    ∀ (A : Connection),
      Litlib.Math.CalculusOfVariations.IsStationaryPoint Action A isValidVar → dStar (F A) = 0

end Litlib.Y1982.uhlenbeck1982connections
