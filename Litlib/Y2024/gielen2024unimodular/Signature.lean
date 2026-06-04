-- FILENAME: Litlib/Y2024/gielen2024unimodular/Signature.lean

import Litlib.Core
import Mathlib.Data.Complex.Basic
import Mathlib.Data.Matrix.Basic
import Mathlib.LinearAlgebra.Matrix.Determinant.Basic
import Mathlib.LinearAlgebra.Matrix.Trace
import Mathlib.Topology.Basic

open BigOperators

namespace Litlib.Y2024.gielen2024unimodular

Litlib.paper "gielen2024unimodular"
  type "article"
  title "Unimodular Plebański gravity"
  authors ["Gielen, Steffen", "Nash, Elliot"]
  journal "Classical and Quantum Gravity"
  volume "41"
  issue "8"
  pages "085009"
  year "2024"
  publisher "IOP Publishing"
  doi "10.1088/1361-6382/ad3277"

Litlib.equation "gielen2024unimodular"
  eq "3"
  page "4"
  kind "definition"
/--
Physical Interpretation: Constructs the chiral Plebański 2-forms `Σ^i` from a tetrad field `e`, demonstrating the equivalence between the metric variables and the chiral form variables.
Mathematical Boundaries: The volume form `ω` determined by the tetrad must be strictly non-zero (`detE ≠ 0`), which mathematically prevents topological collapse into a degenerate geometry and avoids a trivial zero-equals-zero tautology.
-/
class PlebanskiTetradReconstruction where
  general_solution_tetrad
    (e0 : Fin 4 → ℂ)
    (eS : Fin 3 → Fin 4 → ℂ)
    (eps3 : Fin 3 → Fin 3 → Fin 3 → ℂ)
    (hEps3 : eps3 0 1 2 = 1 ∧ ∀ i j k, eps3 i j k = -eps3 j i k ∧ eps3 i j k = -eps3 i k j ∧ eps3 i j k = -eps3 k j i)
    (eps4 : Fin 4 → Fin 4 → Fin 4 → Fin 4 → ℂ)
    (hEps4 : eps4 0 1 2 3 = 1 ∧ ∀ a b c d, eps4 a b c d = -eps4 b a c d ∧ eps4 a b c d = -eps4 a c b d ∧ eps4 a b c d = -eps4 a b d c)
    (hNonDegenerate : (∑ a : Fin 4, ∑ b : Fin 4, ∑ c : Fin 4, ∑ d : Fin 4, eps4 a b c d * e0 a * eS 0 b * eS 1 c * eS 2 d) ≠ 0) :
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

Litlib.equation "gielen2024unimodular"
  eq "6"
  page "4"
  kind "identity"
/--
Physical Interpretation: Relates the contraction of the Plebański 2-forms to the Urbantke metric, explicitly mapping the chiral algebraic structure back to the macroscopic spacetime metric tensor.
Mathematical Boundaries: Requires the Urbantke metric `g` to be non-degenerate to maintain a well-defined physical spacetime without coordinate singularities.
-/
class UrbantkeMetricIdentity where
  sigma_algebra 
    (sigmaUp : Fin 3 → Fin 4 → Fin 4 → ℂ)
    (sigmaDown : Fin 3 → Fin 4 → Fin 4 → ℂ)
    (g : Fin 4 → Fin 4 → ℂ)
    (eps3 : Fin 3 → Fin 3 → Fin 3 → ℂ)
    (hNonDegenerate : Matrix.det (fun μ ν => g μ ν) ≠ 0) : Prop
  sigma_algebra_iff : ∀ sigmaUp sigmaDown g eps3 hN, 
    sigma_algebra sigmaUp sigmaDown g eps3 hN ↔ 
    ∀ i j μ ν, 
      (∑ ρ : Fin 4, sigmaUp i μ ρ * sigmaDown j ρ ν) = 
      -(if i = j then (1:ℂ) else 0) * g μ ν + 
      ∑ k : Fin 3, eps3 i j k * sigmaDown k μ ν

Litlib.equation "gielen2024unimodular"
  eq "7"
  page "5"
  kind "equation"
/--
Physical Interpretation: Derives the trace of the Einstein field equations entirely from the Bianchi identities and the algebraic simplicity constraints. This is the cornerstone of the unimodular gravity formulation where the cosmological constant arises as an integration constant.
Mathematical Boundaries: Strictly requires the total antisymmetry of the 2-forms and structural consistency with the internal SU(2)/SO(3) algebra.
-/
class BianchiTraceIdentity where
  derive_trace_eom 
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

Litlib.equation "gielen2024unimodular"
  eq "11"
  page "6"
  kind "equation"
/--
Physical Interpretation: Solves the simplicity constraint in the pure connection formalism, linking the independent connection fields to the chiral 2-forms via a matrix equation.
Mathematical Boundaries: By specifying `Minv * M = 1`, the formulation explicitly excludes pathological vacua where the mapping matrix `M` drops rank, guaranteeing a bijective mapping to physical tetrad states.
-/
class PureConnectionMatrixSolution where
  pureConnectionMatrix 
    (M Minv X : Matrix (Fin 3) (Fin 3) ℂ)
    (hMSymm : ∀ i j, M i j = M j i)
    (hMinvSymm : ∀ i j, Minv i j = Minv j i)
    (hInv : Minv * M = 1)
    (hEq : Minv * X * Minv = 1) :
    X = M * M

Litlib.equation "gielen2024unimodular"
  eq "14"
  page "6"
  kind "equation"
/--
Physical Interpretation: Evaluates the equation of motion for unimodular gravity in the pure connection framework. It describes the covariant dynamics of the pure connection without reference to an independent tetrad field.
Mathematical Boundaries: The spacetime must possess a topological structure to admit continuous field mappings. The matrix field `X_tilde` must be globally invertible to compute the inverse square roots required for the action.
-/
class PureConnectionEOM 
    (SpacetimePoint : Type*) [TopologicalSpace SpacetimePoint]
    [TopologicalSpace ℂ]
    [TopologicalSpace (Fin 3 → ℂ)]
    [TopologicalSpace (Matrix (Fin 3) (Fin 3) ℂ)]
    (covariantDeriv : (SpacetimePoint → Matrix (Fin 3) (Fin 3) ℂ) → (SpacetimePoint → ℂ) → SpacetimePoint → Fin 4 → ℂ) where
  unimodular_eom
    (X_tilde : SpacetimePoint → Matrix (Fin 3) (Fin 3) ℂ)
    (X_tilde_inv_sqrt : SpacetimePoint → Matrix (Fin 3) (Fin 3) ℂ)
    (F : SpacetimePoint → Fin 3 → ℂ)
    (A : SpacetimePoint → Matrix (Fin 3) (Fin 3) ℂ)
    (hContX : Continuous X_tilde)
    (hContXInv : Continuous X_tilde_inv_sqrt)
    (hContF : Continuous F)
    (hContA : Continuous A)
    (hNonDegenerate : ∀ x, Matrix.det (X_tilde x) ≠ 0)
    (hInvSqrt : ∀ x, X_tilde_inv_sqrt x * X_tilde_inv_sqrt x * X_tilde x = 1) : Prop
  unimodular_eom_iff : ∀ X_tilde X_tilde_inv_sqrt F A hCX hCXI hCF hCA hN hI,
    unimodular_eom X_tilde X_tilde_inv_sqrt F A hCX hCXI hCF hCA hN hI ↔ 
    ∀ x μ, 
      let tr_sqrt_X p := Matrix.trace (X_tilde_inv_sqrt p * X_tilde p)
      let inner_term p j := tr_sqrt_X p * ∑ i, (X_tilde_inv_sqrt p) i j * F p j
      -- Represents the covariant exterior derivative D_A evaluating to 0 across all 4 spacetime dimensions
      covariantDeriv A (fun p => ∑ j, inner_term p j) x μ = 0

end Litlib.Y2024.gielen2024unimodular
