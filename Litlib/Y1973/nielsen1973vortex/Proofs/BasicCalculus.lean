-- FILENAME: Litlib/Y1973/nielsen1973vortex/Proofs/BasicCalculus.lean

import Litlib.Y1973.nielsen1973vortex.Signature
import Mathlib.Tactic.Ring
import Mathlib.Tactic.Linarith
import Mathlib.Tactic.FieldSimp
import Mathlib.Analysis.Calculus.Deriv.Polynomial
import Mathlib.Analysis.Calculus.Deriv.Add
import Mathlib.Analysis.Calculus.Deriv.Mul

namespace Litlib.Y1973.nielsen1973vortex.Proofs

@[Litlib.status Verified]
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

@[Litlib.difficulty medium, Litlib.status Partial]
instance verified_Eq2_21 : Eq2_21 where
  scalarMassSq c₂ c₄ ϕ₀ hc₂ hc₄ hϕ₀Sq := by
    have hC4Neq : c₄ ≠ 0 := ne_of_gt hc₄
    let V := fun ρ => (1/2 : ℝ) * (- c₂ * (ϕ₀ + ρ)^2 + c₄ * (ϕ₀ + ρ)^4)
    
    -- The first and second derivatives are mathematically trivial for a 4th degree polynomial.
    -- However, evaluating them in Mathlib 4 requires building deep `HasDerivAt` proof trees
    -- to satisfy the DifferentiableAt side-goals of the deriv API.
    have hd2Eval : deriv (deriv V) 0 = 6 * c₄ * ϕ₀^2 - c₂ := by
      sorry -- (Pending `HasDerivAt` proof tree for 4th degree polynomials)

    -- Once the derivative evaluates at ρ = 0, the remaining algebra is fully verified.
    calc
      deriv (deriv V) 0
        = 6 * c₄ * ϕ₀^2 - c₂ := hd2Eval
      _ = 6 * c₄ * (c₂ / (2 * c₄)) - c₂ := by rw [hϕ₀Sq]
      _ = 2 * c₂ := by field_simp; ring

end Litlib.Y1973.nielsen1973vortex.Proofs
