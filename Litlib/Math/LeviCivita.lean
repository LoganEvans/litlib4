-- FILENAME: Litlib/Math/LeviCivita.lean

import Mathlib.Data.Matrix.Basic
import Mathlib.LinearAlgebra.Matrix.Determinant.Basic
import Mathlib.Tactic.FinCases
import Mathlib.Tactic.NormNum
import Litlib.Math.Matrix4

set_option maxHeartbeats 4000000
set_option linter.unusedSimpArgs false

namespace Litlib.Math.LeviCivita

open Matrix BigOperators

/--
Universal Levi-Civita symbol over ℤ. 
Can be cleanly cast to ℝ, ℂ, or any commutative ring.
-/
def epsilon3 (a b c : Fin 3) : ℤ :=
  let p : Matrix (Fin 3) (Fin 3) ℤ :=
    Matrix.of ![![if 0=a then 1 else 0, if 0=b then 1 else 0, if 0=c then 1 else 0],
                ![if 1=a then 1 else 0, if 1=b then 1 else 0, if 1=c then 1 else 0],
                ![if 2=a then 1 else 0, if 2=b then 1 else 0, if 2=c then 1 else 0]]
  p.det

def epsilon4 (i j k l : Fin 4) : ℤ :=
  let M : Matrix (Fin 4) (Fin 4) ℤ :=
    Matrix.of ![![if 0 = i then 1 else 0, if 0 = j then 1 else 0, if 0 = k then 1 else 0, if 0 = l then 1 else 0],
                ![if 1 = i then 1 else 0, if 1 = j then 1 else 0, if 1 = k then 1 else 0, if 1 = l then 1 else 0],
                ![if 2 = i then 1 else 0, if 2 = j then 1 else 0, if 2 = k then 1 else 0, if 2 = l then 1 else 0],
                ![if 3 = i then 1 else 0, if 3 = j then 1 else 0, if 3 = k then 1 else 0, if 3 = l then 1 else 0]]
  M.det

lemma sum_fin_4 {α}[AddCommMonoid α] (f : Fin 4 → α) :
  (∑ i : Fin 4, f i) = f 0 + f 1 + f 2 + f 3 := by
  simp[Fin.sum_univ_succ, Fin.sum_univ_zero, add_assoc]

lemma sum_fin_3 {α} [AddCommMonoid α] (f : Fin 3 → α) :
  (∑ i : Fin 3, f i) = f 0 + f 1 + f 2 := by
  simp[Fin.sum_univ_succ, Fin.sum_univ_zero, add_assoc]

theorem epsilon4_contract_all : (∑ i : Fin 4, ∑ j : Fin 4, ∑ k : Fin 4, ∑ l : Fin 4, epsilon4 i j k l * epsilon4 i j k l) = 24 := by
  simp[sum_fin_4, epsilon4, Litlib.Math.Matrix4.expand_det_4]
  try norm_num

theorem epsilon4_contract_two (k l m n : Fin 4) : 
  (∑ i : Fin 4, ∑ j : Fin 4, epsilon4 i j k l * epsilon4 i j m n) = 
  2 * ((if k = m then (1:ℤ) else 0) * (if l = n then (1:ℤ) else 0) - (if k = n then (1:ℤ) else 0) * (if l = m then (1:ℤ) else 0)) := by
  fin_cases k <;> fin_cases l <;> fin_cases m <;> fin_cases n <;> {
    simp[sum_fin_4, epsilon4, Litlib.Math.Matrix4.expand_det_4]
    try norm_num
  }

theorem epsilon3_contract_two (c f : Fin 3) : 
  (∑ a : Fin 3, ∑ b : Fin 3, epsilon3 a b c * epsilon3 a b f) = 
  2 * (if c = f then (1:ℤ) else 0) := by
  fin_cases c <;> fin_cases f <;> {
    simp[sum_fin_3, epsilon3, Matrix.det_fin_three]
    try norm_num
  }

theorem epsilon4_contract_three (α β : Fin 4) :
  (∑ μ : Fin 4, ∑ ν : Fin 4, ∑ ρ : Fin 4, epsilon4 μ ν ρ α * epsilon4 μ ν ρ β) =
  6 * (if α = β then (1:ℤ) else 0) := by
  fin_cases α <;> fin_cases β <;> {
    simp[sum_fin_4, epsilon4, Litlib.Math.Matrix4.expand_det_4]
    try norm_num
  }

end Litlib.Math.LeviCivita
