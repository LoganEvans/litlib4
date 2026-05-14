-- FILENAME: Litlib/Y2003/nakahara2003geometry/Chapter07/Sec10_GeneralRelativity.lean

import Litlib.Core
import Mathlib.Data.Real.Basic
import Mathlib.Data.Fintype.Basic
import Mathlib.Analysis.SpecialFunctions.Trigonometric.Basic

namespace Litlib.Y2003.nakahara2003geometry

Litlib.equation "nakahara2003geometry"
  eq "7.214"
  page "57"
  kind "equation"
class EinsteinEquation
    (Point Index : Type _) [Fintype Index] [Nonempty Index] [Nonempty Point]
    (G T : Index → Index → Point → ℝ) 
    (newtonG : ℝ) where
  -- Anti-BS constraint
  h_nontrivial_matter : ∃ mu nu x, T mu nu x ≠ 0
  h_positive_G : newtonG > 0
  
  einsteinEq :
    ∀ (mu nu : Index) (x : Point),
      G mu nu x = 8 * Real.pi * newtonG * T mu nu x

end Litlib.Y2003.nakahara2003geometry
