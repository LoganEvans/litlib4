-- FILENAME: Litlib/Y1995/peres1995quantum/Chapter07/Sec03_KochenSpecker.lean


import Litlib.Core
import Mathlib.Data.Real.Basic
import Mathlib.Data.Complex.Basic
import Mathlib.Data.Matrix.Basic
import Mathlib.Algebra.BigOperators.Group.Finset.Basic

namespace Litlib.Y1995.peres1995quantum

noncomputable section

open scoped BigOperators

Litlib.equation "peres1995quantum" eq "7.26" page "199" kind "definition"
/-- Spin 1 angular momentum matrices in natural units (ħ = 1). -/
class Eq7_26_SpinOneMatrices
    (Jx Jy Jz : Matrix (Fin 3) (Fin 3) ℂ) where
  jx_def : ∀ i j, Jx i j = match i.val, j.val with
    | 1, 2 => -Complex.I
    | 2, 1 => Complex.I
    | _, _ => 0
  jy_def : ∀ i j, Jy i j = match i.val, j.val with
    | 0, 2 => Complex.I
    | 2, 0 => -Complex.I
    | _, _ => 0
  jz_def : ∀ i j, Jz i j = match i.val, j.val with
    | 0, 1 => -Complex.I
    | 1, 0 => Complex.I
    | _, _ => 0
  comm_xy : Jx * Jy - Jy * Jx = Complex.I • Jz
  comm_yz : Jy * Jz - Jz * Jy = Complex.I • Jx
  comm_zx : Jz * Jx - Jx * Jz = Complex.I • Jy

Litlib.equation "peres1995quantum" eq "7.27" page "199" kind "theorem"
/-- Squared spin 1 components commute and are diagonal. -/
class Eq7_27_SpinOneSquaredMatrices
    (Jx Jy Jz Jx2 Jy2 Jz2 : Matrix (Fin 3) (Fin 3) ℂ)
    [Eq7_26_SpinOneMatrices Jx Jy Jz] where
  jx2_def : Jx2 = Jx * Jx
  jy2_def : Jy2 = Jy * Jy
  jz2_def : Jz2 = Jz * Jz
  jx2_diag : ∀ i j, Jx2 i j = if i = j ∧ i.val ≠ 0 then 1 else 0
  jy2_diag : ∀ i j, Jy2 i j = if i = j ∧ i.val ≠ 1 then 1 else 0
  jz2_diag : ∀ i j, Jz2 i j = if i = j ∧ i.val ≠ 2 then 1 else 0
  comm_x2_y2 : Jx2 * Jy2 = Jy2 * Jx2
  comm_y2_z2 : Jy2 * Jz2 = Jz2 * Jy2
  comm_z2_x2 : Jz2 * Jx2 = Jx2 * Jz2

Litlib.equation "peres1995quantum" eq "7.28" page "200" kind "definition"
/-- Nondegenerate observable K = J_x^2 - J_y^2 with eigenvalues -1, 1, 0. -/
class Eq7_28_NondegenerateObservableK
    (Jx2 Jy2 K : Matrix (Fin 3) (Fin 3) ℂ) where
  k_def : K = Jx2 - Jy2
  k_diag : ∀ i j, K i j = match i.val, j.val with
    | 0, 0 => -1
    | 1, 1 => 1
    | _, _ => 0

Litlib.equation "peres1995quantum" eq "7.29" page "200" kind "theorem"
/-- Projector onto state m · J = 0: P_m = 1 - (m · J)^2, with components (P_m)_rs = m_r m_s. -/
class Eq7_29_SpinOneRayProjector
    (Jx Jy Jz : Matrix (Fin 3) (Fin 3) ℂ)
    (m : Fin 3 → ℝ) (hm : (∑ r, m r * m r) = 1)
    (mDotJ Pm : Matrix (Fin 3) (Fin 3) ℂ) where
  mdotj_def : mDotJ = (m 0 : ℂ) • Jx + (m 1 : ℂ) • Jy + (m 2 : ℂ) • Jz
  pm_def : Pm = 1 - mDotJ * mDotJ
  pm_components : ∀ r s, Pm r s = (m r * m s : ℂ)
  is_projector : Pm * Pm = Pm ∧ ∀ r s, Pm r s = star (Pm s r)

Litlib.equation "peres1995quantum" eq "7.30" page "200" kind "definition"
/-- Triad observable K(m, n) = (m · J)^2 - (n · J)^2 with eigenvalues -1, 0, 1. -/
class Eq7_30_TriadObservable
    (Jx Jy Jz : Matrix (Fin 3) (Fin 3) ℂ)
    (m n : Fin 3 → ℝ)
    (hm : (∑ r, m r * m r) = 1)
    (hn : (∑ r, n r * n r) = 1)
    (h_ortho : (∑ r, m r * n r) = 0)
    (Kmn : Matrix (Fin 3) (Fin 3) ℂ) where
  kmn_def :
    let mDotJ : Matrix (Fin 3) (Fin 3) ℂ :=
      (m 0 : ℂ) • Jx + (m 1 : ℂ) • Jy + (m 2 : ℂ) • Jz
    let nDotJ : Matrix (Fin 3) (Fin 3) ℂ :=
      (n 0 : ℂ) • Jx + (n 1 : ℂ) • Jy + (n 2 : ℂ) • Jz
    Kmn = mDotJ * mDotJ - nDotJ * nDotJ

Litlib.equation "peres1995quantum" eq "7.30b" page "201" kind "theorem"
/-- The Kochen-Specker parity obstruction in 4 dimensions (Table 7-2, Kernaghan 1994).
A system of 20 rays forming 11 orthogonal tetrads in ℝ^4, where each ray appears
an even number of times (2 or 4 times). Consequently, no valuation v : Rays → {0, 1}
can satisfy ∑_{r ∈ T} v(r) = 1 for all 11 tetrads. -/
class Theorem_KochenSpecker4D_Parity
    (numRays : ℕ) (hRays : numRays = 20)
    (numTetrads : ℕ) (hTetrads : numTetrads = 11)
    (tetrads : Fin numTetrads → Fin 4 → Fin numRays)
    (multiplicity : Fin numRays → ℕ) where
  tetrad_mult_def : ∀ r,
    multiplicity r =
      ∑ t : Fin numTetrads, ∑ k : Fin 4, if tetrads t k = r then 1 else 0
  even_multiplicities : ∀ r, Even (multiplicity r)
  parity_contradiction :
    ¬ ∃ v : Fin numRays → ℕ,
      (∀ r, v r = 0 ∨ v r = 1) ∧
      (∀ t : Fin numTetrads, (∑ k : Fin 4, v (tetrads t k)) = 1)

end

end Litlib.Y1995.peres1995quantum
