-- FILENAME: Litlib/Y2017/bengtsson2017geometry/Chapter04/Sec06_CPIllustrated.lean

import Litlib.Core
import Mathlib.Data.Complex.Basic
import Mathlib.Data.Matrix.Basic
import Mathlib.Data.Fintype.Basic
import Litlib.Y2017.bengtsson2017geometry.Paper

namespace Litlib.Y2017.bengtsson2017geometry

open Finset

Litlib.equation "bengtsson2017geometry"
  eq "4.62"
  page "111"
  kind "definition"
class Eq4_62 (N : ℕ)
    (rho : (Fin N → ℂ) → Matrix (Fin N) (Fin N) ℂ) where
  -- No-BS constraint: Z must be non-zero to ensure the trace/denominator is non-zero
  rho_def : ∀ (Z : Fin N → ℂ) (α β : Fin N),
    Z ≠ 0 →
    rho Z α β = (Z α * star (Z β)) / (∑ i, Z i * star (Z i))

end Litlib.Y2017.bengtsson2017geometry
