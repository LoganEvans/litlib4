-- FILENAME: Litlib/Y1973/nielsen1973vortex/Proofs/BasicCalculus.lean

import Litlib.Y1973.nielsen1973vortex.Signature
import Mathlib.Tactic.Ring
import Mathlib.Tactic.Linarith
import Mathlib.Tactic.FieldSimp
import Mathlib.Analysis.Calculus.Deriv.Basic
import Mathlib.Analysis.Calculus.Deriv.Add
import Mathlib.Analysis.Calculus.Deriv.Mul

namespace Litlib.Y1973.nielsen1973vortex.Proofs

instance verified_Eq2_19 : Eq2_19 where
  vacuumValue c₂ c₄ hc₂ hc₄ ϕ₀ hϕ₀Pos hϕ₀Sq x := by
    have hC4Neq : c₄ ≠ 0 := ne_of_gt hc₄
    have hDiff : 0 ≤ c₄ * (x^2 - c₂ / (2 * c₄))^2 := by
      have hSqPos : 0 ≤ (x^2 - c₂ / (2 * c₄))^2 := sq_nonneg _
      exact mul_nonneg (le_of_lt hc₄) hSqPos
    
    have hExpand : - c₂ * (c₂ / (2 * c₄)) + c₄ * (c₂ / (2 * c₄))^2 = - c₂^2 / (4 * c₄) := by
      field_simp; ring
      
    have hRhsExpand : - c₂^2 / (4 * c₄) + c₄ * (x^2 - c₂ / (2 * c₄))^2 = - c₂ * x^2 + c₄ * x^4 := by
      field_simp; ring

    have hPhi4 : ϕ₀^4 = (c₂ / (2 * c₄))^2 := by
      calc
        ϕ₀^4 = (ϕ₀^2)^2 := by ring
        _ = (c₂ / (2 * c₄))^2 := by rw [hϕ₀Sq]

    calc
      - c₂ * ϕ₀^2 + c₄ * ϕ₀^4
        = - c₂ * (c₂ / (2 * c₄)) + c₄ * (c₂ / (2 * c₄))^2 := by rw [hϕ₀Sq, hPhi4]
      _ = - c₂^2 / (4 * c₄) := hExpand
      _ ≤ - c₂^2 / (4 * c₄) + c₄ * (x^2 - c₂ / (2 * c₄))^2 := by linarith [hDiff]
      _ = - c₂ * x^2 + c₄ * x^4 := hRhsExpand

instance verified_Eq2_21 : Eq2_21 where
  scalarMassSq c₂ c₄ ϕ₀ hc₂ hc₄ hϕ₀Sq := by
    have hC4Neq : c₄ ≠ 0 := ne_of_gt hc₄
    let V := fun ρ => (1/2 : ℝ) * (- c₂ * (ϕ₀ + ρ)^2 + c₄ * (ϕ₀ + ρ)^4)
    
    let A := (1/2 : ℝ) * (-c₂ * ϕ₀^2 + c₄ * ϕ₀^4)
    let B := -c₂ * ϕ₀ + 2 * c₄ * ϕ₀^3
    let C := (1/2 : ℝ) * (-c₂ + 6 * c₄ * ϕ₀^2)
    let D := 2 * c₄ * ϕ₀
    let E := (1/2 : ℝ) * c₄

    have hV_eq : V = fun ρ : ℝ => A + B * ρ + C * (ρ * ρ) + D * (ρ * (ρ * ρ)) + E * ((ρ * ρ) * (ρ * ρ)) := by
      ext ρ
      unfold V
      ring

    have hdV : ∀ ρ : ℝ, HasDerivAt V (B + 2 * C * ρ + 3 * D * ρ^2 + 4 * E * ρ^3) ρ := by
      intro ρ
      rw [hV_eq]
      have hA : HasDerivAt (fun _ : ℝ => A) (0 : ℝ) ρ := hasDerivAt_const ρ A
      have hId : HasDerivAt (fun r : ℝ => r) (1 : ℝ) ρ := hasDerivAt_id ρ
      have hB := HasDerivAt.const_mul B hId
      
      have hSq := HasDerivAt.mul hId hId
      have hC_term := HasDerivAt.const_mul C hSq
      
      have hCb := HasDerivAt.mul hId hSq
      have hD_term := HasDerivAt.const_mul D hCb
      
      have hQu := HasDerivAt.mul hSq hSq
      have hE_term := HasDerivAt.const_mul E hQu
      
      have step1 := HasDerivAt.add hA hB
      have step2 := HasDerivAt.add step1 hC_term
      have step3 := HasDerivAt.add step2 hD_term
      have step4 := HasDerivAt.add step3 hE_term
      
      apply HasDerivAt.congr_deriv step4
      dsimp
      ring

    let dV := fun ρ : ℝ => B + (2 * C) * ρ + (3 * D) * (ρ * ρ) + (4 * E) * (ρ * (ρ * ρ))
    
    have h_deriv_V : deriv V = dV := by
      ext ρ
      have h_eq : B + 2 * C * ρ + 3 * D * ρ^2 + 4 * E * ρ^3 = dV ρ := by
        unfold dV; ring
      rw [← h_eq]
      exact (hdV ρ).deriv

    have hd2V : HasDerivAt dV (2 * C) (0 : ℝ) := by
      have hB_deriv : HasDerivAt (fun _ : ℝ => B) (0 : ℝ) (0 : ℝ) := hasDerivAt_const (0 : ℝ) B
      have hId : HasDerivAt (fun r : ℝ => r) (1 : ℝ) (0 : ℝ) := hasDerivAt_id (0 : ℝ)
      have hC_deriv := HasDerivAt.const_mul (2 * C) hId
      
      have hSq := HasDerivAt.mul hId hId
      have hD_deriv := HasDerivAt.const_mul (3 * D) hSq
      
      have hCb := HasDerivAt.mul hId hSq
      have hE_deriv := HasDerivAt.const_mul (4 * E) hCb
      
      have step1 := HasDerivAt.add hB_deriv hC_deriv
      have step2 := HasDerivAt.add step1 hD_deriv
      have step3 := HasDerivAt.add step2 hE_deriv
      
      apply HasDerivAt.congr_deriv step3
      dsimp
      ring

    have hd2Eval : deriv (deriv V) 0 = 6 * c₄ * ϕ₀^2 - c₂ := by
      rw [h_deriv_V]
      have h_eval : deriv dV (0 : ℝ) = 2 * C := hd2V.deriv
      rw [h_eval]
      ring

    calc
      deriv (deriv V) 0
        = 6 * c₄ * ϕ₀^2 - c₂ := hd2Eval
      _ = 6 * c₄ * (c₂ / (2 * c₄)) - c₂ := by rw [hϕ₀Sq]
      _ = 2 * c₂ := by field_simp; ring

end Litlib.Y1973.nielsen1973vortex.Proofs
