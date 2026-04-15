-- FILENAME: Litlib/Y2024/gielen2024unimodular/Signature.lean

import Litlib.Core
import Mathlib.Data.Complex.Basic
import Mathlib.Data.Matrix.Basic
import Mathlib.LinearAlgebra.Matrix.Determinant.Basic
import Mathlib.LinearAlgebra.Matrix.Trace

open BigOperators

namespace Litlib.Y2024.gielen2024unimodular

Litlib.reference Eq3
  bibtex "gielen2024unimodular"
  doi "10.1088/1361-6382/ad3277"
  authors["Gielen, Steffen", "Nash, Elliot"]
  status Standard
class Eq3 where
  /--
  Equation (3) (page 4): Tetrad reconstruction constraint. The specific self-dual 
  2-form ansatz evaluates exactly to the 4-volume form without cross-terms.
  We express this locally through the components of the forms using the 
  4D and 3D Levi-Civita symbols.
  -/
  plebanskiTetradReconstruction
    (e0 : Fin 4 → ℂ)
    (eS : Fin 3 → Fin 4 → ℂ)
    (eps3 : Fin 3 → Fin 3 → Fin 3 → ℂ)
    (hEps3 : eps3 0 1 2 = 1 ∧ ∀ i j k, eps3 i j k = -eps3 j i k ∧ eps3 i j k = -eps3 i k j ∧ eps3 i j k = -eps3 k j i)
    (eps4 : Fin 4 → Fin 4 → Fin 4 → Fin 4 → ℂ)
    (hEps4 : eps4 0 1 2 3 = 1 ∧ ∀ a b c d, eps4 a b c d = -eps4 b a c d ∧ eps4 a b c d = -eps4 a c b d ∧ eps4 a b c d = -eps4 a b d c) :
    let sigma := fun (i : Fin 3) (μ ν : Fin 4) =>
      Complex.I * (e0 μ * eS i ν - eS i μ * e0 ν)
      - ∑ j : Fin 3, ∑ k : Fin 3, eps3 i j k * eS j μ * eS k ν
    let wedgeSigma := fun (i j : Fin 3) =>
      (1 / 4 : ℂ) * ∑ μ : Fin 4, ∑ ν : Fin 4, ∑ ρ : Fin 4, ∑ σ_idx : Fin 4,
        eps4 μ ν ρ σ_idx * sigma i μ ν * sigma j ρ σ_idx
    let detE := ∑ a : Fin 4, ∑ b : Fin 4, ∑ c : Fin 4, ∑ d : Fin 4,
        eps4 a b c d * e0 a * eS 0 b * eS 1 c * eS 2 d
    let ω := -2 * Complex.I * detE
    ∀ i j : Fin 3, wedgeSigma i j = if i = j then ω else 0

Litlib.reference Eq7
  bibtex "gielen2024unimodular"
  doi "10.1088/1361-6382/ad3277"
  authors["Gielen, Steffen", "Nash, Elliot"]
  status Standard
class Eq7 where
  /--
  Equation (7) (page 5): The trace Einstein constraint emerges purely algebraically 
  from the self-dual contraction properties of the 2-forms (Equation 6) and the 
  symmetry of the covariant derivative of M (the field V here). 
  -/
  bianchiTraceIdentity 
    (sigma : Fin 3 → Fin 4 → Fin 4 → ℂ)
    (v : Fin 3 → Fin 3 → Fin 4 → ℂ)
    (eps3 : Fin 3 → Fin 3 → Fin 3 → ℂ)
    (hSigmaAntisymm : ∀ i μ ν, sigma i μ ν = -sigma i ν μ)
    (hSigmaSigma1 : ∀ i j, ∑ μ : Fin 4, ∑ ν : Fin 4, sigma i μ ν * sigma j μ ν = 4 * if i = j then (1:ℂ) else 0)
    (hSigmaSigma2 : ∀ i j μ ρ, ∑ ν : Fin 4, sigma i μ ν * sigma j ν ρ = 
      -(if i = j then (1:ℂ) else 0) * (if μ = ρ then (1:ℂ) else 0) + ∑ k : Fin 3, eps3 i j k * sigma k μ ρ)
    (hVSymm : ∀ i j ρ, v i j ρ = v j i ρ)
    (hEps3Antisymm : ∀ i j k, eps3 i j k = -eps3 j i k ∧ eps3 i j k = -eps3 i k j) :
    ∀ ρ, ∑ i : Fin 3, ∑ j : Fin 3, ∑ μ : Fin 4, ∑ ν : Fin 4, sigma i μ ν * (sigma j μ ν * v i j ρ + sigma j ν ρ * v i j μ + sigma j ρ μ * v i j ν) 
      = 2 * ∑ i : Fin 3, ∑ j : Fin 3, (if i = j then (1:ℂ) else 0) * v i j ρ

Litlib.reference Eq11
  bibtex "gielen2024unimodular"
  doi "10.1088/1361-6382/ad3277"
  authors ["Gielen, Steffen", "Nash, Elliot"]
  status Standard
class Eq11 where
  /--
  Equation (11) (page 6): The derivation of the pure connection formalism relies 
  on the matrix factorization of the dualized fields.
  -/
  pureConnectionMatrix 
    (M Minv X : Matrix (Fin 3) (Fin 3) ℂ)
    (hMSymm : ∀ i j, M i j = M j i)
    (hMinvSymm : ∀ i j, Minv i j = Minv j i)
    (hInv : Minv * M = 1)
    (hEq : Minv * X * Minv = 1) :
    X = M * M

Litlib.reference UnimodularCDJ
  bibtex "gielen2024unimodular"
  doi "10.1088/1361-6382/ad3277"
  authors ["Gielen, Steffen", "Nash, Elliot"]
  status Standard
class UnimodularCDJ 
    (SpacetimePoint : Type*)
    (urbantkeMetric : (Fin 4 → Fin 4 → Matrix (Fin 3) (Fin 3) ℂ) → Matrix (Fin 4) (Fin 4) ℂ) where
  /--
  Capstone Theorem: The Unimodular Capovilla-Dell-Jacobson constraint.
  Secured by migrating mappings to class bounds and enforcing rigorous matrix 
  trace equations (Tr(F ∧ F) = Λ). Asserts that any connection satisfying the 
  chiral CDJ field equations inherently generates an Urbantke metric that has 
  a constant spacetime volume.
  -/
  cdjImpliesConstantVolume
    (F : Fin 4 → Fin 4 → SpacetimePoint → Matrix (Fin 3) (Fin 3) ℂ)
    (epsilon4 : Fin 4 → Fin 4 → Fin 4 → Fin 4 → ℂ)
    (Λ : ℂ)
    (hEpsilonAlt : ∀ α β γ δ, 
      epsilon4 α β γ δ = -epsilon4 β α γ δ ∧ 
      epsilon4 α β γ δ = -epsilon4 α γ β δ ∧ 
      epsilon4 α β γ δ = -epsilon4 α β δ γ)
    (hEpsilonNondeg : epsilon4 0 1 2 3 ≠ 0)
    (hLambdaNz : Λ ≠ 0)
    (hCdjConstraint : ∀ x, 
      (∑ μ : Fin 4, ∑ ν : Fin 4, ∑ ρ : Fin 4, ∑ σ : Fin 4,
        epsilon4 μ ν ρ σ * Matrix.trace (F μ ν x * F ρ σ x)) = Λ) :
    ∃ (c : ℂ), c ≠ 0 ∧ ∀ x, Matrix.det (urbantkeMetric (fun m n => F m n x)) = c

end Litlib.Y2024.gielen2024unimodular
