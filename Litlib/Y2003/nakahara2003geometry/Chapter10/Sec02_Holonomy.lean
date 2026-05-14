-- FILENAME: Litlib/Y2003/nakahara2003geometry/Chapter10/Sec02_Holonomy.lean

import Litlib.Core
import Mathlib.Topology.Basic

namespace Litlib.Y2003.nakahara2003geometry

Litlib.equation "nakahara2003geometry"
  eq "10.22"
  page "11"
  kind "equation"
class HolonomyGroup
    (Point GroupElement Loop : Type _)
    [TopologicalSpace Point] [TopologicalSpace GroupElement]
    [Nonempty Point] [Nonempty GroupElement] [Nonempty Loop]
    (tau : Loop → Point → Point)
    (rightAction : Point → GroupElement → Point)
    (basePoint : Point)
    (isContinuousLoop : Loop → Prop)
    (isLoopAtBase : Loop → Prop)
    (belongsToHolonomy : GroupElement → Prop) where
  -- Anti-BS constraint: Ensures the holonomy group is not vacuously empty
  h_nontrivial : ∃ g : GroupElement, belongsToHolonomy g
  holonomy_def : ∀ g : GroupElement, 
    belongsToHolonomy g ↔ ∃ gamma : Loop, isContinuousLoop gamma ∧ isLoopAtBase gamma ∧ tau gamma basePoint = rightAction basePoint g

Litlib.equation "nakahara2003geometry"
  eq "10.26"
  page "12"
  kind "equation"
class WilsonLoopHolonomy
    (Loop GaugePotential GroupElement : Type _)
    [TopologicalSpace GaugePotential]
    [Nonempty Loop] [Nonempty GaugePotential] [Nonempty GroupElement]
    (isContinuousGauge : GaugePotential → Prop)
    (parallelTransport : Loop → GaugePotential → GroupElement)
    (pathOrderedExpIntegral : Loop → GaugePotential → GroupElement) where
  -- Anti-BS constraint: The path-ordered integral must distinguish between different connections/paths
  h_nontrivial : ∃ gamma A1 A2, isContinuousGauge A1 ∧ pathOrderedExpIntegral gamma A1 ≠ pathOrderedExpIntegral gamma A2
  wilson_loop : ∀ gamma A, isContinuousGauge A → parallelTransport gamma A = pathOrderedExpIntegral gamma A

end Litlib.Y2003.nakahara2003geometry
