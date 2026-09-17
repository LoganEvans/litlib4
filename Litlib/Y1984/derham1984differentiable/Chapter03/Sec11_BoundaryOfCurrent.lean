-- FILENAME: Litlib/Y1984/derham1984differentiable/Chapter03/Sec11_BoundaryOfCurrent.lean

import Mathlib.Analysis.InnerProductSpace.PiL2
import Litlib.Core
import Litlib.Y1984.derham1984differentiable.Paper

namespace Litlib.Y1984.derham1984differentiable.Chapter03

/-!
# Chapter III: Currents
## § 11. Boundary of a Current. Image of a Current by a Map

By duality with the exterior derivative `d` on forms, the boundary `bT` of a current `T` is
defined by `bT[phi] = T[d phi]`. Stokes' theorem identifies the geometric boundary of chains
with this operator.
-/

Litlib.equation "derham1984differentiable" eq "11.1" page "45" kind "definition"
class BoundaryDuality
    (TestFormP : Type*) [AddCommGroup TestFormP] [Module ℝ TestFormP]
    (TestFormPrev : Type*) [AddCommGroup TestFormPrev] [Module ℝ TestFormPrev]
    (CurrentP : Type*) [AddCommGroup CurrentP] [Module ℝ CurrentP]
    (CurrentPrev : Type*) [AddCommGroup CurrentPrev] [Module ℝ CurrentPrev]
    (pairingP : CurrentP → TestFormP → ℝ)
    (pairingPrev : CurrentPrev → TestFormPrev → ℝ)
    (d : TestFormPrev → TestFormP)
    (b : CurrentP → CurrentPrev) where
  b_linear (c1 c2 : ℝ) (T1 T2 : CurrentP) :
    b (c1 • T1 + c2 • T2) = c1 • b T1 + c2 • b T2
  d_linear (c1 c2 : ℝ) (phi1 phi2 : TestFormPrev) :
    d (c1 • phi1 + c2 • phi2) = c1 • d phi1 + c2 • d phi2
  boundary_pairing_dual (T : CurrentP) (phi : TestFormPrev) :
    pairingPrev (b T) phi = pairingP T (d phi)

Litlib.equation "derham1984differentiable" eq "11.differential" page "45" kind "definition"
class DifferentialOfCurrent (n p : ℕ) (hp : p ≤ n)
    (CurrentP : Type*) [AddCommGroup CurrentP] [Module ℝ CurrentP]
    (CurrentPrev : Type*) [AddCommGroup CurrentPrev] [Module ℝ CurrentPrev]
    (b : CurrentP → CurrentPrev)
    (w : CurrentPrev → CurrentPrev)
    (dCurr : CurrentP → CurrentPrev) where
  w_homogeneous (S : CurrentPrev) :
    w S = (-1 : ℝ) ^ (n - (p - 1)) • S
  dCurr_eq_w_b (T : CurrentP) :
    dCurr T = w (b T)

Litlib.equation "derham1984differentiable" eq "11.nilpotency" page "46" kind "theorem"
class BoundaryNilpotency
    (TestFormP : Type*) [AddCommGroup TestFormP] [Module ℝ TestFormP]
    (TestFormNext : Type*) [AddCommGroup TestFormNext] [Module ℝ TestFormNext]
    (TestFormNext2 : Type*) [AddCommGroup TestFormNext2] [Module ℝ TestFormNext2]
    (CurrentP : Type*) [AddCommGroup CurrentP] [Module ℝ CurrentP]
    (CurrentPrev : Type*) [AddCommGroup CurrentPrev] [Module ℝ CurrentPrev]
    (CurrentPrev2 : Type*) [AddCommGroup CurrentPrev2] [Module ℝ CurrentPrev2]
    (d1 : TestFormP → TestFormNext)
    (d2 : TestFormNext → TestFormNext2)
    (b1 : CurrentP → CurrentPrev)
    (b2 : CurrentPrev → CurrentPrev2) where
  exterior_derivative_sq_zero (phi : TestFormP) :
    d2 (d1 phi) = 0
  boundary_sq_zero (T : CurrentP) :
    b2 (b1 T) = 0

Litlib.equation "derham1984differentiable" eq "11.stokes_duality" page "45" kind "theorem"
class StokesDualityChains
    (ChainP : Type*) [AddCommGroup ChainP] [Module ℝ ChainP]
    (ChainPrev : Type*) [AddCommGroup ChainPrev] [Module ℝ ChainPrev]
    (TestFormP : Type*) [AddCommGroup TestFormP] [Module ℝ TestFormP]
    (TestFormPrev : Type*) [AddCommGroup TestFormPrev] [Module ℝ TestFormPrev]
    (CurrentP : Type*) [AddCommGroup CurrentP] [Module ℝ CurrentP]
    (CurrentPrev : Type*) [AddCommGroup CurrentPrev] [Module ℝ CurrentPrev]
    (toCurrentP : ChainP → CurrentP)
    (toCurrentPrev : ChainPrev → CurrentPrev)
    (chainBoundary : ChainP → ChainPrev)
    (currentBoundary : CurrentP → CurrentPrev)
    (d : TestFormPrev → TestFormP)
    (integrateP : ChainP → TestFormP → ℝ)
    (integratePrev : ChainPrev → TestFormPrev → ℝ)
    (pairingP : CurrentP → TestFormP → ℝ)
    (pairingPrev : CurrentPrev → TestFormPrev → ℝ) where
  toCurrent_linear_prev (c1 c2 : ℝ) (s1 s2 : ChainPrev) :
    toCurrentPrev (c1 • s1 + c2 • s2) = c1 • toCurrentPrev s1 + c2 • toCurrentPrev s2
  pairing_linear_left_prev (T1 T2 : CurrentPrev) (c1 c2 : ℝ) (phi : TestFormPrev) :
    pairingPrev (c1 • T1 + c2 • T2) phi = c1 * pairingPrev T1 phi + c2 * pairingPrev T2 phi
  current_boundary_comm (c : ChainP) :
    currentBoundary (toCurrentP c) = toCurrentPrev (chainBoundary c)
  stokes_identity (c : ChainP) (phi : TestFormPrev) :
    integratePrev (chainBoundary c) phi = integrateP c (d phi)
  chain_pairing_duality (c : ChainP) (phi : TestFormPrev) :
    pairingPrev (toCurrentPrev (chainBoundary c)) phi = pairingP (toCurrentP c) (d phi)

end Litlib.Y1984.derham1984differentiable.Chapter03
