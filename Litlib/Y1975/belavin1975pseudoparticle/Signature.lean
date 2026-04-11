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
