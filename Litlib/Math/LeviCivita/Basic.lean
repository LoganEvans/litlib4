-- FILENAME: Litlib/Math/LeviCivita/Basic.lean

import Mathlib.Data.Matrix.Basic
import Mathlib.LinearAlgebra.Matrix.Determinant.Basic

set_option linter.unusedSimpArgs false

namespace Litlib.Math.LeviCivita

open Matrix BigOperators

/--
Physical Interpretation:
The completely antisymmetric Levi-Civita density pseudo-tensor in 3D. Used universally to construct non-degenerate spatial volume forms, magnetic cross products, and holonomy loops.

Mathematical Boundaries:
Defined universally over ℤ to permit safe, strict casting into ℝ, ℂ, or any commutative topological ring without floating-point drift.

Literature:
Standard multi-linear algebra and spatial tensor calculus representation (e.g., Misner, Thorne, Wheeler).
-/
def epsilon3 (a b c : Fin 3) : ℤ :=
  let p : Matrix (Fin 3) (Fin 3) ℤ :=
    Matrix.of ![![if 0=a then 1 else 0, if 0=b then 1 else 0, if 0=c then 1 else 0],
                ![if 1=a then 1 else 0, if 1=b then 1 else 0, if 1=c then 1 else 0],
                ![if 2=a then 1 else 0, if 2=b then 1 else 0, if 2=c then 1 else 0]]
  p.det

/--
Physical Interpretation:
The completely antisymmetric Levi-Civita density pseudo-tensor in 4D. Forms the foundation of spacetime volume measurements and gravitational action integration.
-/
def epsilon4 (i j k l : Fin 4) : ℤ :=
  let M : Matrix (Fin 4) (Fin 4) ℤ :=
    Matrix.of ![![if 0 = i then 1 else 0, if 0 = j then 1 else 0, if 0 = k then 1 else 0, if 0 = l then 1 else 0],
                ![if 1 = i then 1 else 0, if 1 = j then 1 else 0, if 1 = k then 1 else 0, if 1 = l then 1 else 0],
                ![if 2 = i then 1 else 0, if 2 = j then 1 else 0, if 2 = k then 1 else 0, if 2 = l then 1 else 0],
                ![if 3 = i then 1 else 0, if 3 = j then 1 else 0, if 3 = k then 1 else 0, if 3 = l then 1 else 0]]
  M.det

/-- Auxiliary evaluation limits. -/
lemma sum_fin_4 {α} [AddCommMonoid α] (f : Fin 4 → α) :
  (∑ i : Fin 4, f i) = f 0 + f 1 + f 2 + f 3 := by
  simp[Fin.sum_univ_succ, Fin.sum_univ_zero, add_assoc]

lemma sum_fin_3 {α} [AddCommMonoid α] (f : Fin 3 → α) :
  (∑ i : Fin 3, f i) = f 0 + f 1 + f 2 := by
  simp[Fin.sum_univ_succ, Fin.sum_univ_zero, add_assoc]

end Litlib.Math.LeviCivita
