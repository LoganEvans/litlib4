-- FILENAME: Litlib/Y2017/bengtsson2017geometry/Chapter04/Sec05_FubiniStudy.lean

import Litlib.Core
import Mathlib.Data.Complex.Basic
import Mathlib.Data.Fintype.Basic
import Mathlib.Data.Matrix.Basic
import Litlib.Y2017.bengtsson2017geometry.Paper

namespace Litlib.Y2017.bengtsson2017geometry

open Finset

Litlib.equation "bengtsson2017geometry"
  eq "4.47"
  page "108"
  kind "definition"
/--
Physical Interpretation: The Fubini-Study cross ratio, measuring the quantum mechanical transition probability (fidelity) between two pure states in a projective Hilbert space.
Mathematical Boundaries: The state vectors must be explicitly non-zero to prevent the denominator of the inner products from causing a division-by-zero exploit.
-/
class Eq4_47 (N : ℕ)
    (kappa : (Fin N → ℂ) → (Fin N → ℂ) → ℝ) where
  -- Non-Degeneracy Constraint: Vectors must be strictly non-zero to avoid division by zero.
  kappa_def : ∀ (P Q : Fin N → ℂ),
    P ≠ 0 → Q ≠ 0 →
    kappa P Q = Complex.re (
      ((∑ i, P i * star (Q i)) * (∑ i, Q i * star (P i))) /
      ((∑ i, P i * star (P i)) * (∑ i, Q i * star (Q i)))
    )

end Litlib.Y2017.bengtsson2017geometry
