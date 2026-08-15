-- FILENAME: Litlib/Y2003/nakahara2003geometry/Chapter11/Sec04_PontrjaginAndEulerClasses.lean

import Litlib.Core
import Mathlib.Analysis.SpecialFunctions.Trigonometric.Basic

namespace Litlib.Y2003.nakahara2003geometry

Litlib.equation "nakahara2003geometry" eq "11.75" kind "equation"
/--
Explicit expansions of the Pontrjagin classes in terms of the traces of the powers of the
curvature 2-form. The fractional coefficients and integer powers of (1/2π) are explicitly
hardcoded into the signature via scalar multiplication onto the commutative R-algebra of
differential forms.
-/
class Eq11_75
    (Form : Type*) [CommRing Form] [Algebra ℝ Form]
    (F_tr : ℕ → Form)
    (F_det : Form)
    (p : ℕ → Form)
    (k : ℕ) where
  p1_eq : p 1 = (- (1 / 2 : ℝ) * (1 / (2 * Real.pi)) ^ 2) • F_tr 2

  p2_eq : p 2 = ((1 / 8 : ℝ) * (1 / (2 * Real.pi)) ^ 4) • ((F_tr 2) ^ 2 - 2 * F_tr 4)

  p3_eq : p 3 = ((1 / 48 : ℝ) * (1 / (2 * Real.pi)) ^ 6) •
    (-(F_tr 2) ^ 3 + 6 * (F_tr 2) * (F_tr 4) - 8 * F_tr 6)

  p4_eq : p 4 = ((1 / 384 : ℝ) * (1 / (2 * Real.pi)) ^ 8) •
    ((F_tr 2) ^ 4 - 12 * (F_tr 2) ^ 2 * (F_tr 4) + 32 * (F_tr 2) * (F_tr 6) +
      12 * (F_tr 4) ^ 2 - 48 * F_tr 8)

  pk_eq : p (k / 2) = ((1 / (2 * Real.pi)) ^ k) • F_det

end Litlib.Y2003.nakahara2003geometry
