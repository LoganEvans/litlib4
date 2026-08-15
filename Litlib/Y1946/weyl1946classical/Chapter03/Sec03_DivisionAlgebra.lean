-- FILENAME: Litlib/Y1946/weyl1946classical/Chapter03/Sec03_DivisionAlgebra.lean

import Mathlib
import Litlib.Core

namespace Litlib.Y1946.weyl1946classical

Litlib.equation "weyl1946classical" eq "3.3.A" page "87" kind "Theorem"
class Thm3_3_A where
  /--
  Physical Interpretation & Mathematical Boundaries:
  Demonstrates that a division algebra possesses no non-trivial two-sided ideals, rendering
  its regular representation strictly simple. Physically, this classifies the underlying
  algebraic structures of observables (e.g., the field of real numbers or the algebra of
  quaternions) as indivisible, atomic symmetry domains without proper invariant sub-sectors.

  Relationship to Literature:
  Directly formalizes Chapter III, Theorem 3.3.A of Weyl: "A division algebra a is simple."
  -/
  divisionRingIsSimpleRing (D : Type*) [DivisionRing D] : IsSimpleRing D
