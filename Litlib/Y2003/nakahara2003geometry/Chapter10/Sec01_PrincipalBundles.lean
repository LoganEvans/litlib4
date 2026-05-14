-- FILENAME: Litlib/Y2003/nakahara2003geometry/Chapter10/Sec01_PrincipalBundles.lean

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
  -- (10.3a) Projection property onto fundamental vector fields
  axiom_i : ∀ A : LieAlgebra, omega (fundVectorField A) = A
  
  -- (10.3b) Right equivariance
  axiom_ii : ∀ (g : GroupElement) (v : TangentVector), 
    rightPullback g omega v = adjointAction (inv g) (omega v)

Litlib.equation "nakahara2003geometry"
  eq "10.7"
  page "4"
  kind "theorem"
class ConnectionFormExistence
    (GaugePotential ConnectionForm LocalSection : Type _) 
    [TopologicalSpace GaugePotential] [TopologicalSpace LocalSection] [TopologicalSpace ConnectionForm]
    [Nonempty GaugePotential] [Nonempty LocalSection] [Nonempty ConnectionForm]
    (pullback : LocalSection → ConnectionForm → GaugePotential) where
  connection_exists :
    ∀ (A : GaugePotential) (sigma : LocalSection),
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
  -- Compatibility condition
  compatibility : ∀ p : Point, 
    A_j p = adjoint (inv (t_ij p)) (A_i p) + cartanMaurer t_ij p

Litlib.equation "nakahara2003geometry"
  eq "10.14-footnote1"
  page "9"
  kind "definition"
class PathOrderingOperator 
    (Time Operator : Type _) 
    [LinearOrder Time] [Nonempty Operator]
    (multiply : Operator → Operator → Operator)
    (pathOrder : (Time → Operator) → Time → Time → Operator) where
  -- Path ordering definition
  path_ordering_def : ∀ (paramOp : Time → Operator) (t s : Time),
    pathOrder paramOp t s = if t > s then 
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
  -- Theorem 10.2: Existence and uniqueness of horizontal lift
  horizontal_lift : ∀ (c : ℝ → PointM) (u0 : PointP),
    Continuous c → 
    project u0 = c 0 → 
    ∃! (lift : ℝ → PointP), 
      Continuous lift ∧
      isHorizontal lift ∧ 
      (∀ t : ℝ, project (lift t) = c t) ∧ 
      lift 0 = u0

end Litlib.Y2003.nakahara2003geometry
