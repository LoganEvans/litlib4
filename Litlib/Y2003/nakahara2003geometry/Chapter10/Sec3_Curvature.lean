-- FILENAME: Litlib/Y2003/nakahara2003geometry/Chapter10/Sec3_Curvature.lean

import Litlib.Core
import Mathlib.Topology.Basic
import Mathlib.Algebra.Group.Defs

namespace Litlib.Y2003.nakahara2003geometry

Litlib.equation "nakahara2003geometry"
  eq "10.28"
  page "13"
  kind "equation"
class CovariantDerivativePrincipal
    (Vector Form : Type _) [TopologicalSpace Vector] [TopologicalSpace Form] [Nonempty Vector] [Nonempty Form]
    (horizontalProj : Vector → Vector)
    (evalForm : Form → (Vector → Vector) → Form) 
    (extDeriv : Form → Form)
    (covDeriv : Form → Form) where
  -- Anti-BS constraint: Ensures the horizontal projection actually does something
  h_nontrivial_proj : ∃ v : Vector, Continuous horizontalProj ∧ horizontalProj v ≠ v
  cov_deriv_def : ∀ phi : Form, covDeriv phi = evalForm (extDeriv phi) horizontalProj

Litlib.equation "nakahara2003geometry"
  eq "10.32b"
  page "14"
  kind "theorem"
class CartanStructureEquationPrincipal
    (Form : Type _) [TopologicalSpace Form] [AddCommGroup Form] [Nonempty Form]
    (extDeriv : Form → Form)
    (wedge : Form → Form → Form)
    (curvature : Form → Form) where
  -- Anti-BS Constraint
  h_nontrivial : ∃ omega, Continuous extDeriv ∧ curvature omega ≠ 0
  cartan_eq : ∀ omega, Continuous extDeriv → curvature omega = extDeriv omega + wedge omega omega

Litlib.equation "nakahara2003geometry"
  eq "10.36"
  page "15"
  kind "theorem"
class AmbroseSingerTheorem
    (Point Vector LieAlgebra : Type _) 
    [TopologicalSpace Point]
    [Nonempty LieAlgebra] [Nonempty Point] [Nonempty Vector] [Zero LieAlgebra]
    (HolonomyAlgebra : Point → LieAlgebra → Prop)
    (Curvature : Point → Vector → Vector → LieAlgebra)
    (isHorizontal : Point → Vector → Prop)
    (onSameHorizontalLift : Point → Point → Prop)
    (subalgebraSpannedBy : (LieAlgebra → Prop) → (LieAlgebra → Prop)) where
  -- Anti-BS constraint
  h_nontrivial_curvature : ∃ u X Y, isHorizontal u X ∧ isHorizontal u Y ∧ Curvature u X Y ≠ 0
  ambrose_singer :
    ∀ u_0 g,
      HolonomyAlgebra u_0 g ↔
      subalgebraSpannedBy (fun elem => ∃ u X Y, onSameHorizontalLift u_0 u ∧ isHorizontal u X ∧ isHorizontal u Y ∧ elem = Curvature u X Y) g

Litlib.equation "nakahara2003geometry"
  eq "10.38a"
  page "16"
  kind "equation"
class LocalFieldStrength
    (Form : Type _) [TopologicalSpace Form] [AddCommGroup Form] [Nonempty Form]
    (extDeriv : Form → Form)
    (wedge : Form → Form → Form)
    (fieldStrength : Form → Form) where
  h_nontrivial : ∃ A, fieldStrength A ≠ 0
  local_field_strength : ∀ A, Continuous extDeriv → fieldStrength A = extDeriv A + wedge A A

Litlib.equation "nakahara2003geometry"
  eq "10.45"
  page "17"
  kind "equation"
class PrincipalBianchiIdentity 
    (Form : Type _) [TopologicalSpace Form] [Zero Form] [Nonempty Form]
    (covExtDeriv : Form → Form)
    (Curvature : Form) where
  h_nontrivial : Curvature ≠ 0
  bianchi : Continuous covExtDeriv → covExtDeriv Curvature = 0

end Litlib.Y2003.nakahara2003geometry
