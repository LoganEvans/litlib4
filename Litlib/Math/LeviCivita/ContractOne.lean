-- FILENAME: Litlib/Math/LeviCivita/ContractOne.lean

import Litlib.Math.LeviCivita.Basic
import Mathlib.Data.Complex.Basic

namespace Litlib.Math.LeviCivita

open BigOperators

/-- Pure computable Kronecker delta over the integers. -/
def kroneckerDelta (i j : Fin 4) : ℤ := if i = j then 1 else 0

/--
The 3x3 determinant of Kronecker deltas (6 terms).
Represents the exact topological expansion of the generalized Kronecker Delta δ^{αβγ}_{ρστ}.
-/
def generalizedDelta3 (a b c ρ σ τ : Fin 4) : ℤ :=
  kroneckerDelta a ρ * kroneckerDelta b σ * kroneckerDelta c τ
  + kroneckerDelta a σ * kroneckerDelta b τ * kroneckerDelta c ρ
  + kroneckerDelta a τ * kroneckerDelta b ρ * kroneckerDelta c σ
  - kroneckerDelta a ρ * kroneckerDelta b τ * kroneckerDelta c σ
  - kroneckerDelta a σ * kroneckerDelta b ρ * kroneckerDelta c τ
  - kroneckerDelta a τ * kroneckerDelta b σ * kroneckerDelta c ρ

/-- O(1) matching for epsilon4 to allow fast kernel evaluation. -/
def epsilon4_fast : Fin 4 → Fin 4 → Fin 4 → Fin 4 → ℤ
| 0, 1, 2, 3 => 1
| 0, 2, 3, 1 => 1
| 0, 3, 1, 2 => 1
| 1, 0, 3, 2 => 1
| 1, 2, 0, 3 => 1
| 1, 3, 2, 0 => 1
| 2, 0, 1, 3 => 1
| 2, 1, 3, 0 => 1
| 2, 3, 0, 1 => 1
| 3, 0, 2, 1 => 1
| 3, 1, 0, 2 => 1
| 3, 2, 1, 0 => 1
| 0, 1, 3, 2 => -1
| 0, 2, 1, 3 => -1
| 0, 3, 2, 1 => -1
| 1, 0, 2, 3 => -1
| 1, 2, 3, 0 => -1
| 1, 3, 0, 2 => -1
| 2, 0, 3, 1 => -1
| 2, 1, 0, 3 => -1
| 2, 3, 1, 0 => -1
| 3, 0, 1, 2 => -1
| 3, 1, 2, 0 => -1
| 3, 2, 0, 1 => -1
| _, _, _, _ => 0

/-- Equivalence between matrix determinant and fast definition. -/
lemma epsilon4_eq_fast (i j k l : Fin 4) : epsilon4 i j k l = epsilon4_fast i j k l := by
  revert i j k l
  decide

/--
Evaluates the single-index contraction of the 4D Levi-Civita symbol.
Uses `decide` on the fast version to compute all 4,096 combinations securely in the kernel.
-/
theorem epsilon4_contract_one (α β γ ρ σ τ : Fin 4) :
  (∑ μ : Fin 4, epsilon4 μ α β γ * epsilon4 μ ρ σ τ) =
  generalizedDelta3 α β γ ρ σ τ := by
  simp only [epsilon4_eq_fast, sum_fin_4]
  revert α β γ ρ σ τ
  decide

/-- Complex-casted version for use in subsequent metric contractions. -/
lemma epsilon4_contract_one_complex (α β γ ρ σ τ : Fin 4) :
  (∑ μ : Fin 4, (epsilon4 μ α β γ : ℂ) * (epsilon4 μ ρ σ τ : ℂ)) =
  (generalizedDelta3 α β γ ρ σ τ : ℂ) := by
  rw [← epsilon4_contract_one α β γ ρ σ τ]
  push_cast
  rfl

end Litlib.Math.LeviCivita
