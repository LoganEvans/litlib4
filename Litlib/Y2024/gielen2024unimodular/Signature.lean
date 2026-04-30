-- FILENAME: Litlib/Y2024/gielen2024unimodular/Signature.lean

import Litlib.Core
import Mathlib.Data.Complex.Basic
import Mathlib.Data.Matrix.Basic
import Mathlib.LinearAlgebra.Matrix.Determinant.Basic
import Mathlib.LinearAlgebra.Matrix.Trace

open BigOperators

namespace Litlib.Y2024.gielen2024unimodular

Litlib.reference PlebanskiTetradReconstruction
  type "article"
  bibtex "gielen2024unimodular"
  title "Unimodular Plebański gravity"
  authors ["Gielen, Steffen", "Nash, Elliot"]
  journal "Classical and Quantum Gravity"
  volume "41"
  issue "8"
  pages "085009"
  year "2024"
  publisher "IOP Publishing"
  doi "10.1088/1361-6382/ad3277"
class PlebanskiTetradReconstruction where
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

Litlib.reference BianchiTraceIdentity
  type "article"
  bibtex "gielen2024unimodular"
  title "Unimodular Plebański gravity"
  authors ["Gielen, Steffen", "Nash, Elliot"]
  journal "Classical and Quantum Gravity"
  volume "41"
  issue "8"
  pages "085009"
  year "2024"
  publisher "IOP Publishing"
  doi "10.1088/1361-6382/ad3277"
class BianchiTraceIdentity where
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

Litlib.reference PureConnectionMatrix
  type "article"
  bibtex "gielen2024unimodular"
  title "Unimodular Plebański gravity"
  authors ["Gielen, Steffen", "Nash, Elliot"]
  journal "Classical and Quantum Gravity"
  volume "41"
  issue "8"
  pages "085009"
  year "2024"
  publisher "IOP Publishing"
  doi "10.1088/1361-6382/ad3277"
class PureConnectionMatrix where
  pureConnectionMatrix 
    (M Minv X : Matrix (Fin 3) (Fin 3) ℂ)
    (hMSymm : ∀ i j, M i j = M j i)
    (hMinvSymm : ∀ i j, Minv i j = Minv j i)
    (hInv : Minv * M = 1)
    (hEq : Minv * X * Minv = 1) :
    X = M * M

Litlib.reference UnimodularCDJ
  type "article"
  bibtex "gielen2024unimodular"
  title "Unimodular Plebański gravity"
  authors ["Gielen, Steffen", "Nash, Elliot"]
  journal "Classical and Quantum Gravity"
  volume "41"
  issue "8"
  pages "085009"
  year "2024"
  publisher "IOP Publishing"
  doi "10.1088/1361-6382/ad3277"
class UnimodularCDJ 
    (SpacetimePoint : Type*)
    (urbantkeMetric : (Fin 4 → Fin 4 → Matrix (Fin 3) (Fin 3) ℂ) → Matrix (Fin 4) (Fin 4) ℂ) where
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
