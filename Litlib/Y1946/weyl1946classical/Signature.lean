-- FILENAME: Litlib/Y1946/weyl1946classical/Signature.lean

import Litlib.Core
import Mathlib.RingTheory.Noetherian.Basic
import Mathlib.Algebra.Polynomial.Basic
import Mathlib.Algebra.Module.Basic
import Mathlib.RingTheory.SimpleModule.Basic
import Mathlib.Algebra.MonoidAlgebra.Basic
import Mathlib.RepresentationTheory.Maschke
import Mathlib.Data.Complex.Basic
import Mathlib.Algebra.Algebra.IsSimpleRing  -- FIXED: Exact import for IsSimpleRing

namespace Litlib.Y1946.weyl1946classical

literature_axiom SchursLemma
  bibtex_key "weyl1946classical"
  authors ["Weyl, Hermann"]
  status Standard
class SchursLemma where
  /-- Chapter III, Lemma 3.1.A -/
  end_of_simple_module_is_division_ring (R V : Type*) [Ring R] [AddCommGroup V] [Module R V] [IsSimpleModule R V] : 
    Nonempty (DivisionRing (Module.End R V))

literature_axiom DivRingIsSimple
  bibtex_key "weyl1946classical"
  authors ["Weyl, Hermann"]
  status Standard
class DivRingIsSimple where
  /-- Chapter III, Theorem 3.3.A -/
  division_ring_is_simple_ring (D : Type*) [DivisionRing D] : IsSimpleRing D

literature_axiom MaschkesTheorem
  bibtex_key "weyl1946classical"
  authors ["Weyl, Hermann"]
  status Standard
class MaschkesTheorem where
  /-- Chapter III, Section 7 -/
  group_ring_is_semisimple (k G : Type*) [Field k] [Group G] [Fintype G] [Invertible (Fintype.card G : k)] :
    IsSemisimpleRing (MonoidAlgebra k G)

literature_axiom HilbertBasisTheorem
  bibtex_key "weyl1946classical"
  authors ["Weyl, Hermann"]
  status Standard
class HilbertBasisTheorem where
  /-- Chapter VIII, Theorem 8.6.A -/
  polynomial_is_noetherian (R : Type*) [CommRing R] [IsNoetherianRing R] : 
    IsNoetherianRing (Polynomial R)

literature_axiom FirstMainTheoremOrthogonalRank4
  bibtex_key "weyl1946classical"
  authors ["Weyl, Hermann"]
  status Standard
class FirstMainTheoremOrthogonalRank4 where
  /-- Chapter II, Theorem 2.9.A -/
  unique_lorentz_invariant_rank4 
    (IsLorentzInvariant : (Fin 4 → Fin 4 → Fin 4 → Fin 4 → ℂ) → Prop)
    (eta : Fin 4 → Fin 4 → ℂ)
    (epsilon4 : Fin 4 → Fin 4 → Fin 4 → Fin 4 → ℂ)
    (T : Fin 4 → Fin 4 → Fin 4 → Fin 4 → ℂ) :
    IsLorentzInvariant T →
    ∃ (c1 c2 c3 c4 : ℂ), ∀ μ ν ρ σ,
      T μ ν ρ σ = c1 * (eta μ ν * eta ρ σ) + c2 * (eta μ ρ * eta ν σ) + c3 * (eta μ σ * eta ν ρ) + c4 * epsilon4 μ ν ρ σ
