-- FILENAME: Litlib/Y2003/nakahara2003geometry/Chapter07/Sec11_StringTheory.lean

import Litlib.Core
import Mathlib.Data.Real.Basic
import Mathlib.Data.Fintype.Basic
import Mathlib.Algebra.BigOperators.Group.Finset.Basic

open BigOperators

namespace Litlib.Y2003.nakahara2003geometry

Litlib.equation "nakahara2003geometry"
  eq "7.237a"
  page "62"
  kind "equation"
class PolyakovEquationOfMotion
    (WorldSheet Index : Type _) [Fintype Index] [Nonempty WorldSheet]
    (g_inv : Index → Index → WorldSheet → ℝ)
    (sqrt_det_g : WorldSheet → ℝ)
    (X : Index → WorldSheet → ℝ)
    (partialDeriv : Index → (WorldSheet → ℝ) → WorldSheet → ℝ) where
  -- Anti-BS
  h_nontrivial_g : ∃ x, sqrt_det_g x ≠ 0
  
  polyakovEOM : ∀ (mu : Index) (x : WorldSheet),
    ∑ alpha : Index, partialDeriv alpha (fun p => 
      sqrt_det_g p * ∑ beta : Index, (g_inv alpha beta p * partialDeriv beta (fun p' => X mu p') p)
    ) x = 0

Litlib.equation "nakahara2003geometry"
  eq "7.237b"
  page "62"
  kind "equation"
class VirasoroConstraint
    (WorldSheet Index SpaceIndex : Type _) [Fintype Index] [Fintype SpaceIndex] [Nonempty WorldSheet]
    (g g_inv : Index → Index → WorldSheet → ℝ)
    (X : SpaceIndex → WorldSheet → ℝ)
    (partialDeriv : Index → (WorldSheet → ℝ) → WorldSheet → ℝ)
    (T : Index → Index → WorldSheet → ℝ) where
  -- Anti-BS
  h_nontrivial_X : ∃ mu alpha p, partialDeriv alpha (fun p' => X mu p') p ≠ 0
  
  virasoro_def : ∀ (alpha beta : Index) (p : WorldSheet),
    T alpha beta p = 
      (∑ mu : SpaceIndex, partialDeriv alpha (fun p' => X mu p') p * partialDeriv beta (fun p' => X mu p') p) - 
      (1/2 : ℝ) * g alpha beta p * (∑ gamma : Index, ∑ delta : Index, ∑ mu : SpaceIndex, 
        g_inv gamma delta p * partialDeriv gamma (fun p' => X mu p') p * partialDeriv delta (fun p' => X mu p') p)

  virasoro_constraint : ∀ (alpha beta : Index) (p : WorldSheet),
    T alpha beta p = 0

end Litlib.Y2003.nakahara2003geometry
