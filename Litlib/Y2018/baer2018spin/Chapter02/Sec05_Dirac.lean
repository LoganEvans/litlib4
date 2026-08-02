-- FILENAME: Litlib/Y2018/baer2018spin/Chapter02/Sec05_Dirac.lean

import Litlib.Core
import Mathlib.Data.Real.Basic
import Mathlib.Algebra.Module.Pi
import Mathlib.Algebra.BigOperators.Group.Finset.Basic
import Mathlib.Data.Fintype.Basic

namespace Litlib.Y2018.baer2018spin

Litlib.equation "baer2018spin" eq "2.5.15" page "108" kind "theorem"
class Thm2_5_15
  (M Sigma_fiber : Type _) [AddCommGroup Sigma_fiber] [Module ℝ Sigma_fiber]
  (D : (M → Sigma_fiber) → (M → Sigma_fiber))
  (nabla_star_nabla : (M → Sigma_fiber) → (M → Sigma_fiber))
  (scal : M → ℝ) : Prop where
  schrodinger_lichnerowicz : ∀ (psi : M → Sigma_fiber) (x : M),
    D (D psi) x = nabla_star_nabla psi x + (0.25 * scal x) • psi x

Litlib.equation "baer2018spin" eq "2.5.15_twisted" page "111" kind "theorem"
class Thm2_5_15_Twisted {n : ℕ}
  (M Sigma_A_fiber : Type _) [AddCommGroup Sigma_A_fiber] [Module ℝ Sigma_A_fiber]
  (D_A : (M → Sigma_A_fiber) → (M → Sigma_A_fiber))
  (nabla_A_star_nabla_A : (M → Sigma_A_fiber) → (M → Sigma_A_fiber))
  (scal : M → ℝ)
  (F : M → (Fin n → ℝ) → (Fin n → ℝ) → ℝ)
  (c : M → (Fin n → ℝ) → Sigma_A_fiber → Sigma_A_fiber)
  (dual_frame : M → Fin n → (Fin n → ℝ)) : Prop where
  schrodinger_lichnerowicz_twisted : ∀ (psi : M → Sigma_A_fiber) (x : M),
    D_A (D_A psi) x = nabla_A_star_nabla_A psi x + (0.25 * scal x) • psi x +
      (0.5 : ℝ) • ∑ μ : Fin n, ∑ ν : Fin n,
        (F x (dual_frame x μ) (dual_frame x ν)) • c x (dual_frame x μ) (c x (dual_frame x ν) (psi x))

end Litlib.Y2018.baer2018spin
