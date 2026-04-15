-- FILENAME: Litlib/Y2008/dacorogna2008direct/Signature.lean

import Litlib.Core
import Mathlib.Data.Real.Basic
import Mathlib.Topology.Basic

namespace Litlib.Y2008.dacorogna2008direct

literature_citation ConvexityHierarchy
  bibtex_key "dacorogna2008direct"
  doi "10.1007/978-0-387-55249-1"
  authors["Dacorogna, Bernard"]
  status Standard
class ConvexityHierarchy 
    (M : Type*)
    (isConvex isPolyconvex isQuasiconvex isRankOneConvex : (M → ℝ) → Prop) where
  /--
  Theorem 5.3: The hierarchy of generalized convexities.
  Secured by mapping the geometric mappings to the class definition.
  -/
  hierarchy :
    ∀ (f : M → ℝ),
      (isConvex f → isPolyconvex f) ∧
      (isPolyconvex f → isQuasiconvex f) ∧
      (isQuasiconvex f → isRankOneConvex f)

literature_citation DirectMethod
  bibtex_key "dacorogna2008direct"
  doi "10.1007/978-0-387-55249-1"
  authors ["Dacorogna, Bernard"]
  status Standard
class DirectMethod 
    (State : Type*) [TopologicalSpace State]
    (Action : State → ℝ) where
  /--
  The abstract Direct Method of the Calculus of Variations.
  If a functional has compact sublevel sets (encoding coercivity and lower 
  semicontinuity natively in Mathlib's topology), a global minimum absolutely exists.
  -/
  exists_global_minimum
    (h_nonempty : Nonempty State)
    (h_compact_sublevel : ∀ (c : ℝ), IsCompact {u | Action u ≤ c}) :
    ∃ (u : State), ∀ (v : State), Action u ≤ Action v

literature_citation RelaxationTheorem
  bibtex_key "dacorogna2008direct"
  doi "10.1007/978-0-387-55249-1"
  authors ["Dacorogna, Bernard"]
  status Standard
class RelaxationTheorem 
    (State : Type*)
    (Action RelaxedAction : State → ℝ)
    (isQuasiconvexEnvelope : (State → ℝ) → (State → ℝ) → Prop) where
  /--
  Theorem 9.1: The Relaxation Theorem. The infimum of the original problem 
  is equal to the infimum of the relaxed problem formed by taking the 
  quasiconvex envelope. Secured using native Mathlib Greatest Lower Bounds (IsGLB).
  -/
  inf_P_eq_inf_QP
    (infP infQP : ℝ)
    (h_envelope : isQuasiconvexEnvelope Action RelaxedAction)
    (h_inf_P : IsGLB (Set.range Action) infP)
    (h_inf_QP : IsGLB (Set.range RelaxedAction) infQP) :
    infP = infQP

end Litlib.Y2008.dacorogna2008direct
