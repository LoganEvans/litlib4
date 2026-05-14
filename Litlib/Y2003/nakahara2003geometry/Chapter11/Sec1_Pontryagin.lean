-- FILENAME: Litlib/Y2003/nakahara2003geometry/Chapter11/Sec1_Pontryagin.lean

import Litlib.Core
import Mathlib.Data.Real.Basic
import Mathlib.Analysis.Calculus.Deriv.Basic
import Mathlib.Analysis.Normed.Group.Basic
import Mathlib.Analysis.Normed.Module.Basic

namespace Litlib.Y2003.nakahara2003geometry

Litlib.equation "nakahara2003geometry"
  eq "11.22"
  page "7"
  kind "equation"
class PontryaginActionVariation 
    (Universe β : Type _) [NormedAddCommGroup β] [NormedSpace ℝ β] [Nonempty Universe]
    (Action : Universe → β)
    (isValidVariation : (ℝ → Universe) → Prop) where
  -- Anti-BS constraint
  h_nontrivial_action : ∃ u1 u2, Action u1 ≠ Action u2
  variation_exists (u : Universe) : ∃ (v : ℝ → Universe), isValidVariation v ∧ v 0 = u
  variation_zero (u : Universe) (v : ℝ → Universe) :
    isValidVariation v → v 0 = u → HasDerivAt (fun t => Action (v t)) (0 : β) (0 : ℝ)

end Litlib.Y2003.nakahara2003geometry
