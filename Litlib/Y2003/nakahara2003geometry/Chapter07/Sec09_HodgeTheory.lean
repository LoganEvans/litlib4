-- FILENAME: Litlib/Y2003/nakahara2003geometry/Chapter07/Sec09_HodgeTheory.lean

import Litlib.Core
import Mathlib.Algebra.Group.Basic
import Mathlib.Algebra.Module.Basic
import Mathlib.Data.Real.Basic

namespace Litlib.Y2003.nakahara2003geometry

Litlib.equation "nakahara2003geometry"
  eq "7.192a"
  page "52"
  kind "theorem"
class HodgeDecompositionTheorem
    (Manifold Metric : Type _)
    (isCompact : Manifold → Prop)
    (isOrientable : Manifold → Prop)
    (hasNoBoundary : Manifold → Prop)
    (isRiemannian : Manifold → Metric → Prop)
    (Form : Manifold → Type _) [∀ M, AddCommGroup (Form M)]
    (IsOfDegree : ∀ M, Form M → ℕ → Prop)
    (d : ∀ M, Form M → Form M)
    (d_dagger : ∀ M, Form M → Form M)
    (isHarmonic : ∀ M, Form M → Prop)
    (isExact : ∀ M, Form M → Prop)
    (isCoexact : ∀ M, Form M → Prop) where
  
  d_degree : ∀ M r (w : Form M), IsOfDegree M w r → IsOfDegree M (d M w) (r + 1)
  d_dagger_degree : ∀ M r (w : Form M), IsOfDegree M w r → IsOfDegree M (d_dagger M w) (r - 1)

  exact_def : ∀ M (w : Form M), isExact M w ↔ ∃ alpha, w = d M alpha
  coexact_def : ∀ M (w : Form M), isCoexact M w ↔ ∃ beta, w = d_dagger M beta
  
  -- The fundamental decomposition into independent parts
  hodge_decomp : ∀ (M : Manifold) (g : Metric),
    isCompact M → isOrientable M → hasNoBoundary M → isRiemannian M g →
    ∀ r (omega : Form M), IsOfDegree M omega r →
    ∃ alpha beta gamma : Form M,
      IsOfDegree M alpha r ∧ IsOfDegree M beta r ∧ IsOfDegree M gamma r ∧
      isExact M alpha ∧ isCoexact M beta ∧ isHarmonic M gamma ∧
      omega = alpha + beta + gamma
    
  -- Uniqueness condition
  hodge_decomp_unique : ∀ M r (omega a1 b1 g1 a2 b2 g2 : Form M),
    IsOfDegree M omega r →
    IsOfDegree M a1 r → IsOfDegree M b1 r → IsOfDegree M g1 r →
    isExact M a1 → isCoexact M b1 → isHarmonic M g1 → omega = a1 + b1 + g1 →
    IsOfDegree M a2 r → IsOfDegree M b2 r → IsOfDegree M g2 r →
    isExact M a2 → isCoexact M b2 → isHarmonic M g2 → omega = a2 + b2 + g2 →
    a1 = a2 ∧ b1 = b2 ∧ g1 = g2

Litlib.equation "nakahara2003geometry"
  eq "7.176a"
  page "48"
  kind "theorem"
class HodgeStarInvolutionRiemannian
    (Manifold Metric : Type _)
    (isRiemannian : Manifold → Metric → Prop)
    (dim : Manifold → ℕ)
    (Form : Manifold → Type _) [∀ M, AddCommGroup (Form M)]
    (IsOfDegree : ∀ M, Form M → ℕ → Prop)
    (star : ∀ M, Form M → Form M) where
  h_nontrivial : ∃ M, ∃ omega : Form M, omega ≠ 0
  
  hodge_involution : ∀ (M : Manifold) (g : Metric) (omega : Form M) (r : ℕ),
    isRiemannian M g →
    IsOfDegree M omega r →
    star M (star M omega) = ((-1 : ℤ) ^ (r * (dim M - r))) • omega

Litlib.equation "nakahara2003geometry"
  eq "7.176b"
  page "48"
  kind "theorem"
class HodgeStarInvolutionLorentzian
    (Manifold Metric : Type _)
    (isLorentzian : Manifold → Metric → Prop)
    (dim : Manifold → ℕ)
    (Form : Manifold → Type _) [∀ M, AddCommGroup (Form M)]
    (IsOfDegree : ∀ M, Form M → ℕ → Prop)
    (star : ∀ M, Form M → Form M) where
  h_nontrivial : ∃ M, ∃ omega : Form M, omega ≠ 0
  
  hodge_involution : ∀ (M : Manifold) (g : Metric) (omega : Form M) (r : ℕ),
    isLorentzian M g →
    IsOfDegree M omega r →
    star M (star M omega) = ((-1 : ℤ) ^ (1 + r * (dim M - r))) • omega

Litlib.equation "nakahara2003geometry"
  eq "7.186"
  page "50"
  kind "theorem"
class AdjointExteriorDerivative
    (Manifold : Type _)
    (isCompact : Manifold → Prop)
    (isOrientable : Manifold → Prop)
    (hasNoBoundary : Manifold → Prop)
    (Form : Manifold → Type _) [∀ M, AddCommGroup (Form M)]
    (IsOfDegree : ∀ M, Form M → ℕ → Prop)
    (d : ∀ M, Form M → Form M)
    (d_dagger : ∀ M, Form M → Form M)
    (innerProd : ∀ M, Form M → Form M → ℝ) where
  h_nontrivial : ∃ M, ∃ alpha beta : Form M, innerProd M alpha beta ≠ 0
  
  adjoint_prop : ∀ (M : Manifold) (alpha beta : Form M) (r : ℕ),
    isCompact M → isOrientable M → hasNoBoundary M →
    IsOfDegree M alpha r → IsOfDegree M beta (r - 1) →
    innerProd M (d M beta) alpha = innerProd M beta (d_dagger M alpha)

end Litlib.Y2003.nakahara2003geometry
