-- FILENAME: Litlib/Y2003/nakahara2003geometry/Chapter06/Sec8_Stokes.lean

import Litlib.Core
import Mathlib.Data.Real.Basic

namespace Litlib.Y2003.nakahara2003geometry

Litlib.equation "nakahara2003geometry"
  eq "6.8"
  page "3"
  kind "theorem"
class StokesTheorem 
    (Chain Form : Type _) [Nonempty Chain] [Nonempty Form]
    (integral : Chain → Form → ℝ)
    (exteriorDeriv : Form → Form)
    (boundary : Chain → Chain) where
  h_nontrivial : ∃ (c : Chain) (omega : Form), integral c omega ≠ 0
  stokesTheorem :
    ∀ (c : Chain) (omega : Form), 
      integral c (exteriorDeriv omega) = integral (boundary c) omega

end Litlib.Y2003.nakahara2003geometry
