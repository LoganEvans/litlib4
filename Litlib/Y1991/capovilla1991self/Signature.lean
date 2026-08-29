-- FILENAME: Litlib/Y1991/capovilla1991self/Signature.lean


import Litlib.Core
import Mathlib.Topology.Basic
import Mathlib.Data.Matrix.Basic
import Mathlib.Data.Complex.Basic
import Mathlib.MeasureTheory.Measure.MeasureSpace
import Mathlib.MeasureTheory.Integral.Bochner.Basic
import Mathlib.MeasureTheory.Function.StronglyMeasurable.AEStronglyMeasurable

open BigOperators

namespace Litlib.Y1991.capovilla1991self

noncomputable def sumFin4 (f : Fin 4 → ℂ) : ℂ := Finset.sum Finset.univ f
noncomputable def sumFin2 (f : Fin 2 → ℂ) : ℂ := Finset.sum Finset.univ f

Litlib.paper "capovilla1991self"
  type "article"
  title "Self-dual 2-forms and gravity"
  authors ["Capovilla, Riccardo", "Dell, John", "Jacobson, Ted", "Mason, Lionel"]
  journal "Classical and Quantum Gravity"
  volume "8"
  issue "1"
  pages "41--57"
  year "1991"
  doi "10.1088/0264-9381/8/1/009"

Litlib.equation "capovilla1991self"
  eq "2.1"
  page "42"
  kind "Action"
class Eq2_1
    (Spacetime : Type*) [TopologicalSpace Spacetime] [MeasureTheory.MeasureSpace Spacetime]
    (S : ℂ)
    (theta : Spacetime → Fin 4 → Fin 2 → Fin 2 → ℂ)
    (R : Spacetime → Fin 4 → Fin 4 → Fin 2 → Fin 2 → ℂ)
    (eps2_right : Fin 2 → Fin 2 → ℂ)
    (epsilon4 : Fin 4 → Fin 4 → Fin 4 → Fin 4 → ℂ) where
  htheta_meas : ∀ μ A A', MeasureTheory.AEStronglyMeasurable (fun x ↦ theta x μ A A') volume
  hR_meas : ∀ μ ν A B, MeasureTheory.AEStronglyMeasurable (fun x ↦ R x μ ν A B) volume
  heps2_right_anti : ∀ A' B', eps2_right A' B' = - eps2_right B' A'
  h_eps_nonzero : epsilon4 0 1 2 3 ≠ 0

  eq2_1_iff : S = MeasureTheory.integral volume (fun x ↦
    sumFin4 fun μ ↦ sumFin4 fun ν ↦ sumFin4 fun ρ ↦ sumFin4 fun σ ↦
      epsilon4 μ ν ρ σ * (
        sumFin2 fun A ↦ sumFin2 fun B ↦ sumFin2 fun A' ↦ sumFin2 fun B' ↦
          eps2_right A' B' * theta x μ A A' * theta x ν B B' * R x ρ σ A B
      )
  )

Litlib.equation "capovilla1991self"
  eq "2.2"
  page "43"
  kind "Definition"
class Eq2_2
    (Spacetime : Type*) [TopologicalSpace Spacetime]
    (Sigma : Spacetime → Fin 4 → Fin 4 → Fin 2 → Fin 2 → ℂ)
    (theta : Spacetime → Fin 4 → Fin 2 → Fin 2 → ℂ)
    (eps2_right : Fin 2 → Fin 2 → ℂ) where
  hSigma_anti : ∀ x μ ν A B, Sigma x μ ν A B = - Sigma x ν μ A B
  heps2_right_anti : ∀ A' B', eps2_right A' B' = - eps2_right B' A'

  eq2_2_iff : ∀ x μ ν A B,
    Sigma x μ ν A B = sumFin2 fun A' ↦ sumFin2 fun B' ↦
      eps2_right A' B' * theta x μ A A' * theta x ν B B'

Litlib.equation "capovilla1991self"
  eq "2.3a"
  page "43"
  kind "Constraint"
class Eq2_3a
    (Spacetime : Type*) [TopologicalSpace Spacetime]
    (Sigma : Spacetime → Fin 4 → Fin 4 → Fin 2 → Fin 2 → ℂ)
    (epsilon4 : Fin 4 → Fin 4 → Fin 4 → Fin 4 → ℂ) where
  hSigma_anti : ∀ x μ ν A B, Sigma x μ ν A B = - Sigma x ν μ A B
  hSigma_symm : ∀ x μ ν A B, Sigma x μ ν A B = Sigma x μ ν B A
  h_eps_nonzero : epsilon4 0 1 2 3 ≠ 0

  eq2_3a_iff : ∀ x A B C D,
    let w := fun A' B' C' D' ↦ sumFin4 fun μ ↦ sumFin4 fun ν ↦ sumFin4 fun ρ ↦ sumFin4 fun σ ↦
      epsilon4 μ ν ρ σ * Sigma x μ ν A' B' * Sigma x ρ σ C' D';
    w A B C D + w A C B D + w A D B C = 0

Litlib.equation "capovilla1991self"
  eq "2.4"
  page "43"
  kind "Definition"
class Eq2_4
    (Spacetime : Type*) [TopologicalSpace Spacetime]
    (g_dens : Spacetime → Fin 4 → Fin 4 → ℂ)
    (Sigma : Spacetime → Fin 4 → Fin 4 → Fin 2 → Fin 2 → ℂ)
    (epsilon4 : Fin 4 → Fin 4 → Fin 4 → Fin 4 → ℂ)
    (eps2_up : Fin 2 → Fin 2 → ℂ) where
  hg_dens_nondeg : ∀ x, Matrix.det (g_dens x) ≠ 0
  hSigma_anti : ∀ x μ ν A B, Sigma x μ ν A B = - Sigma x ν μ A B
  hSigma_symm_spin : ∀ x μ ν A B, Sigma x μ ν A B = Sigma x μ ν B A
  h_eps_swap1 : ∀ α β γ δ, epsilon4 α β γ δ = - epsilon4 β α γ δ
  h_eps_swap2 : ∀ α β γ δ, epsilon4 α β γ δ = - epsilon4 α γ β δ
  h_eps_nonzero : epsilon4 0 1 2 3 ≠ 0
  heps2_up_anti : ∀ A B, eps2_up A B = - eps2_up B A
  heps2_up_nondeg : eps2_up 0 1 ≠ 0

  eq2_4_iff : ∀ x μ ν, g_dens x μ ν =
    (1 / 3 : ℂ) * sumFin4 fun α ↦ sumFin4 fun β ↦ sumFin4 fun γ ↦ sumFin4 fun δ ↦
      sumFin2 fun A ↦ sumFin2 fun B ↦ sumFin2 fun C ↦
        sumFin2 fun D ↦ sumFin2 fun E ↦ sumFin2 fun F ↦
          epsilon4 α β γ δ * Sigma x μ α A B * eps2_up B C *
            Sigma x β γ C D * eps2_up D E * Sigma x δ ν E F * eps2_up F A

Litlib.equation "capovilla1991self"
  eq "2.6a"
  page "44"
  kind "Constraint"
class Eq2_6a
    (Spacetime : Type*) [TopologicalSpace Spacetime]
    (Sigma : Spacetime → Fin 4 → Fin 4 → Fin 2 → Fin 2 → ℂ)
    (Sigma_bar : Spacetime → Fin 4 → Fin 4 → Fin 2 → Fin 2 → ℂ)
    (epsilon4 : Fin 4 → Fin 4 → Fin 4 → Fin 4 → ℂ) where
  h_eps_nonzero : epsilon4 0 1 2 3 ≠ 0

  eq2_6a_iff : ∀ x A B A' B',
    (sumFin4 fun μ ↦ sumFin4 fun ν ↦ sumFin4 fun ρ ↦ sumFin4 fun σ ↦
      epsilon4 μ ν ρ σ * Sigma x μ ν A B * Sigma_bar x ρ σ A' B') = 0

Litlib.equation "capovilla1991self"
  eq "2.6b"
  page "44"
  kind "Constraint"
class Eq2_6b
    (Spacetime : Type*) [TopologicalSpace Spacetime]
    (Sigma : Spacetime → Fin 4 → Fin 4 → Fin 2 → Fin 2 → ℂ)
    (Sigma_down : Spacetime → Fin 4 → Fin 4 → Fin 2 → Fin 2 → ℂ)
    (Sigma_bar : Spacetime → Fin 4 → Fin 4 → Fin 2 → Fin 2 → ℂ)
    (Sigma_bar_down : Spacetime → Fin 4 → Fin 4 → Fin 2 → Fin 2 → ℂ)
    (epsilon4 : Fin 4 → Fin 4 → Fin 4 → Fin 4 → ℂ) where
  h_eps_nonzero : epsilon4 0 1 2 3 ≠ 0

  eq2_6b_iff : ∀ x,
    let term1 := sumFin4 fun μ ↦ sumFin4 fun ν ↦ sumFin4 fun ρ ↦ sumFin4 fun σ ↦
      epsilon4 μ ν ρ σ * sumFin2 fun M ↦ sumFin2 fun N ↦
        Sigma x μ ν M N * Sigma_down x ρ σ M N;
    let term2 := sumFin4 fun μ ↦ sumFin4 fun ν ↦ sumFin4 fun ρ ↦ sumFin4 fun σ ↦
      epsilon4 μ ν ρ σ * sumFin2 fun M' ↦ sumFin2 fun N' ↦
        Sigma_bar x μ ν M' N' * Sigma_bar_down x ρ σ M' N';
    term1 + term2 = 0

Litlib.equation "capovilla1991self"
  eq "2.7"
  page "44"
  kind "Action"
class Eq2_7
    (Spacetime : Type*) [TopologicalSpace Spacetime] [MeasureTheory.MeasureSpace Spacetime]
    (S : ℂ)
    (Sigma : Spacetime → Fin 4 → Fin 4 → Fin 2 → Fin 2 → ℂ)
    (R : Spacetime → Fin 4 → Fin 4 → Fin 2 → Fin 2 → ℂ)
    (Psi : Spacetime → Fin 2 → Fin 2 → Fin 2 → Fin 2 → ℂ)
    (epsilon4 : Fin 4 → Fin 4 → Fin 4 → Fin 4 → ℂ) where
  hSigma_meas : ∀ μ ν A B, MeasureTheory.AEStronglyMeasurable (fun x ↦ Sigma x μ ν A B) volume
  hR_meas : ∀ μ ν A B, MeasureTheory.AEStronglyMeasurable (fun x ↦ R x μ ν A B) volume
  hPsi_meas : ∀ A B C D, MeasureTheory.AEStronglyMeasurable (fun x ↦ Psi x A B C D) volume
  h_eps_swap1 : ∀ α β γ δ, epsilon4 α β γ δ = - epsilon4 β α γ δ
  h_eps_swap2 : ∀ α β γ δ, epsilon4 α β γ δ = - epsilon4 α γ β δ
  h_eps_nonzero : epsilon4 0 1 2 3 ≠ 0

  eq2_7_iff : S = MeasureTheory.integral volume (fun x ↦
    let term1 := sumFin4 fun μ ↦ sumFin4 fun ν ↦ sumFin4 fun ρ ↦ sumFin4 fun σ ↦
      epsilon4 μ ν ρ σ * sumFin2 fun A ↦ sumFin2 fun B ↦
        Sigma x μ ν A B * R x ρ σ A B;
    let term2 := sumFin4 fun μ ↦ sumFin4 fun ν ↦ sumFin4 fun ρ ↦ sumFin4 fun σ ↦
      epsilon4 μ ν ρ σ * sumFin2 fun A ↦ sumFin2 fun B ↦ sumFin2 fun C ↦ sumFin2 fun D ↦
        Psi x A B C D * Sigma x μ ν A B * Sigma x ρ σ C D;
    term1 - (1/2 : ℂ) * term2
  )

Litlib.equation "capovilla1991self"
  eq "2.8a"
  page "44"
  kind "Equation of Motion"
class Eq2_8a
    (Spacetime : Type*) [TopologicalSpace Spacetime]
    (Sigma : Spacetime → Fin 4 → Fin 4 → Fin 2 → Fin 2 → ℂ)
    (epsilon4 : Fin 4 → Fin 4 → Fin 4 → Fin 4 → ℂ) where
  hSigma_anti : ∀ x μ ν A B, Sigma x μ ν A B = - Sigma x ν μ A B
  hSigma_symm : ∀ x μ ν A B, Sigma x μ ν A B = Sigma x μ ν B A
  h_eps_nonzero : epsilon4 0 1 2 3 ≠ 0

  eq2_8a_iff : ∀ x A B C D,
    let w := fun A' B' C' D' ↦ sumFin4 fun μ ↦ sumFin4 fun ν ↦ sumFin4 fun ρ ↦ sumFin4 fun σ ↦
      epsilon4 μ ν ρ σ * Sigma x μ ν A' B' * Sigma x ρ σ C' D';
    w A B C D + w A C B D + w A D B C = 0

Litlib.equation "capovilla1991self"
  eq "2.8b"
  page "44"
  kind "Equation of Motion"
class Eq2_8b
    (Spacetime : Type*) [TopologicalSpace Spacetime]
    (dSigma : Spacetime → Fin 4 → Fin 4 → Fin 4 → Fin 2 → Fin 2 → ℂ)
    (omega : Spacetime → Fin 4 → Fin 2 → Fin 2 → ℂ)
    (Sigma : Spacetime → Fin 4 → Fin 4 → Fin 2 → Fin 2 → ℂ)
    (eps2_up : Fin 2 → Fin 2 → ℂ) where
  hSigma_anti : ∀ x μ ν A B, Sigma x μ ν A B = - Sigma x ν μ A B
  homega_symm : ∀ x μ A B, omega x μ A B = omega x μ B A

  eq2_8b_iff : ∀ x μ ν ρ A B,
    let omega_up := fun lam A' C' ↦ sumFin2 fun E ↦ eps2_up A' E * omega x lam E C';
    let term := fun m n r ↦ dSigma x m n r A B +
      sumFin2 (fun C ↦ omega_up m A C * Sigma x n r B C + omega_up m B C * Sigma x n r A C);
    term μ ν ρ + term ν ρ μ + term ρ μ ν - term ν μ ρ - term μ ρ ν - term ρ ν μ = 0

Litlib.equation "capovilla1991self"
  eq "2.8c"
  page "44"
  kind "Equation of Motion"
class Eq2_8c
    (Spacetime : Type*) [TopologicalSpace Spacetime]
    (R : Spacetime → Fin 4 → Fin 4 → Fin 2 → Fin 2 → ℂ)
    (Psi : Spacetime → Fin 2 → Fin 2 → Fin 2 → Fin 2 → ℂ)
    (Sigma : Spacetime → Fin 4 → Fin 4 → Fin 2 → Fin 2 → ℂ) where
  hR_anti : ∀ x μ ν A B, R x μ ν A B = - R x ν μ A B
  hSigma_anti : ∀ x μ ν A B, Sigma x μ ν A B = - Sigma x ν μ A B
  hR_symm_spin : ∀ x μ ν A B, R x μ ν A B = R x μ ν B A
  hSigma_symm_spin : ∀ x μ ν A B, Sigma x μ ν A B = Sigma x μ ν B A
  hPsiSymm : ∀ x A B C D,
    Psi x A B C D = Psi x B A C D ∧
    Psi x A B C D = Psi x A C B D ∧
    Psi x A B C D = Psi x A B D C

  eq2_8c_iff : ∀ x μ ν A B, R x μ ν A B =
    sumFin2 fun C ↦ sumFin2 fun D ↦ Psi x A B C D * Sigma x μ ν C D

Litlib.equation "capovilla1991self"
  eq "2.8c_prime"
  page "45"
  kind "Equation of Motion"
class Eq2_8c_Prime
    (Spacetime : Type*) [TopologicalSpace Spacetime]
    (R : Spacetime → Fin 4 → Fin 4 → Fin 2 → Fin 2 → ℂ)
    (Psi : Spacetime → Fin 2 → Fin 2 → Fin 2 → Fin 2 → ℂ)
    (Sigma : Spacetime → Fin 4 → Fin 4 → Fin 2 → Fin 2 → ℂ)
    (Lambda : ℂ) where
  hR_anti : ∀ x μ ν A B, R x μ ν A B = - R x ν μ A B
  hSigma_anti : ∀ x μ ν A B, Sigma x μ ν A B = - Sigma x ν μ A B
  hR_symm_spin : ∀ x μ ν A B, R x μ ν A B = R x μ ν B A
  hSigma_symm_spin : ∀ x μ ν A B, Sigma x μ ν A B = Sigma x μ ν B A
  hPsiSymm : ∀ x A B C D,
    Psi x A B C D = Psi x B A C D ∧
    Psi x A B C D = Psi x A C B D ∧
    Psi x A B C D = Psi x A B D C

  eq2_8c_prime_iff : ∀ x μ ν A B, R x μ ν A B =
    (sumFin2 fun C ↦ sumFin2 fun D ↦ Psi x A B C D * Sigma x μ ν C D) +
    (Lambda / 6) * Sigma x μ ν A B

Litlib.equation "capovilla1991self"
  eq "Page 45, Theorem 1"
  page "45"
  kind "Theorem"
class Theorem_Eq2_8c_Prime_EinsteinSpace
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
    (Lambda : ℂ)
    (isEinsteinSpace : ℂ → (Spacetime → Fin 4 → Fin 4 → ℂ) → Prop) where
  heps2_anti : ∀ A B, eps2_down A B = - eps2_down B A
  heps2_bar_anti : ∀ A' B', eps2_bar_down A' B' = - eps2_bar_down B' A'
  heps2_right_anti : ∀ A' B', eps2_right A' B' = - eps2_right B' A'
  heps2_up_anti : ∀ A B, eps2_up A B = - eps2_up B A

  hSigma_anti : ∀ x μ ν A B, Sigma x μ ν A B = - Sigma x ν μ A B
  homega_symm : ∀ x μ A B, omega x μ A B = omega x μ B A
  hg_def : ∀ x μ ν, g x μ ν =
    sumFin2 fun A ↦ sumFin2 fun B ↦ sumFin2 fun A' ↦ sumFin2 fun B' ↦
      eps2_down A B * eps2_bar_down A' B' * theta x μ A A' * theta x ν B B'

  eq2_8c_prime_implies_einstein_space :
    (∀ x μ ν A B, Sigma x μ ν A B = sumFin2 fun A' ↦ sumFin2 fun B' ↦
      eps2_right A' B' * theta x μ A A' * theta x ν B B') →
    (∀ x μ ν ρ A B,
      let omega_up := fun lam A' C' ↦ sumFin2 fun E ↦ eps2_up A' E * omega x lam E C';
      let term := fun m n r ↦ dSigma x m n r A B +
        sumFin2 (fun C ↦ omega_up m A C * Sigma x n r B C + omega_up m B C * Sigma x n r A C);
      term μ ν ρ + term ν ρ μ + term ρ μ ν - term ν μ ρ - term μ ρ ν - term ρ ν μ = 0) →
    (∀ x μ ν A B, R x μ ν A B =
      (sumFin2 fun C ↦ sumFin2 fun D ↦ Psi x A B C D * Sigma x μ ν C D) +
      (Lambda / 6) * Sigma x μ ν A B) →
    isEinsteinSpace Lambda g

Litlib.equation "capovilla1991self"
  eq "2.11"
  page "46"
  kind "Constraint"
class Eq2_11
    (Spacetime : Type*) [TopologicalSpace Spacetime]
    (R : Spacetime → Fin 4 → Fin 4 → Fin 2 → Fin 2 → ℂ)
    (epsilon4 : Fin 4 → Fin 4 → Fin 4 → Fin 4 → ℂ) where
  hR_anti : ∀ x μ ν A B, R x μ ν A B = - R x ν μ A B
  hR_symm_spin : ∀ x μ ν A B, R x μ ν A B = R x μ ν B A
  h_eps_nonzero : epsilon4 0 1 2 3 ≠ 0

  eq2_11_iff : ∀ x A B C D,
    let w := fun A' B' C' D' ↦ sumFin4 fun μ ↦ sumFin4 fun ν ↦ sumFin4 fun ρ ↦ sumFin4 fun σ ↦
      epsilon4 μ ν ρ σ * R x μ ν A' B' * R x ρ σ C' D';
    w A B C D + w A C B D + w A D B C = 0

Litlib.equation "capovilla1991self"
  eq "4.3"
  page "49"
  kind "Action"
class Eq4_3_YangMills
    (Spacetime : Type*) [TopologicalSpace Spacetime] [MeasureTheory.MeasureSpace Spacetime]
    (S_YM : ℂ)
    (Sigma : Spacetime → Fin 4 → Fin 4 → Fin 2 → Fin 2 → ℂ)
    (F : Spacetime → Fin 4 → Fin 4 → ℂ)
    (phi : Spacetime → Fin 2 → Fin 2 → ℂ)
    (epsilon4 : Fin 4 → Fin 4 → Fin 4 → Fin 4 → ℂ) where
  hSigma_meas : ∀ μ ν A B, MeasureTheory.AEStronglyMeasurable (fun x ↦ Sigma x μ ν A B) volume
  hF_meas : ∀ μ ν, MeasureTheory.AEStronglyMeasurable (fun x ↦ F x μ ν) volume
  hphi_meas : ∀ A B, MeasureTheory.AEStronglyMeasurable (fun x ↦ phi x A B) volume
  h_eps_nonzero : epsilon4 0 1 2 3 ≠ 0

  eq4_3_iff : S_YM = MeasureTheory.integral volume (fun x ↦
    let term1 := sumFin4 fun μ ↦ sumFin4 fun ν ↦ sumFin4 fun ρ ↦ sumFin4 fun σ ↦
      epsilon4 μ ν ρ σ * (
        sumFin2 fun A ↦ sumFin2 fun B ↦
          F x μ ν * phi x A B * Sigma x ρ σ A B
      );
    let term2 := sumFin4 fun μ ↦ sumFin4 fun ν ↦ sumFin4 fun ρ ↦ sumFin4 fun σ ↦
      epsilon4 μ ν ρ σ * (
        sumFin2 fun A ↦ sumFin2 fun B ↦ sumFin2 fun C ↦ sumFin2 fun D ↦
          phi x A B * phi x C D * Sigma x μ ν A B * Sigma x ρ σ C D
      );
    term1 - (1/2 : ℂ) * term2
  )

Litlib.equation "capovilla1991self"
  eq "4.12"
  page "50"
  kind "Action"
class Eq4_12_SpinHalf
    (Spacetime : Type*) [TopologicalSpace Spacetime] [MeasureTheory.MeasureSpace Spacetime]
    (S_half : ℂ)
    (Sigma : Spacetime → Fin 4 → Fin 4 → Fin 2 → Fin 2 → ℂ)
    (p : Spacetime → Fin 4 → Fin 2 → ℂ)
    (Dlambda : Spacetime → Fin 4 → Fin 2 → ℂ)
    (tau : Spacetime → Fin 4 → Fin 2 → Fin 2 → Fin 2 → ℂ)
    (epsilon4 : Fin 4 → Fin 4 → Fin 4 → Fin 4 → ℂ) where
  hSigma_meas : ∀ μ ν A B, MeasureTheory.AEStronglyMeasurable (fun x ↦ Sigma x μ ν A B) volume
  hp_meas : ∀ μ A, MeasureTheory.AEStronglyMeasurable (fun x ↦ p x μ A) volume
  hDlambda_meas : ∀ μ A, MeasureTheory.AEStronglyMeasurable (fun x ↦ Dlambda x μ A) volume
  htau_meas : ∀ μ A B C, MeasureTheory.AEStronglyMeasurable (fun x ↦ tau x μ A B C) volume
  htau_symm : ∀ x μ A B C,
    tau x μ A B C = tau x μ B A C ∧
    tau x μ A B C = tau x μ A C B ∧
    tau x μ A B C = tau x μ C B A
  h_eps_nonzero : epsilon4 0 1 2 3 ≠ 0

  eq4_12_iff : S_half = MeasureTheory.integral volume (fun x ↦
    let term1 := sumFin4 fun μ ↦ sumFin4 fun ν ↦ sumFin4 fun ρ ↦ sumFin4 fun σ ↦
      epsilon4 μ ν ρ σ * (
        sumFin2 fun A ↦ sumFin2 fun B ↦
          Sigma x μ ν A B * p x ρ A * Dlambda x σ B
      );
    let term2 := sumFin4 fun μ ↦ sumFin4 fun ν ↦ sumFin4 fun ρ ↦ sumFin4 fun σ ↦
      epsilon4 μ ν ρ σ * (
        sumFin2 fun A ↦ sumFin2 fun B ↦ sumFin2 fun C ↦
          tau x μ A B C * Sigma x ν ρ A B * p x σ C
      );
    term1 + term2
  )

Litlib.equation "capovilla1991self"
  eq "4.17"
  page "51"
  kind "Action"
class Eq4_17_Supergravity
    (Spacetime : Type*) [TopologicalSpace Spacetime] [MeasureTheory.MeasureSpace Spacetime]
    (S_SG : ℂ)
    (Sigma : Spacetime → Fin 4 → Fin 4 → Fin 2 → Fin 2 → ℂ)
    (R : Spacetime → Fin 4 → Fin 4 → Fin 2 → Fin 2 → ℂ)
    (chi : Spacetime → Fin 4 → Fin 4 → Fin 2 → ℂ)
    (Dpsi : Spacetime → Fin 4 → Fin 4 → Fin 2 → ℂ)
    (Psi : Spacetime → Fin 2 → Fin 2 → Fin 2 → Fin 2 → ℂ)
    (kappa : Spacetime → Fin 2 → Fin 2 → Fin 2 → ℂ)
    (epsilon4 : Fin 4 → Fin 4 → Fin 4 → Fin 4 → ℂ) where
  hSigma_meas : ∀ μ ν A B, MeasureTheory.AEStronglyMeasurable (fun x ↦ Sigma x μ ν A B) volume
  hR_meas : ∀ μ ν A B, MeasureTheory.AEStronglyMeasurable (fun x ↦ R x μ ν A B) volume
  hchi_meas : ∀ μ ν A, MeasureTheory.AEStronglyMeasurable (fun x ↦ chi x μ ν A) volume
  hDpsi_meas : ∀ μ ν A, MeasureTheory.AEStronglyMeasurable (fun x ↦ Dpsi x μ ν A) volume
  hPsi_meas : ∀ A B C D, MeasureTheory.AEStronglyMeasurable (fun x ↦ Psi x A B C D) volume
  hkappa_meas : ∀ A B C, MeasureTheory.AEStronglyMeasurable (fun x ↦ kappa x A B C) volume
  hkappa_symm : ∀ x A B C,
    kappa x A B C = kappa x B A C ∧
    kappa x A B C = kappa x A C B ∧
    kappa x A B C = kappa x C B A
  h_eps_nonzero : epsilon4 0 1 2 3 ≠ 0

  eq4_17_iff : S_SG = MeasureTheory.integral volume (fun x ↦
    let term1 := sumFin4 fun μ ↦ sumFin4 fun ν ↦ sumFin4 fun ρ ↦ sumFin4 fun σ ↦
      epsilon4 μ ν ρ σ * (
        sumFin2 fun A ↦ sumFin2 fun B ↦
          Sigma x μ ν A B * R x ρ σ A B
      );
    let term2 := sumFin4 fun μ ↦ sumFin4 fun ν ↦ sumFin4 fun ρ ↦ sumFin4 fun σ ↦
      epsilon4 μ ν ρ σ * (
        sumFin2 fun A ↦
          chi x μ ν A * Dpsi x ρ σ A
      );
    let term3 := (1/2 : ℂ) * sumFin4 fun μ ↦ sumFin4 fun ν ↦ sumFin4 fun ρ ↦ sumFin4 fun σ ↦
      epsilon4 μ ν ρ σ * (
        sumFin2 fun A ↦ sumFin2 fun B ↦ sumFin2 fun C ↦ sumFin2 fun D ↦
          Psi x A B C D * Sigma x μ ν A B * Sigma x ρ σ C D
      );
    let term4 := sumFin4 fun μ ↦ sumFin4 fun ν ↦ sumFin4 fun ρ ↦ sumFin4 fun σ ↦
      epsilon4 μ ν ρ σ * (
        sumFin2 fun A ↦ sumFin2 fun B ↦ sumFin2 fun C ↦
          kappa x A B C * Sigma x μ ν A B * chi x ρ σ C
      );
    term1 + term2 - term3 - term4
  )

end Litlib.Y1991.capovilla1991self
