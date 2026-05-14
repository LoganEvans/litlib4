-- FILENAME: Litlib/Y2003/nakahara2003geometry/Chapter07/Sec8_NonCoordinateBases.lean

import Litlib.Core
import Mathlib.Algebra.Group.Basic

namespace Litlib.Y2003.nakahara2003geometry

Litlib.equation "nakahara2003geometry"
  eq "7.146b"
  page "42"
  kind "equation"
class CartanStructureEquation 
    (Form : Type _) [AddCommGroup Form] [Nonempty Form]
    (exteriorDeriv : Form → Form)
    (wedge : Form → Form → Form)
    (curvature : Form → Form) where
  -- Anti-BS constraint: Prevent trivial zeros
  h_nontrivial_curvature : ∃ (omega : Form), curvature omega ≠ 0
  cartanStructureEq
    (omega : Form) :
    curvature omega = exteriorDeriv omega + wedge omega omega

Litlib.equation "nakahara2003geometry"
  eq "7.147b"
  page "42"
  kind "equation"
class BianchiIdentity 
    (Form : Type _) [Zero Form] [Nonempty Form]
    (covariantDeriv : Form → Form → Form)
    (curvature : Form → Form) where
  h_nontrivial_curvature : ∃ (omega : Form), curvature omega ≠ 0
  bianchiIdentity
    (omega : Form) :
    covariantDeriv omega (curvature omega) = 0

end Litlib.Y2003.nakahara2003geometry
