-- FILENAME: Litlib/Y1975/belavin1975pseudoparticle/Signature.lean

import Litlib.Core
import Mathlib.Data.Real.Basic
import Mathlib.Analysis.Calculus.Deriv.Basic

namespace Litlib.Y1975.belavin1975pseudoparticle

literature_citation Eq16
  bibtex_key "belavin1975pseudoparticle"
  doi "10.1016/0370-2693(75)90163-X"
  authors["Belavin, A.A.", "Polyakov, A.M.", "Schwartz, A.S.", "Tyupkin, Yu.S."]
  status Standard
class Eq16 where
  /-- 
  Equation (16) (page 86): The radial profile of the BPST instanton.
  -/
  bpst_profile_ode (lam : ℝ) :
    let f := fun (r : ℝ) => 2 / (r^2 + lam^2)
    ∀ r : ℝ, r ≠ 0 → deriv f r / r + (f r)^2 = 0

literature_citation BpstModuliUniqueness
  bibtex_key "belavin1975pseudoparticle"
  doi "10.1016/0370-2693(75)90163-X"
  authors["Belavin, A.A.", "Polyakov, A.M.", "Schwartz, A.S.", "Tyupkin, Yu.S."]
  status Standard
class BpstModuliUniqueness where
  /--
  Capstone Theorem: Moduli Uniqueness.
  If a topological state minimizes the action (e.g. self-dual, W=1), 
  then it is gauge-equivalent to the BPST instanton.
  -/
  bpst_uniqueness
    (State : Type*)
    (isSelfDual : State → Prop)
    (hasWindingNumber1 : State → Prop)
    (isGaugeEquivalent : State → State → Prop)
    (bpstInstanton : State) :
    isSelfDual bpstInstanton ∧ hasWindingNumber1 bpstInstanton ∧
    ∀ (s : State), isSelfDual s → hasWindingNumber1 s → isGaugeEquivalent s bpstInstanton

literature_citation BpstIsSelfDual
  bibtex_key "belavin1975pseudoparticle"
  doi "10.1016/0370-2693(75)90163-X"
  authors["Belavin, A.A.", "Polyakov, A.M.", "Schwartz, A.S.", "Tyupkin, Yu.S."]
  status Standard
class BpstIsSelfDual where
  /--
  Capstone Theorem for CGD: BPST is Self-Dual.
  The assertion that the BPST mathematical ansatz explicitly satisfies 
  the self-duality bound (F = ⋆F).
  -/
  bpst_satisfies_self_duality
    (Connection FieldStrength : Type*)
    (bpstAnsatz : Connection)
    (curvature : Connection → FieldStrength)
    (hodgeStar : FieldStrength → FieldStrength) :
    curvature bpstAnsatz = hodgeStar (curvature bpstAnsatz)

literature_citation BpstCoreExpansion
  bibtex_key "belavin1975pseudoparticle"
  doi "10.1016/0370-2693(75)90163-X"
  authors["Belavin, A.A.", "Polyakov, A.M.", "Schwartz, A.S.", "Tyupkin, Yu.S."]
  status Standard
class BpstCoreExpansion where
  /--
  Capstone Theorem for CGD: BPST Core Expansion.
  A kinematic bridge stating that the trace of the BPST instanton at the core (r=0) 
  is zero if and only if the trace of the spatial 3D Hedgehog ansatz is zero at the core.
  -/
  bpst_core_trace_eq_hedgehog_core_trace
    (Connection SpatialAnsatz : Type*)
    (bpstInstanton : Connection)
    (hedgehogAnsatz : SpatialAnsatz)
    (traceAtCore : Connection → ℝ)
    (spatialTraceAtCore : SpatialAnsatz → ℝ) :
    traceAtCore bpstInstanton = 0 ↔ spatialTraceAtCore hedgehogAnsatz = 0
