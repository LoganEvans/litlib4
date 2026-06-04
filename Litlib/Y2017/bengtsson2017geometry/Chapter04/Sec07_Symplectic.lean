-- FILENAME: Litlib/Y2017/bengtsson2017geometry/Chapter04/Sec07_Symplectic.lean

import Litlib.Core
import Mathlib.Data.Real.Basic
import Mathlib.Analysis.SpecialFunctions.Trigonometric.Basic
import Mathlib.Data.Nat.Factorial.Basic
import Mathlib.MeasureTheory.Measure.MeasureSpace
import Litlib.Y2017.bengtsson2017geometry.Paper

namespace Litlib.Y2017.bengtsson2017geometry

Litlib.equation "bengtsson2017geometry"
  eq "4.88"
  page "119"
  kind "theorem"
/--
Physical Interpretation: Computes the total symplectic volume of the complex projective space, corresponding to the total number of mutually exclusive quantum states in a finite volume of phase space.
Mathematical Boundaries: Requires a properly normalized invariant measure over the space CP^n.
-/
class Eq4_88
    (CP : ℕ → Type)
    [∀ n, MeasureTheory.MeasureSpace (CP n)] where
  volCP_def : ∀ n, 
    MeasureTheory.volume (Set.univ : Set (CP n)) = 
    ENNReal.ofReal ((Real.pi ^ n) / (Nat.factorial n : ℝ))

end Litlib.Y2017.bengtsson2017geometry
