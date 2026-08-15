-- FILENAME: Litlib/Y1946/weyl1946classical/Chapter03/Sec01_SchursLemma.lean

import Mathlib
import Litlib.Core

namespace Litlib.Y1946.weyl1946classical

Litlib.equation "weyl1946classical" eq "3.1.A" page "81" kind "Lemma"
class Lemma3_1_A where
  /--
  Physical Interpretation & Mathematical Boundaries:
  Schur's Lemma for representations of algebras. In quantum mechanics and gauge theory,
  this foundational lemma guarantees that any operator that commutes with all observables
  of an irreducible representation space must either be identically zero or strictly invertible.
  Over an algebraically closed field, this forces such operators to be scalar multiples
  of the identity, rigorously enforcing superselection rules and determining the structure
  of the system's commutator algebra.

  Relationship to Literature:
  Formalizes Chapter III, Lemma 3.1.A of Weyl's "The Classical Groups": "If L is irreducible
  in k, then any commutator A of L in k is either zero or non-singular; in other words,
  the commutator algebra A of L in k is a division algebra."
  -/
  endOfSimpleModuleIsDivisionRing (R V : Type*) [Ring R] [AddCommGroup V] [Module R V]
    [IsSimpleModule R V] :
    ∀ (f : Module.End R V), f ≠ 0 → IsUnit f
