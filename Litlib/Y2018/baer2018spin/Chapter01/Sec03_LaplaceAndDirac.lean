-- FILENAME: Litlib/Y2018/baer2018spin/Chapter01/Sec03_LaplaceAndDirac.lean

import Litlib.Core
import Mathlib.Data.Real.Basic
import Mathlib.Algebra.Module.Pi

namespace Litlib.Y2018.baer2018spin

Litlib.equation "baer2018spin" eq "1.3.1" page "19" kind "definition"
class Def1_3_1 {n : ℕ}
  (M E_fiber : Type _) [AddCommGroup E_fiber] [Module ℝ E_fiber]
  (norm_sq_cotangent : M → (Fin n → ℝ) → ℝ)
  (σ₂ : ((M → E_fiber) → (M → E_fiber)) → M → (Fin n → ℝ) → E_fiber → E_fiber)
  (P : (M → E_fiber) → (M → E_fiber)) : Prop where
  is_laplace_type : ∀ (x : M) (ξ : Fin n → ℝ) (e : E_fiber),
    σ₂ P x ξ e = - (norm_sq_cotangent x ξ) • e

Litlib.equation "baer2018spin" eq "1.18" page "25" kind "equation"
class Eq1_18 {n : ℕ}
  (M E_fiber : Type _) [AddCommGroup E_fiber] [Module ℝ E_fiber]
  (σ₁ : ((M → E_fiber) → (M → E_fiber)) → M → (Fin n → ℝ) → E_fiber → E_fiber)
  (D : (M → E_fiber) → (M → E_fiber))
  (inner_cotangent : M → (Fin n → ℝ) → (Fin n → ℝ) → ℝ) : Prop where
  clifford_relations : ∀ (x : M) (ξ η : Fin n → ℝ) (e : E_fiber),
    σ₁ D x ξ (σ₁ D x η e) + σ₁ D x η (σ₁ D x ξ e) = (-2 * inner_cotangent x ξ η) • e

Litlib.equation "baer2018spin" eq "1.3.5" page "20" kind "lemma"
class Lemma1_3_5 {n : ℕ}
  (M E_fiber : Type _) [AddCommGroup E_fiber] [Module ℝ E_fiber]
  (P : (M → E_fiber) → (M → E_fiber))
  (nabla : (M → E_fiber) → (M → (Fin n → ℝ) → E_fiber))
  (nabla_star : (M → (Fin n → ℝ) → E_fiber) → (M → E_fiber))
  (K : (M → E_fiber) → (M → E_fiber))
  (is_zero_order : ((M → E_fiber) → (M → E_fiber)) → Prop) : Prop where
  decomposition : ∀ (u : M → E_fiber) (x : M),
    P u x = nabla_star (nabla u) x + K u x
  K_is_zero_order : is_zero_order K

Litlib.equation "baer2018spin" eq "1.3.7" page "21" kind "definition"
class Def1_3_7 {n : ℕ}
  (M E_fiber F_fiber : Type _) [AddCommGroup E_fiber] [Module ℝ E_fiber] [AddCommGroup F_fiber] [Module ℝ F_fiber]
  (norm_sq_cotangent : M → (Fin n → ℝ) → ℝ)
  (σ₂_E : ((M → E_fiber) → (M → E_fiber)) → M → (Fin n → ℝ) → E_fiber → E_fiber)
  (σ₂_F : ((M → F_fiber) → (M → F_fiber)) → M → (Fin n → ℝ) → F_fiber → F_fiber)
  (D : (M → E_fiber) → (M → F_fiber))
  (D_star : (M → F_fiber) → (M → E_fiber)) : Prop where
  D_star_D_laplace : ∀ (x : M) (ξ : Fin n → ℝ) (e : E_fiber),
    σ₂_E (fun u => D_star (D u)) x ξ e = - (norm_sq_cotangent x ξ) • e
  D_D_star_laplace : ∀ (x : M) (ξ : Fin n → ℝ) (f : F_fiber),
    σ₂_F (fun v => D (D_star v)) x ξ f = - (norm_sq_cotangent x ξ) • f

Litlib.equation "baer2018spin" eq "1.3.12" page "24" kind "proposition"
class Prop1_3_12 {n : ℕ}
  (M Form1_fiber : Type _) [AddCommGroup Form1_fiber]
  (Delta_d : (M → Form1_fiber) → (M → Form1_fiber))
  (nabla : (M → Form1_fiber) → (M → (Fin n → ℝ) → Form1_fiber))
  (nabla_star : (M → (Fin n → ℝ) → Form1_fiber) → (M → Form1_fiber))
  (Ricci : (M → Form1_fiber) → (M → Form1_fiber)) : Prop where
  bochner_formula : ∀ (omega : M → Form1_fiber) (x : M),
    Delta_d omega x = nabla_star (nabla omega) x + Ricci omega x

end Litlib.Y2018.baer2018spin
