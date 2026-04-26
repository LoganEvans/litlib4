-- FILENAME: Litlib/Y1991/capovilla1991pure/Signature.lean

import Litlib.Core
import Mathlib.Data.Matrix.Basic
import Mathlib.Data.Complex.Basic

namespace Litlib.Y1991.capovilla1991pure

Litlib.reference Eq2_22
  bibtex "capovilla1991pure"
  doi "10.1088/0264-9381/8/1/01"
  authors ["Capovilla, Riccardo", "Dell, John", "Jacobson, Ted"]
  status Standard

class Eq2_22 
    (R : Fin 4 → Fin 4 → Fin 2 → Fin 2 → ℂ)
    (eta : ℂ)
    (epsilon : Fin 4 → Fin 4 → Fin 4 → Fin 4 → ℂ) where
  urbantkeMetricSymmetric
    (hEpsAlt : ∀ α β γ δ, 
      epsilon α β γ δ = -epsilon β α γ δ ∧ 
      epsilon α β γ δ = -epsilon α γ β δ ∧ 
      epsilon α β γ δ = -epsilon α β δ γ)
    (hEpsNondeg : epsilon 0 1 2 3 ≠ 0)
    (hRSkew : ∀ μ ν A B, R μ ν A B = - R ν μ A B)
    (hRSymmSpin : ∀ μ ν A B, R μ ν A B = R μ ν B A) :
    let g := fun (μ ν : Fin 4) =>
      (1 / 3 : ℂ) * eta *
      Finset.sum Finset.univ (fun α =>
        Finset.sum Finset.univ (fun β =>
          Finset.sum Finset.univ (fun γ =>
            Finset.sum Finset.univ (fun δ =>
              Finset.sum Finset.univ (fun A =>
                Finset.sum Finset.univ (fun B =>
                  Finset.sum Finset.univ (fun C =>
                    epsilon α β γ δ * R μ α A B * R β γ B C * R δ ν C A)))))))
    ∀ μ ν, g μ ν = g ν μ

Litlib.reference Eq2_2c
  bibtex "capovilla1991pure"
  doi "10.1088/0264-9381/8/1/01"
  authors ["Capovilla, Riccardo", "Dell, John", "Jacobson, Ted"]
  status Standard

class Eq2_2c 
    (SpacetimePoint : Type*)
    (partialDeriv : Fin 4 → (SpacetimePoint → ℂ) → SpacetimePoint → ℂ)
    (urbantkeMetric : (SpacetimePoint → Fin 4 → Fin 4 → Matrix (Fin 2) (Fin 2) ℂ) → (Fin 4 → Fin 4 → SpacetimePoint → ℂ))
    (metricInv : (Fin 4 → Fin 4 → SpacetimePoint → ℂ) → (Fin 4 → Fin 4 → SpacetimePoint → ℂ))
    (christoffel : (Fin 4 → Fin 4 → SpacetimePoint → ℂ) → Fin 4 → Fin 4 → Fin 4 → SpacetimePoint → ℂ)
    (ricciTensor : (Fin 4 → Fin 4 → SpacetimePoint → ℂ) → Fin 4 → Fin 4 → SpacetimePoint → ℂ) where
  
  -- Anti-BS Calculus Constraints
  derivCommute : ∀ μ ν f x, partialDeriv μ (fun p => partialDeriv ν f p) x = partialDeriv ν (fun p => partialDeriv μ f p) x
  derivLeibniz : ∀ μ f1 f2 x, partialDeriv μ (fun p => f1 p * f2 p) x = partialDeriv μ f1 x * f2 x + f1 x * partialDeriv μ f2 x
  
  -- Metric Invertibility Constraint
  h_inv : ∀ g x i j, (∑ k : Fin 4, g i k x * metricInv g k j x) = if i = j then 1 else 0
  
  -- Geometric Integrity: Ricci must be derived from Christoffel symbols, which must be derived from the metric.
  h_christoffel : ∀ g x rho mu nu, 
    christoffel g rho mu nu x = (1/2 : ℂ) * ∑ sigma : Fin 4, metricInv g rho sigma x * (
      partialDeriv mu (fun p => g sigma nu p) x + 
      partialDeriv nu (fun p => g mu sigma p) x - 
      partialDeriv sigma (fun p => g mu nu p) x)
      
  h_ricci : ∀ g x mu nu,
    ricciTensor g mu nu x = ∑ rho : Fin 4, (
      partialDeriv rho (fun p => christoffel g rho mu nu p) x - 
      partialDeriv nu (fun p => christoffel g rho mu rho p) x + 
      ∑ lambda : Fin 4, (christoffel g rho lambda rho x * christoffel g lambda mu nu x - 
                         christoffel g rho lambda nu x * christoffel g lambda mu rho x)
    )

  /--
  Capovilla 1991, Equation (2.2c) + associated text:
  "The third equation (2.2c) states that the curvature is pure Weyl, i.e. the metric 
  defined by this tetrad is Ricci flat."
  By fixing the constraints explicitly to complex functions, we prevent metric mutialation.
  -/
  urbantkeIsRicciFlat
    (F : SpacetimePoint → Fin 4 → Fin 4 → Matrix (Fin 2) (Fin 2) ℂ)
    (epsilon4 : Fin 4 → Fin 4 → Fin 4 → Fin 4 → ℂ)
    (hEpsilonAlt : ∀ α β γ δ, 
      epsilon4 α β γ δ = -epsilon4 β α γ δ ∧ 
      epsilon4 α β γ δ = -epsilon4 α γ β δ ∧ 
      epsilon4 α β γ δ = -epsilon4 α β δ γ)
    (hEpsilonNondeg : epsilon4 0 1 2 3 ≠ 0)
    (hNonDegenerate : ∀ x, Matrix.det (Matrix.of (fun i j => urbantkeMetric F i j x)) ≠ 0)
    (hPureConnection : ∀ x, 
      (∑ μ : Fin 4, ∑ ν : Fin 4, ∑ ρ : Fin 4, ∑ σ : Fin 4,
        epsilon4 μ ν ρ σ * Matrix.trace (F x μ ν * F x ρ σ)) = 0) :
    ∀ (x : SpacetimePoint) (μ ν : Fin 4), ricciTensor (urbantkeMetric F) μ ν x = 0

end Litlib.Y1991.capovilla1991pure
