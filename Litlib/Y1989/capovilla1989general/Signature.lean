-- FILENAME: Litlib/Y1989/capovilla1989general/Signature.lean

import Litlib.Core
import Mathlib.Data.Complex.Basic
import Mathlib.Data.Real.Basic
import Mathlib.Data.Matrix.Basic
import Mathlib.LinearAlgebra.Matrix.Determinant.Basic

open BigOperators

namespace Litlib.Y1989.capovilla1989general

-- Eq (2): The h_{abcd} tensor over the SO(3,C) indices
def capovillaMetric (α β : ℂ) (a b c d : Fin 3) : ℂ := 
  α * ((if c = a then (1 : ℂ) else 0) * (if b = d then (1 : ℂ) else 0) + 
       (if c = b then (1 : ℂ) else 0) * (if a = d then (1 : ℂ) else 0)) + 
  β * (if a = b then (1 : ℂ) else 0) * (if c = d then (1 : ℂ) else 0)

-- Helper to contract the 4D spacetime indices for the wedge product F ∧ F
def wedgeContract (F1 F2 : Fin 4 → Fin 4 → ℂ) (eps : Fin 4 → Fin 4 → Fin 4 → Fin 4 → ℂ) : ℂ :=
  ∑ μ, ∑ ν, ∑ ρ, ∑ σ, eps μ ν ρ σ * F1 μ ν * F2 ρ σ

Litlib.paper "capovilla1989general"
  type "article"
  title "General relativity without the metric"
  authors ["Capovilla, Riccardo", "Jacobson, Ted", "Dell, John"]
  journal "Physical Review Letters"
  volume "63"
  issue "21"
  pages "2325"
  year "1989"
  publisher "APS"
  doi "10.1103/PhysRevLett.63.2325"

Litlib.equation "capovilla1989general"
  eq "1, 2"
  page "2326"
  kind "Action Integrand"
class CDJActionIntegrand 
    (Spacetime : Type*)
    (F : Spacetime → Fin 3 → Fin 4 → Fin 4 → ℂ)
    (η : Spacetime → ℂ)
    (α β : ℂ)
    (epsilon4 : Fin 4 → Fin 4 → Fin 4 → Fin 4 → ℂ)
    (Integrand : Spacetime → ℂ) where
  cdj_integrand_iff : ∀ x, Integrand x = 
    ∑ a, ∑ b, ∑ c, ∑ d,
      capovillaMetric α β a b c d * 
      (η x * wedgeContract (F x a) (F x b) epsilon4) * 
      wedgeContract (F x c) (F x d) epsilon4

Litlib.equation "capovilla1989general"
  eq "6a"
  page "2326"
  kind "Equation of Motion"
class CDJEquation6a
    (Spacetime : Type*)
    (F : Spacetime → Fin 3 → Fin 4 → Fin 4 → ℂ)
    (α β : ℂ)
    (epsilon4 : Fin 4 → Fin 4 → Fin 4 → Fin 4 → ℂ)
    (satisfies_6a : Spacetime → Prop) where
  satisfies_6a_iff : ∀ x, satisfies_6a x ↔ 
    (∑ a, ∑ b, ∑ c, ∑ d,
      capovillaMetric α β a b c d * 
      wedgeContract (F x a) (F x b) epsilon4 * 
      wedgeContract (F x c) (F x d) epsilon4) = 0

Litlib.equation "capovilla1989general"
  eq "7a"
  page "2326"
  kind "Definition"
class CDJSigmaDef
    (Spacetime : Type*)
    (F : Spacetime → Fin 3 → Fin 4 → Fin 4 → ℂ)
    (η : Spacetime → ℂ)
    (α β : ℂ)
    (epsilon4 : Fin 4 → Fin 4 → Fin 4 → Fin 4 → ℂ)
    (Sigma : Spacetime → Fin 3 → Fin 4 → Fin 4 → ℂ) where
  sigma_def_iff : ∀ x d μ ν, Sigma x d μ ν = 
    ∑ a, ∑ b, ∑ c,
      capovillaMetric α β a b c d * 
      (η x * wedgeContract (F x a) (F x b) epsilon4) * 
      F x c μ ν

Litlib.equation "capovilla1989general"
  eq "Theorem"
  page "2326"
  kind "Theorem"
class CDJImpliesRicciFlat
    (Spacetime : Type*)
    (urbantkeMetric : (Spacetime → Fin 3 → Fin 4 → Fin 4 → ℂ) → Spacetime → Fin 4 → Fin 4 → ℂ)
    (ricciTensor : (Spacetime → Fin 4 → Fin 4 → ℂ) → Spacetime → Fin 4 → Fin 4 → ℂ) where
  cdj_implies_ricci_flat 
    (F : Spacetime → Fin 3 → Fin 4 → Fin 4 → ℂ)
    (α β : ℂ)
    (epsilon4 : Fin 4 → Fin 4 → Fin 4 → Fin 4 → ℂ)
    (hEpsilonAlt : ∀ μ ν ρ σ, 
      epsilon4 μ ν ρ σ = -epsilon4 ν μ ρ σ ∧ 
      epsilon4 μ ν ρ σ = -epsilon4 μ ρ ν σ ∧ 
      epsilon4 μ ν ρ σ = -epsilon4 μ ν σ ρ)
    (hEpsilonNondeg : epsilon4 0 1 2 3 ≠ 0)
    (h_coupling : α = -β)
    (h_alpha_nz : α ≠ 0)
    (h_non_degenerate : ∀ x, Matrix.det (Matrix.of (urbantkeMetric F x)) ≠ 0)
    (h_6a : ∀ x, (∑ a, ∑ b, ∑ c, ∑ d,
      capovillaMetric α β a b c d * 
      wedgeContract (F x a) (F x b) epsilon4 * 
      wedgeContract (F x c) (F x d) epsilon4) = 0) :
    ∀ x μ ν, ricciTensor (urbantkeMetric F) x μ ν = 0

end Litlib.Y1989.capovilla1989general
