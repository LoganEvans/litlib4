-- FILENAME: Litlib/Y2024/gielen2024unimodular/Signature.lean

import Litlib.Core
import Mathlib.Data.Complex.Basic
import Mathlib.Data.Matrix.Basic
import Mathlib.LinearAlgebra.Matrix.Determinant.Basic

namespace Litlib.Y2024.gielen2024unimodular

literature_citation Eq3
  bibtex_key "gielen2024unimodular"
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
  plebanski_tetrad_reconstruction
    (E_0 : Fin 4 → ℂ)
    (E_s : Fin 3 → Fin 4 → ℂ)
    (eps3 : Fin 3 → Fin 3 → Fin 3 → ℂ)
    (h_eps3 : eps3 0 1 2 = 1 ∧ ∀ i j k, eps3 i j k = -eps3 j i k ∧ eps3 i j k = -eps3 i k j ∧ eps3 i j k = -eps3 k j i)
    (eps4 : Fin 4 → Fin 4 → Fin 4 → Fin 4 → ℂ)
    (h_eps4 : eps4 0 1 2 3 = 1 ∧ ∀ a b c d, eps4 a b c d = -eps4 b a c d ∧ eps4 a b c d = -eps4 a c b d ∧ eps4 a b c d = -eps4 a b d c) :
    let sigma := fun (i : Fin 3) (μ ν : Fin 4) =>
      Complex.I * (E_0 μ * E_s i ν - E_s i μ * E_0 ν)
      - ∑ j : Fin 3, ∑ k : Fin 3, eps3 i j k * E_s j μ * E_s k ν
    let wedge_sigma := fun (i j : Fin 3) =>
      (1 / 4 : ℂ) * ∑ μ : Fin 4, ∑ ν : Fin 4, ∑ ρ : Fin 4, ∑ σ_idx : Fin 4,
        eps4 μ ν ρ σ_idx * sigma i μ ν * sigma j ρ σ_idx
    let detE := ∑ a : Fin 4, ∑ b : Fin 4, ∑ c : Fin 4, ∑ d : Fin 4,
        eps4 a b c d * E_0 a * E_s 0 b * E_s 1 c * E_s 2 d
    let ω := -2 * Complex.I * detE
    ∀ i j : Fin 3, wedge_sigma i j = if i = j then ω else 0

literature_citation Eq7
  bibtex_key "gielen2024unimodular"
  doi "10.1088/1361-6382/ad3277"
  authors["Gielen, Steffen", "Nash, Elliot"]
  status Standard
class Eq7 where
  /--
  Equation (7) (page 5): The trace Einstein constraint emerges purely algebraically 
  from the self-dual contraction properties of the 2-forms (Equation 6) and the 
  symmetry of the covariant derivative of M (the field V here). 
  -/
  bianchi_trace_identity 
    (Sigma : Fin 3 → Fin 4 → Fin 4 → ℂ)
    (V : Fin 3 → Fin 3 → Fin 4 → ℂ)
    (eps3 : Fin 3 → Fin 3 → Fin 3 → ℂ)
    (h_Sigma_antisymm : ∀ i μ ν, Sigma i μ ν = -Sigma i ν μ)
    (h_Sigma_Sigma1 : ∀ i j, ∑ μ : Fin 4, ∑ ν : Fin 4, Sigma i μ ν * Sigma j μ ν = 4 * if i = j then (1:ℂ) else 0)
    (h_Sigma_Sigma2 : ∀ i j μ ρ, ∑ ν : Fin 4, Sigma i μ ν * Sigma j ν ρ = 
      -(if i = j then (1:ℂ) else 0) * (if μ = ρ then (1:ℂ) else 0) + ∑ k : Fin 3, eps3 i j k * Sigma k μ ρ)
    (h_V_symm : ∀ i j ρ, V i j ρ = V j i ρ)
    (h_eps3_antisymm : ∀ i j k, eps3 i j k = -eps3 j i k ∧ eps3 i j k = -eps3 i k j) :
    ∀ i ρ, ∑ j : Fin 3, ∑ μ : Fin 4, ∑ ν : Fin 4, Sigma i μ ν * (Sigma j μ ν * V i j ρ + Sigma j ν ρ * V i j μ + Sigma j ρ μ * V i j ν) 
      = 2 * ∑ j : Fin 3, (if i = j then (1:ℂ) else 0) * V i j ρ

literature_citation Eq11
  bibtex_key "gielen2024unimodular"
  doi "10.1088/1361-6382/ad3277"
  authors ["Gielen, Steffen", "Nash, Elliot"]
  status Standard
class Eq11 where
  /--
  Equation (11) (page 6): The derivation of the pure connection formalism relies 
  on the matrix factorization of the dualized fields.
  -/
  pure_connection_matrix 
    (M Minv X : Matrix (Fin 3) (Fin 3) ℂ)
    (hM_symm : ∀ i j, M i j = M j i)
    (hMinv_symm : ∀ i j, Minv i j = Minv j i)
    (h_inv : Minv * M = 1)
    (h_eq : Minv * X * Minv = 1) :
    X = M * M

literature_citation UnimodularCDJ
  bibtex_key "gielen2024unimodular"
  doi "10.1088/1361-6382/ad3277"
  authors ["Gielen, Steffen", "Nash, Elliot"]
  status Standard
class UnimodularCDJ where
  /--
  Capstone Theorem: The Unimodular Capovilla-Dell-Jacobson constraint.
  Using the Weyl Pattern, this theorem asserts that any connection satisfying 
  the chiral CDJ field equations inherently generates a spacetime metric 
  (via the Urbantke construction) that has a constant spacetime volume.
  -/
  cdj_implies_constant_volume
    (SpacetimePoint SL2C : Type*)
    (satisfiesCdjConstraint : (Fin 4 → Fin 4 → SpacetimePoint → SL2C) → Prop)
    (urbantkeMetric : (Fin 4 → Fin 4 → SL2C) → Matrix (Fin 4) (Fin 4) ℂ)
    (F : Fin 4 → Fin 4 → SpacetimePoint → SL2C) :
    satisfiesCdjConstraint F →
    ∃ (c : ℂ), c ≠ 0 ∧ ∀ x, Matrix.det (urbantkeMetric (fun m n => F m n x)) = c

end Litlib.Y2024.gielen2024unimodular
