-- FILENAME: Litlib/Y2012/lee2012smooth/Chapter16/Sec07_Problems.lean

import Mathlib
import Litlib.Core

-- Explicit definition outside the class prevents the "Default Override" exploit.
noncomputable def problem16_9_omega (n : ℕ) (x : Fin (n + 1) → ℝ) (v : Fin n → (Fin (n + 1) → ℝ)) : ℝ :=
  let norm_x := Real.sqrt (∑ i : Fin (n + 1), x i ^ 2)
  -- Fin.succAbove skips the i-th row, perfectly modeling the omitted wedge component ̂dx^i
  let wedgeOmitted (i : Fin (n + 1)) : ℝ := 
    Matrix.det (fun (r c : Fin n) => v c (i.succAbove r))
  (norm_x ^ (-(n + 1 : ℝ))) * 
  (∑ i : Fin (n + 1), (-1 : ℝ) ^ (i.val) * x i * wedgeOmitted i)

Litlib.equation "lee2012smooth" eq "16.22" page "435" kind "problem"
class Problem_16_9
  (n : ℕ)
  where
  -- ι_{S^n}^* ω is the Riemannian volume form of S^n.
  -- This means if x is on the unit sphere, and v is an oriented orthonormal frame 
  -- in the tangent space of S^n at x, the hardcoded form evaluates to 1.
  pullbackIsVolumeForm :
    ∀ (x : Fin (n + 1) → ℝ) (v : Fin n → (Fin (n + 1) → ℝ)),
      (∑ i, x i ^ 2) = 1 → 
      (∀ c, ∑ i, x i * v c i = 0) → 
      (∀ c d, ∑ i, v c i * v d i = if c = d then 1 else 0) → 
      let aug : Fin (n + 1) → Fin (n + 1) → ℝ := Fin.cons x v;
      Matrix.det (fun (r c : Fin (n + 1)) => aug c r) = 1 →
      problem16_9_omega n x v = 1
