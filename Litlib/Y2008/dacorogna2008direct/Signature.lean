-- FILENAME: Litlib/Y2008/dacorogna2008direct/Signature.lean

import Litlib.Core
import Mathlib.Data.Real.Basic
import Mathlib.Topology.Basic

namespace Litlib.Y2008.dacorogna2008direct

Litlib.reference ConvexityHierarchy
  bibtex "dacorogna2008direct"
  doi "10.1007/978-0-387-55249-1"
  authors["Dacorogna, Bernard"]
  status Standard
class ConvexityHierarchy 
    (M : Type*)
    (isConvex isPolyconvex isQuasiconvex isRankOneConvex : (M → ℝ) → Prop) where
  hierarchy :
    ∀ (f : M → ℝ),
      (isConvex f → isPolyconvex f) ∧
      (isPolyconvex f → isQuasiconvex f) ∧
      (isQuasiconvex f → isRankOneConvex f)

Litlib.reference DirectMethod
  bibtex "dacorogna2008direct"
  doi "10.1007/978-0-387-55249-1"
  authors ["Dacorogna, Bernard"]
  status Standard
class DirectMethod 
    (State : Type*) [TopologicalSpace State]
    (Action : State → ℝ) where
  existsGlobalMinimum
    (hNonempty : Nonempty State)
    (hCompactSublevel : ∀ (c : ℝ), IsCompact {u | Action u ≤ c}) :
    ∃ (u : State), ∀ (v : State), Action u ≤ Action v

Litlib.reference RelaxationTheorem
  bibtex "dacorogna2008direct"
  doi "10.1007/978-0-387-55249-1"
  authors ["Dacorogna, Bernard"]
  status Standard
class RelaxationTheorem 
    (State : Type*)
    (Action RelaxedAction : State → ℝ)
    (isQuasiconvexEnvelope : (State → ℝ) → (State → ℝ) → Prop) where
  infPEqInfQp
    (infP infQP : ℝ)
    (hEnvelope : isQuasiconvexEnvelope Action RelaxedAction)
    (hInfP : IsGLB (Set.range Action) infP)
    (hInfQp : IsGLB (Set.range RelaxedAction) infQP) :
    infP = infQP

end Litlib.Y2008.dacorogna2008direct
