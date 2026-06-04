-- FILENAME: Litlib/Y2003/nakahara2003geometry/Chapter11/Sec01_Pontryagin.lean

import Litlib.Core
import Mathlib.Data.Real.Basic
import Mathlib.Topology.Basic

namespace Litlib.Y2003.nakahara2003geometry

Litlib.equation "nakahara2003geometry"
  eq "11.22"
  page "7"
  kind "equation"
/-- 
Topological Invariance of Characteristic Classes:
The integral of a characteristic class over a closed manifold is independent of the choice of connection. 
Specifically, if `F` and `F'` are the curvature two-forms associated with connections `A` and `A'`, 
the difference `P(F') - P(F)` for an invariant polynomial `P` of degree `m/2` (yielding an `m`-form) 
is exact. By Stokes' theorem, its integral over a compact, orientable manifold `M` without boundary vanishes.
We correct the text's typographical error which writes `P_m` instead of `P_{m/2}` and mislabels the transgression form in the boundary integral.
-/
class CharacteristicClassIntegralInvariance 
    (Manifold Form : Type _) 
    [TopologicalSpace Manifold] [AddCommGroup Form]
    (isCompact : Manifold → Prop)
    (isOrientable : Manifold → Prop)
    (hasNoBoundary : Manifold → Prop)
    (integral : Manifold → Form → ℝ)
    (exteriorDeriv : Form → Form)
    (invariantPoly : Form → Form)
    (transgression : Form → Form → Form) where

  /-- Geometric Non-Degeneracy Constraint: The manifold must be compact and orientable to admit a well-defined global integral, and must have no boundary for Stokes' theorem to yield zero. -/
  h_manifold_props : ∀ M : Manifold, isCompact M ∧ isOrientable M ∧ hasNoBoundary M

  /-- The difference between the invariant polynomial evaluated on two different curvatures is the exterior derivative of the transgression form. -/
  transgression_diff : ∀ F F' A A', invariantPoly F' - invariantPoly F = exteriorDeriv (transgression A' A)

  /-- The integral of an exact form over a compact, orientable manifold without boundary vanishes. -/
  integral_exact_zero : ∀ (M : Manifold) (omega : Form), integral M (exteriorDeriv omega) = 0

  /-- The integrals of an invariant polynomial evaluated on two different curvatures over a closed manifold are equal. -/
  integral_invariance : ∀ (M : Manifold) (F F' : Form),
    integral M (invariantPoly F') - integral M (invariantPoly F) = 0

end Litlib.Y2003.nakahara2003geometry
