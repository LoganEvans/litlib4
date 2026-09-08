-- FILENAME: Litlib/Y1995/peres1995quantum/Chapter02/Sec04_Consecutive.lean


import Litlib.Core
import Mathlib.Data.Real.Basic
import Mathlib.Algebra.BigOperators.Group.Finset.Basic
import Mathlib.Algebra.BigOperators.Ring.Finset

namespace Litlib.Y1995.peres1995quantum

noncomputable section

open scoped BigOperators
open Finset

Litlib.equation "peres1995quantum" eq "2.1" page "34" kind "definition"
class Eq2_1_Stochastic (N : ℕ) (hN : 0 < N) (P : Fin N → Fin N → ℝ) where
  prob_nonneg : ∀ mu m, 0 ≤ P mu m
  prob_le_one : ∀ mu m, P mu m ≤ 1
  stochastic_sum : ∀ m, (∑ mu : Fin N, P mu m) = 1

Litlib.equation "peres1995quantum" eq "2.2" page "34" kind "theorem"
class Eq2_2_DoublyStochastic (N : ℕ) (hN : 0 < N) (P : Fin N → Fin N → ℝ)
    [Eq2_1_Stochastic N hN P] where
  doubly_stochastic_sum : ∀ mu, (∑ m : Fin N, P mu m) = 1

Litlib.equation "peres1995quantum" eq "2.3" page "35" kind "theorem"
class Eq2_3_ReciprocityMatrix (N : ℕ) (hN : 0 < N)
    (P : Fin N → Fin N → ℝ) (Pi : Fin N → Fin N → ℝ)
    [Eq2_1_Stochastic N hN P] [Eq2_1_Stochastic N hN Pi] where
  reciprocity_matrix_eq : ∀ mu m, Pi m mu = P mu m

Litlib.equation "peres1995quantum" eq "2.4" page "36" kind "theorem"
class Eq2_4_ReciprocityLaw
    (State : Type*)
    (prob : State → State → ℝ) where
  prob_nonneg : ∀ phi psi, 0 ≤ prob phi psi
  prob_le_one : ∀ phi psi, prob phi psi ≤ 1
  repeatability : ∀ psi, prob psi psi = 1
  reciprocity_law : ∀ phi psi, prob phi psi = prob psi phi

end

end Litlib.Y1995.peres1995quantum
