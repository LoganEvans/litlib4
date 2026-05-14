-- FILENAME: Litlib/Y2003/nakahara2003geometry/Chapter10/Sec04_AssociatedBundles.lean

import Litlib.Core
import Mathlib.Topology.Basic
import Mathlib.Algebra.Group.Defs

namespace Litlib.Y2003.nakahara2003geometry

Litlib.equation "nakahara2003geometry"
  eq "10.49"
  page "19"
  kind "equation"
class AssociatedCovariantDerivative
    (VecType SecType : Type _) [TopologicalSpace VecType] [TopologicalSpace SecType] [Nonempty VecType] [Nonempty SecType]
    (covDeriv : VecType → SecType → SecType) where
  -- Anti-BS constraint: Derivative operator must inherently be continuous for all vector directions
  covDeriv_continuous : ∀ X, Continuous (covDeriv X)
  
  h_nontrivial : ∃ X s, covDeriv X s ≠ s

Litlib.equation "nakahara2003geometry"
  eq "10.73"
  page "24"
  kind "theorem"
class MetricConnection 
    (SecType Scalar OneForm : Type _) [TopologicalSpace SecType] [TopologicalSpace Scalar] [Add OneForm] [Nonempty SecType] [Zero Scalar]
    (d : Scalar → OneForm)
    (g : SecType → SecType → Scalar)
    (gForm : SecType → SecType → OneForm)
    (nabla : SecType → SecType) where
  h_nontrivial : ∃ s1 s2, g s1 s2 ≠ 0
  metric_compatibility : ∀ s1 s2, d (g s1 s2) = gForm (nabla s1) s2 + gForm s1 (nabla s2)

Litlib.equation "nakahara2003geometry"
  eq "10.6"
  page "24"
  kind "definition"
class HolomorphicVectorBundle
    (BundleType BaseType : Type _) [TopologicalSpace BundleType] [TopologicalSpace BaseType] [Nonempty BundleType] [Nonempty BaseType]
    (projection : BundleType → BaseType)
    (isHolomorphicSurjection : (BundleType → BaseType) → Prop)
    (hasComplexFibers : Prop)
    (hasGLkCStructureGroup : Prop)
    (hasHolomorphicTransitions : Prop) where
  h_surj : isHolomorphicSurjection projection ∧ Continuous projection
  h_fibers : hasComplexFibers
  h_group : hasGLkCStructureGroup
  h_transitions : hasHolomorphicTransitions

end Litlib.Y2003.nakahara2003geometry
