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
class Thm1_3 where
  existsCoulombGauge :
    ∀ (Connection GaugeTransform Form : Type*) [Zero Form] [Zero Connection]
      (curvatureLn2Norm : Connection → ℝ)
      (applyGauge : GaugeTransform → Connection → Connection)
      (dStar : Connection → Form)
      (_h_curvature_zero : curvatureLn2Norm 0 = 0),
      ∃ (κ : ℝ), κ > 0 ∧
      ∀ (A : Connection),
        curvatureLn2Norm A ≤ κ →
        ∃ (g : GaugeTransform), dStar (applyGauge g A) = 0

Litlib.reference Thm1_5
  bibtex "uhlenbeck1982connections"
  doi "10.1007/BF01206014"
  authors ["Uhlenbeck, Karen K."]
  status Standard
class Thm1_5 where
  uhlenbeckCompactness :
    ∀ (Connection GaugeTransform : Type*) [TopologicalSpace Connection]
      (curvatureLpNorm : Connection → ℝ)
      (applyGauge : GaugeTransform → Connection → Connection)
      (_h_norm_nonneg : ∀ A, curvatureLpNorm A ≥ 0),
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
class ConnectionTopology where
  existsGaugeMetric :
    ∀ (Connection GaugeTransform : Type*)
      (applyGauge : GaugeTransform → Connection → Connection),
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
class YangMillsActionDifferentiable where
  isFrechetDifferentiable :
    ∀ (Connection : Type*) [NormedAddCommGroup Connection] [NormedSpace ℝ Connection]
      (Action : Connection → ℝ)
      (_h_action_zero : Action 0 = 0),
      Differentiable ℝ Action

Litlib.reference YangMillsFunctionalDerivative
  bibtex "uhlenbeck1982connections"
  doi "10.1007/BF01206014"
  authors ["Uhlenbeck, Karen K."]
  status Standard
class YangMillsFunctionalDerivative where
  stationaryImpliesEOM :
    ∀ (Connection Form : Type*) [NormedAddCommGroup Connection] [NormedSpace ℝ Connection] [Zero Form]
      (Action : Connection → ℝ)
      (F : Connection → Form) (dStar : Form → Form)
      (_h_action_zero : Action 0 = 0)
      (_h_F_zero : F 0 = 0)
      (_h_dStar_zero : dStar 0 = 0),
      ∀ (A : Connection),
        HasFDerivAt Action (0 : Connection →L[ℝ] ℝ) A → dStar (F A) = 0

end Litlib.Y1982.uhlenbeck1982connections
