-- FILENAME: Litlib/Y2012/lee2013introduction/Chapter15/Sec03_RiemannianVolumeForm.lean

import Mathlib
import Litlib.Core

namespace Litlib.Y2012.lee2013introduction

Litlib.equation "lee2013introduction" eq "15.29" page "389" kind "proposition"
class Proposition_15_29
  (n : ℕ)
  (M : Type*)
  (TM : M → Type*)
  (innerProd : (p : M) → TM p → TM p → ℝ)
  (isOriented : (p : M) → (Fin n → TM p) → Prop)
  (omega_g : (p : M) → (Fin n → TM p) → ℝ)
  where
  n_ge_1 : n ≥ 1
  isAlternating : ∀ p (v : Fin n → TM p) (i j : Fin n),
    i ≠ j → v i = v j → omega_g p v = 0
  evalsToOne : ∀ p (e : Fin n → TM p),
    isOriented p e →
    (∀ i j, innerProd p (e i) (e j) = if i = j then 1 else 0) →
    omega_g p e = 1

Litlib.equation "lee2013introduction" eq "15.31" page "389" kind "proposition"
class Proposition_15_31
  (n : ℕ)
  (g : Matrix (Fin n) (Fin n) ℝ)
  (v : Fin n → (Fin n → ℝ))
  (omega_g_eval : ℝ)
  where
  n_ge_1 : n ≥ 1
  isPosDef : g.PosDef
  -- ω_g = sqrt(det(g)) dx^1 ^ ... ^ dx^n
  -- Evaluated on a local coordinate frame `v` (where `v i j` is the j-th component of vector i),
  -- the wedge product evaluates to the determinant of the component matrix.
  omegaCoordExpr :
    omega_g_eval = Real.sqrt (g.det) * Matrix.det (fun (i j : Fin n) => v j i)

Litlib.equation "lee2013introduction" eq "15.32" page "390" kind "proposition"
class Proposition_15_32
  (n : ℕ)
  (omega_g : (Fin (n + 1) → (Fin (n + 1) → ℝ)) → ℝ)
  (N : Fin (n + 1) → ℝ)
  (omega_g_tilde : (Fin n → (Fin (n + 1) → ℝ)) → ℝ)
  where
  -- ω_g_tilde = i_S^* (N ⌟ ω_g)
  -- Evaluated on n tangent vectors v_1 ... v_n on the hypersurface, 
  -- this corresponds exactly to ω_g evaluated on (N, v_1, ..., v_n).
  -- Lean 4's `Fin.cons` prepends N to the frame perfectly.
  inducedVol : ∀ (v : Fin n → (Fin (n + 1) → ℝ)),
    omega_g_tilde v = omega_g (Fin.cons N v)

end Litlib.Y2012.lee2013introduction
