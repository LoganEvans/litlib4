-- FILENAME: Litlib/Y1984/urbantke1984integrability/Proofs/Eq2_and_6.lean

import Litlib.Y1984.urbantke1984integrability.Signature
import Mathlib.Tactic.Ring
import Mathlib.Tactic.NormNum

namespace Litlib.Y1984.urbantke1984integrability

instance verified_Eq2_and_6 : Eq2_and_6 where
  simpleBivectorAnnihilation F u v a := by
    -- Introduce the unnamed (∀ μ ν, F = -F) hypothesis inside the tactic block
    intro hF
    
    -- Expand the antisymmetric difference and split the sums using strict calc
    have H_sub : (Finset.sum Finset.univ (fun μ => Finset.sum Finset.univ (fun ν => F a μ ν * (u μ * v ν - u ν * v μ)))) =
        Finset.sum Finset.univ (fun μ => Finset.sum Finset.univ (fun ν => F a μ ν * u μ * v ν)) -
        Finset.sum Finset.univ (fun μ => Finset.sum Finset.univ (fun ν => F a μ ν * u ν * v μ)) := by
      calc
        (Finset.sum Finset.univ (fun μ => Finset.sum Finset.univ (fun ν => F a μ ν * (u μ * v ν - u ν * v μ))))
          = Finset.sum Finset.univ (fun μ => Finset.sum Finset.univ (fun ν => F a μ ν * u μ * v ν - F a μ ν * u ν * v μ)) := by
            apply Finset.sum_congr rfl
            intro μ _
            apply Finset.sum_congr rfl
            intro ν _
            ring
        _ = Finset.sum Finset.univ (fun μ => (Finset.sum Finset.univ (fun ν => F a μ ν * u μ * v ν) - Finset.sum Finset.univ (fun ν => F a μ ν * u ν * v μ))) := by
            apply Finset.sum_congr rfl
            intro μ _
            rw [Finset.sum_sub_distrib]
        _ = Finset.sum Finset.univ (fun μ => Finset.sum Finset.univ (fun ν => F a μ ν * u μ * v ν)) - Finset.sum Finset.univ (fun μ => Finset.sum Finset.univ (fun ν => F a μ ν * u ν * v μ)) := by
            rw [Finset.sum_sub_distrib]

    -- Commute the dummy indices on the second sum
    have H_comm : Finset.sum Finset.univ (fun μ => Finset.sum Finset.univ (fun ν => F a μ ν * u ν * v μ)) =
        Finset.sum Finset.univ (fun ν => Finset.sum Finset.univ (fun μ => F a μ ν * u ν * v μ)) := by
      exact Finset.sum_comm

    -- Apply the antisymmetry of F to the commuted sum
    have H_anti : Finset.sum Finset.univ (fun ν => Finset.sum Finset.univ (fun μ => F a μ ν * u ν * v μ)) =
        - Finset.sum Finset.univ (fun ν => Finset.sum Finset.univ (fun μ => F a ν μ * u ν * v μ)) := by
      calc
        Finset.sum Finset.univ (fun ν => Finset.sum Finset.univ (fun μ => F a μ ν * u ν * v μ))
          = Finset.sum Finset.univ (fun ν => Finset.sum Finset.univ (fun μ => (- F a ν μ) * u ν * v μ)) := by
            apply Finset.sum_congr rfl
            intro x _
            apply Finset.sum_congr rfl
            intro y _
            rw [hF y x]
        _ = Finset.sum Finset.univ (fun ν => Finset.sum Finset.univ (fun μ => - (F a ν μ * u ν * v μ))) := by
            apply Finset.sum_congr rfl
            intro x _
            apply Finset.sum_congr rfl
            intro y _
            ring
        _ = Finset.sum Finset.univ (fun ν => - Finset.sum Finset.univ (fun μ => F a ν μ * u ν * v μ)) := by
            apply Finset.sum_congr rfl
            intro x _
            rw [Finset.sum_neg_distrib]
        _ = - Finset.sum Finset.univ (fun ν => Finset.sum Finset.univ (fun μ => F a ν μ * u ν * v μ)) := by
            rw [Finset.sum_neg_distrib]
    
    rw [H_sub, H_comm, H_anti]
    
    -- In characteristic 0 (Complex numbers), S - (-S) = 0 iff S = 0
    have H_alg : ∀ (S : ℂ), S - (- S) = 0 ↔ S = 0 := by
      intro S
      constructor
      · intro h
        have h2 : 2 * S = 0 := by calc
          2 * S = S - (-S) := by ring
          _ = 0 := h
        cases mul_eq_zero.mp h2 with
        | inl h_two => exact False.elim ((by norm_num : (2 : ℂ) ≠ 0) h_two)
        | inr h_S => exact h_S
      · intro h
        rw [h]
        ring
        
    -- Evaluates using alpha equivalence on the unified target sum
    exact H_alg (Finset.sum Finset.univ (fun μ => Finset.sum Finset.univ (fun ν => F a μ ν * u μ * v ν)))

end Litlib.Y1984.urbantke1984integrability
