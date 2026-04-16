-- FILENAME: Litlib/Y2008/dacorogna2008direct/Signature.lean

import Litlib.Core
import Mathlib.Data.Real.Basic
import Mathlib.Topology.Basic
import Mathlib.Analysis.Calculus.FDeriv.Basic

namespace Litlib.Y2008.dacorogna2008direct

Litlib.reference ConvexityHierarchy
  bibtex "dacorogna2008direct"
  doi "10.1007/978-0-387-55249-1"
  authors["Dacorogna, Bernard"]
  status Standard
class ConvexityHierarchy where
  hierarchy :
    ∀ (M : Type*)
      (isConvex isPolyconvex isQuasiconvex isRankOneConvex : (M → ℝ) → Prop)
      (_h_convex_zero : isConvex (fun _ => 0)),
      ∀ (f : M → ℝ),
        (isConvex f → isPolyconvex f) ∧
        (isPolyconvex f → isQuasiconvex f) ∧
        (isQuasiconvex f → isRankOneConvex f)

Litlib.reference DirectMethod
  bibtex "dacorogna2008direct"
  doi "10.1007/978-0-387-55249-1"
  authors ["Dacorogna, Bernard"]
  status Standard
class DirectMethod where
  existsGlobalMinimum :
    ∀ (State : Type*) [TopologicalSpace State] (Action : State → ℝ)
      (_hNonempty : Nonempty State)
      (_hCompactSublevel : ∀ (c : ℝ), IsCompact {u | Action u ≤ c})
      (_hContinuous : Continuous Action),
      ∃ (u : State), ∀ (v : State), Action u ≤ Action v

Litlib.reference RelaxationTheorem
  bibtex "dacorogna2008direct"
  doi "10.1007/978-0-387-55249-1"
  authors ["Dacorogna, Bernard"]
  status Standard
class RelaxationTheorem where
  infPEqInfQp :
    ∀ (State : Type*)
      (Action RelaxedAction : State → ℝ)
      (isQuasiconvexEnvelope : (State → ℝ) → (State → ℝ) → Prop)
      (infP infQP : ℝ)
      (_hEnvelope : isQuasiconvexEnvelope Action RelaxedAction)
      (_hInfP : IsGLB (Set.range Action) infP)
      (_hInfQp : IsGLB (Set.range RelaxedAction) infQP),
      infP = infQP

end Litlib.Y2008.dacorogna2008direct
