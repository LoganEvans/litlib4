-- FILENAME: Litlib/Y1989/capovilla1989general/Signature.lean

import Litlib.Core
import Mathlib.Data.Complex.Basic
import Mathlib.Data.Real.Basic
import Mathlib.Data.Matrix.Basic
import Mathlib.LinearAlgebra.Matrix.Trace

open BigOperators

namespace Litlib.Y1989.capovilla1989general

Litlib.reference Eq1
  bibtex "capovilla1989general"
  doi "10.1103/PhysRevLett.63.2325"
  authors ["Capovilla, Riccardo", "Jacobson, Ted", "Dell, John"]
  status Standard
class Eq1 where
  cdjIntegrand :
    ∀ (SpacetimePoint : Type*)
      (F : SpacetimePoint → Fin 4 → Fin 4 → Matrix (Fin 3) (Fin 3) ℂ)
      (η : SpacetimePoint → ℂ)
      (epsilon4 : Fin 4 → Fin 4 → Fin 4 → Fin 4 → ℂ)
      (_hEpsilonAlt : ∀ α β γ δ, 
        epsilon4 α β γ δ = -epsilon4 β α γ δ ∧ 
        epsilon4 α β γ δ = -epsilon4 α γ β δ ∧ 
        epsilon4 α β γ δ = -epsilon4 α β δ γ)
      (_hEpsilonNondeg : epsilon4 0 1 2 3 ≠ 0)
      (Integrand : SpacetimePoint → ℂ),
      ∀ x, Integrand x = η x * ∑ μ : Fin 4, ∑ ν : Fin 4, ∑ ρ : Fin 4, ∑ σ : Fin 4,
        epsilon4 μ ν ρ σ * Matrix.trace (F x μ ν * F x ρ σ)

Litlib.reference Eq6_RicciFlat
  bibtex "capovilla1989general"
  doi "10.1103/PhysRevLett.63.2325"
  authors ["Capovilla, Riccardo", "Jacobson, Ted", "Dell, John"]
  status Standard
class Eq6_RicciFlat where
  cdjImpliesRicciFlat :
    ∀ (SpacetimePoint : Type*)
      (urbantkeMetric : (SpacetimePoint → Fin 4 → Fin 4 → Matrix (Fin 3) (Fin 3) ℂ) → (SpacetimePoint → Fin 4 → Fin 4 → ℝ))
      (ricciTensor : (SpacetimePoint → Fin 4 → Fin 4 → ℝ) → SpacetimePoint → Fin 4 → Fin 4 → ℝ)
      (F : SpacetimePoint → Fin 4 → Fin 4 → Matrix (Fin 3) (Fin 3) ℂ)
      (epsilon4 : Fin 4 → Fin 4 → Fin 4 → Fin 4 → ℂ)
      (_hEpsilonAlt : ∀ α β γ δ, 
        epsilon4 α β γ δ = -epsilon4 β α γ δ ∧ 
        epsilon4 α β γ δ = -epsilon4 α γ β δ ∧ 
        epsilon4 α β γ δ = -epsilon4 α β δ γ)
      (_hEpsilonNondeg : epsilon4 0 1 2 3 ≠ 0)
      (_h_metric_zero : urbantkeMetric (fun _ _ _ => 0) = fun _ _ _ => 0)
      (_hCdjConstraint : ∀ x, 
        (∑ μ : Fin 4, ∑ ν : Fin 4, ∑ ρ : Fin 4, ∑ σ : Fin 4,
          epsilon4 μ ν ρ σ * Matrix.trace (F x μ ν * F x ρ σ)) = 0),
      ∀ (x : SpacetimePoint) (μ ν : Fin 4), ricciTensor (urbantkeMetric F) x μ ν = 0

end Litlib.Y1989.capovilla1989general
