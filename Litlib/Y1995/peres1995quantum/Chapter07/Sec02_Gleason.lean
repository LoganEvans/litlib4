-- FILENAME: Litlib/Y1995/peres1995quantum/Chapter07/Sec02_Gleason.lean


import Litlib.Core
import Mathlib.Data.Real.Basic
import Mathlib.Data.Real.Sqrt
import Mathlib.Data.Complex.Basic
import Mathlib.Data.Matrix.Basic
import Mathlib.Data.Int.Interval
import Mathlib.LinearAlgebra.Matrix.Trace
import Mathlib.Analysis.SpecialFunctions.Exp
import Mathlib.Analysis.SpecialFunctions.Trigonometric.Basic
import Mathlib.Algebra.BigOperators.Group.Finset.Basic
import Mathlib.Algebra.BigOperators.Ring.Finset

namespace Litlib.Y1995.peres1995quantum

noncomputable section

open scoped BigOperators

Litlib.equation "peres1995quantum" eq "7.4" page "190" kind "theorem"
/-- Gleason's expectation rule: ⟨P⟩ = Tr(ρ P) for a density operator ρ. -/
class Eq7_4_GleasonExpectation
    (d : ℕ) (hd : 3 ≤ d)
    (ρ P : Matrix (Fin d) (Fin d) ℂ)
    (expVal : ℝ) where
  rho_trace_one : (Matrix.trace ρ).re = 1
  rho_pos_semidef : ∀ v : Fin d → ℂ, 0 ≤ (∑ i, ∑ j, star (v i) * ρ i j * v j).re
  p_proj : P * P = P ∧ Matrix.conjTranspose P = P
  exp_val_eq : expVal = (Matrix.trace (ρ * P)).re

Litlib.equation "peres1995quantum" eq "7.5" page "191" kind "theorem"
/-- Postulate γ: additivity of expectation values for orthogonal projectors. -/
class Eq7_5_OrthogonalProjectorAdditivity
    (d : ℕ)
    (Pu Pv Puv : Matrix (Fin d) (Fin d) ℂ)
    (expVal : Matrix (Fin d) (Fin d) ℂ → ℝ) where
  pu_proj : Pu * Pu = Pu ∧ Matrix.conjTranspose Pu = Pu
  pv_proj : Pv * Pv = Pv ∧ Matrix.conjTranspose Pv = Pv
  orthogonal : Pu * Pv = 0
  puv_sum : Puv = Pu + Pv
  puv_proj : Puv * Puv = Puv ∧ Matrix.conjTranspose Puv = Puv
  exp_add : expVal Puv = expVal Pu + expVal Pv

Litlib.equation "peres1995quantum" eq "7.6" page "191" kind "definition"
/-- Rotated orthonormal pair constructed from orthonormal vectors u and v. -/
class Eq7_6_RotatedOrthonormalPair
    (d : ℕ)
    (u v x y : Fin d → ℂ) where
  x_def : ∀ i, x i = (u i + v i) / (Real.sqrt 2 : ℂ)
  y_def : ∀ i, y i = (u i - v i) / (Real.sqrt 2 : ℂ)

Litlib.equation "peres1995quantum" eq "7.7" page "191" kind "theorem"
/-- Projector sum identity P_x + P_y = P_u + P_v for rotated vectors. -/
class Eq7_7_ProjectorSumIdentity
    (d : ℕ)
    (u v x y : Fin d → ℂ)
    (Pu Pv Px Py : Matrix (Fin d) (Fin d) ℂ)
    [Eq7_6_RotatedOrthonormalPair d u v x y] where
  pu_def : ∀ i j, Pu i j = u i * star (u j)
  pv_def : ∀ i j, Pv i j = v i * star (v j)
  px_def : ∀ i j, Px i j = x i * star (x j)
  py_def : ∀ i j, Py i j = y i * star (y j)
  sum_eq : Px + Py = Pu + Pv

Litlib.equation "peres1995quantum" eq "7.8" page "191" kind "theorem"
/-- Non-trivial physical identity for expectations of rotated projectors. -/
class Eq7_8_ProjectorExpectationIdentity
    (d : ℕ)
    (Pu Pv Px Py : Matrix (Fin d) (Fin d) ℂ)
    (expVal : Matrix (Fin d) (Fin d) ℂ → ℝ) where
  exp_sum_eq : expVal Px + expVal Py = expVal Pu + expVal Pv

Litlib.equation "peres1995quantum" eq "7.9" page "191" kind "theorem"
/-- Spin 1 observable identity: J_z^2 = (J_x^2 - J_y^2)^2. -/
class Eq7_9_SpinOneObservableRelation
    (Jx Jy Jz : Matrix (Fin 3) (Fin 3) ℂ) where
  relation : Jz * Jz = (Jx * Jx - Jy * Jy) * (Jx * Jx - Jy * Jy)

Litlib.equation "peres1995quantum" eq "7.10" page "192" kind "theorem"
/-- Fraction of beam intensity received at left filter (first setup). -/
class Eq7_10_BeamSplitterFraction1
    (Pu Pv Pw : Matrix (Fin 3) (Fin 3) ℂ)
    (expVal : Matrix (Fin 3) (Fin 3) ℂ → ℝ)
    (expPw1 : ℝ) where
  fraction_eq : expPw1 = 1 - expVal Pu - expVal Pv

Litlib.equation "peres1995quantum" eq "7.11" page "192" kind "theorem"
/-- Fraction of beam intensity received at left filter (second setup). -/
class Eq7_11_BeamSplitterFraction2
    (Px Py Pw : Matrix (Fin 3) (Fin 3) ℂ)
    (expVal : Matrix (Fin 3) (Fin 3) ℂ → ℝ)
    (expPw2 : ℝ) where
  fraction_eq : expPw2 = 1 - expVal Px - expVal Py

Litlib.equation "peres1995quantum" eq "7.12" page "193" kind "definition"
/-- Gleason frame function: nonnegative function summing to constant W on any basis. -/
class Eq7_12_FrameFunction
    (d : ℕ) (f : (Fin d → ℝ) → ℝ) (W : ℝ) where
  f_nonneg : ∀ u, 0 ≤ f u
  frame_sum : ∀ e : Fin d → (Fin d → ℝ),
    (∀ m n, (∑ i, e m i * e n i) = if m = n then 1 else 0) →
    (∑ m, f (e m)) = W

Litlib.equation "peres1995quantum" eq "7.13" page "193" kind "definition"
/-- Two-dimensional frame function on the unit circle: f(θ) + f(θ + π/2) = 1. -/
class Eq7_13_FrameFunction2D
    (f : ℝ → ℝ) where
  f_nonneg : ∀ θ, 0 ≤ f θ
  frame_sum_2d : ∀ θ, f θ + f (θ + Real.pi / 2) = 1

Litlib.equation "peres1995quantum" eq "7.14" page "193" kind "theorem"
/-- Fourier expansion of a 2D frame function with c_{-n} = conj(c_n). -/
class Eq7_14_FourierFrameFunction2D
    (f : ℝ → ℂ) (c : ℤ → ℂ) (N : ℕ) where
  c_conj : ∀ n, c (-n) = star (c n)
  fourier_expansion : ∀ θ,
    f θ + f (θ + Real.pi / 2) =
      ∑ n ∈ Finset.Icc (- (N : ℤ)) (N : ℤ),
        c n * Complex.exp (Complex.I * (n : ℂ) * (θ : ℂ)) *
          (1 + Complex.exp (Complex.I * (n : ℂ) * (Real.pi / 2 : ℂ)))

Litlib.equation "peres1995quantum" eq "7.15" page "194" kind "definition"
/-- Expansion of a 3D frame function in spherical harmonics Y_{lm}(θ, φ). -/
class Eq7_15_SphericalHarmonicsExpansion
    (f : ℝ → ℝ → ℂ)
    (L : ℕ)
    (c : (l : ℕ) → Fin (2 * l + 1) → ℂ)
    (Y : (l : ℕ) → Fin (2 * l + 1) → ℝ → ℝ → ℂ) where
  expansion : ∀ θ φ,
    f θ φ = ∑ l ∈ Finset.range (L + 1), ∑ m : Fin (2 * l + 1), c l m * Y l m θ φ

Litlib.equation "peres1995quantum" eq "7.16" page "194" kind "theorem"
/-- Transformation of spherical harmonics under rotation carrying (θ, φ) to (θ', φ'). -/
class Eq7_16_RotatedHarmonicsPrime
    (f : ℝ → ℝ → ℂ) (L : ℕ)
    (c : (l : ℕ) → Fin (2 * l + 1) → ℂ)
    (D_prime : (l : ℕ) → Matrix (Fin (2 * l + 1)) (Fin (2 * l + 1)) ℂ)
    (Y : (l : ℕ) → Fin (2 * l + 1) → ℝ → ℝ → ℂ)
    (θ' φ' θ φ : ℝ) where
  rotated_expansion :
    f θ' φ' = ∑ l ∈ Finset.range (L + 1), ∑ m : Fin (2 * l + 1),
      c l m * ∑ r : Fin (2 * l + 1), D_prime l r m * Y l r θ φ

Litlib.equation "peres1995quantum" eq "7.17" page "194" kind "theorem"
/-- Transformation of spherical harmonics under rotation carrying (θ, φ) to (θ'', φ''). -/
class Eq7_17_RotatedHarmonicsDoublePrime
    (f : ℝ → ℝ → ℂ) (L : ℕ)
    (c : (l : ℕ) → Fin (2 * l + 1) → ℂ)
    (D_dprime : (l : ℕ) → Matrix (Fin (2 * l + 1)) (Fin (2 * l + 1)) ℂ)
    (Y : (l : ℕ) → Fin (2 * l + 1) → ℝ → ℝ → ℂ)
    (θ'' φ'' θ φ : ℝ) where
  rotated_expansion :
    f θ'' φ'' = ∑ l ∈ Finset.range (L + 1), ∑ m : Fin (2 * l + 1),
      c l m * ∑ r : Fin (2 * l + 1), D_dprime l r m * Y l r θ φ

Litlib.equation "peres1995quantum" eq "7.18" page "194" kind "theorem"
/-- Sum of 3D frame function values over an orthogonal triad of directions. -/
class Eq7_18_FrameFunctionSum3D
    (f : ℝ → ℝ → ℂ) (L : ℕ)
    (c : (l : ℕ) → Fin (2 * l + 1) → ℂ)
    (D_prime D_dprime : (l : ℕ) → Matrix (Fin (2 * l + 1)) (Fin (2 * l + 1)) ℂ)
    (Y : (l : ℕ) → Fin (2 * l + 1) → ℝ → ℝ → ℂ)
    (θ φ θ' φ' θ'' φ'' : ℝ) where
  sum_expansion :
    f θ φ + f θ' φ' + f θ'' φ'' =
      ∑ l ∈ Finset.range (L + 1), ∑ m : Fin (2 * l + 1),
        (c l m + ∑ r : Fin (2 * l + 1), (D_prime l m r + D_dprime l m r) * c l r) *
          Y l m θ φ

Litlib.equation "peres1995quantum" eq "7.19" page "194" kind "theorem"
/-- Vanishing of the l-multipole coefficients of a frame function for l ≠ 0. -/
class Eq7_19_IrreducibleComponentCondition
    (L : ℕ)
    (c : (l : ℕ) → Fin (2 * l + 1) → ℂ)
    (D_prime D_dprime : (l : ℕ) → Matrix (Fin (2 * l + 1)) (Fin (2 * l + 1)) ℂ) where
  multipole_vanish : ∀ (l : ℕ), l ≤ L → l ≠ 0 → ∀ (m : Fin (2 * l + 1)),
    c l m + ∑ r : Fin (2 * l + 1), (D_prime l m r + D_dprime l m r) * c l r = 0

Litlib.equation "peres1995quantum" eq "7.20" page "194" kind "definition"
/-- Single l-multipole component f_l(θ, φ) expanded in associated Legendre polynomials. -/
class Eq7_20_SingleMultipoleComponent
    (l : ℕ)
    (fl : ℝ → ℝ → ℂ)
    (c : ℤ → ℂ)
    (P : ℕ → ℤ → ℝ → ℝ) where
  fl_def : ∀ θ φ,
    fl θ φ = ∑ m ∈ Finset.Icc (- (l : ℤ)) (l : ℤ),
      c m * (P l m (Real.cos θ) : ℂ) *
        Complex.exp (Complex.I * (m : ℂ) * (φ : ℂ))

Litlib.equation "peres1995quantum" eq "7.21" page "194" kind "definition"
/-- Associated Legendre polynomial P_l^m in terms of derivatives of P_l. -/
class Eq7_21_AssociatedLegendre
    (l m : ℕ)
    (Plm : ℝ → ℝ)
    (dmPl : ℝ → ℝ) where
  associated_legendre_eq : ∀ θ,
    Plm (Real.cos θ) = (Real.sin θ) ^ m * dmPl (Real.cos θ)

Litlib.equation "peres1995quantum" eq "7.22" page "195" kind "theorem"
/-- Associated Legendre polynomials vanish at cos θ = 1 for m ≠ 0. -/
class Eq7_22_AssociatedLegendreAtOne
    (l m : ℕ) (_hm : m ≠ 0)
    (Plm : ℝ → ℝ) where
  vanish_at_one : Plm 1 = 0

Litlib.equation "peres1995quantum" eq "7.23" page "195" kind "theorem"
/-- Equatorial sum of l-multipole at θ = π/2. -/
class Eq7_23_MultipoleEquatorialSum
    (l : ℕ)
    (fl : ℝ → ℝ → ℂ)
    (c : ℤ → ℂ)
    (P : ℕ → ℤ → ℝ → ℝ) where
  equatorial_sum : ∀ φ,
    fl (Real.pi / 2) φ + fl (Real.pi / 2) (φ + Real.pi / 2) =
      ∑ m ∈ Finset.Icc (- (l : ℤ)) (l : ℤ),
        c m * (P l m 0 : ℂ) * Complex.exp (Complex.I * (m : ℂ) * (φ : ℂ)) *
          (1 + Complex.exp (Complex.I * (m : ℂ) * (Real.pi / 2 : ℂ)))

Litlib.equation "peres1995quantum" eq "7.24" page "195" kind "theorem"
/-- Solution to Gleason's problem in ℝ^3: f(u) = ∑_{mn} ρ_{mn} u_m u_n. -/
class Eq7_24_Gleason3DRealQuadraticForm
    (f : (Fin 3 → ℝ) → ℝ)
    (ρ : Matrix (Fin 3) (Fin 3) ℝ) where
  rho_nonneg : ∀ v : Fin 3 → ℝ, 0 ≤ ∑ m, ∑ n, v m * ρ m n * v n
  rho_trace_one : Matrix.trace ρ = 1
  quadratic_form : ∀ u : Fin 3 → ℝ,
    (∑ m, u m * u m = 1) →
    f u = ∑ m, ∑ n, ρ m n * u m * u n

Litlib.equation "peres1995quantum" eq "7.25" page "195" kind "theorem"
/-- Gleason's theorem in higher-dimensional complex Hilbert spaces:
any frame function is a sesquilinear form f(u) = ∑_{mn} ρ_{mn} \bar{u}_m u_n. -/
class Eq7_25_GleasonHigherDimSesquilinearForm
    (d : ℕ) (hd : 3 ≤ d)
    (f : (Fin d → ℂ) → ℝ)
    (ρ : Matrix (Fin d) (Fin d) ℂ) where
  rho_nonneg : ∀ v : Fin d → ℂ, 0 ≤ (∑ m, ∑ n, star (v m) * ρ m n * v n).re
  rho_trace_one : (Matrix.trace ρ).re = 1
  sesquilinear_form : ∀ u : Fin d → ℂ,
    (∑ m, Complex.normSq (u m) = 1) →
    f u = (∑ m, ∑ n, ρ m n * star (u m) * u n).re

end

end Litlib.Y1995.peres1995quantum
