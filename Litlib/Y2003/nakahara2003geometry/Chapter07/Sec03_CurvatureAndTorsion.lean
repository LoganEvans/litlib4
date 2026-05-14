-- FILENAME: Litlib/Y2003/nakahara2003geometry/Chapter07/Sec03_CurvatureAndTorsion.lean

import Litlib.Core
import Mathlib.Algebra.Group.Basic
import Mathlib.Algebra.Module.Basic

namespace Litlib.Y2003.nakahara2003geometry

Litlib.equation "nakahara2003geometry"
  eq "7.36"
  page "12"
  kind "definition"
class TorsionTensor
    (Vect : Type _) [AddCommGroup Vect]
    (nabla : Vect → Vect → Vect)
    (lieBracket : Vect → Vect → Vect)
    (T : Vect → Vect → Vect) where
  -- Anti-BS: Prevent trivially flat spaces
  h_nontrivial : ∃ X Y, T X Y ≠ 0
  
  torsion_def : ∀ X Y, T X Y = nabla X Y - nabla Y X - lieBracket X Y

Litlib.equation "nakahara2003geometry"
  eq "7.37"
  page "12"
  kind "definition"
class RiemannCurvatureTensor
    (Vect : Type _) [AddCommGroup Vect]
    (nabla : Vect → Vect → Vect)
    (lieBracket : Vect → Vect → Vect)
    (R : Vect → Vect → Vect → Vect) where
  -- Anti-BS: Prevent trivially flat spaces
  h_nontrivial : ∃ X Y Z, R X Y Z ≠ 0
  
  riemann_def : ∀ X Y Z, R X Y Z = nabla X (nabla Y Z) - nabla Y (nabla X Z) - nabla (lieBracket X Y) Z

end Litlib.Y2003.nakahara2003geometry
