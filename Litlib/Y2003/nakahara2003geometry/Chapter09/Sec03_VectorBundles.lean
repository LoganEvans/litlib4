-- FILENAME: Litlib/Y2003/nakahara2003geometry/Chapter09/Sec03_VectorBundles.lean

import Litlib.Core
import Litlib.Y2003.nakahara2003geometry.Paper
import Mathlib.Data.Matrix.Basic
import Mathlib.Data.Real.Basic

namespace Litlib.Y2003.nakahara2003geometry

Litlib.equation "nakahara2003geometry"
  eq "9.37"
  page "15"
  kind "equation"
class WhitneySumTransitionFunction
    (Base Index : Type _) [Nonempty Base] [Nonempty Index]
    (kE kE' : ℕ)
    (tE : Index → Index → Base → Matrix (Fin kE) (Fin kE) ℝ)
    (tE' : Index → Index → Base → Matrix (Fin kE') (Fin kE') ℝ)
    (tWhitney : Index → Index → Base → Matrix (Fin kE ⊕ Fin kE') (Fin kE ⊕ Fin kE') ℝ) where
  
  -- T_{ij}(p) = block_diag(t^E_{ij}(p), t^{E'}_{ij}(p))
  whitney_transition_inl_inl : ∀ i j p a b, tWhitney i j p (Sum.inl a) (Sum.inl b) = tE i j p a b
  whitney_transition_inl_inr : ∀ i j p a b, tWhitney i j p (Sum.inl a) (Sum.inr b) = 0
  whitney_transition_inr_inl : ∀ i j p a b, tWhitney i j p (Sum.inr a) (Sum.inl b) = 0
  whitney_transition_inr_inr : ∀ i j p a b, tWhitney i j p (Sum.inr a) (Sum.inr b) = tE' i j p a b
      
end Litlib.Y2003.nakahara2003geometry
