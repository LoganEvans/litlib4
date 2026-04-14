-- FILENAME: Litlib/Y1946/weyl1946classical/Signature.lean

import Litlib.Core
import Mathlib.RingTheory.Noetherian.Basic
import Mathlib.Algebra.Polynomial.Basic
import Mathlib.Algebra.Module.Basic
import Mathlib.RingTheory.SimpleModule.Basic
import Mathlib.Algebra.MonoidAlgebra.Basic
import Mathlib.RepresentationTheory.Maschke
import Mathlib.Data.Complex.Basic
import Mathlib.Algebra.Algebra.IsSimpleRing
import Mathlib.Data.Matrix.Basic
import Mathlib.LinearAlgebra.Matrix.Determinant.Basic

open Matrix BigOperators

namespace Litlib.Y1946.weyl1946classical

literature_citation SchursLemma
  bibtex_key "weyl1946classical"
  authors ["Weyl, Hermann"]
  status Standard
class SchursLemma where
  /-- Chapter III, Lemma 3.1.A -/
  end_of_simple_module_is_division_ring (R V : Type*) [Ring R] [AddCommGroup V] [Module R V] [IsSimpleModule R V] : 
    Nonempty (DivisionRing (Module.End R V))

literature_citation DivRingIsSimple
  bibtex_key "weyl1946classical"
  authors ["Weyl, Hermann"]
  status Standard
class DivRingIsSimple where
  /-- Chapter III, Theorem 3.3.A -/
  division_ring_is_simple_ring (D : Type*) [DivisionRing D] : IsSimpleRing D

literature_citation MaschkesTheorem
  bibtex_key "weyl1946classical"
  authors ["Weyl, Hermann"]
  status Standard
class MaschkesTheorem where
  /-- Chapter III, Section 7 -/
  group_ring_is_semisimple (k G : Type*) [Field k] [Group G] [Fintype G] [Invertible (Fintype.card G : k)] :
    IsSemisimpleRing (MonoidAlgebra k G)

literature_citation HilbertBasisTheorem
  bibtex_key "weyl1946classical"
  authors ["Weyl, Hermann"]
  status Standard
class HilbertBasisTheorem where
  /-- Chapter VIII, Theorem 8.6.A -/
  polynomial_is_noetherian (R : Type*) [CommRing R] [IsNoetherianRing R] : 
    IsNoetherianRing (Polynomial R)

literature_citation FirstMainTheoremOrthogonalRank4
  bibtex_key "weyl1946classical"
  authors ["Weyl, Hermann"]
  status Standard
class FirstMainTheoremOrthogonalRank4 where
  /-- Chapter II, Theorem 2.9.A -/
  unique_lorentz_invariant_rank4 
    (eta : Matrix (Fin 4) (Fin 4) ℂ)
    (epsilon4 : Fin 4 → Fin 4 → Fin 4 → Fin 4 → ℂ)
    (T : Fin 4 → Fin 4 → Fin 4 → Fin 4 → ℂ)
    (h_eta_symm : ∀ i j, eta i j = eta j i)
    (h_eta_nondeg : Matrix.det eta ≠ 0)
    (h_epsilon_alt : ∀ α β γ δ, 
      epsilon4 α β γ δ = -epsilon4 β α γ δ ∧ 
      epsilon4 α β γ δ = -epsilon4 α γ β δ ∧ 
      epsilon4 α β γ δ = -epsilon4 α β δ γ)
    (h_epsilon_nondeg : epsilon4 0 1 2 3 ≠ 0)
    (h_inv : ∀ (Λ : Matrix (Fin 4) (Fin 4) ℂ),
      Λ * eta * Matrix.transpose Λ = eta → Matrix.det Λ = 1 →
      ∀ μ ν ρ σ, ∑ α : Fin 4, ∑ β : Fin 4, ∑ γ : Fin 4, ∑ δ : Fin 4,
        Λ μ α * Λ ν β * Λ ρ γ * Λ σ δ * T α β γ δ = T μ ν ρ σ) :
    ∃ (c1 c2 c3 c4 : ℂ), ∀ μ ν ρ σ,
      T μ ν ρ σ = c1 * (eta μ ν * eta ρ σ) + c2 * (eta μ ρ * eta ν σ) + c3 * (eta μ σ * eta ν ρ) + c4 * epsilon4 μ ν ρ σ

end Litlib.Y1946.weyl1946classical
