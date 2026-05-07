-- FILENAME: Litlib/Y1982/taubes1982existence/Signature.lean

import Litlib.Core
import Mathlib.Analysis.Calculus.Deriv.Basic
import Mathlib.Analysis.SpecialFunctions.Trigonometric.Basic
import Mathlib.Topology.Basic
import Mathlib.Order.Filter.Basic
import Mathlib.Data.Real.Basic

open Filter Topology

namespace Litlib.Y1982.taubes1982existence

Litlib.paper "taubes1982existence"
  type "article"
  title "The existence of a non-minimal solution to the SU(2) Yang-Mills-Higgs equations on ℝ3. Part I"
  authors ["Taubes, Clifford Henry"]
  journal "Communications in Mathematical Physics"
  volume "86"
  issue "2"
  pages "257--298"
  year "1982"
  publisher "Springer"
  doi "10.1007/BF01206014"

Litlib.equation "taubes1982existence"
  eq "2.7, 2.8"
  page "263"
  kind "Definition"
class YangMillsHiggsVariations
    (Configuration Tangent : Type*)
    [AddCommGroup Tangent] [Module ℝ Tangent]
    (action : Configuration → ℝ)
    (add : Configuration → Tangent → Configuration)
    (gradient : Configuration → Tangent → ℝ)
    (hessian : Configuration → Tangent → ℝ) where
  /--
  Equations (2.7) and (2.8) (page 263): The gradient and Hessian of the
  Yang-Mills-Higgs action are rigorously defined as the first and second
  directional derivatives evaluated at s = 0.
  -/
  gradient_def : ∀ c ψ, HasDerivAt (fun (s : ℝ) => action (add c (s • ψ))) (gradient c ψ) (0 : ℝ)
  hessian_def : ∀ c ψ, HasDerivAt (fun (s : ℝ) => gradient (add c (s • ψ)) ψ) (hessian c ψ) (0 : ℝ)

Litlib.equation "taubes1982existence"
  eq "Theorem 1.1"
  page "258"
  kind "Theorem"
class NonMinimalSolution
    (Configuration Tangent Field : Type*)
    [AddCommGroup Tangent] [Module ℝ Tangent]
    [AddCommGroup Field]
    (gradient : Configuration → Tangent → ℝ)
    (curvature covDeriv : Configuration → Field)
    (hodgeStar : Field → Field) where
  /--
  Theorem 1.1: There is a smooth, finite action solution to the SU(2)
  Yang-Mills-Higgs equations on ℝ³ which does not satisfy the first-order
  Bogomol'nyi equations (*F_A = ± D_A \Phi).
  -/
  theorem_1_1 : ∃ (c : Configuration),
    (∀ ψ, gradient c ψ = 0) ∧ 
    ¬ (hodgeStar (curvature c) = covDeriv c ∨ hodgeStar (curvature c) = - (covDeriv c))

Litlib.equation "taubes1982existence"
  eq "Theorem 5.6"
  page "277"
  kind "Theorem"
class GoodSequenceConvergence
    (Configuration Tangent GaugeTransform : Type*)
    [TopologicalSpace Configuration]
    (action : Configuration → ℝ)
    (gradientNorm : Configuration → ℝ)
    (gradient : Configuration → Tangent → ℝ)
    (applyGauge : GaugeTransform → Configuration → Configuration) where
  /--
  Theorem 5.6: A sequence of configurations with bounded action and vanishing gradient
  has a subsequence which converges strongly modulo gauge transformations
  to a solution of the Yang-Mills-Higgs equations.
  -/
  theorem_5_6 : ∀ (c : ℕ → Configuration) (B : ℝ),
    (∀ i, action (c i) ≤ B) →
    Tendsto (fun i => gradientNorm (c i)) atTop (𝓝 0) →
    ∃ (subseq : ℕ → ℕ) (cInf : Configuration) (g : ℕ → GaugeTransform),
      StrictMono subseq ∧
      Tendsto (fun i => applyGauge (g i) (c (subseq i))) atTop (𝓝 cInf) ∧
      (∀ ψ, gradient cInf ψ = 0)

Litlib.equation "taubes1982existence"
  eq "Theorem 8.1"
  page "291"
  kind "Theorem"
class MonopoleNumberCondition
    (Configuration Tangent GaugeTransform : Type*)
    [TopologicalSpace Configuration]
    (action : Configuration → ℝ)
    (gradient : Configuration → Tangent → ℝ)
    (applyGauge : GaugeTransform → Configuration → Configuration)
    (topologicalSector : Configuration → ℤ) where
  /--
  Theorem 8.1: If a good sequence converges to a solution and the 
  limit of the action is strictly less than 8π, then the limit 
  configuration is in the trivial topological sector (k = 0).
  -/
  theorem_8_1 : ∀ (c : ℕ → Configuration) (cInf : Configuration) (aInf : ℝ) (g : ℕ → GaugeTransform),
    Tendsto (fun i => applyGauge (g i) (c i)) atTop (𝓝 cInf) →
    (∀ ψ, gradient cInf ψ = 0) →
    Tendsto (fun i => action (c i)) atTop (𝓝 aInf) →
    aInf < 8 * Real.pi →
    topologicalSector cInf = 0

end Litlib.Y1982.taubes1982existence
