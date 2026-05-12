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
  eq "2.4"
  page "61"
  kind "Definition"
class Eq2_4 
    (Spacetime : Type*) [TopologicalSpace Spacetime]
    (g_dens : Spacetime → Fin 4 → Fin 4 → ℂ) -- Represents \sqrt{g} g_{\mu\nu}
    (Sigma : Spacetime → Fin 4 → Fin 4 → Fin 2 → Fin 2 → ℂ)
    (epsilon4 : Fin 4 → Fin 4 → Fin 4 → Fin 4 → ℂ)
    (eps2 : Fin 2 → Fin 2 → ℂ) where
  -- ANTI-BS: The metric density must be non-degenerate.
  hg_dens_nondeg : ∀ x, Matrix.det (g_dens x) ≠ 0
  -- ANTI-BS: Sigma is a 2-form, antisymmetric in spacetime indices.
  hSigma_anti : ∀ x μ ν A B, Sigma x μ ν A B = - Sigma x ν μ A B
  -- ANTI-BS: Sigma is symmetric in its chiral spinor indices.
  hSigma_symm_spin : ∀ x μ ν A B, Sigma x μ ν A B = Sigma x μ ν B A
  -- ANTI-BS: epsilon4 must be a totally antisymmetric, non-zero tensor.
  h_eps_swap1 : ∀ α β γ δ, epsilon4 α β γ δ = - epsilon4 β α γ δ
  h_eps_swap2 : ∀ α β γ δ, epsilon4 α β γ δ = - epsilon4 α γ β δ
  h_eps_swap3 : ∀ α β γ δ, epsilon4 α β γ δ = - epsilon4 α β δ γ
  h_eps_nonzero : epsilon4 0 1 2 3 ≠ 0
  -- ANTI-BS: eps2 (spinor metric) is antisymmetric and non-degenerate.
  heps2_anti : ∀ A B, eps2 A B = - eps2 B A
  heps2_nondeg : eps2 0 1 ≠ 0
  eq2_4_iff : ∀ x μ ν, g_dens x μ ν = 
    (1 / 3 : ℂ) * sumFin4 fun α => sumFin4 fun β => sumFin4 fun γ => sumFin4 fun δ =>
      sumFin2 fun A => sumFin2 fun B => sumFin2 fun C => sumFin2 fun D => sumFin2 fun E => sumFin2 fun F =>
        epsilon4 α β γ δ * Sigma x μ α A B * eps2 B C * Sigma x β γ C D * eps2 D E * Sigma x δ ν E F * eps2 F A

Litlib.equation "capovilla1991pure"
  eq "2.9"
  page "62"
  kind "Definition"
class Eq2_9
    (Spacetime : Type*) [TopologicalSpace Spacetime]
    (M : Spacetime → Fin 2 → Fin 2 → Fin 2 → Fin 2 → ℂ)
    (R : Spacetime → Fin 4 → Fin 4 → Fin 2 → Fin 2 → ℂ)
    (epsilon4 : Fin 4 → Fin 4 → Fin 4 → Fin 4 → ℂ) where
  -- ANTI-BS: R is a 2-form, antisymmetric in spacetime indices.
  hR_anti : ∀ x μ ν A B, R x μ ν A B = - R x ν μ A B
  -- ANTI-BS: R is symmetric in its chiral spinor indices.
  hR_symm_spin : ∀ x μ ν A B, R x μ ν A B = R x μ ν B A
  eq2_9_iff : ∀ x A B C D, M x A B C D = 
    sumFin4 fun μ => sumFin4 fun ν => sumFin4 fun ρ => sumFin4 fun σ =>
      epsilon4 μ ν ρ σ * R x μ ν A B * R x ρ σ C D

Litlib.equation "capovilla1991pure"
  eq "Page 62"
  page "62"
  kind "Definition"
class Page62_Psi3x3
    (Spacetime : Type*) [TopologicalSpace Spacetime]
    (Psi : Spacetime → Fin 2 → Fin 2 → Fin 2 → Fin 2 → ℂ)
    (Psi_3x3 : Spacetime → Fin 3 → Fin 3 → ℂ)
    (clump : Fin 2 → Fin 2 → Fin 3)
    (detPsi : Spacetime → ℂ) where
  -- ANTI-BS: Psi is totally symmetric
  hPsiSymm : ∀ x A B C D, 
    Psi x A B C D = Psi x B A C D ∧ 
    Psi x A B C D = Psi x A C B D ∧ 
    Psi x A B C D = Psi x A B D C
  -- ANTI-BS: The "clump" mapping must respect the symmetry of the index pair
  h_clump_symm : ∀ A B, clump A B = clump B A
  -- ANTI-BS: The mapping must be surjective onto Fin 3 to be a valid 3D basis projection
  -- This prevents the 3x3 matrix from trivially having zero rows/columns.
  h_clump_surj : Function.Surjective (fun (p : Fin 2 × Fin 2) => clump p.1 p.2)
  -- Psi_3x3 is exactly the 4-index Psi evaluated via the clumped indices
  h_Psi_3x3_iff : ∀ x A B C D, Psi_3x3 x (clump A B) (clump C D) = Psi x A B C D
  -- detPsi, as used in Eq 2.21, is formally the 3x3 determinant of this matrix!
  h_detPsi_iff : ∀ x, detPsi x = Matrix.det (Psi_3x3 x)

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
    (eps2 : Fin 2 → Fin 2 → ℂ) where
  -- ANTI-BS: Fields must be measurable/integrable to prevent meaningless integrals
  heta_meas : MeasureTheory.AEStronglyMeasurable eta volume
  hR_meas : ∀ μ ν A B, MeasureTheory.AEStronglyMeasurable (fun x => R x μ ν A B) volume
  -- ANTI-BS: epsilon4 must be a totally antisymmetric, non-zero tensor.
  h_eps_swap1 : ∀ α β γ δ, epsilon4 α β γ δ = - epsilon4 β α γ δ
  h_eps_swap2 : ∀ α β γ δ, epsilon4 α β γ δ = - epsilon4 α γ β δ
  h_eps_swap3 : ∀ α β γ δ, epsilon4 α β γ δ = - epsilon4 α β δ γ
  h_eps_nonzero : epsilon4 0 1 2 3 ≠ 0
  -- ANTI-BS: eps2 (spinor metric) is antisymmetric and non-degenerate.
  heps2_anti : ∀ A B, eps2 A B = - eps2 B A
  heps2_nondeg : eps2 0 1 ≠ 0
  eq2_18_iff : S = MeasureTheory.integral volume (fun x => 
    eta x * 
    sumFin2 fun A => sumFin2 fun B => sumFin2 fun C => sumFin2 fun D => 
    sumFin2 fun A' => sumFin2 fun B' => sumFin2 fun C' => sumFin2 fun D' =>
      (sumFin4 fun μ => sumFin4 fun ν => sumFin4 fun ρ => sumFin4 fun σ =>
        epsilon4 μ ν ρ σ * R x μ ν A' C' * R x ρ σ B' D') *
      (sumFin4 fun α => sumFin4 fun β => sumFin4 fun γ => sumFin4 fun δ =>
        epsilon4 α β γ δ * R x α β A B * R x γ δ C D) *
      (eps2 A A' * eps2 C C' * eps2 B B' * eps2 D D')
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
  -- ANTI-BS: R is a 2-form, antisymmetric in spacetime indices.
  hR_anti : ∀ x μ ν A B, R x μ ν A B = - R x ν μ A B
  hR_symm_spin : ∀ x μ ν A B, R x μ ν A B = R x μ ν B A
  -- ANTI-BS: epsilon4 is totally antisymmetric
  h_eps_swap1 : ∀ α β γ δ, epsilon4 α β γ δ = - epsilon4 β α γ δ
  h_eps_swap2 : ∀ α β γ δ, epsilon4 α β γ δ = - epsilon4 α γ β δ
  h_eps_swap3 : ∀ α β γ δ, epsilon4 α β γ δ = - epsilon4 α β δ γ
  h_eps_nonzero : epsilon4 0 1 2 3 ≠ 0
  -- ANTI-BS: eps2_up is antisymmetric and non-degenerate
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
  -- ANTI-BS: R is a 2-form
  hR_anti : ∀ x μ ν A B, R x μ ν A B = - R x ν μ A B
  hR_symm_spin : ∀ x μ ν A B, R x μ ν A B = R x μ ν B A
  -- ANTI-BS: eta cannot be zero
  heta_nondeg : ∀ x, eta x ≠ 0
  -- ANTI-BS: epsilon4 is totally antisymmetric
  h_eps_swap1 : ∀ α β γ δ, epsilon4 α β γ δ = - epsilon4 β α γ δ
  h_eps_swap2 : ∀ α β γ δ, epsilon4 α β γ δ = - epsilon4 α γ β δ
  h_eps_swap3 : ∀ α β γ δ, epsilon4 α β γ δ = - epsilon4 α β δ γ
  h_eps_nonzero : epsilon4 0 1 2 3 ≠ 0
  -- ANTI-BS: eps2_up is antisymmetric and non-degenerate
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
  -- ANTI-BS: Sigma and R are 2-forms
  hSigma_anti : ∀ x μ ν A B, Sigma x μ ν A B = - Sigma x ν μ A B
  hR_anti : ∀ x μ ν A B, R x μ ν A B = - R x ν μ A B
  -- ANTI-BS: epsilon4 is totally antisymmetric
  h_eps_swap1 : ∀ α β γ δ, epsilon4 α β γ δ = - epsilon4 β α γ δ
  h_eps_swap2 : ∀ α β γ δ, epsilon4 α β γ δ = - epsilon4 α γ β δ
  h_eps_swap3 : ∀ α β γ δ, epsilon4 α β γ δ = - epsilon4 α β δ γ
  h_eps_nonzero : epsilon4 0 1 2 3 ≠ 0
  -- ANTI-BS: eps2_up is antisymmetric and non-degenerate
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
  -- ANTI-BS: R is a 2-form
  hR_anti : ∀ x μ ν A B, R x μ ν A B = - R x ν μ A B
  -- ANTI-BS: epsilon4 is totally antisymmetric
  h_eps_swap1 : ∀ α β γ δ, epsilon4 α β γ δ = - epsilon4 β α γ δ
  h_eps_swap2 : ∀ α β γ δ, epsilon4 α β γ δ = - epsilon4 α γ β δ
  h_eps_swap3 : ∀ α β γ δ, epsilon4 α β γ δ = - epsilon4 α β δ γ
  h_eps_nonzero : epsilon4 0 1 2 3 ≠ 0
  -- ANTI-BS: eps2_up is antisymmetric and non-degenerate
  heps2_up_anti : ∀ A B, eps2_up A B = - eps2_up B A
  heps2_up_nondeg : eps2_up 0 1 ≠ 0
  eq2_20b_iff : ∀ x A B C D,
    let R_up := fun ρ σ A_idx B_idx => sumFin2 fun A' => sumFin2 fun B' => eps2_up A_idx A' * eps2_up B_idx B' * R x ρ σ A' B';
    invPsi x A B C D =
      eta x * sumFin4 fun ρ => sumFin4 fun σ => sumFin4 fun α => sumFin4 fun β =>
        epsilon4 ρ σ α β * R_up ρ σ A B * R x α β C D

Litlib.equation "capovilla1991pure"
  eq "2.21"
  page "64"
  kind "Definition"
class Eq2_21
    (Spacetime : Type*) [TopologicalSpace Spacetime]
    (eta : Spacetime → ℂ)
    (sqrt_g : Spacetime → ℂ)
    (detPsi : Spacetime → ℂ) where
  -- ANTI-BS: Neither sqrt_g nor detPsi can be zero because they appear in a denominator.
  h_sqrt_g_nondeg : ∀ x, sqrt_g x ≠ 0
  h_detPsi_nondeg : ∀ x, detPsi x ≠ 0
  eq2_21_iff : ∀ x, eta x = (sqrt_g x * detPsi x)⁻¹

Litlib.equation "capovilla1991pure"
  eq "2.22"
  page "64"
  kind "Definition"
class Eq2_22 
    (Spacetime : Type*) [TopologicalSpace Spacetime]
    (g : Spacetime → Fin 4 → Fin 4 → ℂ)
    (eta : Spacetime → ℂ)
    (R : Spacetime → Fin 4 → Fin 4 → Fin 2 → Fin 2 → ℂ)
    (epsilon4 : Fin 4 → Fin 4 → Fin 4 → Fin 4 → ℂ)
    (eps2 : Fin 2 → Fin 2 → ℂ) where
  -- ANTI-BS: A metric must be non-degenerate.
  hg_nondeg : ∀ x, Matrix.det (g x) ≠ 0
  -- ANTI-BS: eta is defined via an inverse, so it cannot be zero.
  heta_nondeg : ∀ x, eta x ≠ 0
  -- ANTI-BS: R is a 2-form, must be antisymmetric in spacetime indices.
  hR_anti : ∀ x μ ν A B, R x μ ν A B = - R x ν μ A B
  -- ANTI-BS: R is symmetric in its chiral spinor indices.
  hR_symm_spin : ∀ x μ ν A B, R x μ ν A B = R x μ ν B A
  -- ANTI-BS: epsilon4 must be a totally antisymmetric, non-zero tensor (Levi-Civita).
  h_eps_swap1 : ∀ α β γ δ, epsilon4 α β γ δ = - epsilon4 β α γ δ
  h_eps_swap2 : ∀ α β γ δ, epsilon4 α β γ δ = - epsilon4 α γ β δ
  h_eps_swap3 : ∀ α β γ δ, epsilon4 α β γ δ = - epsilon4 α β δ γ
  h_eps_nonzero : epsilon4 0 1 2 3 ≠ 0
  -- ANTI-BS: eps2 (spinor metric) is antisymmetric and non-degenerate.
  heps2_anti : ∀ A B, eps2 A B = - eps2 B A
  heps2_nondeg : eps2 0 1 ≠ 0
  eq2_22_iff : ∀ x μ ν, g x μ ν = 
    (1 / 3 : ℂ) * eta x * 
    sumFin4 fun α => sumFin4 fun β => sumFin4 fun γ => sumFin4 fun δ =>
      sumFin2 fun A => sumFin2 fun B => sumFin2 fun C => sumFin2 fun D => sumFin2 fun E => sumFin2 fun F =>
        epsilon4 α β γ δ * R x μ α A B * eps2 B C * R x β γ C D * eps2 D E * R x δ ν E F * eps2 F A

Litlib.equation "capovilla1991pure"
  eq "2.21_2.22_Identity"
  page "64"
  kind "Theorem"
class UrbantkeDeterminantIdentity
    (Spacetime : Type*) [TopologicalSpace Spacetime]
    (epsilon4 : Fin 4 → Fin 4 → Fin 4 → Fin 4 → ℂ)
    (eps2 : Fin 2 → Fin 2 → ℂ)
    (eps2_up : Fin 2 → Fin 2 → ℂ) where
  -- THE THEOREM: The 4x4 determinant of the metric g (Eq 2.22) is exactly 
  -- algebraically determined by eta and the safe 3x3 determinant of Psi^{-1} (Eq 2.20b).
  -- Eq 2.21 states \eta = (\sqrt{g} \det \Psi)^{-1}, which implies \det(g) * \eta^2 = (\det \Psi^{-1})^2.
  determinant_identity : 
    ∀ (R : Spacetime → Fin 4 → Fin 4 → Fin 2 → Fin 2 → ℂ)
      (g : Spacetime → Fin 4 → Fin 4 → ℂ)
      (eta : Spacetime → ℂ)
      (invPsi : Spacetime → Fin 2 → Fin 2 → Fin 2 → Fin 2 → ℂ)
      (invPsi_3x3 : Spacetime → Fin 3 → Fin 3 → ℂ)
      (clump : Fin 2 → Fin 2 → Fin 3),
      -- 1. clump is a symmetric surjection (protects against 0=1 exploits)
      (∀ A B, clump A B = clump B A) →
      Function.Surjective (fun (p : Fin 2 × Fin 2) => clump p.1 p.2) →
      -- 2. g is explicitly defined by Eq 2.22
      (∀ x μ ν, g x μ ν = (1 / 3 : ℂ) * eta x * 
        sumFin4 fun α => sumFin4 fun β => sumFin4 fun γ => sumFin4 fun δ =>
          sumFin2 fun A => sumFin2 fun B => sumFin2 fun C => sumFin2 fun D => sumFin2 fun E => sumFin2 fun F =>
            epsilon4 α β γ δ * R x μ α A B * eps2 B C * R x β γ C D * eps2 D E * R x δ ν E F * eps2 F A) →
      -- 3. invPsi is explicitly defined by Eq 2.20b
      (∀ x A B C D,
        let R_up := fun ρ σ A_idx B_idx => sumFin2 fun A' => sumFin2 fun B' => eps2_up A_idx A' * eps2_up B_idx B' * R x ρ σ A' B';
        invPsi x A B C D =
          eta x * sumFin4 fun ρ => sumFin4 fun σ => sumFin4 fun α => sumFin4 fun β =>
            epsilon4 ρ σ α β * R_up ρ σ A B * R x α β C D) →
      -- 4. invPsi_3x3 is exactly invPsi evaluated via the clumped indices (Page 62 mapping)
      (∀ x A B C D, invPsi_3x3 x (clump A B) (clump C D) = invPsi x A B C D) →
      -- 5. Conclusion:
      ∀ x, Matrix.det (g x) * (eta x)^2 = (Matrix.det (invPsi_3x3 x))^2

Litlib.equation "capovilla1991pure"
  eq "2.2c"
  page "61"
  kind "Equation of Motion"
class Eq2_2c 
    (Spacetime : Type*) [TopologicalSpace Spacetime]
    (R : Spacetime → Fin 4 → Fin 4 → Fin 2 → Fin 2 → ℂ)
    (Psi : Spacetime → Fin 2 → Fin 2 → Fin 2 → Fin 2 → ℂ)
    (Sigma : Spacetime → Fin 4 → Fin 4 → Fin 2 → Fin 2 → ℂ)
    (eps2 : Fin 2 → Fin 2 → ℂ) where
  -- ANTI-BS: R and Sigma are 2-forms, strictly antisymmetric in spacetime indices
  hR_anti : ∀ x μ ν A B, R x μ ν A B = - R x ν μ A B
  hSigma_anti : ∀ x μ ν A B, Sigma x μ ν A B = - Sigma x ν μ A B
  -- ANTI-BS: R and Sigma are symmetric in chiral spinor indices
  hR_symm_spin : ∀ x μ ν A B, R x μ ν A B = R x μ ν B A
  hSigma_symm_spin : ∀ x μ ν A B, Sigma x μ ν A B = Sigma x μ ν B A
  -- ANTI-BS: eps2 (spinor metric) is antisymmetric and non-degenerate.
  heps2_anti : ∀ A B, eps2 A B = - eps2 B A
  heps2_nondeg : eps2 0 1 ≠ 0
  -- Psi is a totally symmetric Lagrange multiplier field. 
  hPsiSymm : ∀ x A B C D, 
    Psi x A B C D = Psi x B A C D ∧ 
    Psi x A B C D = Psi x A C B D ∧ 
    Psi x A B C D = Psi x A B D C
  eq2_2c_iff : ∀ x μ ν A B, R x μ ν A B = 
    sumFin2 fun C => sumFin2 fun D => sumFin2 fun C' => sumFin2 fun D' => 
      Psi x A B C D * eps2 C C' * eps2 D D' * Sigma x μ ν C' D'

end Litlib.Y1991.capovilla1991pure
