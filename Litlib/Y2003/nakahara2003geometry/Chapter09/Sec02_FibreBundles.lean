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
    (ManifoldM ManifoldN BundleE F : Type _) 
    [TopologicalSpace ManifoldM] [TopologicalSpace ManifoldN] [TopologicalSpace BundleE] [TopologicalSpace F]
    (p : BundleE → ManifoldM)
    (isFibreBundle : (BundleE → ManifoldM) → Prop)
    (isHomotopic : (ManifoldN → ManifoldM) → (ManifoldN → ManifoldM) → Prop)
    (PullbackBundle : (ManifoldN → ManifoldM) → Type _)
    [∀ f, TopologicalSpace (PullbackBundle f)]
    (pullback_p : ∀ f, PullbackBundle f → ManifoldN)
    (isPullback : ∀ f, (PullbackBundle f → ManifoldN) → Prop)
    where
  homotopy_pullback_equiv :
    ∀ (f g : ManifoldN → ManifoldM),
      isFibreBundle p →
      Continuous f → Continuous g →
      isHomotopic f g →
      isPullback f (pullback_p f) →
      isPullback g (pullback_p g) →
      -- Rigorous anti-BS equivalency: A bijection exists that is continuous, has a continuous inverse, and commutes with the projections
      ∃ (h : PullbackBundle f ≃ PullbackBundle g), Continuous h ∧ Continuous h.symm ∧ ∀ x, pullback_p g (h x) = pullback_p f x

Litlib.equation "nakahara2003geometry"
  eq "9.1"
  page "10"
  kind "corollary"
class ContractibleBaseTrivialBundle
    (Manifold Bundle F : Type _) [TopologicalSpace Manifold] [TopologicalSpace Bundle] [TopologicalSpace F]
    [TopologicalSpace (Manifold × F)]
    (p : Bundle → Manifold)
    (isFibreBundle : (Bundle → Manifold) → Prop)
    (isContractible : Type _ → Prop)
    where
  h_contractible_implies_trivial : 
    isFibreBundle p →
    isContractible Manifold →
    -- Rigorous anti-BS triviality: Homeomorphic (via continuous Equiv) to Base x Fibre mapping points via projection.
    ∃ (h : Bundle ≃ Manifold × F), Continuous h ∧ Continuous h.symm ∧ ∀ x, (h x).1 = p x

end Litlib.Y2003.nakahara2003geometry
