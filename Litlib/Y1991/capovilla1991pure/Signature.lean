-- FILENAME: Litlib/Y1991/capovilla1991pure/Signature.lean

import Litlib.Core
import Mathlib.Topology.Basic
import Mathlib.Data.Matrix.Basic
import Mathlib.Data.Complex.Basic
import Mathlib.MeasureTheory.Measure.MeasureSpace
import Mathlib.MeasureTheory.Integral.Bochner.Basic
import Mathlib.MeasureTheory.Function.StronglyMeasurable.AEStronglyMeasurable

open BigOperators

namespace Litlib.Y1991.capovilla1991pure

-- Helper functions to completely bypass Mathlib's `∑` macro parser traps
noncomputable def sumFin4 (f : Fin 4 → ℂ) : ℂ := Finset.sum Finset.univ f
noncomputable def sumFin2 (f : Fin 2 → ℂ) : ℂ := Finset.sum Finset.univ f

Litlib.paper "capovilla1991pure"
  type "article"
  title "A pure spin-connection formulation of gravity"
  authors ["Capovilla, Riccardo", "Dell, John", "Jacobson, Ted"]
  journal "Classical and Quantum Gravity"
  volume "8"
  issue "1"
  pages "59--73"
  year "1991"
  doi "10.1088/0264-9381/8/1/01"

Litlib.equation "capovilla1991pure"
  eq "2.1"
  page "61"
  kind "Action"
class Eq2_1
    (Spacetime : Type*) [TopologicalSpace Spacetime] [MeasureTheory.MeasureSpace Spacetime]
    (S : ℂ)
    (Sigma : Spacetime → Fin 4 → Fin 4 → Fin 2 → Fin 2 → ℂ)
    (R : Spacetime → Fin 4 → Fin 4 → Fin 2 → Fin 2 → ℂ)
    (Psi : Spacetime → Fin 2 → Fin 2 → Fin 2 → Fin 2 → ℂ)
    (epsilon4 : Fin 4 → Fin 4 → Fin 4 → Fin 4 → ℂ) where
  /-- Measure-Theoretic Integrability Constraint: Fields must be strongly measurable across the spacetime manifold to ensure that the action integral is rigorously well-defined. -/
  hSigma_meas : ∀ μ ν A B, MeasureTheory.AEStronglyMeasurable (fun x => Sigma x μ ν A B) volume
  hR_meas : ∀ μ ν A B, MeasureTheory.AEStronglyMeasurable (fun x => R x μ ν A B) volume
  hPsi_meas : ∀ A B C D, MeasureTheory.AEStronglyMeasurable (fun x => Psi x A B C D) volume
  
  /-- Topological Orientation Constraint: The Levi-Civita symbol must be strictly antisymmetric under index exchange to preserve the proper volume form of the spacetime manifold. -/
  h_eps_swap1 : ∀ α β γ δ, epsilon4 α β γ δ = - epsilon4 β α γ δ
  h_eps_swap2 : ∀ α β γ δ, epsilon4 α β γ δ = - epsilon4 α γ β δ
  
  /-- Non-Degeneracy Constraint: The four-dimensional Levi-Civita symbol must be strictly non-zero. -/
  h_eps_nonzero : epsilon4 0 1 2 3 ≠ 0
  
  eq2_1_iff : S = MeasureTheory.integral volume (fun x =>
    let term1 := sumFin4 fun μ => sumFin4 fun ν => sumFin4 fun ρ => sumFin4 fun σ =>
      epsilon4 μ ν ρ σ * sumFin2 fun A => sumFin2 fun B =>
        Sigma x μ ν A B * R x ρ σ A B;
    let term2 := sumFin4 fun μ => sumFin4 fun ν => sumFin4 fun ρ => sumFin4 fun σ =>
      epsilon4 μ ν ρ σ * sumFin2 fun A => sumFin2 fun B => sumFin2 fun C => sumFin2 fun D =>
        Psi x A B C D * Sigma x μ ν A B * Sigma x ρ σ C D;
    term1 - (1/2 : ℂ) * term2
  )

Litlib.equation "capovilla1991pure"
  eq "2.2a"
  page "61"
  kind "Equation of Motion"
class Eq2_2a
    (Spacetime : Type*) [TopologicalSpace Spacetime]
    (Sigma : Spacetime → Fin 4 → Fin 4 → Fin 2 → Fin 2 → ℂ)
    (epsilon4 : Fin 4 → Fin 4 → Fin 4 → Fin 4 → ℂ) where
  /-- Algebraic Symmetry Constraint: $\Sigma$ must transform as a valid 2-form, requiring strict antisymmetry in its spacetime indices. -/
  hSigma_anti : ∀ x μ ν A B, Sigma x μ ν A B = - Sigma x ν μ A B
  
  /-- Spinor Symmetry Constraint: $\Sigma$ must be strictly symmetric in its chiral spinor indices. -/
  hSigma_symm : ∀ x μ ν A B, Sigma x μ ν A B = Sigma x μ ν B A
  
  /-- Non-Degeneracy Constraint: The four-dimensional Levi-Civita symbol must be strictly non-zero. -/
  h_eps_nonzero : epsilon4 0 1 2 3 ≠ 0
  
  eq2_2a_iff : ∀ x A B C D,
    let w := fun A' B' C' D' => sumFin4 fun μ => sumFin4 fun ν => sumFin4 fun ρ => sumFin4 fun σ =>
      epsilon4 μ ν ρ σ * Sigma x μ ν A' B' * Sigma x ρ σ C' D';
    -- Total symmetrization over A,B,C,D (since pairs AB and CD are already symmetric)
    w A B C D + w A C B D + w A D B C = 0

Litlib.equation "capovilla1991pure"
  eq "2.2b"
  page "61"
  kind "Equation of Motion"
class Eq2_2b
    (Spacetime : Type*) [TopologicalSpace Spacetime]
    (dSigma : Spacetime → Fin 4 → Fin 4 → Fin 4 → Fin 2 → Fin 2 → ℂ) -- 3-form
    (omega : Spacetime → Fin 4 → Fin 2 → Fin 2 → ℂ) -- 1-form connection
    (Sigma : Spacetime → Fin 4 → Fin 4 → Fin 2 → Fin 2 → ℂ) -- 2-form
    (eps2_up : Fin 2 → Fin 2 → ℂ) where
  /-- Algebraic Form Constraint: Enforces proper exterior algebra antisymmetry on spacetime indices for $\Sigma$. -/
  hSigma_anti : ∀ x μ ν A B, Sigma x μ ν A B = - Sigma x ν μ A B
  
  /-- Connection Symmetry Constraint: The spin connection $\omega$ must be symmetric in its spinor indices. -/
  homega_symm : ∀ x μ A B, omega x μ A B = omega x μ B A
  
  eq2_2b_iff : ∀ x μ ν ρ A B,
    let omega_up := fun lam A' C' => sumFin2 fun E => eps2_up A' E * omega x lam E C';
    let term := fun m n r => dSigma x m n r A B + 
      sumFin2 (fun C => omega_up m A C * Sigma x n r B C + omega_up m B C * Sigma x n r A C);
    -- The total antisymmetrization of this 3-form term must be 0 (enforcing the \wedge product structure)
    term μ ν ρ + term ν ρ μ + term ρ μ ν - term ν μ ρ - term μ ρ ν - term ρ ν μ = 0

Litlib.equation "capovilla1991pure"
  eq "2.2c"
  page "61"
  kind "Equation of Motion"
class Eq2_2c 
    (Spacetime : Type*) [TopologicalSpace Spacetime]
    (R : Spacetime → Fin 4 → Fin 4 → Fin 2 → Fin 2 → ℂ)
    (Psi : Spacetime → Fin 2 → Fin 2 → Fin 2 → Fin 2 → ℂ)
    (Sigma : Spacetime → Fin 4 → Fin 4 → Fin 2 → Fin 2 → ℂ) where
  /-- Curvature 2-Form Constraint: The curvature tensor $R$ and $\Sigma$ must be strictly antisymmetric in their spacetime indices. -/
  hR_anti : ∀ x μ ν A B, R x μ ν A B = - R x ν μ A B
  hSigma_anti : ∀ x μ ν A B, Sigma x μ ν A B = - Sigma x ν μ A B
  
  /-- Spinor Symmetry Constraint: $R$ and $\Sigma$ must be symmetric in their chiral spinor indices. -/
  hR_symm_spin : ∀ x μ ν A B, R x μ ν A B = R x μ ν B A
  hSigma_symm_spin : ∀ x μ ν A B, Sigma x μ ν A B = Sigma x μ ν B A
  
  /-- Trace-Free Weyl Symmetry: The Lagrange multiplier field $\Psi$ must be totally symmetric in all four of its spinor indices, encoding the 5 complex degrees of freedom of the self-dual Weyl tensor. -/
  hPsiSymm : ∀ x A B C D, 
    Psi x A B C D = Psi x B A C D ∧ 
    Psi x A B C D = Psi x A C B D ∧ 
    Psi x A B C D = Psi x A B D C
    
  eq2_2c_iff : ∀ x μ ν A B, R x μ ν A B = 
    sumFin2 fun C => sumFin2 fun D => 
      Psi x A B C D * Sigma x μ ν C D

Litlib.equation "capovilla1991pure"
  eq "Page 61, Theorem B"
  page "61"
  kind "Theorem"
class Theorem_Eq2_2c_RicciFlat
    (Spacetime : Type*) [TopologicalSpace Spacetime]
    (theta : Spacetime → Fin 4 → Fin 2 → Fin 2 → ℂ)
    (g : Spacetime → Fin 4 → Fin 4 → ℂ)
    (eps2_down : Fin 2 → Fin 2 → ℂ)
    (eps2_bar_down : Fin 2 → Fin 2 → ℂ)
    (eps2_right : Fin 2 → Fin 2 → ℂ)
    (eps2_up : Fin 2 → Fin 2 → ℂ)
    (R : Spacetime → Fin 4 → Fin 4 → Fin 2 → Fin 2 → ℂ)
    (Psi : Spacetime → Fin 2 → Fin 2 → Fin 2 → Fin 2 → ℂ)
    (Sigma : Spacetime → Fin 4 → Fin 4 → Fin 2 → Fin 2 → ℂ)
    (dSigma : Spacetime → Fin 4 → Fin 4 → Fin 4 → Fin 2 → Fin 2 → ℂ)
    (omega : Spacetime → Fin 4 → Fin 2 → Fin 2 → ℂ)
    (isRicciFlat : (Spacetime → Fin 4 → Fin 4 → ℂ) → Prop) where
  /-- Spinor Metric Antisymmetry: The fundamental spinor metrics must be antisymmetric to properly raise and lower $SL(2, \mathbb{C})$ indices. -/
  heps2_anti : ∀ A B, eps2_down A B = - eps2_down B A
  heps2_bar_anti : ∀ A' B', eps2_bar_down A' B' = - eps2_bar_down B' A'
  heps2_right_anti : ∀ A' B', eps2_right A' B' = - eps2_right B' A'
  heps2_up_anti : ∀ A B, eps2_up A B = - eps2_up B A
  
  hSigma_anti : ∀ x μ ν A B, Sigma x μ ν A B = - Sigma x ν μ A B
  homega_symm : ∀ x μ A B, omega x μ A B = omega x μ B A
  hg_def : ∀ x μ ν, g x μ ν = 
    sumFin2 fun A => sumFin2 fun B => sumFin2 fun A' => sumFin2 fun B' =>
      eps2_down A B * eps2_bar_down A' B' * theta x μ A A' * theta x ν B B'
      
  eq2_2c_implies_ricci_flat :
    -- Hypothesis 1: Sigma is derived from the tetrad (Eq 2.3)
    (∀ x μ ν A B, Sigma x μ ν A B = (1/2 : ℂ) * sumFin2 fun A' => sumFin2 fun B' =>
      eps2_right A' B' * (theta x μ A A' * theta x ν B B' - theta x ν A A' * theta x μ B B')) →
    -- Hypothesis 2: Zero Torsion (Eq 2.2b) guarantees curvature is the Riemann curvature
    (∀ x μ ν ρ A B,
      let omega_up := fun lam A' C' => sumFin2 fun E => eps2_up A' E * omega x lam E C';
      let term := fun m n r => dSigma x m n r A B + 
        sumFin2 (fun C => omega_up m A C * Sigma x n r B C + omega_up m B C * Sigma x n r A C);
      term μ ν ρ + term ν ρ μ + term ρ μ ν - term ν μ ρ - term μ ρ ν - term ρ ν μ = 0) →
    -- Hypothesis 3: Curvature constraints (Eq 2.2c)
    (∀ x μ ν A B, R x μ ν A B = sumFin2 fun C => sumFin2 fun D => Psi x A B C D * Sigma x μ ν C D) →
    -- Conclusion: Metric is Ricci flat
    isRicciFlat g

Litlib.equation "capovilla1991pure"
  eq "2.3"
  page "61"
  kind "Definition"
class Eq2_3
    (Spacetime : Type*) [TopologicalSpace Spacetime]
    (Sigma : Spacetime → Fin 4 → Fin 4 → Fin 2 → Fin 2 → ℂ)
    (theta : Spacetime → Fin 4 → Fin 2 → Fin 2 → ℂ) -- Tetrad fields
    (eps2_right : Fin 2 → Fin 2 → ℂ) where
  hSigma_anti : ∀ x μ ν A B, Sigma x μ ν A B = - Sigma x ν μ A B
  heps2_right_anti : ∀ A' B', eps2_right A' B' = - eps2_right B' A'
  eq2_3_iff : ∀ x μ ν A B,
    Sigma x μ ν A B = (1/2 : ℂ) * sumFin2 fun A' => sumFin2 fun B' =>
      eps2_right A' B' * (theta x μ A A' * theta x ν B B' - theta x ν A A' * theta x μ B B')

Litlib.equation "capovilla1991pure"
  eq "2.4"
  page "61"
  kind "Definition"
class Eq2_4 
    (Spacetime : Type*) [TopologicalSpace Spacetime]
    (g_dens : Spacetime → Fin 4 → Fin 4 → ℂ) -- Represents \sqrt{g} g_{\mu\nu}
    (Sigma : Spacetime → Fin 4 → Fin 4 → Fin 2 → Fin 2 → ℂ)
    (epsilon4 : Fin 4 → Fin 4 → Fin 4 → Fin 4 → ℂ)
    (eps2_up : Fin 2 → Fin 2 → ℂ) where
  /-- Geometric Non-Degeneracy Constraint: The macroscopic metric density determinant must be strictly non-zero to prevent topological collapse of the volume form. -/
  hg_dens_nondeg : ∀ x, Matrix.det (g_dens x) ≠ 0
  
  /-- Algebraic Form Constraint: $\Sigma$ is a valid 2-form, antisymmetric in spacetime indices. -/
  hSigma_anti : ∀ x μ ν A B, Sigma x μ ν A B = - Sigma x ν μ A B
  
  /-- Spinor Symmetry Constraint: $\Sigma$ is symmetric in its chiral spinor indices. -/
  hSigma_symm_spin : ∀ x μ ν A B, Sigma x μ ν A B = Sigma x μ ν B A
  
  /-- Topological Orientation Constraint: The four-dimensional Levi-Civita symbol must be totally antisymmetric and strictly non-zero. -/
  h_eps_swap1 : ∀ α β γ δ, epsilon4 α β γ δ = - epsilon4 β α γ δ
  h_eps_swap2 : ∀ α β γ δ, epsilon4 α β γ δ = - epsilon4 α γ β δ
  h_eps_swap3 : ∀ α β γ δ, epsilon4 α β γ δ = - epsilon4 α β δ γ
  h_eps_nonzero : epsilon4 0 1 2 3 ≠ 0
  
  /-- Spinor Metric Constraint: The $SL(2, \mathbb{C})$ spinor metric must be strictly non-degenerate and antisymmetric to serve as a valid index manipulation operator. -/
  heps2_up_anti : ∀ A B, eps2_up A B = - eps2_up B A
  heps2_up_nondeg : eps2_up 0 1 ≠ 0
  
  eq2_4_iff : ∀ x μ ν, g_dens x μ ν = 
    (1 / 3 : ℂ) * sumFin4 fun α => sumFin4 fun β => sumFin4 fun γ => sumFin4 fun δ =>
      sumFin2 fun A => sumFin2 fun B => sumFin2 fun C => sumFin2 fun D => sumFin2 fun E => sumFin2 fun F =>
        epsilon4 α β γ δ * Sigma x μ α A B * eps2_up B C * Sigma x β γ C D * eps2_up D E * Sigma x δ ν E F * eps2_up F A

Litlib.equation "capovilla1991pure"
  eq "2.5a"
  page "62"
  kind "Constraint"
class Eq2_5a
    (Spacetime : Type*) [TopologicalSpace Spacetime]
    (Sigma : Spacetime → Fin 4 → Fin 4 → Fin 2 → Fin 2 → ℂ)
    (Sigma_bar : Spacetime → Fin 4 → Fin 4 → Fin 2 → Fin 2 → ℂ)
    (epsilon4 : Fin 4 → Fin 4 → Fin 4 → Fin 4 → ℂ) where
  h_eps_nonzero : epsilon4 0 1 2 3 ≠ 0
  eq2_5a_iff : ∀ x A B A' B',
    (sumFin4 fun μ => sumFin4 fun ν => sumFin4 fun ρ => sumFin4 fun σ =>
      epsilon4 μ ν ρ σ * Sigma x μ ν A B * Sigma_bar x ρ σ A' B') = 0

Litlib.equation "capovilla1991pure"
  eq "2.5b"
  page "62"
  kind "Constraint"
class Eq2_5b
    (Spacetime : Type*) [TopologicalSpace Spacetime]
    (Sigma : Spacetime → Fin 4 → Fin 4 → Fin 2 → Fin 2 → ℂ)
    (Sigma_down : Spacetime → Fin 4 → Fin 4 → Fin 2 → Fin 2 → ℂ)
    (Sigma_bar : Spacetime → Fin 4 → Fin 4 → Fin 2 → Fin 2 → ℂ)
    (Sigma_bar_down : Spacetime → Fin 4 → Fin 4 → Fin 2 → Fin 2 → ℂ)
    (epsilon4 : Fin 4 → Fin 4 → Fin 4 → Fin 4 → ℂ) where
  h_eps_nonzero : epsilon4 0 1 2 3 ≠ 0
  eq2_5b_iff : ∀ x,
    let term1 := sumFin4 fun μ => sumFin4 fun ν => sumFin4 fun ρ => sumFin4 fun σ =>
      epsilon4 μ ν ρ σ * sumFin2 fun M => sumFin2 fun N =>
        Sigma x μ ν M N * Sigma_down x ρ σ M N;
    let term2 := sumFin4 fun μ => sumFin4 fun ν => sumFin4 fun ρ => sumFin4 fun σ =>
      epsilon4 μ ν ρ σ * sumFin2 fun M_prime => sumFin2 fun N_prime =>
        Sigma_bar x μ ν M_prime N_prime * Sigma_bar_down x ρ σ M_prime N_prime;
    term1 + term2 = 0

Litlib.equation "capovilla1991pure"
  eq "2.6"
  page "62"
  kind "Definition"
class Eq2_6
    (Spacetime : Type*) [TopologicalSpace Spacetime]
    (Sigma : Spacetime → Fin 4 → Fin 4 → Fin 2 → Fin 2 → ℂ)
    (invPsi : Spacetime → Fin 2 → Fin 2 → Fin 2 → Fin 2 → ℂ)
    (R : Spacetime → Fin 4 → Fin 4 → Fin 2 → Fin 2 → ℂ) where
  hSigma_anti : ∀ x μ ν A B, Sigma x μ ν A B = - Sigma x ν μ A B
  hR_anti : ∀ x μ ν A B, R x μ ν A B = - R x ν μ A B
  eq2_6_iff : ∀ x μ ν A B,
    Sigma x μ ν A B = sumFin2 fun C => sumFin2 fun D =>
      invPsi x A B C D * R x μ ν C D

Litlib.equation "capovilla1991pure"
  eq "2.7"
  page "62"
  kind "Action"
class Eq2_7
    (Spacetime : Type*) [TopologicalSpace Spacetime] [MeasureTheory.MeasureSpace Spacetime]
    (S : ℂ)
    (invPsi : Spacetime → Fin 2 → Fin 2 → Fin 2 → Fin 2 → ℂ)
    (R : Spacetime → Fin 4 → Fin 4 → Fin 2 → Fin 2 → ℂ)
    (epsilon4 : Fin 4 → Fin 4 → Fin 4 → Fin 4 → ℂ) where
  /-- Measure-Theoretic Integrability Constraint: Fields must be strongly measurable across the spacetime manifold to ensure the action integral is well-defined. -/
  hinvPsi_meas : ∀ A B C D, MeasureTheory.AEStronglyMeasurable (fun x => invPsi x A B C D) volume
  hR_meas : ∀ μ ν A B, MeasureTheory.AEStronglyMeasurable (fun x => R x μ ν A B) volume
  h_eps_nonzero : epsilon4 0 1 2 3 ≠ 0
  eq2_7_iff : S = (1/2 : ℂ) * MeasureTheory.integral volume (fun x =>
    sumFin4 fun μ => sumFin4 fun ν => sumFin4 fun ρ => sumFin4 fun σ =>
      epsilon4 μ ν ρ σ * (
        sumFin2 fun A => sumFin2 fun B => sumFin2 fun C => sumFin2 fun D =>
          invPsi x A B C D * R x μ ν A B * R x ρ σ C D
      )
  )

Litlib.equation "capovilla1991pure"
  eq "2.9"
  page "62"
  kind "Definition"
class Eq2_9
    (Spacetime : Type*) [TopologicalSpace Spacetime]
    (M : Spacetime → Fin 2 → Fin 2 → Fin 2 → Fin 2 → ℂ)
    (R : Spacetime → Fin 4 → Fin 4 → Fin 2 → Fin 2 → ℂ)
    (epsilon4 : Fin 4 → Fin 4 → Fin 4 → Fin 4 → ℂ)
    (eps2_up : Fin 2 → Fin 2 → ℂ) where
  /-- Curvature 2-Form Structure: The curvature tensor $R$ must be antisymmetric in spacetime indices. -/
  hR_anti : ∀ x μ ν A B, R x μ ν A B = - R x ν μ A B
  
  /-- Spinor Symmetry Constraint: $R$ must be symmetric in its chiral spinor indices. -/
  hR_symm_spin : ∀ x μ ν A B, R x μ ν A B = R x μ ν B A
  
  eq2_9_iff : ∀ x A B C D, 
    let R_up := fun ρ σ C_idx D_idx => sumFin2 fun C' => sumFin2 fun D' => eps2_up C_idx C' * eps2_up D_idx D' * R x ρ σ C' D';
    M x A B C D = 
      sumFin4 fun μ => sumFin4 fun ν => sumFin4 fun ρ => sumFin4 fun σ =>
        epsilon4 μ ν ρ σ * R x μ ν A B * R_up ρ σ C D

Litlib.equation "capovilla1991pure"
  eq "Page 62"
  page "62"
  kind "Definition"
class Page62_Psi3x3
    (Spacetime : Type*) [TopologicalSpace Spacetime]
    (Psi : Spacetime → Fin 2 → Fin 2 → Fin 2 → Fin 2 → ℂ)
    (Psi_3x3 : Spacetime → Matrix (Fin 3) (Fin 3) ℂ)
    (clump : Fin 2 → Fin 2 → Fin 3)
    (detPsi : Spacetime → ℂ) where
  /-- Trace-Free Weyl Symmetry: The $\Psi$ tensor must be totally symmetric to correctly encode the complex degrees of freedom of the self-dual Weyl tensor. -/
  hPsiSymm : ∀ x A B C D, 
    Psi x A B C D = Psi x B A C D ∧ 
    Psi x A B C D = Psi x A C B D ∧ 
    Psi x A B C D = Psi x A B D C
    
  /-- Index Projection Symmetry: The mapping from spinor pairs to the 3-dimensional basis must respect the underlying symmetry of the indices. -/
  h_clump_symm : ∀ A B, clump A B = clump B A
  
  /-- Basis Projection Surjectivity: The projection mapping must be surjective onto `Fin 3` to prevent the resulting $3 \times 3$ matrix from trivially containing zero rows or columns, ensuring algebraic completeness. -/
  h_clump_surj : Function.Surjective (fun (p : Fin 2 × Fin 2) => clump p.1 p.2)
  
  -- Psi_3x3 is exactly the 4-index Psi evaluated via the clumped indices
  h_Psi_3x3_iff : ∀ x A B C D, Psi_3x3 x (clump A B) (clump C D) = Psi x A B C D
  -- detPsi, as used in Eq 2.21, is formally the 3x3 determinant of this matrix!
  h_detPsi_iff : ∀ x, detPsi x = Matrix.det (Psi_3x3 x)

Litlib.equation "capovilla1991pure"
  eq "2.11"
  page "63"
  kind "Definition"
class Eq2_11
    (Spacetime : Type*) [TopologicalSpace Spacetime]
    (Psi_3x3 : Spacetime → Matrix (Fin 3) (Fin 3) ℂ)
    (M_3x3 : Spacetime → Matrix (Fin 3) (Fin 3) ℂ)
    (mu : Spacetime → ℂ) where
  /-- Non-Degeneracy Constraint: The metric volume element `mu` must be strictly non-zero. -/
  h_mu_nondeg : ∀ x, mu x ≠ 0
  /-- Matrix Square Root Definition: Encodes the algebraic relation between the Weyl spinor matrix and the curvature invariant matrix M. Uses squares to strictly bound the definition and avoid branch-cut ambiguities of the fractional exponent. -/
  eq2_11_iff : ∀ x, (mu x) • (Psi_3x3 x * Psi_3x3 x) = M_3x3 x

Litlib.equation "capovilla1991pure"
  eq "2.14"
  page "63"
  kind "Identity"
class Eq2_14
    (M_3x3 : Matrix (Fin 3) (Fin 3) ℂ)
    (B_3x3 : Matrix (Fin 3) (Fin 3) ℂ) where
  /-- Determinant Non-Degeneracy Constraint: The square root matrix must be invertible. -/
  hB_nondeg : Matrix.det B_3x3 ≠ 0
  /-- Trace-Free Constraint: The matrix B represents the trace-free square root of M. -/
  hB_tracefree : Matrix.trace B_3x3 = 0
  /-- Root Property: B is the exact square root of M. -/
  hB_root : B_3x3 * B_3x3 = M_3x3
  /-- Algebraic Identity: Equation 2.14 evaluates the trace-free square root of a 3x3 matrix purely polynomially in terms of its square and trace. -/
  eq2_14_iff : B_3x3 = (Matrix.det B_3x3)⁻¹ • (M_3x3 * (M_3x3 - ((1 / 2 : ℂ) * Matrix.trace M_3x3) • (1 : Matrix (Fin 3) (Fin 3) ℂ)))

Litlib.equation "capovilla1991pure"
  eq "2.16"
  page "63"
  kind "Definition"
class Eq2_16
    (Spacetime : Type*) [TopologicalSpace Spacetime]
    (eta : Spacetime → ℂ)
    (mu : Spacetime → ℂ)
    (M_3x3 : Spacetime → Matrix (Fin 3) (Fin 3) ℂ) where
  /-- Determinant Non-Degeneracy Constraint: M must be an invertible 3x3 matrix. -/
  hM_nondeg : ∀ x, Matrix.det (M_3x3 x) ≠ 0
  /-- Scalar Density Definition: Defines the geometric density eta algebraically. Squared to strictly bound the definition against branch-cut exploits. -/
  eq2_16_iff : ∀ x, (eta x)^2 = mu x / Matrix.det (M_3x3 x)

Litlib.equation "capovilla1991pure"
  eq "2.18"
  page "63"
  kind "Action"
class Eq2_18
    (Spacetime : Type*) [TopologicalSpace Spacetime] [MeasureTheory.MeasureSpace Spacetime]
    (S : ℂ)
    (eta : Spacetime → ℂ)
    (R : Spacetime → Fin 4 → Fin 4 → Fin 2 → Fin 2 → ℂ)
    (epsilon4 : Fin 4 → Fin 4 → Fin 4 → Fin 4 → ℂ)
    (eps2_up : Fin 2 → Fin 2 → ℂ) where
  /-- Measure-Theoretic Integrability Constraint: Fields must be strongly measurable across the spacetime manifold to ensure the action integral is well-defined. -/
  heta_meas : MeasureTheory.AEStronglyMeasurable eta volume
  hR_meas : ∀ μ ν A B, MeasureTheory.AEStronglyMeasurable (fun x => R x μ ν A B) volume
  
  /-- Topological Orientation Constraint: The four-dimensional Levi-Civita symbol must be strictly non-zero and totally antisymmetric. -/
  h_eps_swap1 : ∀ α β γ δ, epsilon4 α β γ δ = - epsilon4 β α γ δ
  h_eps_swap2 : ∀ α β γ δ, epsilon4 α β γ δ = - epsilon4 α γ β δ
  h_eps_swap3 : ∀ α β γ δ, epsilon4 α β γ δ = - epsilon4 α β δ γ
  h_eps_nonzero : epsilon4 0 1 2 3 ≠ 0
  
  /-- Spinor Metric Constraint: The $SL(2, \mathbb{C})$ spinor metric must be strictly non-degenerate and antisymmetric. -/
  heps2_up_anti : ∀ A B, eps2_up A B = - eps2_up B A
  heps2_up_nondeg : eps2_up 0 1 ≠ 0
  
  eq2_18_iff : S = MeasureTheory.integral volume (fun x => 
    let R_up := fun μ ν A B => sumFin2 fun A' => sumFin2 fun B' => eps2_up A A' * eps2_up B B' * R x μ ν A' B';
    eta x * sumFin2 fun A => sumFin2 fun B => sumFin2 fun C => sumFin2 fun D => 
      (sumFin4 fun μ => sumFin4 fun ν => sumFin4 fun ρ => sumFin4 fun σ =>
        epsilon4 μ ν ρ σ * R_up μ ν A C * R_up ρ σ B D) *
      (sumFin4 fun α => sumFin4 fun β => sumFin4 fun γ => sumFin4 fun δ =>
        epsilon4 α β γ δ * R x α β A B * R x γ δ C D)
  )

Litlib.equation "capovilla1991pure"
  eq "2.19a"
  page "64"
  kind "Equation of Motion"
class Eq2_19a
    (Spacetime : Type*) [TopologicalSpace Spacetime]
    (R : Spacetime → Fin 4 → Fin 4 → Fin 2 → Fin 2 → ℂ)
    (eps2_up : Fin 2 → Fin 2 → ℂ)
    (epsilon4 : Fin 4 → Fin 4 → Fin 4 → Fin 4 → ℂ) where
  /-- Curvature 2-Form Structure: The curvature tensor $R$ must be antisymmetric in spacetime indices. -/
  hR_anti : ∀ x μ ν A B, R x μ ν A B = - R x ν μ A B
  
  /-- Spinor Symmetry Constraint: $R$ must be symmetric in its chiral spinor indices. -/
  hR_symm_spin : ∀ x μ ν A B, R x μ ν A B = R x μ ν B A
  
  /-- Topological Orientation Constraint: The four-dimensional Levi-Civita symbol must be strictly non-zero and totally antisymmetric. -/
  h_eps_swap1 : ∀ α β γ δ, epsilon4 α β γ δ = - epsilon4 β α γ δ
  h_eps_swap2 : ∀ α β γ δ, epsilon4 α β γ δ = - epsilon4 α γ β δ
  h_eps_swap3 : ∀ α β γ δ, epsilon4 α β γ δ = - epsilon4 α β δ γ
  h_eps_nonzero : epsilon4 0 1 2 3 ≠ 0
  
  /-- Spinor Metric Constraint: The $SL(2, \mathbb{C})$ spinor metric must be strictly non-degenerate and antisymmetric. -/
  heps2_up_anti : ∀ A B, eps2_up A B = - eps2_up B A
  heps2_up_nondeg : eps2_up 0 1 ≠ 0
  
  eq2_19a_iff : ∀ x,
    let R_up := fun ρ σ A B => sumFin2 fun A' => sumFin2 fun B' => eps2_up A A' * eps2_up B B' * R x ρ σ A' B';
    let RR_up := fun A B C D => sumFin4 fun μ => sumFin4 fun ν => sumFin4 fun ρ => sumFin4 fun σ =>
      epsilon4 μ ν ρ σ * R_up μ ν A C * R_up ρ σ B D;
    let RR_down := fun A B C D => sumFin4 fun α => sumFin4 fun β => sumFin4 fun γ => sumFin4 fun δ =>
      epsilon4 α β γ δ * R x α β A B * R x γ δ C D;
    (sumFin2 fun A => sumFin2 fun B => sumFin2 fun C => sumFin2 fun D =>
      RR_up A B C D * RR_down A B C D) = 0

Litlib.equation "capovilla1991pure"
  eq "2.19b"
  page "64"
  kind "Equation of Motion"
class Eq2_19b
    (Spacetime : Type*) [TopologicalSpace Spacetime]
    (eta : Spacetime → ℂ)
    (R : Spacetime → Fin 4 → Fin 4 → Fin 2 → Fin 2 → ℂ)
    (eps2_up : Fin 2 → Fin 2 → ℂ)
    (epsilon4 : Fin 4 → Fin 4 → Fin 4 → Fin 4 → ℂ)
    (CovariantDerivative : (Spacetime → Fin 4 → Fin 4 → Fin 2 → Fin 2 → ℂ) → (Spacetime → Fin 4 → Fin 4 → Fin 4 → Fin 2 → Fin 2 → ℂ)) where
  /-- Curvature 2-Form Structure: The curvature tensor $R$ must be antisymmetric in spacetime indices. -/
  hR_anti : ∀ x μ ν A B, R x μ ν A B = - R x ν μ A B
  
  /-- Spinor Symmetry Constraint: $R$ must be symmetric in its chiral spinor indices. -/
  hR_symm_spin : ∀ x μ ν A B, R x μ ν A B = R x μ ν B A
  
  /-- Scalar Density Non-Degeneracy: The scalar density $\eta$ must be strictly non-zero everywhere to maintain equivalence with the non-degenerate metric formulation of General Relativity. -/
  heta_nondeg : ∀ x, eta x ≠ 0
  
  /-- Topological Orientation Constraint: The four-dimensional Levi-Civita symbol must be strictly non-zero and totally antisymmetric. -/
  h_eps_swap1 : ∀ α β γ δ, epsilon4 α β γ δ = - epsilon4 β α γ δ
  h_eps_swap2 : ∀ α β γ δ, epsilon4 α β γ δ = - epsilon4 α γ β δ
  h_eps_swap3 : ∀ α β γ δ, epsilon4 α β γ δ = - epsilon4 α β δ γ
  h_eps_nonzero : epsilon4 0 1 2 3 ≠ 0
  
  /-- Spinor Metric Constraint: The $SL(2, \mathbb{C})$ spinor metric must be strictly non-degenerate and antisymmetric. -/
  heps2_up_anti : ∀ A B, eps2_up A B = - eps2_up B A
  heps2_up_nondeg : eps2_up 0 1 ≠ 0
  
  eq2_19b_iff :
    let R_up := fun x ρ σ A B => sumFin2 fun A' => sumFin2 fun B' => eps2_up A A' * eps2_up B B' * R x ρ σ A' B';
    let Bracket := fun x μ ν A B =>
      eta x * sumFin2 fun C => sumFin2 fun D =>
        (sumFin4 fun ρ => sumFin4 fun σ => sumFin4 fun α => sumFin4 fun β =>
          epsilon4 ρ σ α β * R_up x ρ σ A C * R_up x α β B D) * R x μ ν C D;
    CovariantDerivative Bracket = 0

Litlib.equation "capovilla1991pure"
  eq "2.20a"
  page "64"
  kind "Definition"
class Eq2_20a
    (Spacetime : Type*) [TopologicalSpace Spacetime]
    (Sigma : Spacetime → Fin 4 → Fin 4 → Fin 2 → Fin 2 → ℂ)
    (eta : Spacetime → ℂ)
    (R : Spacetime → Fin 4 → Fin 4 → Fin 2 → Fin 2 → ℂ)
    (eps2_up : Fin 2 → Fin 2 → ℂ)
    (epsilon4 : Fin 4 → Fin 4 → Fin 4 → Fin 4 → ℂ) where
  /-- Algebraic Form Constraint: $\Sigma$ and $R$ are valid 2-forms, strictly antisymmetric in spacetime indices. -/
  hSigma_anti : ∀ x μ ν A B, Sigma x μ ν A B = - Sigma x ν μ A B
  hR_anti : ∀ x μ ν A B, R x μ ν A B = - R x ν μ A B
  
  /-- Topological Orientation Constraint: The four-dimensional Levi-Civita symbol must be strictly non-zero and totally antisymmetric. -/
  h_eps_swap1 : ∀ α β γ δ, epsilon4 α β γ δ = - epsilon4 β α γ δ
  h_eps_swap2 : ∀ α β γ δ, epsilon4 α β γ δ = - epsilon4 α γ β δ
  h_eps_swap3 : ∀ α β γ δ, epsilon4 α β γ δ = - epsilon4 α β δ γ
  h_eps_nonzero : epsilon4 0 1 2 3 ≠ 0
  
  /-- Spinor Metric Constraint: The $SL(2, \mathbb{C})$ spinor metric must be strictly non-degenerate and antisymmetric. -/
  heps2_up_anti : ∀ A B, eps2_up A B = - eps2_up B A
  heps2_up_nondeg : eps2_up 0 1 ≠ 0
  
  eq2_20a_iff : ∀ x μ ν A B,
    let R_up := fun ρ σ A_idx B_idx => sumFin2 fun A' => sumFin2 fun B' => eps2_up A_idx A' * eps2_up B_idx B' * R x ρ σ A' B';
    Sigma x μ ν A B =
      eta x * sumFin2 fun C => sumFin2 fun D =>
        (sumFin4 fun ρ => sumFin4 fun σ => sumFin4 fun α => sumFin4 fun β =>
          epsilon4 ρ σ α β * R_up ρ σ A C * R_up α β B D) * R x μ ν C D

Litlib.equation "capovilla1991pure"
  eq "2.20b"
  page "64"
  kind "Definition"
class Eq2_20b
    (Spacetime : Type*) [TopologicalSpace Spacetime]
    (invPsi : Spacetime → Fin 2 → Fin 2 → Fin 2 → Fin 2 → ℂ)
    (eta : Spacetime → ℂ)
    (R : Spacetime → Fin 4 → Fin 4 → Fin 2 → Fin 2 → ℂ)
    (eps2_up : Fin 2 → Fin 2 → ℂ)
    (epsilon4 : Fin 4 → Fin 4 → Fin 4 → Fin 4 → ℂ) where
  /-- Curvature 2-Form Structure: The curvature tensor $R$ must be antisymmetric in spacetime indices. -/
  hR_anti : ∀ x μ ν A B, R x μ ν A B = - R x ν μ A B
  
  /-- Topological Orientation Constraint: The four-dimensional Levi-Civita symbol must be strictly non-zero and totally antisymmetric. -/
  h_eps_swap1 : ∀ α β γ δ, epsilon4 α β γ δ = - epsilon4 β α γ δ
  h_eps_swap2 : ∀ α β γ δ, epsilon4 α β γ δ = - epsilon4 α γ β δ
  h_eps_swap3 : ∀ α β γ δ, epsilon4 α β γ δ = - epsilon4 α β δ γ
  h_eps_nonzero : epsilon4 0 1 2 3 ≠ 0
  
  /-- Spinor Metric Constraint: The $SL(2, \mathbb{C})$ spinor metric must be strictly non-degenerate and antisymmetric. -/
  heps2_up_anti : ∀ A B, eps2_up A B = - eps2_up B A
  heps2_up_nondeg : eps2_up 0 1 ≠ 0
  
  eq2_20b_iff : ∀ x A B C D,
    let R_up := fun ρ σ A_idx B_idx => sumFin2 fun A' => sumFin2 fun B' => eps2_up A_idx A' * eps2_up B_idx B' * R x ρ σ A' B';
    invPsi x A B C D =
      eta x * sumFin4 fun ρ => sumFin4 fun σ => sumFin4 fun α => sumFin4 fun β =>
        epsilon4 ρ σ α β * R_up ρ σ A B * R_up α β C D

Litlib.equation "capovilla1991pure"
  eq "Page 64, Theorem A"
  page "64"
  kind "Theorem"
class Theorem_Eq2_19_Equivalent_To_Eq2_2
    (Spacetime : Type*) [TopologicalSpace Spacetime]
    (isNonDegenerateWeylCurvature : Spacetime → Prop)
    (eq2_19a_holds : Spacetime → Prop)
    (eq2_19b_holds : Spacetime → Prop)
    (eq2_2a_holds : Spacetime → Prop)
    (eq2_2b_holds : Spacetime → Prop)
    (eq2_2c_holds : Spacetime → Prop)
    (eq2_20a_holds : Spacetime → Prop)
    (eq2_20b_holds : Spacetime → Prop) where
  equivalence : ∀ x,
    isNonDegenerateWeylCurvature x →
    eq2_20a_holds x →
    eq2_20b_holds x →
    ((eq2_19a_holds x ∧ eq2_19b_holds x) ↔ (eq2_2a_holds x ∧ eq2_2b_holds x ∧ eq2_2c_holds x))

Litlib.equation "capovilla1991pure"
  eq "2.21"
  page "64"
  kind "Definition"
class Eq2_21
    (Spacetime : Type*) [TopologicalSpace Spacetime]
    (eta : Spacetime → ℂ)
    (sqrt_g : Spacetime → ℂ)
    (detPsi : Spacetime → ℂ) where
  /-- Denominator Non-Degeneracy Constraint: The metric determinant factor and the Weyl curvature determinant must be strictly non-zero to prevent singularities and division-by-zero artifacts in the scalar density definition. -/
  h_sqrt_g_nondeg : ∀ x, sqrt_g x ≠ 0
  h_detPsi_nondeg : ∀ x, detPsi x ≠ 0
  
  eq2_21_iff : ∀ x, eta x = (sqrt_g x * detPsi x)⁻¹

Litlib.equation "capovilla1991pure"
  eq "2.22"
  page "64"
  kind "Theorem"
class Theorem_Eq2_22_Derivation
    (Spacetime : Type*) [TopologicalSpace Spacetime]
    (g : Spacetime → Fin 4 → Fin 4 → ℂ)
    (g_dens : Spacetime → Fin 4 → Fin 4 → ℂ)
    (eta : Spacetime → ℂ)
    (sqrt_g : Spacetime → ℂ)
    (detPsi : Spacetime → ℂ)
    (R : Spacetime → Fin 4 → Fin 4 → Fin 2 → Fin 2 → ℂ)
    (Psi : Spacetime → Fin 2 → Fin 2 → Fin 2 → Fin 2 → ℂ)
    (Sigma : Spacetime → Fin 4 → Fin 4 → Fin 2 → Fin 2 → ℂ)
    (epsilon4 : Fin 4 → Fin 4 → Fin 4 → Fin 4 → ℂ)
    (eps2_up : Fin 2 → Fin 2 → ℂ) where
  /-- Geometric Non-Degeneracy Constraint: The derived macroscopic metric determinant must be strictly non-zero to prevent topological collapse and ensure a valid Lorentzian/Riemannian signature. This mathematically blocks the `0⁻¹ = 0` exploit from forcing trivial metric states via Eq 2.21. -/
  hg_nondeg : ∀ x, Matrix.det (g x) ≠ 0
  h_g_dens_def : ∀ x μ ν, g_dens x μ ν = sqrt_g x * g x μ ν
  
  -- Definitions as explicit hypotheses corresponding to (2.4, 2.2c, 2.21)
  eq2_4_holds : ∀ x μ ν, g_dens x μ ν = 
    (1 / 3 : ℂ) * sumFin4 fun α => sumFin4 fun β => sumFin4 fun γ => sumFin4 fun δ =>
      sumFin2 fun A => sumFin2 fun B => sumFin2 fun C => sumFin2 fun D => sumFin2 fun E => sumFin2 fun F =>
        epsilon4 α β γ δ * Sigma x μ α A B * eps2_up B C * Sigma x β γ C D * eps2_up D E * Sigma x δ ν E F * eps2_up F A
        
  eq2_2c_holds : ∀ x μ ν A B, R x μ ν A B = 
    sumFin2 fun C => sumFin2 fun D => Psi x A B C D * Sigma x μ ν C D
    
  eq2_21_holds : ∀ x, eta x = (sqrt_g x * detPsi x)⁻¹
  
  -- The theorem claim (2.22), logically dependent on the above holding
  eq2_22_derived : ∀ x μ ν, g x μ ν = 
    (1 / 3 : ℂ) * eta x * 
    sumFin4 fun α => sumFin4 fun β => sumFin4 fun γ => sumFin4 fun δ =>
      sumFin2 fun A => sumFin2 fun B => sumFin2 fun C => sumFin2 fun D => sumFin2 fun E => sumFin2 fun F =>
        epsilon4 α β γ δ * R x μ α A B * eps2_up B C * R x β γ C D * eps2_up D E * R x δ ν E F * eps2_up F A

Litlib.equation "capovilla1991pure"
  eq "Page 67"
  page "67"
  kind "Theorem"
class Theorem_Volume_Element_Identity
    (Spacetime : Type*) [TopologicalSpace Spacetime]
    (sqrt_g : Spacetime → ℂ)
    (mu : Spacetime → ℂ)
    (eta : Spacetime → ℂ)
    (Psi_3x3 : Spacetime → Matrix (Fin 3) (Fin 3) ℂ)
    (M_3x3 : Spacetime → Matrix (Fin 3) (Fin 3) ℂ) where
  /-- Field Non-Degeneracy Constraint: Precludes division by zero and ensures metric non-degeneracy. -/
  h_sqrt_g_nondeg : ∀ x, sqrt_g x ≠ 0
  h_mu_nondeg : ∀ x, mu x ≠ 0
  h_M_nondeg : ∀ x, Matrix.det (M_3x3 x) ≠ 0
  h_Psi_nondeg : ∀ x, Matrix.det (Psi_3x3 x) ≠ 0
  
  -- Eq 2.16
  eq2_16_holds : ∀ x, (eta x)^2 = mu x / Matrix.det (M_3x3 x)
  -- Eq 2.21
  eq2_21_holds : ∀ x, eta x = (sqrt_g x * Matrix.det (Psi_3x3 x))⁻¹
  -- Eq 2.11 taking determinant: det(Psi) = mu^(-3/2) * det(M^(1/2)) => det(Psi)^2 = mu^(-3) * det(M)
  eq2_11_det_holds : ∀ x, (Matrix.det (Psi_3x3 x))^2 = (mu x)⁻¹ * (mu x)⁻¹ * (mu x)⁻¹ * Matrix.det (M_3x3 x)
  
  /-- 
  Physical Volume Density Evaluation:
  The text on page 67 implicitly defines and utilizes this identity, showing that the 
  Lagrange multiplier μ enforcing tracelessness in the matrix action natively encodes 
  the emergent square root metric determinant \sqrt{g}. Computed algebraically 
  from comparing the evaluation of η across equations 2.16 and 2.21.
  -/
  volume_element_identity : ∀ x, (sqrt_g x)^2 = (mu x)^2

end Litlib.Y1991.capovilla1991pure
