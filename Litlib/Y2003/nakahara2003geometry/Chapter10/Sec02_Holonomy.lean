-- FILENAME: Litlib/Y2003/nakahara2003geometry/Chapter10/Sec02_Holonomy.lean

import Litlib.Core
import Mathlib.Topology.Basic
import Mathlib.Algebra.Group.Basic

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
  
  /-- Holonomy Non-Triviality Constraint: Ensures the holonomy group is well-defined and not vacuously empty by asserting the existence of at least one group element. -/
  h_nontrivial : ∃ g : GroupElement, belongsToHolonomy g
  
  holonomy_def : ∀ g : GroupElement, 
    belongsToHolonomy g ↔ ∃ gamma : Loop, isContinuousLoop gamma ∧ isLoopAtBase gamma ∧ tau gamma basePoint = rightAction basePoint g

Litlib.equation "nakahara2003geometry"
  eq "10.26"
  page "12"
  kind "equation"
class WilsonLoopHolonomy
    (Loop GaugePotential LieAlgebra GroupElement : Type _)
    [TopologicalSpace GaugePotential] [AddCommGroup LieAlgebra]
    [Nonempty Loop] [Nonempty GaugePotential] [Nonempty GroupElement]
    (isContinuousGauge : GaugePotential → Prop)
    (parallelTransport : Loop → GaugePotential → GroupElement)
    (integral : Loop → GaugePotential → LieAlgebra)
    (pathOrderExp : LieAlgebra → GroupElement) where
  
  /-- Wilson Loop Non-Degeneracy Constraint: The path-ordered integral must be capable of distinguishing between different connections over a loop, ensuring the holonomy mapping is non-trivial. -/
  h_nontrivial : ∃ gamma A1 A2, isContinuousGauge A1 ∧ isContinuousGauge A2 ∧ pathOrderExp (- integral gamma A1) ≠ pathOrderExp (- integral gamma A2)
  
  /-- Sign Convention Lock: The Wilson loop holonomy must explicitly include the minus sign in the path-ordered exponential. -/
  wilson_loop : ∀ gamma A, isContinuousGauge A → 
    parallelTransport gamma A = pathOrderExp (- integral gamma A)

end Litlib.Y2003.nakahara2003geometry
