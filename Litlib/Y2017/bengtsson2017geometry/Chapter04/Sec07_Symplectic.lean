-- FILENAME: Litlib/Y2017/bengtsson2017geometry/Chapter04/Sec07_Symplectic.lean

import Litlib.Core
import Mathlib.Data.Real.Basic
import Mathlib.Analysis.SpecialFunctions.Trigonometric.Basic
import Mathlib.Data.Nat.Factorial.Basic
import Litlib.Y2017.bengtsson2017geometry.Paper

namespace Litlib.Y2017.bengtsson2017geometry

Litlib.equation "bengtsson2017geometry"
  eq "4.88"
  page "119"
  kind "theorem"
class Eq4_88
    (volCP : ℕ → ℝ) where
  volCP_def : ∀ n, volCP n = (Real.pi ^ n) / (Nat.factorial n : ℝ)

end Litlib.Y2017.bengtsson2017geometry
