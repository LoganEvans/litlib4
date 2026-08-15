-- FILENAME: Litlib/Y1946/weyl1946classical/Chapter03/Sec07_Maschke.lean

import Mathlib
import Litlib.Core

namespace Litlib.Y1946.weyl1946classical

Litlib.equation "weyl1946classical" eq "3.7.A" page "101" kind "Theorem"
class Thm3_7_A where
  /--
  Physical Interpretation & Mathematical Boundaries:
  Maschke's Theorem for the regular representation. In the context of quantum mechanics,
  this theorem guarantees that any state space transforming under a finite symmetry group
  (such as a lattice point group) can be fully decomposed into a direct sum of independent,
  irreducible symmetry modes.

  Algebraic Non-Degeneracy Constraint:
  The theorem explicitly requires that the order of the group `G` is invertible in the
  underlying field `k` (`Invertible (Fintype.card G : k)`). This prevents the "modular"
  collapse of the representation theory, which would otherwise allow non-diagonalizable
  (indecomposable but reducible) physical states.

  Relationship to Literature:
  Formalizes Chapter III, Section 7, Theorem 3.7.A of Weyl, which asserts that every
  invariant subspace of the group ring possesses an idempotent generator, an algebraic
  condition equivalent to the semisimplicity of the group ring.
  -/
  groupRingIsSemisimple (k G : Type*) [Field k] [Group G] [Fintype G]
    [Invertible (Fintype.card G : k)] :
    IsSemisimpleRing (MonoidAlgebra k G)
