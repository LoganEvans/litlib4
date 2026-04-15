-- FILENAME: Litlib/Y1979/duan1979su2/Proofs/Original.lean

import Mathlib.Data.Matrix.Basic
import Mathlib.Data.Complex.Basic
import Mathlib.Tactic.Ring
import Mathlib.Tactic.FinCases
import Mathlib.Algebra.BigOperators.Group.Finset.Basic
import Mathlib.Algebra.BigOperators.Fin

open Matrix Complex BigOperators

namespace Litlib.Y1979.duan1979su2.Proofs.Original

variable {m : Type*} [Fintype m]

lemma smulMulSmulC (c : Complex) (A B : Matrix m m Complex) :
  (c • A) * (c • B) = (c * c) • (A * B) := by
  calc (c • A) * (c • B)
    _ = c • (A * (c • B)) := by rw[Matrix.smul_mul]
    _ = c • (c • (A * B)) := by rw[Matrix.mul_smul]
    _ = (c * c) • (A * B) := by rw[smul_smul]

lemma choDuanCurvature [DecidableEq m]
  (n u v : Matrix m m Complex)
  (c g : Complex)
  (hNSq : n * n = 1)
  (hNu : n * u = - (u * n))
  (hNv : n * v = - (v * n)) :
  let bU := c • (n * u)
  let bV := c • (n * v)
  let curl := c • (u * v - v * u)
  let comm := bU * bV - bV * bU
  curl + g • comm = (c - g * c^2) • (u * v - v * u) := by

  intros bU bV curl comm

  have hNuNv : (n * u) * (n * v) = - (u * v) := by
    calc (n * u) * (n * v)
      _ = -(u * n) * (n * v) := by rw[hNu]
      _ = - ((u * n) * (n * v)) := by exact neg_mul _ _
      _ = - (u * (n * (n * v))) := by rw[Matrix.mul_assoc]
      _ = - (u * ((n * n) * v)) := by rw[← Matrix.mul_assoc n n v]
      _ = - (u * (1 * v)) := by rw[hNSq]
      _ = - (u * v) := by rw[Matrix.one_mul]

  have hNvNu : (n * v) * (n * u) = - (v * u) := by
    calc (n * v) * (n * u)
      _ = -(v * n) * (n * u) := by rw[hNv]
      _ = - ((v * n) * (n * u)) := by exact neg_mul _ _
      _ = - (v * (n * (n * u))) := by rw[Matrix.mul_assoc]
      _ = - (v * ((n * n) * u)) := by rw[← Matrix.mul_assoc n n u]
      _ = - (v * (1 * u)) := by rw[hNSq]
      _ = - (v * u) := by rw[Matrix.one_mul]

  have hComm : comm = (- (c * c)) • (u * v - v * u) := by
    dsimp[comm, bU, bV]
    rw[smulMulSmulC c (n * u) (n * v)]
    rw[smulMulSmulC c (n * v) (n * u)]
    rw[hNuNv, hNvNu]

    have step1 : (c * c) • -(u * v) - (c * c) • -(v * u) = -((c * c) • (u * v)) + (c * c) • (v * u) := by
      rw[smul_neg, smul_neg, sub_neg_eq_add]
    have step2 : -((c * c) • (u * v)) + (c * c) • (v * u) = (c * c) • (v * u) - (c * c) • (u * v) := by
      exact add_comm _ _
    have step3 : (c * c) • (v * u) - (c * c) • (u * v) = (c * c) • (v * u - u * v) := by
      exact (smul_sub _ _ _).symm
    have step4 : v * u - u * v = -(u * v - v * u) := by
      exact (neg_sub (u * v) (v * u)).symm
    have step5 : (c * c) • -(u * v - v * u) = -((c * c) • (u * v - v * u)) := by
      exact smul_neg _ _
    have step6 : -((c * c) • (u * v - v * u)) = (-(c * c)) • (u * v - v * u) := by
      exact (neg_smul _ _).symm

    rw[step1, step2, step3, step4, step5, step6]

  calc curl + g • comm
    _ = c • (u * v - v * u) + g • ((- (c * c)) • (u * v - v * u)) := by rw[hComm]
    _ = c • (u * v - v * u) + (g * - (c * c)) • (u * v - v * u) := by rw[smul_smul]
    _ = (c + g * - (c * c)) • (u * v - v * u) := by rw[add_smul]
    _ = (c - g * c^2) • (u * v - v * u) := by
       have : c + g * - (c * c) = c - g * c^2 := by ring
       rw [this]

/-- The 2x2 Pauli matrices, safely defined with Nat pattern matching -/
def s1 : Matrix (Fin 2) (Fin 2) Complex :=
  fun i j =>
    if i.val = 0 ∧ j.val = 1 then 1
    else if i.val = 1 ∧ j.val = 0 then 1
    else 0

def s2 : Matrix (Fin 2) (Fin 2) Complex :=
  fun i j =>
    if i.val = 0 ∧ j.val = 1 then -I
    else if i.val = 1 ∧ j.val = 0 then I
    else 0

def s3 : Matrix (Fin 2) (Fin 2) Complex :=
  fun i j =>
    if i.val = 0 ∧ j.val = 0 then 1
    else if i.val = 1 ∧ j.val = 1 then -1
    else 0

/-- Explicitly unroll a sum over Fin 2 -/
lemma sumFin2 (f : Fin 2 → Complex) : ∑ i : Fin 2, f i = f 0 + f 1 := by
  rw[Fin.sum_univ_castSucc, Fin.sum_univ_castSucc]
  simp

/-- Explicitly unroll 2x2 matrix multiplication using canonical sum expansion -/
lemma evalMul2x2 (A B : Matrix (Fin 2) (Fin 2) Complex) (i j : Fin 2) :
  (A * B) i j = A i 0 * B 0 j + A i 1 * B 1 j := by
  rw[Matrix.mul_apply, sumFin2]

theorem choDuanCurvatureNonzero :
  ∃ (n u v : Matrix (Fin 2) (Fin 2) Complex) (c g : Complex),
    n * n = 1 ∧
    n * u = - (u * n) ∧
    n * v = - (v * n) ∧
    (c - g * c^2) • (u * v - v * u) ≠ 0 := by
  use s3, s1, s2, 2, 0

  have hNSq : s3 * s3 = 1 := by
    ext i j
    fin_cases i <;> fin_cases j <;>
    simp[s3, evalMul2x2]

  have hNu : s3 * s1 = - (s1 * s3) := by
    ext i j
    fin_cases i <;> fin_cases j <;>
    simp[s3, s1, evalMul2x2]

  have hNv : s3 * s2 = - (s2 * s3) := by
    ext i j
    fin_cases i <;> fin_cases j <;>
    simp[s3, s2, evalMul2x2]

  refine ⟨hNSq, hNu, hNv, ?_⟩

  intro hEq
  have hContra : ((2 - 0 * 2^2 : Complex) • (s1 * s2 - s2 * s1)) 0 0 = 0 := by
    rw[hEq]
    rfl

  have hS1S2 : (s1 * s2) 0 0 = Complex.I := by
    simp[s1, s2, evalMul2x2]

  have hS2S1 : (s2 * s1) 0 0 = -Complex.I := by
    simp[s1, s2, evalMul2x2]

  have hEval : ((2 - 0 * 2^2 : Complex) • (s1 * s2 - s2 * s1)) 0 0 = 4 * I := by
    have hc : (2 - 0 * (2:Complex)^2) = 2 := by ring
    have hsub : (s1 * s2 - s2 * s1) 0 0 = (s1 * s2) 0 0 - (s2 * s1) 0 0 := rfl
    rw[Matrix.smul_apply, hc, hsub, hS1S2, hS2S1]
    change (2 : Complex) * (I - -I) = 4 * I
    ring

  rw[hEval] at hContra

  have h4I : (4 : Complex) * I ≠ 0 := by
    intro h
    have hIm : ((4 : Complex) * I).im = 0 := by rw [h]; rfl
    have hImEval : ((4 : Complex) * I).im = 4 := by
      have h1 : ((4:Complex) * I).im = (4:Complex).re * I.im + (4:Complex).im * I.re := rfl
      have h2 : (4:Complex).re = 4 := rfl
      have h3 : (4:Complex).im = 0 := rfl
      have h4 : I.im = 1 := rfl
      have h5 : I.re = 0 := rfl
      rw[h1, h2, h3, h4, h5]
      ring
    rw[hImEval] at hIm
    norm_num at hIm

  exact h4I hContra

end Litlib.Y1979.duan1979su2.Proofs.Original
