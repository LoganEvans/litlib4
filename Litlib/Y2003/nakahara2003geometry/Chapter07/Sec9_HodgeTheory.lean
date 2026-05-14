-- FILENAME: Litlib/Y2003/nakahara2003geometry/Chapter07/Sec9_HodgeTheory.lean

import Litlib.Core
import Mathlib.Algebra.Group.Basic

namespace Litlib.Y2003.nakahara2003geometry

Litlib.equation "nakahara2003geometry"
  eq "7.192a"
  page "52"
  kind "theorem"
class HodgeDecompositionTheorem
    (Form : Type _) [AddCommGroup Form] [Nonempty Form]
    (d d_dagger : Form → Form)
    (isHarmonic : Form → Prop)
    (isExact : Form → Prop)
    (isCoexact : Form → Prop) where
  h_nontrivial : ∃ omega, omega ≠ 0
  exact_def : ∀ w, isExact w ↔ ∃ alpha, w = d alpha
  coexact_def : ∀ w, isCoexact w ↔ ∃ beta, w = d_dagger beta
  
  -- The fundamental decomposition into independent parts
  hodge_decomp : ∀ omega, ∃ alpha beta gamma : Form,
    isExact alpha ∧ isCoexact beta ∧ isHarmonic gamma ∧
    omega = alpha + beta + gamma
    
  -- Uniqueness condition expanded to avoid `∃!` multi-binder Lean 4 error
  hodge_decomp_unique : ∀ omega a1 b1 g1 a2 b2 g2,
    isExact a1 → isCoexact b1 → isHarmonic g1 → omega = a1 + b1 + g1 →
    isExact a2 → isCoexact b2 → isHarmonic g2 → omega = a2 + b2 + g2 →
    a1 = a2 ∧ b1 = b2 ∧ g1 = g2

end Litlib.Y2003.nakahara2003geometry
