-- FILENAME: Litlib/Y2003/nakahara2003geometry/Chapter10/Sec1_PrincipalBundles.lean

import Litlib.Core
import Mathlib.Topology.Basic
import Mathlib.Order.Basic
import Mathlib.Data.Real.Basic
import Mathlib.Analysis.Calculus.Deriv.Basic

namespace Litlib.Y2003.nakahara2003geometry

Litlib.equation "nakahara2003geometry"
  eq "10.3a-b"
  page "3"
  kind "definition"
class ConnectionOneForm 
    (TangentVector LieAlgebra GroupElement : Type _) 
    [TopologicalSpace TangentVector] [TopologicalSpace LieAlgebra] [Zero LieAlgebra] [Nonempty TangentVector] [Nonempty GroupElement]
    (omega : TangentVector → LieAlgebra)
    (fundVectorField : LieAlgebra → TangentVector)
    (inv : GroupElement → GroupElement)
    (adjointAction : GroupElement → LieAlgebra → LieAlgebra)
    (rightPullback : GroupElement → (TangentVector → LieAlgebra) → (TangentVector → LieAlgebra)) where
  -- Anti-BS constraint: The Lie algebra must not be the trivial {0} space
  h_nontrivial_algebra : ∃ A : LieAlgebra, A ≠ 0
  
  -- (10.3a) Projection property onto fundamental vector fields
  axiom_i : ∀ A : LieAlgebra, Continuous omega → omega (fundVectorField A) = A
  
  -- (10.3b) Right equivariance
  axiom_ii : ∀ (g : GroupElement) (v : TangentVector), 
    Continuous omega → rightPullback g omega v = adjointAction (inv g) (omega v)

Litlib.equation "nakahara2003geometry"
  eq "10.7"
  page "4"
  kind "theorem"
class ConnectionFormExistence
    (GaugePotential ConnectionForm LocalSection : Type _) 
    [TopologicalSpace GaugePotential] [TopologicalSpace LocalSection] [TopologicalSpace ConnectionForm]
    [Nonempty GaugePotential] [Nonempty LocalSection] [Nonempty ConnectionForm]
    (pullback : LocalSection → ConnectionForm → GaugePotential) where
  -- Anti-BS constraint: Ensure the pullback mapping is not trivially constant/degenerate.
  h_nontrivial : ∃ (omega1 omega2 : ConnectionForm) (sigma : LocalSection), 
    Continuous (pullback sigma) ∧ pullback sigma omega1 ≠ pullback sigma omega2 
  connection_exists :
    ∀ (A : GaugePotential) (sigma : LocalSection),
      Continuous (pullback sigma) →
      ∃ (omega : ConnectionForm), A = pullback sigma omega

Litlib.equation "nakahara2003geometry"
  eq "10.9"
  page "7"
  kind "equation"
class GaugeTransformationCompatibility 
    (Point GaugePotential GroupElement : Type _) 
    [TopologicalSpace Point] [TopologicalSpace GroupElement] [Nonempty Point] [AddCommGroup GaugePotential] [Nonempty GroupElement]
    (identityElem : GroupElement)
    (A_i A_j : Point → GaugePotential)
    (t_ij : Point → GroupElement)
    (inv : GroupElement → GroupElement)
    (adjoint : GroupElement → GaugePotential → GaugePotential)
    (cartanMaurer : (Point → GroupElement) → Point → GaugePotential) where
  -- Anti-BS constraint: The bundle must have non-trivial transition 
  -- functions on the overlap, otherwise it's just a trivial bundle.
  h_nontrivial_transition : ∃ p : Point, t_ij p ≠ identityElem
  
  -- Compatibility condition
  compatibility : ∀ p : Point, 
    Continuous t_ij →
    A_j p = adjoint (inv (t_ij p)) (A_i p) + cartanMaurer t_ij p

Litlib.equation "nakahara2003geometry"
  eq "10.14-footnote1"
  page "9"
  kind "definition"
class PathOrderingOperator 
    (Time Operator : Type _) 
    [LinearOrder Time] [Nonempty Operator]
    (paramOp : Time → Operator)
    (multiply : Operator → Operator → Operator)
    (pathOrder : Time → Time → Operator) where
  -- Anti-BS constraint: The operators must not inherently commute. 
  -- If they do, the path-ordering operator is a meaningless abstraction.
  h_non_commutative : ∃ t s : Time, 
    multiply (paramOp t) (paramOp s) ≠ multiply (paramOp s) (paramOp t)
  
  -- Path ordering definition
  path_ordering_def : ∀ t s : Time,
    pathOrder t s = if t > s then 
      multiply (paramOp t) (paramOp s) 
    else 
      multiply (paramOp s) (paramOp t)

Litlib.equation "nakahara2003geometry"
  eq "10.14"
  page "8"
  kind "theorem"
class HorizontalLiftExistence 
    (PointM PointP : Type _) 
    [TopologicalSpace PointM] [TopologicalSpace PointP] [Nonempty PointM] [Nonempty PointP]
    (project : PointP → PointM)
    (isHorizontal : (ℝ → PointP) → Prop) where
  -- Anti-BS constraint: We must be able to form a continuous curve that actually moves,
  -- otherwise the horizontal lift is trivially just a static point.
  h_nontrivial_curve : ∃ (c : ℝ → PointM) (t : ℝ), Continuous c ∧ c t ≠ c 0
  
  -- Theorem 10.2: Existence and uniqueness of horizontal lift
  horizontal_lift : ∀ (c : ℝ → PointM) (u0 : PointP),
    Continuous c → Continuous project →
    project u0 = c 0 → 
    ∃! (lift : ℝ → PointP), 
      Continuous lift ∧
      isHorizontal lift ∧ 
      (∀ t : ℝ, project (lift t) = c t) ∧ 
      lift 0 = u0

end Litlib.Y2003.nakahara2003geometry
