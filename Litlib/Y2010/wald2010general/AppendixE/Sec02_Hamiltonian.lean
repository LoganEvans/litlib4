-- FILENAME: Litlib/Y2010/wald2010general/AppendixE/Sec02_Hamiltonian.lean

import Litlib.Core
import Litlib.Y2010.wald2010general.Paper
import Mathlib.Data.Real.Basic
import Mathlib.Data.Matrix.Basic

namespace Litlib.Y2010.wald2010general

open BigOperators

Litlib.equation "wald2010general" eq "E.2.21" page "463" kind "definition"
/-- ADM Lapse Function (Wald Eq. E.2.21).
N = -g_{ab} t^a n^b, where t^a is the time flow vector and n^a is the unit
normal to the spacelike hypersurface Sigma_t. -/
class EqE_2_21
    (M : Type*)
    (g : M → Fin 4 → Fin 4 → ℝ)
    (t : M → Fin 4 → ℝ)
    (n : M → Fin 4 → ℝ)
    (lapse : M → ℝ) where
  unit_normal_timelike : ∀ (p : M),
    (∑ a : Fin 4, ∑ b : Fin 4, g p a b * n p a * n p b) = -1
  lapse_def : ∀ (p : M),
    lapse p = - ∑ a : Fin 4, ∑ b : Fin 4, g p a b * t p a * n p b
  lapse_pos : ∀ (p : M), 0 < lapse p

Litlib.equation "wald2010general" eq "E.2.22" page "463" kind "definition"
/-- ADM Shift Vector (Wald Eq. E.2.22).
N^a = h^a_b t^b, where h^a_b is the projection operator onto Sigma_t. -/
class EqE_2_22
    (M : Type*)
    (hProj : M → Fin 4 → Fin 4 → ℝ)
    (t : M → Fin 4 → ℝ)
    (shift : M → Fin 4 → ℝ) where
  shift_def : ∀ (p : M) (a : Fin 4),
    shift p a = ∑ b : Fin 4, hProj p a b * t p b

Litlib.equation "wald2010general" eq "E.2.23" page "463" kind "equation"
/-- Normal Vector in Terms of Lapse and Shift (Wald Eq. E.2.23).
n^a = (1 / N) * (t^a - N^a). -/
class EqE_2_23
    (M : Type*)
    (t : M → Fin 4 → ℝ)
    (shift : M → Fin 4 → ℝ)
    (lapse : M → ℝ)
    (n : M → Fin 4 → ℝ) where
  lapse_pos : ∀ (p : M), 0 < lapse p
  normal_from_lapse_shift : ∀ (p : M) (a : Fin 4),
    n p a = (1 / lapse p) * (t p a - shift p a)

Litlib.equation "wald2010general" eq "E.2.24" page "463" kind "equation"
/-- ADM Inverse Spacetime Metric Decomposition (Wald Eq. E.2.24).
g^{ab} = h^{ab} - n^a n^b = h^{ab} - N^{-2} (t^a - N^a)(t^b - N^b). -/
class EqE_2_24
    (M : Type*)
    (gInv : M → Fin 4 → Fin 4 → ℝ)
    (hInv : M → Fin 4 → Fin 4 → ℝ)
    (n : M → Fin 4 → ℝ) where
  metric_decomposition : ∀ (p : M) (a b : Fin 4),
    gInv p a b = hInv p a b - n p a * n p b

Litlib.equation "wald2010general" eq "E.2.30" page "464" kind "definition"
/-- Extrinsic Curvature in ADM Variables (Wald Eq. E.2.30).
K_{ab} = (1 / (2 * N)) * (h_dot_{ab} - D_a N_b - D_b N_a),
relating extrinsic curvature to the time derivative of the spatial metric and
covariant derivatives of the shift vector. -/
class EqE_2_30
    (Sigma : Type*)
    (lapse : Sigma → ℝ)
    (hDot : Sigma → Fin 3 → Fin 3 → ℝ)
    (D_shift : Sigma → Fin 3 → Fin 3 → ℝ)
    (K : Sigma → Fin 3 → Fin 3 → ℝ) where
  lapse_pos : ∀ x, 0 < lapse x
  extrinsic_curvature_eq : ∀ (x : Sigma) (a b : Fin 3),
    K x a b = (1 / (2 * lapse x)) * (hDot x a b - D_shift x a b - D_shift x b a)

Litlib.equation "wald2010general" eq "E.2.31" page "464" kind "definition"
/-- ADM Momentum Canonically Conjugate to the Spatial Metric (Wald Eq. E.2.31).
π^{ab} = delta L_G / delta h_dot_{ab} = sqrt(h) * (K^{ab} - K * h^{ab}). -/
class EqE_2_31
    (Sigma : Type*)
    (h : Sigma → Fin 3 → Fin 3 → ℝ)
    (hInv : Sigma → Fin 3 → Fin 3 → ℝ)
    (sqrtDetH : Sigma → ℝ)
    (K : Sigma → Fin 3 → Fin 3 → ℝ)
    (piMom : Sigma → Fin 3 → Fin 3 → ℝ) where
  h_inverse : ∀ (x : Sigma) (a b : Fin 3),
    (∑ c : Fin 3, h x a c * hInv x c b) = if a = b then 1 else 0
  sqrt_det_pos : ∀ x, 0 < sqrtDetH x
  momentum_def : ∀ (x : Sigma) (a b : Fin 3),
    let traceK := ∑ c : Fin 3, ∑ d : Fin 3, hInv x c d * K x c d
    let K_upper := ∑ c : Fin 3, ∑ d : Fin 3, hInv x a c * hInv x b d * K x c d
    piMom x a b = sqrtDetH x * (K_upper - traceK * hInv x a b)

Litlib.equation "wald2010general" eq "E.2.33" page "465" kind "equation"
/-- ADM Hamiltonian Constraint (Wald Eq. E.2.33).
The variation of the Hamiltonian action with respect to the lapse N yields:
h^{-1} π^{ab} π_{ab} - {}^{(3)}R - (1/2) * h^{-1} π^2 = 0. -/
class EqE_2_33
    (Sigma : Type*)
    (h : Sigma → Fin 3 → Fin 3 → ℝ)
    (hInv : Sigma → Fin 3 → Fin 3 → ℝ)
    (detH : Sigma → ℝ)
    (ricciScalar3 : Sigma → ℝ)
    (piMom : Sigma → Fin 3 → Fin 3 → ℝ) where
  det_pos : ∀ x, 0 < detH x
  h_inverse : ∀ (x : Sigma) (a b : Fin 3),
    (∑ c : Fin 3, h x a c * hInv x c b) = if a = b then 1 else 0
  hamiltonian_constraint : ∀ (x : Sigma),
    let piTrace := ∑ a : Fin 3, ∑ b : Fin 3, h x a b * piMom x a b
    let piContracted :=
      ∑ a : Fin 3, ∑ b : Fin 3, ∑ c : Fin 3, ∑ d : Fin 3,
        h x a c * h x b d * piMom x a b * piMom x c d
    let hInvDet := 1 / detH x
    hInvDet * piContracted - ricciScalar3 x - (1 / 2 : ℝ) * hInvDet * piTrace ^ 2 = 0

Litlib.equation "wald2010general" eq "E.2.34" page "465" kind "equation"
/-- ADM Momentum Constraint (Wald Eq. E.2.34).
The variation of the action with respect to the shift vector N_a yields:
D_a (h^{-1/2} π^{ab}) = 0, where D_a is the spatial covariant derivative. -/
class EqE_2_34
    (Sigma : Type*)
    (sqrtDetH : Sigma → ℝ)
    (piMom : Sigma → Fin 3 → Fin 3 → ℝ)
    (spatialDiv : (Sigma → Fin 3 → Fin 3 → ℝ) → Sigma → Fin 3 → ℝ) where
  sqrt_det_pos : ∀ x, 0 < sqrtDetH x
  momentum_constraint : ∀ (x : Sigma) (b : Fin 3),
    spatialDiv (fun y c d ↦ (1 / sqrtDetH y) * piMom y c d) x b = 0

Litlib.equation "wald2010general" eq "E.2.35" page "465" kind "equation"
/-- ADM Dynamical Evolution Equation for the Spatial Metric (Wald Eq. E.2.35).
h_dot_{ab} = 2 * h^{-1/2} * N * (π_{ab} - (1/2) * h_{ab} * π) + 2 * D_{(a} N_{b)}. -/
class EqE_2_35
    (Sigma : Type*)
    (h : Sigma → Fin 3 → Fin 3 → ℝ)
    (hInv : Sigma → Fin 3 → Fin 3 → ℝ)
    (sqrtDetH : Sigma → ℝ)
    (lapse : Sigma → ℝ)
    (piMom : Sigma → Fin 3 → Fin 3 → ℝ)
    (D_shift : Sigma → Fin 3 → Fin 3 → ℝ)
    (hDot : Sigma → Fin 3 → Fin 3 → ℝ) where
  sqrt_det_pos : ∀ x, 0 < sqrtDetH x
  lapse_pos : ∀ x, 0 < lapse x
  h_inverse : ∀ (x : Sigma) (a b : Fin 3),
    (∑ c : Fin 3, h x a c * hInv x c b) = if a = b then 1 else 0
  metric_evolution : ∀ (x : Sigma) (a b : Fin 3),
    let piTrace := ∑ c : Fin 3, ∑ d : Fin 3, h x c d * piMom x c d
    let piLower :=
      ∑ c : Fin 3, ∑ d : Fin 3, h x a c * h x b d * piMom x c d
    let symmDShift := (1 / 2 : ℝ) * (D_shift x a b + D_shift x b a)
    hDot x a b =
      2 * (1 / sqrtDetH x) * lapse x * (piLower - (1 / 2 : ℝ) * h x a b * piTrace) +
      2 * symmDShift

end Litlib.Y2010.wald2010general
