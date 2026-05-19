-- FILENAME: Litlib/Y2003/nakahara2003geometry/Chapter09/Sec02_FibreBundles.lean

import Litlib.Core
import Litlib.Y2003.nakahara2003geometry.Paper
import Mathlib.Topology.Basic
import Mathlib.Algebra.Group.Defs

namespace Litlib.Y2003.nakahara2003geometry

Litlib.equation "nakahara2003geometry"
  eq "9.6"
  page "4"
  kind "equation"
class TransitionFunctionConsistency
    (Base GroupType Index : Type _) [TopologicalSpace Base] [Group GroupType] [Nonempty Index] [Nonempty Base]
    (t : Index → Index → Base → GroupType) where
  cocycle_i : ∀ i p, t i i p = 1
  cocycle_ii : ∀ i j p, t i j p = (t j i p)⁻¹
  cocycle_iii : ∀ i j k p, t i j p * t j k p = t i k p

Litlib.equation "nakahara2003geometry"
  eq "9.18"
  page "9"
  kind "equation"
class PullbackTransitionFunction
    (ManifoldM ManifoldN GroupType Index : Type _) 
    [TopologicalSpace ManifoldM] [TopologicalSpace ManifoldN] [Group GroupType] [Nonempty Index]
    (t : Index → Index → ManifoldM → GroupType)
    (t_star : Index → Index → ManifoldN → GroupType)
    (f : ManifoldN → ManifoldM) where
  pullback_transition : ∀ i j p, t_star i j p = t i j (f p)

Litlib.equation "nakahara2003geometry"
  eq "9.1"
  page "10"
  kind "theorem"
class HomotopyPullbackEquivalence
    (ManifoldM ManifoldN BundleE : Type _) 
    [TopologicalSpace ManifoldM] [TopologicalSpace ManifoldN] [TopologicalSpace BundleE]
    (isFibreBundle : Type _ → Type _ → Prop)
    (isHomotopic : (ManifoldN → ManifoldM) → (ManifoldN → ManifoldM) → Prop)
    (PullbackBundle : (ManifoldN → ManifoldM) → Type _)
    (areEquivalentBundles : Type _ → Type _ → Prop) where
  homotopy_pullback_equiv :
    ∀ (f g : ManifoldN → ManifoldM),
      isFibreBundle BundleE ManifoldM →
      Continuous f → Continuous g →
      isHomotopic f g →
      areEquivalentBundles (PullbackBundle f) (PullbackBundle g)

Litlib.equation "nakahara2003geometry"
  eq "9.1"
  page "10"
  kind "corollary"
class ContractibleBaseTrivialBundle
    (Manifold Bundle : Type _) [TopologicalSpace Manifold] [TopologicalSpace Bundle]
    (isFibreBundle : Type _ → Type _ → Prop)
    (isContractible : Type _ → Prop)
    (isTrivialBundle : Type _ → Prop) where
  h_contractible_implies_trivial : 
    isFibreBundle Bundle Manifold →
    isContractible Manifold →
    isTrivialBundle Bundle

end Litlib.Y2003.nakahara2003geometry
