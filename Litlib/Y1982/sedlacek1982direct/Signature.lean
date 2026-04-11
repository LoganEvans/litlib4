-- FILENAME: Litlib/Y1982/sedlacek1982direct/Signature.lean

import Litlib.Core
import Mathlib.Data.Real.Basic
import Mathlib.Analysis.SpecialFunctions.Trigonometric.Basic

namespace Litlib.Y1982.sedlacek1982direct

literature_citation Thm5_5
  bibtex_key "sedlacek1982direct"
  doi "10.1007/BF01214887"
  authors ["Sedlacek, Steven"]
  status Standard
class Thm5_5 where
  /--
  Theorem 5.5 (and Corollary 6.2): The obstruction to lifting the structure 
  group is preserved under the minimizing limit of the Yang-Mills functional.
  -/
  obstruction_preserved
    (Bundle ObstructionClass : Type*)
    (eta : Bundle → ObstructionClass)
    (isMinimizingLimit : Bundle → Bundle → Prop)
    (P P_infty : Bundle)
    (h_limit : isMinimizingLimit P P_infty) :
    eta P_infty = eta P

literature_citation Thm7_1
  bibtex_key "sedlacek1982direct"
  doi "10.1007/BF01214887"
  authors ["Sedlacek, Steven"]
  status Standard
class Thm7_1 where
  /--
  Theorem 7.1: The defect in the first Pontryagin number is bounded by 
  the loss of the Yang-Mills energy functional limit.
  -/
  pontryagin_defect_bound
    (Bundle : Type*)
    (p1 : Bundle → ℝ)
    (m : Bundle → ℝ)
    (isMinimizingLimit : Bundle → Bundle → Prop)
    (P P_infty : Bundle)
    (h_limit : isMinimizingLimit P P_infty) :
    |p1 P - p1 P_infty| ≤ (m P - m P_infty) / (4 * Real.pi ^ 2)

literature_citation YangMillsCoercivity
  bibtex_key "sedlacek1982direct"
  doi "10.1007/BF01214887"
  authors["Sedlacek, Steven"]
  status Standard
class YangMillsCoercivity where
  /--
  Capstone Theorem: Yang-Mills Coercivity.
  The Yang-Mills energy functional is coercive, bounding the energy from below 
  and ensuring minimizing sequences are well-behaved.
  -/
  is_coercive
    (Connection : Type*)
    (energy : Connection → ℝ)
    (norm : Connection → ℝ) :
    ∀ (M : ℝ), ∃ (C : ℝ), ∀ (A : Connection), norm A ≥ C → energy A ≥ M
