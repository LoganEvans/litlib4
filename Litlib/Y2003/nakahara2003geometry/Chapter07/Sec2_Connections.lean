-- FILENAME: Litlib/Y2003/nakahara2003geometry/Chapter07/Sec2_Connections.lean

import Litlib.Core
import Mathlib.Data.Real.Basic
import Mathlib.Analysis.Calculus.Deriv.Basic
import Mathlib.Algebra.BigOperators.Group.Finset.Basic
import Mathlib.Data.Fintype.Basic

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

end Litlib.Y2003.nakahara2003geometry
