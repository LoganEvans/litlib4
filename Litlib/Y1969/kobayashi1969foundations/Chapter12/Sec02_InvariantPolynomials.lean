-- FILENAME: Litlib/Y1969/kobayashi1969foundations/Chapter12/Sec02_InvariantPolynomials.lean

import Mathlib
import Litlib.Core

namespace Litlib.Y1969.kobayashi1969foundations

Litlib.equation "kobayashi1969foundations" eq "2.5" page "300" kind "theorem"
class DegreeOneInvariant (n : Type*) [Fintype n] [DecidableEq n]
    (R : Type*) [CommRing R] [Algebra ℝ R] where
  degreeOneInvariant :
    ∀ (P : Matrix n n R → R),
      (∃ (poly : MvPolynomial (n × n) R),
        ∀ (X : Matrix n n R), P X = MvPolynomial.eval (fun p ↦ X p.1 p.2) poly) →
      (∀ (U U_inv X : Matrix n n R), U * U_inv = 1 → U_inv * U = 1 → P (U * X * U_inv) = P X) →
      (∀ (r : R) (X : Matrix n n R), P (r • X) = r * P X) →
      ∃ (c : R), ∀ (X : Matrix n n R), P X = c * Matrix.trace X
