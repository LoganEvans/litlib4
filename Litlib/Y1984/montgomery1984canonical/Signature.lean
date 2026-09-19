-- FILENAME: Litlib/Y1984/montgomery1984canonical/Signature.lean


import Litlib.Core
import Mathlib.Algebra.Module.Basic
import Mathlib.Algebra.Algebra.Basic
import Mathlib.Data.Real.Basic
import Mathlib.Data.Fin.Basic
import Mathlib.Data.Fintype.Basic

namespace Litlib.Y1984.montgomery1984canonical

open Finset

Litlib.paper "montgomery1984canonical"
  type "article"
  title "Canonical formulations of a classical particle in a Yang-Mills field and Wong's equations"
  authors ["Montgomery, Richard"]
  journal "Letters in Mathematical Physics"
  year "1984"

Litlib.equation "montgomery1984canonical" eq "1a" page "59" kind "equation"
class Eq1a
    (dim_G : ℕ)
    (g_cov : Fin 4 → Fin 4 → ℝ)
    (g_inv : Fin 4 → Fin 4 → ℝ)
    (dg_inv : Fin 4 → Fin 4 → Fin 4 → ℝ)
    (F : Fin 4 → Fin 4 → Fin dim_G → ℝ)
    (p : Fin 4 → ℝ)
    (xi : Fin dim_G → ℝ)
    (p_dot : Fin 4 → ℝ) where
  F_antisymm : ∀ μ ν a, F μ ν a = - F ν μ a
  g_inv_symm : ∀ μ ν, g_inv μ ν = g_inv ν μ
  g_inv_spec : ∀ μ ρ : Fin 4, (∑ ν : Fin 4, g_cov μ ν * g_inv ν ρ) = if μ = ρ then 1 else 0
  wong_p_dot : ∀ μ : Fin 4,
    p_dot μ =
      (∑ ν : Fin 4, ∑ a : Fin dim_G,
        F μ ν a * xi a * (∑ k : Fin 4, g_inv ν k * p k)) -
      ((1 / 2 : ℝ) * ∑ α : Fin 4, ∑ β : Fin 4, dg_inv μ α β * p α * p β)

Litlib.equation "montgomery1984canonical" eq "1b" page "59" kind "equation"
class Eq1b
    (dim_G : ℕ)
    (c : Fin dim_G → Fin dim_G → Fin dim_G → ℝ)
    (A : Fin 4 → Fin dim_G → ℝ)
    (g_cov : Fin 4 → Fin 4 → ℝ)
    (g_inv : Fin 4 → Fin 4 → ℝ)
    (p : Fin 4 → ℝ)
    (xi : Fin dim_G → ℝ)
    (xi_dot : Fin dim_G → ℝ) where
  c_antisymm : ∀ a b d, c a b d = - c b a d
  g_inv_spec : ∀ μ ρ : Fin 4, (∑ ν : Fin 4, g_cov μ ν * g_inv ν ρ) = if μ = ρ then 1 else 0
  wong_xi_dot : ∀ a : Fin dim_G,
    xi_dot a = - ∑ b : Fin dim_G, ∑ d : Fin dim_G, ∑ μ : Fin 4,
      c a b d * A μ b * (∑ ν : Fin 4, g_inv μ ν * p ν) * xi d

Litlib.equation "montgomery1984canonical" eq "1c" page "59" kind "equation"
class Eq1c
    (g_cov : Fin 4 → Fin 4 → ℝ)
    (g_inv : Fin 4 → Fin 4 → ℝ)
    (p : Fin 4 → ℝ)
    (x_dot : Fin 4 → ℝ) where
  g_inv_spec : ∀ μ ρ : Fin 4, (∑ ν : Fin 4, g_cov μ ν * g_inv ν ρ) = if μ = ρ then 1 else 0
  wong_x_dot : ∀ μ : Fin 4, x_dot μ = ∑ ν : Fin 4, g_inv μ ν * p ν

Litlib.equation "montgomery1984canonical" eq "2" page "60" kind "equation"
class Eq2
    (TpP : Type*) [AddCommGroup TpP] [Module ℝ TpP]
    (V_p : Submodule ℝ TpP)
    (H_p : Submodule ℝ TpP)
    (K : TpP →ₗ[ℝ] TpP →ₗ[ℝ] ℝ) where
  K_symm : ∀ u v : TpP, K u v = K v u
  direct_sum : IsCompl V_p H_p
  orthogonal : ∀ (v : TpP), v ∈ V_p → ∀ (h : TpP), h ∈ H_p → K v h = 0

Litlib.equation "montgomery1984canonical" eq "3" page "60" kind "equation"
class Eq3
    (LieAlg : Type*) [AddCommGroup LieAlg] [Module ℝ LieAlg]
    (TpP : Type*) [AddCommGroup TpP] [Module ℝ TpP]
    (V_p : Submodule ℝ TpP)
    (sigma_p : LieAlg ≃ₗ[ℝ] V_p)
    (gamma : LieAlg →ₗ[ℝ] LieAlg →ₗ[ℝ] ℝ)
    (K : TpP →ₗ[ℝ] TpP →ₗ[ℝ] ℝ) where
  gamma_symm : ∀ xi eta : LieAlg, gamma xi eta = gamma eta xi
  metric_induced : ∀ (xi eta : LieAlg),
    K (sigma_p xi).val (sigma_p eta).val = gamma xi eta

Litlib.equation "montgomery1984canonical" eq "Theorem 1" page "61" kind "theorem"
class Theorem1
    (dim_G : ℕ)
    (g_cov : Fin 4 → Fin 4 → ℝ)
    (g_inv : Fin 4 → Fin 4 → ℝ)
    (dg_inv : Fin 4 → Fin 4 → Fin 4 → ℝ)
    (F : Fin 4 → Fin 4 → Fin dim_G → ℝ)
    (c : Fin dim_G → Fin dim_G → Fin dim_G → ℝ)
    (A : Fin 4 → Fin dim_G → ℝ)
    (gamma_inv : Fin dim_G → Fin dim_G → ℝ)
    (p : Fin 4 → ℝ)
    (xi : Fin dim_G → ℝ)
    (ham_x : Fin 4 → ℝ)
    (ham_p : Fin 4 → ℝ)
    (ham_xi : Fin dim_G → ℝ) where
  g_inv_spec : ∀ μ ρ : Fin 4, (∑ ν : Fin 4, g_cov μ ν * g_inv ν ρ) = if μ = ρ then 1 else 0
  c_antisymm : ∀ a b d, c a b d = - c b a d
  ham_x_eq_wong : ∀ μ : Fin 4,
    ham_x μ = ∑ ν : Fin 4, g_inv μ ν * p ν
  ham_p_eq_wong : ∀ μ : Fin 4,
    ham_p μ =
      (∑ ν : Fin 4, ∑ a : Fin dim_G,
        F μ ν a * xi a * (∑ k : Fin 4, g_inv ν k * p k)) -
      ((1 / 2 : ℝ) * ∑ α : Fin 4, ∑ β : Fin 4, dg_inv μ α β * p α * p β)
  ham_xi_eq_wong : ∀ a : Fin dim_G,
    ham_xi a = - ∑ b : Fin dim_G, ∑ d : Fin dim_G, ∑ μ : Fin 4,
      c a b d * A μ b * (∑ ν : Fin 4, g_inv μ ν * p ν) * xi d

Litlib.equation "montgomery1984canonical" eq "Theorem 2" page "61" kind "theorem"
class Theorem2
    (dim_G : ℕ)
    (g_inv : Fin 4 → Fin 4 → ℝ)
    (gamma_inv : Fin dim_G → Fin dim_G → ℝ)
    (H_sharp : (Fin 4 → ℝ) → (Fin dim_G → ℝ) → ℝ)
    (H_Sternberg : (Fin 4 → ℝ) → ℝ)
    (casimir : (Fin dim_G → ℝ) → ℝ) where
  H_sharp_def : ∀ (p : Fin 4 → ℝ) (xi : Fin dim_G → ℝ),
    H_sharp p xi = (1 / 2 : ℝ) * (
      (∑ μ : Fin 4, ∑ ν : Fin 4, g_inv μ ν * p μ * p ν) +
      (∑ a : Fin dim_G, ∑ b : Fin dim_G, gamma_inv a b * xi a * xi b))
  H_Sternberg_def : ∀ (p : Fin 4 → ℝ),
    H_Sternberg p = (1 / 2 : ℝ) * (∑ μ : Fin 4, ∑ ν : Fin 4, g_inv μ ν * p μ * p ν)
  casimir_def : ∀ (xi : Fin dim_G → ℝ),
    casimir xi = (1 / 2 : ℝ) * ∑ a : Fin dim_G, ∑ b : Fin dim_G, gamma_inv a b * xi a * xi b
  diff_is_casimir : ∀ (p : Fin 4 → ℝ) (xi : Fin dim_G → ℝ),
    H_sharp p xi - H_Sternberg p = casimir xi

Litlib.equation "montgomery1984canonical" eq "4a" page "63" kind "equation"
class Eq4a
    (dim_G : ℕ)
    (g_inv : Fin 4 → Fin 4 → ℝ)
    (gamma_inv : Fin dim_G → Fin dim_G → ℝ)
    (A : Fin 4 → Fin dim_G → ℝ)
    (p : Fin 4 → ℝ)
    (xi : Fin dim_G → ℝ)
    (p_bar : Fin 4 → ℝ)
    (xi_bar : Fin dim_G → ℝ)
    (H : ℝ) where
  p_bar_def : ∀ ν : Fin 4, p_bar ν = p ν - ∑ a : Fin dim_G, A ν a * xi a
  xi_bar_def : ∀ a : Fin dim_G, xi_bar a = xi a
  H_def : H = (1 / 2 : ℝ) * (
    (∑ μ : Fin 4, ∑ ν : Fin 4, g_inv μ ν * p_bar μ * p_bar ν) +
    (∑ a : Fin dim_G, ∑ b : Fin dim_G, gamma_inv a b * xi_bar a * xi_bar b))

Litlib.equation "montgomery1984canonical" eq "4b" page "63" kind "equation"
class Eq4b
    (dim_G : ℕ)
    (g_inv : Fin 4 → Fin 4 → ℝ)
    (gamma_inv : Fin dim_G → Fin dim_G → ℝ)
    (p : Fin 4 → ℝ)
    (xi : Fin dim_G → ℝ)
    (H_sharp : ℝ) where
  H_sharp_def : H_sharp = (1 / 2 : ℝ) * (
    (∑ μ : Fin 4, ∑ ν : Fin 4, g_inv μ ν * p μ * p ν) +
    (∑ a : Fin dim_G, ∑ b : Fin dim_G, gamma_inv a b * xi a * xi b))

Litlib.equation "montgomery1984canonical" eq "5a" page "63" kind "equation"
class Eq5a
    (P : Type*) [CommRing P] [Algebra ℝ P]
    (bracket : P → P → P)
    (x : Fin 4 → P)
    (p : Fin 4 → P)
    (x_bar : Fin 4 → P)
    (p_bar : Fin 4 → P) where
  bracket_x_p : ∀ μ ν : Fin 4, bracket (x μ) (p ν) = if μ = ν then 1 else 0
  bracket_x_bar_p_bar : ∀ μ ν : Fin 4, bracket (x_bar μ) (p_bar ν) = if μ = ν then 1 else 0

Litlib.equation "montgomery1984canonical" eq "5b" page "63" kind "equation"
class Eq5b
    (dim_G : ℕ)
    (P : Type*) [CommRing P] [Algebra ℝ P]
    (bracket : P → P → P)
    (x : Fin 4 → P)
    (xi : Fin dim_G → P)
    (x_bar : Fin 4 → P)
    (xi_bar : Fin dim_G → P) where
  bracket_x_xi : ∀ (μ : Fin 4) (a : Fin dim_G), bracket (x μ) (xi a) = 0
  bracket_x_bar_xi_bar : ∀ (μ : Fin 4) (a : Fin dim_G), bracket (x_bar μ) (xi_bar a) = 0

Litlib.equation "montgomery1984canonical" eq "5c" page "64" kind "equation"
class Eq5c
    (dim_G : ℕ)
    (P : Type*) [CommRing P]
    (bracket : P → P → P)
    (p : Fin 4 → P)
    (xi : Fin dim_G → P) where
  bracket_p_xi : ∀ (μ : Fin 4) (a : Fin dim_G), bracket (p μ) (xi a) = 0

Litlib.equation "montgomery1984canonical" eq "5d" page "64" kind "equation"
class Eq5d
    (dim_G : ℕ)
    (P : Type*) [CommRing P] [Algebra ℝ P]
    (bracket : P → P → P)
    (xi : Fin dim_G → P)
    (c : Fin dim_G → Fin dim_G → Fin dim_G → ℝ) where
  bracket_xi_xi : ∀ (a b : Fin dim_G),
    bracket (xi a) (xi b) = ∑ d : Fin dim_G, c a b d • xi d

Litlib.equation "montgomery1984canonical" eq "5e" page "64" kind "equation"
class Eq5e
    (dim_G : ℕ)
    (P : Type*) [CommRing P] [Algebra ℝ P]
    (bracket : P → P → P)
    (p_bar : Fin 4 → P)
    (xi : Fin dim_G → P)
    (F : Fin 4 → Fin 4 → Fin dim_G → ℝ)
    (A : Fin 4 → Fin dim_G → ℝ)
    (dA : Fin 4 → Fin 4 → Fin dim_G → ℝ)
    (c : Fin dim_G → Fin dim_G → Fin dim_G → ℝ) where
  F_curvature : ∀ (μ ν : Fin 4) (d : Fin dim_G),
    F μ ν d = dA μ ν d - dA ν μ d +
      ∑ a : Fin dim_G, ∑ b : Fin dim_G, c a b d * A μ a * A ν b
  bracket_p_bar_p_bar : ∀ (μ ν : Fin 4),
    bracket (p_bar μ) (p_bar ν) = ∑ a : Fin dim_G, F μ ν a • xi a

Litlib.equation "montgomery1984canonical" eq "5f" page "64" kind "equation"
class Eq5f
    (dim_G : ℕ)
    (P : Type*) [CommRing P] [Algebra ℝ P]
    (bracket : P → P → P)
    (xi : Fin dim_G → P)
    (p_bar : Fin 4 → P)
    (c : Fin dim_G → Fin dim_G → Fin dim_G → ℝ)
    (A : Fin 4 → Fin dim_G → ℝ) where
  bracket_xi_p_bar : ∀ (a : Fin dim_G) (μ : Fin 4),
    bracket (xi a) (p_bar μ) = - ∑ b : Fin dim_G, ∑ d : Fin dim_G, (c a b d * A μ b) • xi d

Litlib.equation "montgomery1984canonical" eq "6" page "65" kind "equation"
class Eq6
    (Omega_total : Type*) [AddCommGroup Omega_total] [Module ℝ Omega_total]
    (Omega_sharp : Type*) [AddCommGroup Omega_sharp] [Module ℝ Omega_sharp]
    (Omega_orbit : Type*) [AddCommGroup Omega_orbit] [Module ℝ Omega_orbit]
    (Omega_prod : Type*) [AddCommGroup Omega_prod] [Module ℝ Omega_prod]
    (j_star : Omega_total →ₗ[ℝ] Omega_prod)
    (pi_star : Omega_sharp →ₗ[ℝ] Omega_prod)
    (pi_2_star : Omega_orbit →ₗ[ℝ] Omega_prod)
    (omega : Omega_total)
    (omega_sharp : Omega_sharp)
    (omega_orbit_plus : Omega_orbit) where
  reduced_symplectic_form : j_star omega = pi_star omega_sharp + pi_2_star omega_orbit_plus

Litlib.equation "montgomery1984canonical" eq "7" page "65" kind "equation"
class Eq7
    (Omega_prod : Type*) [AddCommGroup Omega_prod] [Module ℝ Omega_prod]
    (OneForm_prod : Type*) [AddCommGroup OneForm_prod] [Module ℝ OneForm_prod]
    (Omega_sharp : Type*) [AddCommGroup Omega_sharp] [Module ℝ Omega_sharp]
    (Omega_orbit : Type*) [AddCommGroup Omega_orbit] [Module ℝ Omega_orbit]
    (d : OneForm_prod →ₗ[ℝ] Omega_prod)
    (pi_star : Omega_sharp →ₗ[ℝ] Omega_prod)
    (pi_2_star : Omega_orbit →ₗ[ℝ] Omega_prod)
    (tilde_omega : Omega_prod)
    (tilde_omega_X : Omega_prod)
    (coupling_one_form : OneForm_prod)
    (omega_orbit_minus : Omega_orbit)
    (omega_S : Omega_sharp) where
  tilde_omega_def : tilde_omega = tilde_omega_X + d coupling_one_form +
    pi_2_star omega_orbit_minus
  sternberg_structure : tilde_omega = pi_star omega_S

Litlib.equation "montgomery1984canonical" eq "8" page "65" kind "equation"
class Eq8
    (OneForm_TstarP : Type*) [AddCommGroup OneForm_TstarP] [Module ℝ OneForm_TstarP]
    (OneForm_prod_G : Type*) [AddCommGroup OneForm_prod_G] [Module ℝ OneForm_prod_G]
    (OneForm_prod_O : Type*) [AddCommGroup OneForm_prod_O] [Module ℝ OneForm_prod_O]
    (OneForm_TstarX : Type*) [AddCommGroup OneForm_TstarX] [Module ℝ OneForm_TstarX]
    (tilde_A_star : OneForm_TstarP →ₗ[ℝ] OneForm_prod_G)
    (j_star : OneForm_prod_G →ₗ[ℝ] OneForm_prod_O)
    (pi_TX_star : OneForm_TstarX →ₗ[ℝ] OneForm_prod_O)
    (theta_P : OneForm_TstarP)
    (theta_X : OneForm_TstarX)
    (coupling_one_form : OneForm_prod_O) where
  symplectic_potential_identity :
    j_star (tilde_A_star theta_P) = pi_TX_star theta_X - coupling_one_form

Litlib.equation "montgomery1984canonical" eq "Proposition" page "66" kind "proposition"
class PropositionKummer
    (T_bundle : Type*) [AddCommGroup T_bundle] [Module ℝ T_bundle]
    (Tstar_bundle : Type*) [AddCommGroup Tstar_bundle] [Module ℝ Tstar_bundle]
    (pairing : Tstar_bundle →ₗ[ℝ] T_bundle →ₗ[ℝ] ℝ)
    (Vertical : Submodule ℝ T_bundle)
    (Sternberg_bundle : Submodule ℝ Tstar_bundle) where
  is_annihilator : ∀ (alpha : Tstar_bundle),
    alpha ∈ Sternberg_bundle ↔ ∀ (v : T_bundle), v ∈ Vertical → pairing alpha v = 0

end Litlib.Y1984.montgomery1984canonical
