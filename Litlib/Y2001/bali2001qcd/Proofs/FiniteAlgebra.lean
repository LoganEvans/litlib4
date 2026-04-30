-- FILENAME: Litlib/Y2001/bali2001qcd/Proofs/FiniteAlgebra.lean

import Litlib.Y2001.bali2001qcd.Signature
import Mathlib.Tactic.FieldSimp
import Mathlib.Tactic.Ring

namespace Litlib.Y2001.bali2001qcd.Proofs

instance verified_Eq2_3_and_2_4 : Eq2_3_and_2_4 where
  stringMassAndAngMom d σ m J hD hSigma hM hJ := by
    rw [hM, hJ]
    have hSigmaNeq : σ ≠ 0 := ne_of_gt hSigma
    have hPiNeq : Real.pi ≠ 0 := Real.pi_ne_zero
    field_simp
    try ring

instance verified_Eq4_40 : Eq4_40 where
  singletOctetPotentials N nA g q hN hNa hQ := by
    have hNNeq : N ≠ 0 := by linarith
    have hNaNeq : nA ≠ 0 := by 
      rw [hNa]
      nlinarith
    -- vO = - (1 / nA) * vS
    dsimp only
    field_simp
    try ring

instance verified_Eq5_11 : Eq5_11 where
  adjointSelfEnergy N cA cF vSelf hN hCa hCf := by
    have hNNeq : N ≠ 0 := by linarith
    have hNaNeq : N^2 - 1 ≠ 0 := by nlinarith
    have hCfNeq : cF ≠ 0 := by
      rw [hCf]
      intro h_zero
      have h_num := div_eq_zero_iff.mp h_zero
      rcases h_num with h1 | h2
      · nlinarith
      · nlinarith
    rw [hCa, hCf]
    field_simp
    try ring

instance verified_Eq6_48_to_6_50 : Eq6_48_to_6_50 where
  gromesAndBbpRelations e h σ vSelf cB cD := by
    constructor
    · -- v2Prime - v1Prime = v0Prime
      intro r hR
      dsimp only
      field_simp
      try ring
    · constructor
      · -- vB + 2 * vD = (r / 6) * v0Prime - (1 / 2) * v0
        intro hV r hR
        dsimp only
        rw [hV]
        field_simp
        try ring
      · -- vC + 2 * vE = - (r / 2) * v0Prime
        intro r hR
        dsimp only
        field_simp
        try ring

end Litlib.Y2001.bali2001qcd.Proofs
