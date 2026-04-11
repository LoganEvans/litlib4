-- FILENAME: Litlib/Y1975/belavin1975pseudoparticle/Signature.lean

import Litlib.Core
import Mathlib.Data.Real.Basic
import Mathlib.Analysis.Calculus.Deriv.Basic

namespace Litlib.Y1975.belavin1975pseudoparticle

literature_axiom Eq16
  bibtex_key "belavin1975pseudoparticle"
  doi "10.1016/0370-2693(75)90163-X"
  authors["Belavin, A.A.", "Polyakov, A.M.", "Schwartz, A.S.", "Tyupkin, Yu.S."]
  status Standard
class Eq16 where
  /-- 
  Equation (16) (page 86): The radial profile of the BPST instanton.
  
  ERRATA TRACKING: The original 1975 paper contains a famous typo here. It prints the 
  solution as f(r) = 1 / (r^2 + λ^2). However, plugging this into the required 
  ODE f'/r + f^2 = 0 yields -2/(r^2+λ^2)^2 + 1/(r^2+λ^2)^2 ≠ 0. 
  The mathematically sound solution (and the physically correct instanton profile) 
  requires a numerator of 2. We formalize the corrected version here.
  -/
  bpst_profile_ode (lam : ℝ) :
    let f := fun (r : ℝ) => 2 / (r^2 + lam^2)
    ∀ r : ℝ, r ≠ 0 → deriv f r / r + (f r)^2 = 0
