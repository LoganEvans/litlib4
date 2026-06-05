-- FILENAME: Litlib/Y1951/papapetrou1951spinning/Signature.lean

import Litlib.Core
import Mathlib.Topology.Basic
import Mathlib.Data.Matrix.Basic
import Mathlib.Data.Real.Basic
import Mathlib.LinearAlgebra.Matrix.Determinant.Basic
import Mathlib.Data.Fintype.Basic

open scoped BigOperators

namespace Litlib.Y1951.papapetrou1951spinning

Litlib.paper "papapetrou1951spinning"
  type "article"
  title "Spinning test-particles in general relativity. I"
  authors ["Papapetrou, Achille"]
  journal "Proceedings of the Royal Society of London. Series A. Mathematical and Physical Sciences"
  volume "209"
  issue "1097"
  pages "248--258"
  year "1951"
  publisher "The Royal Society London"
  doi "10.1098/rspa.1951.0200"

Litlib.equation "papapetrou1951spinning"
  eq "2.12"
  page "252"
  kind "theorem"
/--
Geometric Non-Degeneracy Constraint: The macroscopic metric density determinant must be strictly non-zero to prevent topological collapse of the volume form.
Velocity Non-Degeneracy Constraint: The 4-velocity must not be identically zero, preventing trivial static solutions where the test-particle possesses no worldline progression.
Equation (2.12) proves that the orbits of a single-pole test particle are geodesics of the basic background metric field.
-/
class Eq2_12
    (M : Type*) [TopologicalSpace M]
    (Metric : M → Matrix (Fin 4) (Fin 4) ℝ)
    (Christoffel : M → (Fin 4 → Fin 4 → Fin 4 → ℝ))
    (worldline : ℝ → M)
    (u_up : ℝ → (Fin 4 → ℝ))
    (du_up_ds : ℝ → (Fin 4 → ℝ))
    where
  metric_nondegenerate : ∀ p, (Metric p).det ≠ 0
  u_norm_nonzero : ∀ s, ∑ μ, ∑ ν, Metric (worldline s) μ ν * u_up s μ * u_up s ν ≠ 0
  single_pole_eom : ∀ s α,
    du_up_ds s α + ∑ μ, ∑ ν, Christoffel (worldline s) α μ ν * u_up s μ * u_up s ν = 0

Litlib.equation "papapetrou1951spinning"
  eq "5.3"
  page "257"
  kind "theorem"
/--
Geometric Non-Degeneracy Constraint: The macroscopic metric density determinant must be strictly non-zero.
Velocity Non-Degeneracy Constraint: The 4-velocity must not be identically zero.
Equation (5.3) is the covariant formulation of the equation of motion of the spin for a pole-dipole particle.
-/
class Eq5_3
    (M : Type*) [TopologicalSpace M]
    (Metric : M → Matrix (Fin 4) (Fin 4) ℝ)
    (worldline : ℝ → M)
    (u_up : ℝ → (Fin 4 → ℝ))
    (u_down : ℝ → (Fin 4 → ℝ))
    (S_up : ℝ → Matrix (Fin 4) (Fin 4) ℝ)
    (CovDerivS_up : ℝ → Matrix (Fin 4) (Fin 4) ℝ)
    where
  metric_nondegenerate : ∀ p, (Metric p).det ≠ 0
  u_norm_nonzero : ∀ s, ∑ μ, ∑ ν, Metric (worldline s) μ ν * u_up s μ * u_up s ν ≠ 0
  u_lowering : ∀ s ρ, u_down s ρ = ∑ σ, Metric (worldline s) ρ σ * u_up s σ
  S_antisymmetric : ∀ s α β, S_up s α β = - S_up s β α
  spin_eom : ∀ s α β,
    CovDerivS_up s α β +
    u_up s α * (∑ ρ, u_down s ρ * CovDerivS_up s β ρ) -
    u_up s β * (∑ ρ, u_down s ρ * CovDerivS_up s α ρ) = 0

Litlib.equation "papapetrou1951spinning"
  eq "5.7"
  page "258"
  kind "theorem"
/--
Geometric Non-Degeneracy Constraint: The macroscopic metric density determinant must be strictly non-zero.
Velocity Non-Degeneracy Constraint: The 4-velocity must not be identically zero.
Mass Non-Degeneracy Constraint: The rest mass must be strictly positive to represent a massive physical test particle.
Equation (5.7) is the covariant equation of motion of a pole-dipole particle, generalizing the geodesic equation by coupling the spin tensor to the spacetime curvature.
-/
class Eq5_7
    (M : Type*) [TopologicalSpace M]
    (Metric : M → Matrix (Fin 4) (Fin 4) ℝ)
    (Riemann : M → (Fin 4 → Fin 4 → Fin 4 → Fin 4 → ℝ))
    (worldline : ℝ → M)
    (m : ℝ → ℝ)
    (u_up : ℝ → (Fin 4 → ℝ))
    (u_down : ℝ → (Fin 4 → ℝ))
    (S_up : ℝ → Matrix (Fin 4) (Fin 4) ℝ)
    (CovDerivS_up : ℝ → Matrix (Fin 4) (Fin 4) ℝ)
    (P_up : ℝ → (Fin 4 → ℝ))
    (CovDerivP_up : ℝ → (Fin 4 → ℝ))
    where
  metric_nondegenerate : ∀ p, (Metric p).det ≠ 0
  u_norm_nonzero : ∀ s, ∑ μ, ∑ ν, Metric (worldline s) μ ν * u_up s μ * u_up s ν ≠ 0
  mass_positive : ∀ s, m s > 0
  u_lowering : ∀ s ρ, u_down s ρ = ∑ σ, Metric (worldline s) ρ σ * u_up s σ
  P_def : ∀ s α, P_up s α = m s * u_up s α + ∑ β, u_down s β * CovDerivS_up s α β
  pole_dipole_eom : ∀ s α,
    CovDerivP_up s α +
    (1 / 2) * ∑ μ, ∑ ν, ∑ σ, S_up s μ ν * u_up s σ * Riemann (worldline s) α ν σ μ = 0

end Litlib.Y1951.papapetrou1951spinning
