-- FILENAME: Litlib/Y2010/wald2010general/AppendixE/Sec01_Lagrangian.lean

import Litlib.Core
import Litlib.Y2010.wald2010general.Paper
import Mathlib.Data.Real.Basic
import Mathlib.Data.Matrix.Basic
import Mathlib.Analysis.SpecialFunctions.Trigonometric.Basic

namespace Litlib.Y2010.wald2010general

open BigOperators

Litlib.equation "wald2010general" eq "E.1.12" page "453" kind "definition"
/-- Gravitational Lagrangian Density (Wald Eq. E.1.12).
L_G = sqrt(-g) * R, where R is the scalar curvature constructed from g_{ab}. -/
class EqE_1_12
    (M : Type*)
    (sqrtDetNegG : M → ℝ)
    (R : M → ℝ)
    (LG : M → ℝ) where
  sqrt_det_pos : ∀ p, 0 < sqrtDetNegG p
  lagrangian_density_def : ∀ p, LG p = sqrtDetNegG p * R p

Litlib.equation "wald2010general" eq "E.1.19" page "454" kind "theorem"
/-- Functional Derivative of the Hilbert Action (Wald Eq. E.1.19).
Discarding the boundary term from Stokes' theorem, the variation of the gravitational
action with respect to the inverse metric g^{ab} yields:
delta S_G / delta g^{ab} = sqrt(-g) * (R_{ab} - (1/2) * R * g_{ab}). -/
class EqE_1_19
    (M : Type*)
    (g : M → Fin 4 → Fin 4 → ℝ)
    (gInv : M → Fin 4 → Fin 4 → ℝ)
    (Ricci : M → Fin 4 → Fin 4 → ℝ)
    (sqrtDetNegG : M → ℝ)
    (funcDerivSG : M → Fin 4 → Fin 4 → ℝ) where
  metric_inverse : ∀ (p : M) (a b : Fin 4),
    (∑ c : Fin 4, g p a c * gInv p c b) = if a = b then 1 else 0
  metric_symmetric : ∀ (p : M) (a b : Fin 4), g p a b = g p b a
  ricci_symmetric : ∀ (p : M) (a b : Fin 4), Ricci p a b = Ricci p b a
  functional_derivative_eq : ∀ (p : M) (a b : Fin 4),
    let ricciScalar := ∑ c : Fin 4, ∑ d : Fin 4, gInv p c d * Ricci p c d
    let G := Ricci p a b - (1 / 2 : ℝ) * ricciScalar * g p a b
    funcDerivSG p a b = sqrtDetNegG p * G

Litlib.equation "wald2010general" eq "E.1.20" page "454" kind "definition"
/-- Palatini Action for General Relativity (Wald Eq. E.1.20).
Treats the inverse metric g^{ab} and the connection derivative operator ∇_a as
independent dynamical variables: S_G[g^{ab}, ∇_a] = ∫ sqrt(-g) * R_{ab}(∇) * g^{ab} * e.
Independent variation with respect to ∇ recovers metric compatibility ∇_c g_{ab} = 0,
while variation with respect to g^{ab} yields vacuum Einstein equations. -/
class EqE_1_20
    (M : Type*)
    (gInv : M → Fin 4 → Fin 4 → ℝ)
    (RicciFromConn : M → Fin 4 → Fin 4 → ℝ)
    (sqrtDetNegG : M → ℝ)
    (palatiniLagrangian : M → ℝ) where
  sqrt_det_pos : ∀ p, 0 < sqrtDetNegG p
  palatini_lagrangian_eq : ∀ (p : M),
    palatiniLagrangian p =
      sqrtDetNegG p * (∑ a : Fin 4, ∑ b : Fin 4, RicciFromConn p a b * gInv p a b)

Litlib.equation "wald2010general" eq "E.1.25" page "455" kind "equation"
/-- Sourced Einstein Equation from Lagrangian Variation (Wald Eq. E.1.25).
G_{ab} = R_{ab} - (1/2) * R * g_{ab} = 8 * π * T_{ab}. -/
class EqE_1_25
    (M : Type*)
    (g : M → Fin 4 → Fin 4 → ℝ)
    (gInv : M → Fin 4 → Fin 4 → ℝ)
    (Ricci : M → Fin 4 → Fin 4 → ℝ)
    (T : M → Fin 4 → Fin 4 → ℝ) where
  metric_inverse : ∀ (p : M) (a b : Fin 4),
    (∑ c : Fin 4, g p a c * gInv p c b) = if a = b then 1 else 0
  metric_symmetric : ∀ (p : M) (a b : Fin 4), g p a b = g p b a
  ricci_symmetric : ∀ (p : M) (a b : Fin 4), Ricci p a b = Ricci p b a
  stress_energy_symmetric : ∀ (p : M) (a b : Fin 4), T p a b = T p b a
  einstein_field_eq : ∀ (p : M) (a b : Fin 4),
    let ricciScalar := ∑ c : Fin 4, ∑ d : Fin 4, gInv p c d * Ricci p c d
    let G := Ricci p a b - (1 / 2 : ℝ) * ricciScalar * g p a b
    G = 8 * Real.pi * T p a b

Litlib.equation "wald2010general" eq "E.1.26" page "455" kind "definition"
/-- Matter Stress-Energy Tensor Definition from Action Variation (Wald Eq. E.1.26).
Defines T_{ab} via the functional derivative of the matter action S_M with respect to
the inverse metric: T_{ab} = - (alpha_M / (8 * π)) * (1 / sqrt(-g)) * (delta S_M / delta g^{ab}). -/
class EqE_1_26
    (M : Type*)
    (sqrtDetNegG : M → ℝ)
    (funcDerivSM : M → Fin 4 → Fin 4 → ℝ)
    (alphaM : ℝ)
    (T : M → Fin 4 → Fin 4 → ℝ) where
  sqrt_det_pos : ∀ p, 0 < sqrtDetNegG p
  stress_energy_from_action : ∀ (p : M) (a b : Fin 4),
    T p a b = - (alphaM / (8 * Real.pi)) * (1 / sqrtDetNegG p) * funcDerivSM p a b

Litlib.equation "wald2010general" eq "E.1.29" page "456" kind "theorem"
/-- Stress-Energy Conservation from Diffeomorphism Invariance (Wald Eq. E.1.29).
For any diffeomorphism-invariant matter action, the matter equations of motion imply
that the stress-energy tensor is divergence-free: ∇^a T_{ab} = 0. -/
class EqE_1_29
    (M : Type*)
    (gInv : M → Fin 4 → Fin 4 → ℝ)
    (covDerivT : M → Fin 4 → Fin 4 → Fin 4 → ℝ) where
  cov_divergence_zero : ∀ (p : M) (b : Fin 4),
    (∑ a : Fin 4, ∑ c : Fin 4, gInv p a c * covDerivT p c a b) = 0

Litlib.equation "wald2010general" eq "E.1.30" page "456" kind "theorem"
/-- Contracted Bianchi Identity from Diffeomorphism Invariance (Wald Eq. E.1.30).
Diffeomorphism invariance of the gravitational action S_G implies that the Einstein
tensor is identically divergence-free: ∇^a G_{ab} = 0. -/
class EqE_1_30
    (M : Type*)
    (gInv : M → Fin 4 → Fin 4 → ℝ)
    (covDerivG : M → Fin 4 → Fin 4 → Fin 4 → ℝ) where
  einstein_divergence_zero : ∀ (p : M) (b : Fin 4),
    (∑ a : Fin 4, ∑ c : Fin 4, gInv p a c * covDerivG p c a b) = 0

Litlib.equation "wald2010general" eq "E.1.42" page "458" kind "definition"
/-- Modified Gravitational Action with Gibbons-Hawking-York Boundary Term (Wald Eq. E.1.42).
To obtain Einstein's equation when variations delta g_{ab} vanish on the boundary
without requiring derivatives of delta g_{ab} to vanish, the boundary term
2 * ∫ K is added: S'_G = S_G + 2 * ∫_U_dot K. -/
class EqE_1_42
    (SG : ℝ)
    (boundaryIntegralK : ℝ)
    (SPrimeG : ℝ) where
  modified_action_eq : SPrimeG = SG + 2 * boundaryIntegralK

end Litlib.Y2010.wald2010general
