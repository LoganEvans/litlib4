-- FILENAME: Litlib/Y2018/baer2018spin/Chapter06/Sec04_ClassicalDirac.lean

import Litlib.Core
import Mathlib.Data.Real.Basic
import Mathlib.Algebra.Module.Pi
import Mathlib.Algebra.BigOperators.Group.Finset.Basic
import Mathlib.Data.Fintype.Basic

namespace Litlib.Y2018.baer2018spin

Litlib.equation "baer2018spin" eq "6.4.1" page "216" kind "definition"
class Def6_4_1 {n : ℕ}
  (M Sigma_fiber : Type _) [AddCommGroup Sigma_fiber] [Module ℝ Sigma_fiber]
  (nabla_Sigma : (M → Sigma_fiber) → M → (Fin n → ℝ) → Sigma_fiber)
  (c : M → (Fin n → ℝ) → Sigma_fiber → Sigma_fiber)
  (D : (M → Sigma_fiber) → (M → Sigma_fiber))
  (g : M → (Fin n → ℝ) → (Fin n → ℝ) → ℝ)
  (local_frame : M → Fin n → (Fin n → ℝ))
  (dual_frame : M → Fin n → (Fin n → ℝ)) : Prop where
  clifford_relation : ∀ (x : M) (v w : Fin n → ℝ) (psi : Sigma_fiber),
    c x v (c x w psi) + c x w (c x v psi) = (-2 * g x v w) • psi
  dirac_def : ∀ (psi : M → Sigma_fiber) (x : M),
    D psi x = ∑ i : Fin n, c x (dual_frame x i) (nabla_Sigma psi x (local_frame x i))

Litlib.equation "baer2018spin" eq "6.4.4" page "217" kind "proposition"
class Prop6_4_4 {r : ℕ}
  (M Sigma_fiber : Type _)
  (inner_prod : M → Sigma_fiber → Sigma_fiber → ℝ)
  (D : (M → Sigma_fiber) → (M → Sigma_fiber))
  (integral : (M → ℝ) → ℝ)
  (has_compact_support : (M → Sigma_fiber) → Prop) : Prop where
  adjointness : ∀ (phi psi : M → Sigma_fiber),
    has_compact_support phi → has_compact_support psi →
    integral (fun x => inner_prod x (D phi x) (psi x)) =
    ((-1 : ℝ) ^ r) * integral (fun x => inner_prod x (phi x) (D psi x))

end Litlib.Y2018.baer2018spin
