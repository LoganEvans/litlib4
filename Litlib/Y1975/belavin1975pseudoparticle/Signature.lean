-- FILENAME: Litlib/Y1975/belavin1975pseudoparticle/Signature.lean

import Litlib.Core
import Mathlib.Data.Real.Basic
import Mathlib.Analysis.Calculus.Deriv.Basic
import Mathlib.Topology.Basic
import Mathlib.Order.Filter.Basic
import Mathlib.Analysis.InnerProductSpace.Basic

open Filter Topology

namespace Litlib.Y1975.belavin1975pseudoparticle

literature_citation Eq10_and_11
  bibtex_key "belavin1975pseudoparticle"
  doi "10.1016/0370-2693(75)90163-X"
  authors["Belavin, A.A.", "Polyakov, A.M.", "Schwartz, A.S.", "Tyupkin, Yu.S."]
  status Standard
class Eq10_and_11 where
  /--
  Equations (10) and (11) (page 86): The Topological Action Bound.
  Abstracted to a real Hilbert space equipped with an isometric involution (the Hodge star).
  The energy is bounded below by the topological charge, and the bound is saturated 
  iff the field is self-dual or anti-self-dual.
  -/
  topological_energy_bound
    (V : Type*) [NormedAddCommGroup V] [InnerProductSpace ℝ V]
    (star : V → V)
    (h_star_isometry : ∀ v, ‖star v‖ = ‖v‖) :
    ∀ (v : V),
      let E := (1 / 2 : ℝ) * ‖v‖^2
      let Q := (1 / 2 : ℝ) * inner ℝ v (star v)
      |Q| ≤ E ∧
      (star v = v ∨ star v = -v → E = |Q|)

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
  Capstone Theorem: BPST Profile Uniqueness.
  The only regular solutions to the BPST self-dual radial ODE 
  that vanish at infinity are the 1-parameter family of instanton profiles 
  f(r) = 2 / (r^2 + λ^2). This mathematically rigidifies the Moduli Uniqueness 
  for the spherically symmetric ansatz without using unconstrained predicates.
  -/
  bpst_profile_uniqueness
    (f : ℝ → ℝ)
    (hf_diff : DifferentiableOn ℝ f (Set.Ioi 0))
    (hf_ode : ∀ r > 0, deriv f r / r + (f r)^2 = 0)
    (hf_limit : Tendsto f atTop (nhds 0))
    (hf_pos : ∃ r > 0, f r > 0) :
    ∃ (lam : ℝ), lam > 0 ∧ ∀ r > 0, f r = 2 / (r^2 + lam^2)

end Litlib.Y1975.belavin1975pseudoparticle
