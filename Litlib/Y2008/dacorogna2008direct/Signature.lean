-- FILENAME: Litlib/Y2008/dacorogna2008direct/Signature.lean

import Litlib.Core
import Mathlib.Data.Real.Basic
import Mathlib.Topology.Basic

namespace Litlib.Y2008.dacorogna2008direct

Litlib.reference ConvexityHierarchy
  type "book"
  bibtex "dacorogna2008direct"
  title "Direct methods in the calculus of variations"
  authors ["Dacorogna, Bernard"]
  year "2008"
  publisher "Springer"
  doi "10.1007/978-0-387-55249-1"
class ConvexityHierarchy 
    (M : Type*)
    (isConvex isPolyconvex isQuasiconvex isRankOneConvex : (M → ℝ) → Prop) where
  hierarchy :
    ∀ (f : M → ℝ),
      (isConvex f → isPolyconvex f) ∧
      (isPolyconvex f → isQuasiconvex f) ∧
      (isQuasiconvex f → isRankOneConvex f)

Litlib.reference DirectMethod
  type "book"
  bibtex "dacorogna2008direct"
  title "Direct methods in the calculus of variations"
  authors ["Dacorogna, Bernard"]
  year "2008"
  publisher "Springer"
  doi "10.1007/978-0-387-55249-1"
class DirectMethod 
    (State : Type*) [TopologicalSpace State]
    (Action : State → ℝ) where
  existsGlobalMinimum
    (hNonempty : Nonempty State)
    (hCompactSublevel : ∀ (c : ℝ), IsCompact {u | Action u ≤ c}) :
    ∃ (u : State), ∀ (v : State), Action u ≤ Action v

Litlib.reference RelaxationTheorem
  type "book"
  bibtex "dacorogna2008direct"
  title "Direct methods in the calculus of variations"
  authors ["Dacorogna, Bernard"]
  year "2008"
  publisher "Springer"
  doi "10.1007/978-0-387-55249-1"
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
