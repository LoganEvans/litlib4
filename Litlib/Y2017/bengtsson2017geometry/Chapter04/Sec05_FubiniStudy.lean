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
class Eq4_47 (N : ℕ)
    (kappa : (Fin N → ℂ) → (Fin N → ℂ) → ℝ) where
  -- No-BS constraints: P and Q must be non-zero to avoid division by zero
  kappa_def : ∀ (P Q : Fin N → ℂ),
    P ≠ 0 → Q ≠ 0 →
    kappa P Q = Complex.re (
      ((∑ i, P i * star (Q i)) * (∑ i, Q i * star (P i))) /
      ((∑ i, P i * star (P i)) * (∑ i, Q i * star (Q i)))
    )

end Litlib.Y2017.bengtsson2017geometry
