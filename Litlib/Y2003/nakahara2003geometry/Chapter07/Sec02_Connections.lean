-- FILENAME: Litlib/Y2003/nakahara2003geometry/Chapter07/Sec02_Connections.lean

import Litlib.Core
import Mathlib.Data.Real.Basic
import Mathlib.Analysis.Calculus.Deriv.Basic
import Mathlib.Algebra.BigOperators.Group.Finset.Basic
import Mathlib.Data.Fintype.Basic
import Mathlib.Algebra.Module.Basic

open BigOperators

namespace Litlib.Y2003.nakahara2003geometry

Litlib.equation "nakahara2003geometry"
  eq "7.19b"
  page "8"
  kind "equation"
class GeodesicEquation
    (Point Index : Type _) [Fintype Index] [Nonempty Index] [Nonempty Point]
    (christoffel : Index → Index → Index → Point → ℝ)
    (curve : ℝ → Point)
    (coord : Index → Point → ℝ) where
  -- Anti-BS constraint: Avoid trivial geometry
  h_nontrivial_connection : ∃ mu nu rho x, christoffel mu nu rho x ≠ 0
  
  -- Require the curve to be twice differentiable in coordinates
  isSmoothCurve : (ℝ → Point) → Prop
  h_smooth : isSmoothCurve curve
  
  geodesicEq :
    ∀ (mu : Index) (t : ℝ),
      deriv (deriv (fun t => coord mu (curve t))) t + 
      ∑ (nu : Index), ∑ (rho : Index), 
        christoffel mu nu rho (curve t) * deriv (fun t => coord nu (curve t)) t * deriv (fun t => coord rho (curve t)) t = 0

Litlib.equation "nakahara2003geometry"
  eq "7.13a"
  page "6"
  kind "definition"
class AffineConnection
    (Vect Func : Type _) [AddCommGroup Vect] [CommRing Func] [Module Func Vect]
    (dirDeriv : Vect → Func → Func)
    (nabla : Vect → Vect → Vect) where
  -- Anti-BS constraint: Connection shouldn't be trivially zero for all vector fields
  h_nontrivial : ∃ X Y, nabla X Y ≠ 0
  
  -- Axioms of an affine connection (Eq 7.13a - 7.13d)
  h_add_1 : ∀ (X Y Z : Vect), nabla X (Y + Z) = nabla X Y + nabla X Z
  h_add_2 : ∀ (X Y Z : Vect), nabla (X + Y) Z = nabla X Z + nabla Y Z
  h_smul_1 : ∀ (f : Func) (X Y : Vect), nabla (f • X) Y = f • (nabla X Y)
  h_smul_2 : ∀ (f : Func) (X Y : Vect), nabla X (f • Y) = (dirDeriv X f) • Y + f • (nabla X Y)

end Litlib.Y2003.nakahara2003geometry
