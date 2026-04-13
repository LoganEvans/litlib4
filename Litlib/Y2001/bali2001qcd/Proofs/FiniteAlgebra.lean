-- FILENAME: Litlib/Y2001/bali2001qcd/Proofs/FiniteAlgebra.lean

import Litlib.Y2001.bali2001qcd.Signature
import Mathlib.Tactic.FieldSimp
import Mathlib.Tactic.Ring

namespace Litlib.Y2001.bali2001qcd.Proofs

@[litlib_difficulty easy, litlib_status Verified]
instance verified_Eq2_3_and_2_4 : Eq2_3_and_2_4 where
  string_mass_and_ang_mom d σ m J hd hσ hm hJ := by
    rw [hm, hJ]
    have h_sigma_neq : σ ≠ 0 := ne_of_gt hσ
    have h_pi_neq : Real.pi ≠ 0 := Real.pi_ne_zero
    field_simp
    try ring

@[litlib_difficulty easy, litlib_status Verified]
instance verified_Eq4_40 : Eq4_40 where
  singlet_octet_potentials N N_A g q hN hN_A hq := by
    have h_N_neq : N ≠ 0 := by linarith
    have h_NA_neq : N_A ≠ 0 := by 
      rw [hN_A]
      nlinarith
    -- V_o = - (1 / N_A) * V_s
    dsimp only
    field_simp
    try ring

@[litlib_difficulty easy, litlib_status Verified]
instance verified_Eq5_11 : Eq5_11 where
  adjoint_self_energy N C_A C_F V_self hN hC_A hC_F := by
    have h_N_neq : N ≠ 0 := by linarith
    have h_NA_neq : N^2 - 1 ≠ 0 := by nlinarith
    have h_CF_neq : C_F ≠ 0 := by
      rw [hC_F]
      intro h_zero
      have h_num := div_eq_zero_iff.mp h_zero
      rcases h_num with h1 | h2
      · nlinarith
      · nlinarith
    rw [hC_A, hC_F]
    field_simp
    try ring

@[litlib_difficulty easy, litlib_status Verified]
instance verified_Eq6_48_to_6_50 : Eq6_48_to_6_50 where
  gromes_and_bbp_relations e h σ V_self C_b C_d := by
    constructor
    · -- V_2_prime - V_1_prime = V_0_prime
      intro r hr
      dsimp only
      field_simp
      try ring
    · constructor
      · -- V_b + 2 * V_d = (r / 6) * V_0_prime - (1 / 2) * V_0
        intro hV r hr
        dsimp only
        rw [hV]
        field_simp
        try ring
      · -- V_c + 2 * V_e = - (r / 2) * V_0_prime
        intro r hr
        dsimp only
        field_simp
        try ring

end Litlib.Y2001.bali2001qcd.Proofs
