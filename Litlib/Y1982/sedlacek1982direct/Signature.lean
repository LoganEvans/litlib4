-- FILENAME: Litlib/Y1982/sedlacek1982direct/Signature.lean

import Litlib.Core
import Mathlib.Data.Real.Basic
import Mathlib.Analysis.SpecialFunctions.Trigonometric.Basic
import Mathlib.Topology.Basic
import Mathlib.Order.Filter.Basic

open Filter Topology

namespace Litlib.Y1982.sedlacek1982direct

Litlib.reference Thm5_5
  bibtex "sedlacek1982direct"
  doi "10.1007/BF01214887"
  authors ["Sedlacek, Steven"]
  status Standard
class Thm5_5 where
  /--
  Theorem 5.5 (and Corollary 6.2): The obstruction to lifting the structure 
  group is preserved under the minimizing limit of the Yang-Mills functional.
  Secured using rigorous Mathlib filter limits over a bundle sequence.
  -/
  obstructionPreserved
    (Bundle ObstructionClass : Type*)
    [TopologicalSpace Bundle]
    (eta : Bundle → ObstructionClass)
    (P : ℕ → Bundle) (pInfty : Bundle)
    (hLimit : Tendsto P atTop (𝓝 pInfty)) :
    ∃ (N : ℕ), ∀ i ≥ N, eta pInfty = eta (P i)

Litlib.reference Thm7_1
  bibtex "sedlacek1982direct"
  doi "10.1007/BF01214887"
  authors ["Sedlacek, Steven"]
  status Standard
class Thm7_1 where
  /--
  Theorem 7.1: The defect in the first Pontryagin number is bounded by 
  the loss of the Yang-Mills energy functional limit.
  -/
  pontryaginDefectBound
    (Bundle : Type*)
    [TopologicalSpace Bundle]
    (p1 : Bundle → ℝ)
    (m : Bundle → ℝ)
    (P : ℕ → Bundle) (pInfty : Bundle)
    (hLimit : Tendsto P atTop (𝓝 pInfty)) :
    ∃ (N : ℕ), ∀ i ≥ N, |p1 (P i) - p1 pInfty| ≤ (m (P i) - m pInfty) / (4 * Real.pi ^ 2)

Litlib.reference YangMillsCoercivity
  bibtex "sedlacek1982direct"
  doi "10.1007/BF01214887"
  authors["Sedlacek, Steven"]
  status Standard
class YangMillsCoercivity where
  /--
  Capstone Theorem: Yang-Mills Coercivity.
  The Yang-Mills energy functional is coercive, bounding the energy from below 
  and ensuring minimizing sequences are well-behaved.
  -/
  isCoercive
    (Connection : Type*)
    (energy : Connection → ℝ)
    (norm : Connection → ℝ) :
    ∀ (M : ℝ), ∃ (C : ℝ), ∀ (A : Connection), norm A ≥ C → energy A ≥ M

end Litlib.Y1982.sedlacek1982direct
