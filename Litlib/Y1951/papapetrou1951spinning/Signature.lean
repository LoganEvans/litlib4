-- FILENAME: Litlib/Y1951/papapetrou1951spinning/Signature.lean

import Litlib.Core
import Mathlib.Topology.Basic
import Mathlib.Data.Matrix.Basic
import Mathlib.Data.Real.Basic
import Mathlib.Data.Complex.Basic
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
Geometric Non-Degeneracy Constraint: The macroscopic metric density determinant must be strictly non-zero.
Velocity Non-Degeneracy Constraint: The 4-velocity must not be identically zero.
Algebraic Domain Constraint: Parameterized over a generic Field `F` with Characteristic Zero (`CharZero`).
Physical Domain Binding: Papapetrou (1951) Eq (2.12): If a tensor distribution T represents a single-pole 
test particle, and it is covariantly conserved with respect to the background connection, 
then its worldline must exactly satisfy the geodesic equation.
-/
class Eq2_12
    (M : Type*) [TopologicalSpace M]
    (F : Type*) [Field F] [CharZero F]
    (Metric : M → Matrix (Fin 4) (Fin 4) F)
    (Christoffel : M → (Fin 4 → Fin 4 → Fin 4 → F))
    (T : Fin 4 → Fin 4 → M → F)
    (partialDeriv : Fin 4 → (M → F) → M → F)
    (worldline : F → M)
    (u_up : F → (Fin 4 → F))
    (du_up_ds : F → (Fin 4 → F))
    (isSinglePole : (Fin 4 → Fin 4 → M → F) → (F → M) → Prop)
    where
  metric_nondegenerate : ∀ p, (Metric p).det ≠ 0
  u_norm_nonzero : ∀ s, ∑ μ, ∑ ν, Metric (worldline s) μ ν * u_up s μ * u_up s ν ≠ 0
  single_pole_eom : 
    (∀ x b, ∑ a : Fin 4, (
      partialDeriv a (fun p => T a b p) x +
      ∑ c : Fin 4, (Christoffel x a a c * T c b x + Christoffel x b a c * T a c x)
    ) = 0) →
    isSinglePole T worldline →
    ∀ s α, du_up_ds s α + ∑ μ, ∑ ν, Christoffel (worldline s) α μ ν * u_up s μ * u_up s ν = 0

Litlib.equation "papapetrou1951spinning"
  eq "5.3"
  page "257"
  kind "theorem"
/--
Geometric Non-Degeneracy Constraint: The macroscopic metric density determinant must be strictly non-zero.
Velocity Non-Degeneracy Constraint: The 4-velocity must not be identically zero.
Physical Domain Binding: Eq (5.3) is the covariant formulation of the equation of motion of the spin for a pole-dipole particle, 
strictly derived from the covariant conservation of the internal stress-energy tensor.
-/
class Eq5_3
    (M : Type*) [TopologicalSpace M]
    (F : Type*) [Field F] [CharZero F]
    (Metric : M → Matrix (Fin 4) (Fin 4) F)
    (Christoffel : M → (Fin 4 → Fin 4 → Fin 4 → F))
    (T : Fin 4 → Fin 4 → M → F)
    (partialDeriv : Fin 4 → (M → F) → M → F)
    (worldline : F → M)
    (u_up : F → (Fin 4 → F))
    (u_down : F → (Fin 4 → F))
    (S_up : F → Matrix (Fin 4) (Fin 4) F)
    (CovDerivS_up : F → Matrix (Fin 4) (Fin 4) F)
    (isPoleDipole : (Fin 4 → Fin 4 → M → F) → (F → M) → Prop)
    where
  metric_nondegenerate : ∀ p, (Metric p).det ≠ 0
  u_norm_nonzero : ∀ s, ∑ μ, ∑ ν, Metric (worldline s) μ ν * u_up s μ * u_up s ν ≠ 0
  u_lowering : ∀ s ρ, u_down s ρ = ∑ σ, Metric (worldline s) ρ σ * u_up s σ
  S_antisymmetric : ∀ s α β, S_up s α β = - S_up s β α
  spin_eom : 
    (∀ x b, ∑ a : Fin 4, (
      partialDeriv a (fun p => T a b p) x +
      ∑ c : Fin 4, (Christoffel x a a c * T c b x + Christoffel x b a c * T a c x)
    ) = 0) →
    isPoleDipole T worldline →
    ∀ s α β,
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
Mass Non-Degeneracy Constraint: The rest mass must be strictly non-zero.
Physical Domain Binding: Equation (5.7) is the covariant equation of motion of a pole-dipole particle, 
generalizing the geodesic equation by coupling the spin tensor to the spacetime curvature, strictly derived from 
the conservation of the particle's internal stress-energy tensor.
-/
class Eq5_7
    (M : Type*) [TopologicalSpace M]
    (F : Type*) [Field F] [CharZero F]
    (Metric : M → Matrix (Fin 4) (Fin 4) F)
    (Christoffel : M → (Fin 4 → Fin 4 → Fin 4 → F))
    (Riemann : M → (Fin 4 → Fin 4 → Fin 4 → Fin 4 → F))
    (T : Fin 4 → Fin 4 → M → F)
    (partialDeriv : Fin 4 → (M → F) → M → F)
    (worldline : F → M)
    (m : F → F)
    (u_up : F → (Fin 4 → F))
    (u_down : F → (Fin 4 → F))
    (S_up : F → Matrix (Fin 4) (Fin 4) F)
    (CovDerivS_up : F → Matrix (Fin 4) (Fin 4) F)
    (P_up : F → (Fin 4 → F))
    (CovDerivP_up : F → (Fin 4 → F))
    (isPoleDipole : (Fin 4 → Fin 4 → M → F) → (F → M) → Prop)
    where
  metric_nondegenerate : ∀ p, (Metric p).det ≠ 0
  u_norm_nonzero : ∀ s, ∑ μ, ∑ ν, Metric (worldline s) μ ν * u_up s μ * u_up s ν ≠ 0
  mass_nonzero : ∀ s, m s ≠ 0
  u_lowering : ∀ s ρ, u_down s ρ = ∑ σ, Metric (worldline s) ρ σ * u_up s σ
  P_def : ∀ s α, P_up s α = m s * u_up s α + ∑ β, u_down s β * CovDerivS_up s α β
  pole_dipole_eom : 
    (∀ x b, ∑ a : Fin 4, (
      partialDeriv a (fun p => T a b p) x +
      ∑ c : Fin 4, (Christoffel x a a c * T c b x + Christoffel x b a c * T a c x)
    ) = 0) →
    isPoleDipole T worldline →
    ∀ s α,
      CovDerivP_up s α +
      (1 / 2 : F) * ∑ μ, ∑ ν, ∑ σ, S_up s μ ν * u_up s σ * Riemann (worldline s) α ν σ μ = 0

end Litlib.Y1951.papapetrou1951spinning
