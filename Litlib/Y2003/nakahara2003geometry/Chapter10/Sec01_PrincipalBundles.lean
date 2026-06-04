-- FILENAME: Litlib/Y2003/nakahara2003geometry/Chapter10/Sec01_PrincipalBundles.lean

import Litlib.Core
import Mathlib.Topology.Basic
import Mathlib.Order.Basic
import Mathlib.Data.Real.Basic
import Mathlib.Analysis.Calculus.Deriv.Basic
import Mathlib.Algebra.Group.Basic

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
  eq "Theorem 10.1"
  page "4"
  kind "theorem"
/-- 
Local Connection Form Existence:
A connection one-form can be reconstructed from a local gauge potential over a specific chart.
-/
class LocalConnectionFormExistence
    (GaugePotential ConnectionForm LocalSection : Type _) 
    [TopologicalSpace GaugePotential] [TopologicalSpace LocalSection] [TopologicalSpace ConnectionForm]
    [Nonempty GaugePotential] [Nonempty LocalSection] [Nonempty ConnectionForm]
    (pullback : LocalSection → ConnectionForm → GaugePotential) where
  
  /-- Local Restriction Constraint: Reconstructing a connection one-form from a gauge potential is strictly a local operation over a specific chart. It does NOT guarantee the existence of a global connection unless transition cocycles are explicitly satisfied across all charts. -/
  local_connection_exists :
    ∀ (A_local : GaugePotential) (sigma_local : LocalSection),
      ∃ (omega_local : ConnectionForm), A_local = pullback sigma_local omega_local

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
  eq "Theorem 10.2"
  page "8"
  kind "theorem"
/-- 
Existence and Uniqueness of Horizontal Lifts
-/
class HorizontalLiftExistence 
    (PointM PointP : Type _) 
    [TopologicalSpace PointM] [TopologicalSpace PointP] [Nonempty PointM] [Nonempty PointP]
    (project : PointP → PointM)
    (isHorizontal : (ℝ → PointP) → Prop) where
  horizontal_lift : ∀ (c : ℝ → PointM) (u0 : PointP),
    Continuous c → 
    project u0 = c 0 → 
    ∃! (lift : ℝ → PointP), 
      Continuous lift ∧
      isHorizontal lift ∧ 
      (∀ t : ℝ, project (lift t) = c t) ∧ 
      lift 0 = u0

Litlib.equation "nakahara2003geometry"
  eq "10.14"
  page "8"
  kind "equation"
/-- 
Path-Ordered Exponential Solution for Horizontal Lift
-/
class PathOrderedExponentialSolution
    (Time LieAlgebra GroupElement : Type _)
    [AddCommGroup LieAlgebra] [Nonempty LieAlgebra] [Zero Time]
    (integral : (Time → LieAlgebra) → Time → Time → LieAlgebra)
    (pathOrderExp : LieAlgebra → GroupElement)
    (gaugePotential : Time → LieAlgebra)
    (g : Time → GroupElement) where
    
  /-- Sign Convention Lock: The integration of the connection along the curve inherently requires a minus sign in the path-ordered exponential to correctly define the parallel transport group element. -/
  solution_eq : ∀ t, g t = pathOrderExp (- integral gaugePotential 0 t)

end Litlib.Y2003.nakahara2003geometry
