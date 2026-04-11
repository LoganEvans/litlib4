-- FILENAME: Litlib/Y2008/dacorogna2008direct/Signature.lean

import Litlib.Core
import Mathlib.Data.Real.Basic

namespace Litlib.Y2008.dacorogna2008direct

literature_citation ConvexityHierarchy
  bibtex_key "dacorogna2008direct"
  doi "10.1007/978-0-387-55249-1"
  authors["Dacorogna, Bernard"]
  status Standard
class ConvexityHierarchy where
  /--
  Theorem 5.3: The hierarchy of generalized convexities.
  Convexity implies polyconvexity, which implies quasiconvexity, 
  which implies rank-one convexity.
  -/
  hierarchy (M : Type*)
    (isConvex isPolyconvex isQuasiconvex isRankOneConvex : (M → ℝ) → Prop)
    (f : M → ℝ) :
    (isConvex f → isPolyconvex f) ∧
    (isPolyconvex f → isQuasiconvex f) ∧
    (isQuasiconvex f → isRankOneConvex f)

literature_citation DirectMethod
  bibtex_key "dacorogna2008direct"
  doi "10.1007/978-0-387-55249-1"
  authors ["Dacorogna, Bernard"]
  status Standard
class DirectMethod where
  /--
  The abstract Direct Method of the Calculus of Variations.
  If a functional is coercive (bounded from below), weakly lower semicontinuous,
  and its bounded sequences are weakly compact, then a global minimum absolutely exists.
  -/
  exists_global_minimum
    (State : Type*)
    (Action : State → ℝ)
    (isCoercive : Prop)
    (isWeaklyLowerSemicontinuous : Prop)
    (boundedSequencesAreWeaklyCompact : Prop) :
    isCoercive → isWeaklyLowerSemicontinuous → boundedSequencesAreWeaklyCompact →
    ∃ (u : State), ∀ (v : State), Action u ≤ Action v

literature_citation RelaxationTheorem
  bibtex_key "dacorogna2008direct"
  doi "10.1007/978-0-387-55249-1"
  authors ["Dacorogna, Bernard"]
  status Standard
class RelaxationTheorem where
  /--
  Theorem 9.1: The Relaxation Theorem (Abstracted). The infimum of the original problem 
  is equal to the infimum of the relaxed problem formed by taking the 
  quasiconvex envelope. Abstracted via the Weyl Pattern to avoid raw Set.sInf.
  -/
  inf_P_eq_inf_QP
    (State : Type*)
    (Action RelaxedAction : State → ℝ)
    (isQuasiconvexEnvelope : (State → ℝ) → (State → ℝ) → Prop)
    (isInfimum : (State → ℝ) → ℝ → Prop)
    (infP infQP : ℝ) :
    isQuasiconvexEnvelope Action RelaxedAction →
    isInfimum Action infP →
    isInfimum RelaxedAction infQP →
    infP = infQP
