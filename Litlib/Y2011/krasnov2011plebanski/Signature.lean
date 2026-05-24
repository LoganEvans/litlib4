-- FILENAME: Litlib/Y2011/krasnov2011plebanski/Signature.lean

import Litlib.Core
import Mathlib.Data.Complex.Basic
import Mathlib.Data.Real.Basic
import Mathlib.Data.Matrix.Basic
import Mathlib.Analysis.SpecialFunctions.Trigonometric.Basic

namespace Litlib.Y2011.krasnov2011plebanski

Litlib.paper "krasnov2011plebanski"
  type "article"
  title "Plebański formulation of general relativity: a practical introduction"
  authors ["Krasnov, Kirill"]
  journal "General Relativity and Gravitation"
  volume "43"
  issue "1"
  pages "1--15"
  year "2011"
  publisher "Springer"
  doi "10.1007/s10714-010-1061-x"

Litlib.equation "krasnov2011plebanski"
  eq "3"
  page "3"
  kind "theorem"
class Eq3
    (g : Fin 4 → Fin 4 → ℝ)
    (g_inv : Fin 4 → Fin 4 → ℝ)
    (g_is_inv : ∀ mu nu, (∑ alpha : Fin 4, g mu alpha * g_inv alpha nu) = if mu = nu then 1 else 0)
    (epsilon_up_down : Fin 4 → Fin 4 → Fin 4 → Fin 4 → ℝ)
    (LeftHodge : (Fin 4 → Fin 4 → Fin 4 → Fin 4 → ℝ) → (Fin 4 → Fin 4 → Fin 4 → Fin 4 → ℝ))
    (RightHodge : (Fin 4 → Fin 4 → Fin 4 → Fin 4 → ℝ) → (Fin 4 → Fin 4 → Fin 4 → Fin 4 → ℝ))
    (R_mu_nu : (Fin 4 → Fin 4 → Fin 4 → Fin 4 → ℝ) → (Fin 4 → Fin 4 → ℝ))
    where
  LeftHodge_def : ∀ R mu nu rho sigma, 
    LeftHodge R mu nu rho sigma = 
      (1/2 : ℝ) * ∑ alpha : Fin 4, ∑ beta : Fin 4, epsilon_up_down mu nu alpha beta * R alpha beta rho sigma
  RightHodge_def : ∀ R mu nu rho sigma, 
    RightHodge R mu nu rho sigma = 
      (1/2 : ℝ) * ∑ alpha : Fin 4, ∑ beta : Fin 4, R mu nu alpha beta * epsilon_up_down alpha beta rho sigma
  R_mu_nu_def : ∀ R mu nu, 
    R_mu_nu R mu nu = ∑ rho : Fin 4, ∑ sigma : Fin 4, g_inv rho sigma * R rho mu sigma nu
  einstein_condition_iff : ∀ (R : Fin 4 → Fin 4 → Fin 4 → Fin 4 → ℝ),
    (∀ mu nu rho sigma, R mu nu rho sigma + R mu rho sigma nu + R mu sigma nu rho = 0) → 
    (∀ mu nu rho sigma, R mu nu rho sigma = - R nu mu rho sigma) → 
    (∀ mu nu rho sigma, R mu nu rho sigma = - R mu nu sigma rho) → 
    ((∃ (c : ℝ), ∀ mu nu, R_mu_nu R mu nu = c * g mu nu) ↔ 
     (∀ mu nu rho sigma, LeftHodge R mu nu rho sigma = RightHodge R mu nu rho sigma))

Litlib.equation "krasnov2011plebanski"
  eq "4"
  page "4"
  kind "definition"
class Eq4
    (HodgeStar : (Fin 4 → Fin 4 → ℂ) → (Fin 4 → Fin 4 → ℂ))
    (isSelfDual : (Fin 4 → Fin 4 → ℂ) → Prop)
    (isAntiSelfDual : (Fin 4 → Fin 4 → ℂ) → Prop)
    where
  self_dual_iff : ∀ (A : Fin 4 → Fin 4 → ℂ),
    isSelfDual A ↔ (∀ mu nu, HodgeStar A mu nu = Complex.I * A mu nu)
  anti_self_dual_iff : ∀ (A : Fin 4 → Fin 4 → ℂ),
    isAntiSelfDual A ↔ (∀ mu nu, HodgeStar A mu nu = -(Complex.I * A mu nu))

Litlib.equation "krasnov2011plebanski"
  eq "14"
  page "5"
  kind "theorem"
class Eq14
    (Sigma : Fin 3 → Fin 4 → Fin 4 → ℂ)
    (Sigma_bar : Fin 3 → Fin 4 → Fin 4 → ℂ)
    (forms_basis : ∀ (F : Fin 4 → Fin 4 → ℂ), 
      (∀ mu nu, F mu nu = - F nu mu) → 
      ∃ (c c_bar : Fin 3 → ℂ), ∀ mu nu, 
        F mu nu = (∑ j : Fin 3, c j * Sigma j mu nu) + (∑ j : Fin 3, c_bar j * Sigma_bar j mu nu))
    where
  curvature_decomposition : ∀ (F_i : Fin 3 → Fin 4 → Fin 4 → ℂ),
    (∀ i mu nu, F_i i mu nu = - F_i i nu mu) →
    ∃ (F_ij F_bar_ij : Fin 3 → Fin 3 → ℂ),
      ∀ i mu nu, F_i i mu nu = 
        (∑ j : Fin 3, F_ij i j * Sigma j mu nu) + 
        (∑ j : Fin 3, F_bar_ij i j * Sigma_bar j mu nu)

Litlib.equation "krasnov2011plebanski"
  eq "15"
  page "6"
  kind "definition"
class Eq15
    (plebanski_vacuum : ℂ → (Fin 3 → Fin 3 → ℂ) → (Fin 3 → Fin 3 → ℂ) → Prop)
    where
  plebanski_vacuum_iff : ∀ (Lambda : ℂ) (F_ij F_bar_ij : Fin 3 → Fin 3 → ℂ),
    plebanski_vacuum Lambda F_ij F_bar_ij ↔ 
    ((∑ i : Fin 3, F_ij i i) = -Lambda ∧ (∀ i j, F_bar_ij i j = 0))

Litlib.equation "krasnov2011plebanski"
  eq "16"
  page "6"
  kind "definition"
class Eq16
    (Sigma : Fin 3 → Fin 4 → Fin 4 → ℂ)
    (Sigma_bar : Fin 3 → Fin 4 → Fin 4 → ℂ)
    (g_inv : Fin 4 → Fin 4 → ℂ)
    (T_tilde : Fin 4 → Fin 4 → ℂ)
    (T_ij : Fin 3 → Fin 3 → ℂ)
    where
  T_ij_def : ∀ (i j : Fin 3),
    T_ij i j = 
      ∑ mu : Fin 4, ∑ nu : Fin 4, ∑ rho : Fin 4, ∑ alpha : Fin 4, ∑ beta : Fin 4,
        T_tilde rho mu * 
        Sigma i nu rho * 
        g_inv mu alpha * 
        g_inv nu beta * 
        Sigma_bar j alpha beta

Litlib.equation "krasnov2011plebanski"
  eq "17"
  page "6"
  kind "definition"
class Eq17
    (Lambda : ℂ)
    (G : ℂ)
    (F_ij : Fin 3 → Fin 3 → ℂ)
    (F_bar_ij : Fin 3 → Fin 3 → ℂ)
    (T : ℂ)
    (T_ij : Fin 3 → Fin 3 → ℂ)
    (plebanski_matter_eqs : Prop)
    where
  einstein_eqs_iff : plebanski_matter_eqs ↔ 
    ((∑ i : Fin 3, F_ij i i) = -Lambda - 2 * (Real.pi : ℂ) * G * T ∧ 
     (∀ i j, F_bar_ij i j = -2 * (Real.pi : ℂ) * G * T_ij i j))

end Litlib.Y2011.krasnov2011plebanski
