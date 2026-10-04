-- FILENAME: Litlib/Y1977/macdowell1977gravity/Signature.lean

import Litlib.Core
import Mathlib.Data.Real.Basic
import Mathlib.Data.Complex.Basic
import Mathlib.Data.Fin.Basic
import Mathlib.LinearAlgebra.Matrix.Trace
import Mathlib.LinearAlgebra.Matrix.Determinant.Basic

set_option autoImplicit false

open BigOperators

namespace Litlib.Y1977.macdowell1977gravity

Litlib.paper "macdowell1977gravity"
  type "article"
  title "Unified Geometric Theory of Gravity and Supergravity"
  authors ["MacDowell, S. W.", "Mansouri, F."]
  journal "Physical Review Letters"
  year "1977"

/-- Spacetime point in four-dimensional coordinates. -/
def Point := Fin 4 → ℝ

/-- 4D Levi-Civita permutation symbol `ε^{μνρσ}` defined via the determinant. -/
def leviCivita4 (μ ν ρ σ : Fin 4) : ℝ :=
  Matrix.det (fun (row : Fin 4) (col : Fin 4) ↦
    match row with
    | 0 => if col = μ then 1 else 0
    | 1 => if col = ν then 1 else 0
    | 2 => if col = ρ then 1 else 0
    | 3 => if col = σ then 1 else 0)

Litlib.equation "macdowell1977gravity" eq "10" page "740" kind "definition"
class Eq10
    (AlgIdx : Type*) [Fintype AlgIdx] [DecidableEq AlgIdx]
    (h : Point → Fin 4 → AlgIdx → ℝ)
    (partialDeriv : Fin 4 → (Point → ℝ) → Point → ℝ)
    (f : AlgIdx → AlgIdx → AlgIdx → ℝ)
    (R : Point → Fin 4 → Fin 4 → AlgIdx → ℝ) : Prop where
  antisymmetric :
    ∀ x μ ν A, R x μ ν A = - R x ν μ A
  curvature_eq :
    ∀ x μ ν A, R x μ ν A =
      partialDeriv μ (fun y ↦ h y ν A) x - partialDeriv ν (fun y ↦ h y μ A) x +
      ∑ B, ∑ C, h x μ B * h x ν C * f B C A

Litlib.equation "macdowell1977gravity" eq "12" page "740" kind "definition"
class Eq12
    (AlgIdx : Type*) [Fintype AlgIdx] [DecidableEq AlgIdx]
    (R : Point → Fin 4 → Fin 4 → AlgIdx → ℝ)
    (Q : AlgIdx → AlgIdx → ℝ)
    (actionDensity : Point → ℝ) : Prop where
  density_eq :
    ∀ x, actionDensity x =
      ∑ μ, ∑ ν, ∑ ρ, ∑ σ,
      ∑ A, ∑ B,
      leviCivita4 μ ν ρ σ * Q A B * R x μ ν A * R x ρ σ B

Litlib.equation "macdowell1977gravity" eq "17" page "741" kind "theorem"
class Eq17
    (LorentzIdx : Type*) [Fintype LorentzIdx] [DecidableEq LorentzIdx]
    (e : Point → Fin 4 → Fin 4 → ℝ)
    (f_trans : Fin 4 → Fin 4 → LorentzIdx → ℝ)
    (R0 : Point → Fin 4 → Fin 4 → LorentzIdx → ℝ)
    (R : Point → Fin 4 → Fin 4 → LorentzIdx → ℝ) : Prop where
  det_e_ne_zero :
    ∀ x, Matrix.det (e x) ≠ 0
  f_trans_antisymm :
    ∀ i j a, f_trans i j a = - f_trans j i a
  decomp_eq :
    ∀ x μ ν a, R x μ ν a =
      R0 x μ ν a + ∑ i, ∑ j, e x μ i * e x ν j * f_trans i j a

Litlib.equation "macdowell1977gravity" eq "20" page "741" kind "theorem"
class Eq20
    (LorentzIdx : Type*) [Fintype LorentzIdx] [DecidableEq LorentzIdx]
    (e : Point → Fin 4 → Fin 4 → ℝ)
    (f_trans : Fin 4 → Fin 4 → LorentzIdx → ℝ)
    (epsilon_L : LorentzIdx → LorentzIdx → ℝ)
    (R0 : Point → Fin 4 → Fin 4 → LorentzIdx → ℝ)
    (R : Point → Fin 4 → Fin 4 → LorentzIdx → ℝ)
    [Eq17 LorentzIdx e f_trans R0 R]
    (lagrangianTotal : Point → ℝ)
    (lagrangianEuler : Point → ℝ)
    (lagrangianEH : Point → ℝ)
    (lagrangianCosmo : Point → ℝ) : Prop where
  total_density_def :
    ∀ x, lagrangianTotal x =
      ∑ μ, ∑ ν, ∑ ρ, ∑ σ,
      ∑ a, ∑ b,
      leviCivita4 μ ν ρ σ * epsilon_L a b * R x μ ν a * R x ρ σ b
  euler_density_def :
    ∀ x, lagrangianEuler x =
      ∑ μ, ∑ ν, ∑ ρ, ∑ σ,
      ∑ a, ∑ b,
      leviCivita4 μ ν ρ σ * epsilon_L a b * R0 x μ ν a * R0 x ρ σ b
  eh_density_def :
    ∀ x, lagrangianEH x =
      ∑ μ, ∑ ν, ∑ ρ, ∑ σ,
      ∑ a, ∑ b,
      leviCivita4 μ ν ρ σ * epsilon_L a b *
      (2 * R0 x μ ν a * (∑ i, ∑ j, e x ρ i * e x σ j * f_trans i j b))
  cosmo_density_def :
    ∀ x, lagrangianCosmo x =
      ∑ μ, ∑ ν, ∑ ρ, ∑ σ,
      ∑ a, ∑ b,
      leviCivita4 μ ν ρ σ * epsilon_L a b *
      (∑ i, ∑ j, e x μ i * e x ν j * f_trans i j a) *
      (∑ k, ∑ l, e x ρ k * e x σ l * f_trans k l b)
  macdowell_mansouri_expansion :
    ∀ x, lagrangianTotal x = lagrangianEuler x + lagrangianEH x + lagrangianCosmo x

Litlib.equation "macdowell1977gravity" eq "22" page "741" kind "theorem"
class Eq22
    (LorentzIdx : Type*) [Fintype LorentzIdx] [DecidableEq LorentzIdx]
    (e : Point → Fin 4 → Fin 4 → ℝ)
    (e_inv : Point → Fin 4 → Fin 4 → ℝ)
    (R_trans : Point → Fin 4 → Fin 4 → Fin 4 → ℝ)
    (R_lorentz : Point → Fin 4 → Fin 4 → Fin 4 → Fin 4 → ℝ) : Prop where
  e_inv_right :
    ∀ x i j, ∑ μ, e x μ i * e_inv x j μ = if i = j then 1 else 0
  e_inv_left :
    ∀ x μ ν, ∑ i, e x μ i * e_inv x i ν = if μ = ν then 1 else 0
  torsion_free :
    ∀ x μ ν i, R_trans x μ ν i = 0
  einstein_vacuum :
    ∀ x μ j, ∑ ν, ∑ i, R_lorentz x μ ν i j * e_inv x i ν = 0

Litlib.equation "macdowell1977gravity" eq "20" page "741" kind "theorem"
class Thm_MacDowellMansouriExpansion
    (V : Fin 4 → Matrix (Fin 2) (Fin 2) ℂ)
    (a : Fin 4 → Matrix (Fin 2) (Fin 2) ℂ)
    (F_V : Fin 4 → Fin 4 → Matrix (Fin 2) (Fin 2) ℂ)
    (D_a : Fin 4 → Fin 4 → Matrix (Fin 2) (Fin 2) ℂ)
    (ell : ℝ)
    (Lambda : ℝ) : Prop where
  ell_pos :
    ell > 0
  cosmological_constant_def :
    Lambda = 3 / (ell ^ 2)
  F_V_antisymm :
    ∀ μ ν, F_V μ ν = - F_V ν μ
  D_a_antisymm :
    ∀ μ ν, D_a μ ν = - D_a ν μ
  total_curvature_expansion :
    ∀ μ ν ρ σ : Fin 4,
      Matrix.trace (
        (F_V μ ν + (a μ * a ν - a ν * a μ) + D_a μ ν) *
        (F_V ρ σ + (a ρ * a σ - a σ * a ρ) + D_a ρ σ)) =
      Matrix.trace (F_V μ ν * F_V ρ σ) +
      Matrix.trace (F_V μ ν * (a ρ * a σ - a σ * a ρ)) +
      Matrix.trace ((a μ * a ν - a ν * a μ) * F_V ρ σ) +
      Matrix.trace ((a μ * a ν - a ν * a μ) * (a ρ * a σ - a σ * a ρ)) +
      Matrix.trace ((F_V μ ν + (a μ * a ν - a ν * a μ)) * D_a ρ σ) +
      Matrix.trace (D_a μ ν * (F_V ρ σ + (a ρ * a σ - a σ * a ρ))) +
      Matrix.trace (D_a μ ν * D_a ρ σ)
  action_density_expansion :
    (∑ μ, ∑ ν, ∑ ρ, ∑ σ,
      (leviCivita4 μ ν ρ σ : ℂ) * Matrix.trace (
        (F_V μ ν + (a μ * a ν - a ν * a μ) + D_a μ ν) *
        (F_V ρ σ + (a ρ * a σ - a σ * a ρ) + D_a ρ σ))) =
    (∑ μ, ∑ ν, ∑ ρ, ∑ σ,
      (leviCivita4 μ ν ρ σ : ℂ) * Matrix.trace (F_V μ ν * F_V ρ σ)) +
    (∑ μ, ∑ ν, ∑ ρ, ∑ σ,
      (leviCivita4 μ ν ρ σ : ℂ) * (2 * Matrix.trace (F_V μ ν * (a ρ * a σ - a σ * a ρ)))) +
    (∑ μ, ∑ ν, ∑ ρ, ∑ σ,
      (leviCivita4 μ ν ρ σ : ℂ) * Matrix.trace (
        (a μ * a ν - a ν * a μ) * (a ρ * a σ - a σ * a ρ))) +
    (∑ μ, ∑ ν, ∑ ρ, ∑ σ,
      (leviCivita4 μ ν ρ σ : ℂ) * (
        2 * Matrix.trace ((F_V μ ν + (a μ * a ν - a ν * a μ)) * D_a ρ σ) +
        Matrix.trace (D_a μ ν * D_a ρ σ)))
  on_shell_torsion_free :
    (∀ μ ν, D_a μ ν = 0) →
    (∑ μ, ∑ ν, ∑ ρ, ∑ σ,
      (leviCivita4 μ ν ρ σ : ℂ) * Matrix.trace (
        (F_V μ ν + (a μ * a ν - a ν * a μ)) *
        (F_V ρ σ + (a ρ * a σ - a σ * a ρ)))) =
    (∑ μ, ∑ ν, ∑ ρ, ∑ σ,
      (leviCivita4 μ ν ρ σ : ℂ) * Matrix.trace (F_V μ ν * F_V ρ σ)) +
    (∑ μ, ∑ ν, ∑ ρ, ∑ σ,
      (leviCivita4 μ ν ρ σ : ℂ) * (2 * Matrix.trace (F_V μ ν * (a ρ * a σ - a σ * a ρ)))) +
    (∑ μ, ∑ ν, ∑ ρ, ∑ σ,
      (leviCivita4 μ ν ρ σ : ℂ) * Matrix.trace (
        (a μ * a ν - a ν * a μ) * (a ρ * a σ - a σ * a ρ)))

end Litlib.Y1977.macdowell1977gravity
