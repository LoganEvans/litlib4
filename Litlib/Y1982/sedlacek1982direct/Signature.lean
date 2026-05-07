-- FILENAME: Litlib/Y1982/sedlacek1982direct/Signature.lean

import Litlib.Core
import Mathlib.Data.Real.Basic
import Mathlib.Analysis.SpecialFunctions.Trigonometric.Basic
import Mathlib.Topology.Basic
import Mathlib.Order.Filter.Basic
import Mathlib.Analysis.Normed.Group.Basic

open Filter Topology

namespace Litlib.Y1982.sedlacek1982direct

Litlib.paper "sedlacek1982direct"
  type "article"
  title "A direct method for minimizing the Yang-Mills functional over 4-manifolds"
  authors ["Sedlacek, Steven"]
  journal "Communications in Mathematical Physics"
  volume "86"
  pages "515--527"
  year "1982"
  publisher "Springer"
  doi "10.1007/BF01214887"

Litlib.equation "sedlacek1982direct"
  eq "Theorem 5.5"
  page "523"
  kind "Theorem"
class ObstructionPreserved
    (Connection Bundle Obstruction : Type*)
    [TopologicalSpace Bundle]
    (bundleOf : Connection → Bundle)
    (eta : Bundle → Obstruction)
    (action : Connection → ℝ)
    (m : Obstruction → ℝ)
    (isMinimizingSequence : (ℕ → Connection) → Obstruction → Prop) where
  /--
  Theorem 5.5 (and 6.1): The obstruction to lifting the structure 
  group is preserved under the minimizing limit of the Yang-Mills functional.
  -/
  is_minimizing_sequence_iff : ∀ A obs,
    isMinimizingSequence A obs ↔
      (∀ i, eta (bundleOf (A i)) = obs) ∧
      Tendsto (fun i => action (A i)) atTop (𝓝 (m obs))
  
  theorem_5_5 : ∀ (A : ℕ → Connection) (obs : Obstruction) (pInfty : Bundle),
    isMinimizingSequence A obs →
    Tendsto (fun i => bundleOf (A i)) atTop (𝓝 pInfty) →
    ∃ (N : ℕ), ∀ i ≥ N, eta pInfty = eta (bundleOf (A i))

Litlib.equation "sedlacek1982direct"
  eq "Theorem 7.1"
  page "525"
  kind "Theorem"
class PontryaginDefectBound
    (Bundle : Type*)
    [TopologicalSpace Bundle]
    (p1 : Bundle → ℝ)
    (mHat : Bundle → ℝ) where
  /--
  Theorem 7.1: The defect in the first Pontryagin number is bounded by 
  the loss of the Yang-Mills energy functional limit.
  -/
  theorem_7_1 : ∀ (P : ℕ → Bundle) (pInfty : Bundle),
    Tendsto P atTop (𝓝 pInfty) →
    ∃ (N : ℕ), ∀ i ≥ N, 
      |p1 (P i) - p1 pInfty| ≤ (mHat (P i) - mHat pInfty) / (4 * Real.pi ^ 2)

Litlib.equation "sedlacek1982direct"
  eq "Unknown"
  page "Unknown"
  kind "Theorem"
class YangMillsCoercivity
    (Connection : Type*)
    [Norm Connection]
    (energy : Connection → ℝ) where
  /--
  Capstone Theorem: Yang-Mills Coercivity.
  The Yang-Mills energy functional is coercive, bounding the energy from below 
  and ensuring minimizing sequences are well-behaved.
  -/
  isCoercive : ∀ (M : ℝ), ∃ (C : ℝ), ∀ (A : Connection), ‖A‖ ≥ C → energy A ≥ M

end Litlib.Y1982.sedlacek1982direct
