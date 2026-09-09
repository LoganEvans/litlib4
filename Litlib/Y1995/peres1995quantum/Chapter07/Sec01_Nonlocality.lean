-- FILENAME: Litlib/Y1995/peres1995quantum/Chapter07/Sec01_Nonlocality.lean


import Litlib.Core
import Mathlib.Data.Real.Basic
import Mathlib.Data.Complex.Basic
import Mathlib.Data.Matrix.Basic
import Mathlib.Algebra.BigOperators.Group.Finset.Basic

namespace Litlib.Y1995.peres1995quantum

noncomputable section

open scoped BigOperators

/-- Standard single-qubit Pauli matrices and 2x2 identity. -/
def pauliI : Matrix (Fin 2) (Fin 2) ℂ :=
  fun i j ↦ if i = j then 1 else 0

def pauliX : Matrix (Fin 2) (Fin 2) ℂ :=
  fun i j ↦ if i ≠ j then 1 else 0

def pauliY : Matrix (Fin 2) (Fin 2) ℂ :=
  fun i j ↦ match i.val, j.val with
    | 0, 1 => -Complex.I
    | 1, 0 => Complex.I
    | _, _ => 0

def pauliZ : Matrix (Fin 2) (Fin 2) ℂ :=
  fun i j ↦ match i.val, j.val with
    | 0, 0 => 1
    | 1, 1 => -1
    | _, _ => 0

/-- Kronecker tensor product of two 2x2 matrices. -/
def kron2 (A B : Matrix (Fin 2) (Fin 2) ℂ) :
    Matrix (Fin 2 × Fin 2) (Fin 2 × Fin 2) ℂ :=
  fun (i₁, j₁) (i₂, j₂) ↦ A i₁ i₂ * B j₁ j₂

Litlib.equation "peres1995quantum" eq "7.1" page "189" kind "theorem"
/-- Mermin-Peres magic square array of 9 observables on two qubits.
In each row and each column, the three operators commute. The product of
operators in each row is 1, and in each column is 1, except for the third
column whose product is -1. Consequently, no classical valuation into {-1, 1}
can reproduce these algebraic product rules. -/
class Eq7_1_MerminPeresSquare
    (A : Fin 3 → Fin 3 → Matrix (Fin 2 × Fin 2) (Fin 2 × Fin 2) ℂ) where
  row0_col0 : A 0 0 = kron2 pauliI pauliZ
  row0_col1 : A 0 1 = kron2 pauliZ pauliI
  row0_col2 : A 0 2 = kron2 pauliZ pauliZ
  row1_col0 : A 1 0 = kron2 pauliX pauliI
  row1_col1 : A 1 1 = kron2 pauliI pauliX
  row1_col2 : A 1 2 = kron2 pauliX pauliX
  row2_col0 : A 2 0 = kron2 pauliX pauliZ
  row2_col1 : A 2 1 = kron2 pauliZ pauliX
  row2_col2 : A 2 2 = kron2 pauliY pauliY
  row_comm : ∀ i j k, A i j * A i k = A i k * A i j
  col_comm : ∀ i j k, A i k * A j k = A j k * A i k
  row_product : ∀ i, A i 0 * A i 1 = A i 2
  col_product_0 : A 0 0 * A 1 0 = A 2 0
  col_product_1 : A 0 1 * A 1 1 = A 2 1
  col_product_2 : A 0 2 * A 1 2 = - A 2 2
  no_classical_valuation :
    ¬ ∃ v : Fin 3 → Fin 3 → ℝ,
      (∀ i j, v i j = 1 ∨ v i j = -1) ∧
      (∀ i, v i 0 * v i 1 = v i 2) ∧
      (v 0 0 * v 1 0 = v 2 0) ∧
      (v 0 1 * v 1 1 = v 2 1) ∧
      (v 0 2 * v 1 2 = - v 2 2)

Litlib.equation "peres1995quantum" eq "7.2" page "189" kind "theorem"
/-- Algebraic product rule for row 2: (σ_x ⊗ σ_z)(σ_z ⊗ σ_x) = σ_y ⊗ σ_y. -/
class Eq7_2_MerminRowProduct
    (op1 op2 op3 : Matrix (Fin 2 × Fin 2) (Fin 2 × Fin 2) ℂ) where
  op1_def : op1 = kron2 pauliX pauliZ
  op2_def : op2 = kron2 pauliZ pauliX
  op3_def : op3 = kron2 pauliY pauliY
  prod_eq : op1 * op2 = op3

Litlib.equation "peres1995quantum" eq "7.3" page "189" kind "theorem"
/-- Algebraic product rule for column 2: (σ_z ⊗ σ_z)(σ_x ⊗ σ_x) = - σ_y ⊗ σ_y. -/
class Eq7_3_MerminColProduct
    (op1 op2 op3 : Matrix (Fin 2 × Fin 2) (Fin 2 × Fin 2) ℂ) where
  op1_def : op1 = kron2 pauliZ pauliZ
  op2_def : op2 = kron2 pauliX pauliX
  op3_def : op3 = kron2 pauliY pauliY
  prod_eq : op1 * op2 = - op3

end

end Litlib.Y1995.peres1995quantum
