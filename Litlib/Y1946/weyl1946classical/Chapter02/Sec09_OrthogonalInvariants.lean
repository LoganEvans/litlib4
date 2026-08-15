-- FILENAME: Litlib/Y1946/weyl1946classical/Chapter02/Sec09_OrthogonalInvariants.lean

import Mathlib
import Litlib.Core

open Matrix BigOperators

namespace Litlib.Y1946.weyl1946classical

Litlib.equation "weyl1946classical" eq "2.9.A (Corollary)" page "53" kind "Corollary"
class PhysicsCorollary2_9_A_Rank4 where
  /--
  Physical Interpretation & Mathematical Boundaries:
  Classification of rank-4 invariant tensors under the proper complex orthogonal group SO(4, ℂ).
  In relativistic field theories (e.g., Euclideanized quantum gravity or Yang-Mills theories),
  any interaction vertex, effective action term, or correlation function of rank 4 that is
  locally Lorentz invariant must be constructible purely from the metric tensor `eta` and
  the fully antisymmetric Levi-Civita volume form `epsilon4`.

  Geometric Non-Degeneracy Constraint:
  The macroscopic metric determinant is strictly required to be non-zero (`Matrix.det eta ≠ 0`)
  to prevent the topological collapse of the spacetime volume form. Furthermore, the alternating
  tensor `epsilon4` must not be identically zero.

  Relationship to Literature:
  This corollary explicitly implements Chapter II, Theorem 2.9.A of Weyl, which states that
  every even orthogonal invariant is expressible via combinations of the scalar product, and
  every odd invariant is proportional to the bracket factor (the volume form). For rank 4 in
  4 dimensions, this yields exactly three metric pairings and one volume form.
  -/
  uniqueLorentzInvariantRank4
    (eta : Matrix (Fin 4) (Fin 4) ℂ)
    (epsilon4 : Fin 4 → Fin 4 → Fin 4 → Fin 4 → ℂ)
    (T : Fin 4 → Fin 4 → Fin 4 → Fin 4 → ℂ)
    (hEtaSymm : ∀ i j, eta i j = eta j i)
    (hEtaNondeg : Matrix.det eta ≠ 0)
    (hEpsilonAlt : ∀ α β γ δ,
      epsilon4 α β γ δ = -epsilon4 β α γ δ ∧
      epsilon4 α β γ δ = -epsilon4 α γ β δ ∧
      epsilon4 α β γ δ = -epsilon4 α β δ γ)
    (hEpsilonNondeg : epsilon4 0 1 2 3 ≠ 0)
    (hInv : ∀ (Λ : Matrix (Fin 4) (Fin 4) ℂ),
      Λ * eta * Matrix.transpose Λ = eta → Matrix.det Λ = 1 →
      ∀ μ ν ρ σ, ∑ α : Fin 4, ∑ β : Fin 4, ∑ γ : Fin 4, ∑ δ : Fin 4,
        Λ μ α * Λ ν β * Λ ρ γ * Λ σ δ * T α β γ δ = T μ ν ρ σ) :
    ∃ (c1 c2 c3 c4 : ℂ), ∀ μ ν ρ σ,
      T μ ν ρ σ = c1 * (eta μ ν * eta ρ σ) + c2 * (eta μ ρ * eta ν σ) +
                  c3 * (eta μ σ * eta ν ρ) + c4 * epsilon4 μ ν ρ σ
