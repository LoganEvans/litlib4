-- FILENAME: Litlib/Y1973/nielsen1973vortex/Signature.lean

import Litlib.Core
import Mathlib.Data.Real.Basic
import Mathlib.Analysis.Calculus.Deriv.Basic
import Mathlib.Topology.Basic
import Mathlib.Order.Filter.Basic

open Filter Topology

namespace Litlib.Y1973.nielsen1973vortex

Litlib.paper "nielsen1973vortex"
  type "article"
  title "Vortex-line models for dual strings"
  authors ["Nielsen, Holger Bech", "Olesen, Poul"]
  journal "Nuclear Physics B"
  volume "61"
  pages "45--61"
  year "1973"
  publisher "Elsevier"
  doi "10.1016/0550-3213(73)90350-7"

Litlib.equation "nielsen1973vortex"
  eq "2.19"
  page "49"
  kind "theorem"
class Eq2_19 where
  /-- 
  Physical Interpretation: Vacuum State Symmetry Breaking.
  Equation (2.19) (page 49) identifies the symmetry-breaking vacuum expectation 
  value of the scalar field that minimizes the classical Higgs potential 
  V(|ϕ|) = -c₂|ϕ|² + c₄|ϕ|⁴.
  
  Mathematical Boundaries: The strict positivity constraints `0 < c₂` and `0 < c₄` 
  ensure the potential is bounded from below and exhibits a non-trivial global 
  minimum, preventing vacuum instability or a trivial (zero) field state.
  -/
  vacuumValue (c₂ c₄ : ℝ) (hc₂ : 0 < c₂) (hc₄ : 0 < c₄) (ϕ₀ : ℝ) (hϕ₀Pos : 0 < ϕ₀) (hϕ₀Sq : ϕ₀^2 = c₂ / (2 * c₄)) :
    ∀ x : ℝ, (- c₂ * ϕ₀^2 + c₄ * ϕ₀^4) ≤ (- c₂ * x^2 + c₄ * x^4)

Litlib.equation "nielsen1973vortex"
  eq "2.21"
  page "49"
  kind "theorem"
class Eq2_21 where
  /-- 
  Physical Interpretation: Scalar Mass Generation (Higgs Mechanism).
  Equation (2.21) (page 49) establishes the physical mass-squared of the 
  scalar boson as the curvature (second derivative) of the potential evaluated 
  at the broken symmetry vacuum.

  Mathematical Boundaries: The potential is mathematically a smooth polynomial over ℝ. 
  The positivity constraints `0 < c₂` and `0 < c₄` mathematically guarantee a strictly 
  positive curvature at the minimum, yielding a physical, non-tachyonic scalar mass.
  -/
  scalarMassSq (c₂ c₄ ϕ₀ : ℝ) (hc₂ : 0 < c₂) (hc₄ : 0 < c₄) (hϕ₀Sq : ϕ₀^2 = c₂ / (2 * c₄)) :
    let V := fun ρ => (1/2 : ℝ) * (- c₂ * (ϕ₀ + ρ)^2 + c₄ * (ϕ₀ + ρ)^4)
    deriv (deriv V) 0 = 2 * c₂

Litlib.equation "nielsen1973vortex"
  eq "2.12, 2.13"
  page "48"
  kind "theorem"
class Eq2_12_13 where
  /--
  Physical Interpretation: The Nielsen-Olesen Vortex Solution.
  Equations (2.12) and (2.13) (page 48) postulate the existence of a topologically 
  stable, cylindrically symmetric vortex string solution to the Abelian Higgs model 
  equations of motion.
  
  Mathematical Boundaries (Topological Gatekeeping): 
  The fields `f` (magnitude) and `A` (gauge) must be continuously defined from 
  the origin and differentiable on the open ray `r > 0`. The boundary limits at 
  infinity enforce the topological flux quantization, while the origin conditions 
  prevent singular behavior in the center of the vortex. The strict inequalities 
  `0 < c₂`, `0 < c₄`, and `0 < e` prevent topological collapse to a trivial state 
  and ensure well-posed Euler-Lagrange trajectories.
  -/
  existsVortexSolution
    (c₂ c₄ e ϕ₀ : ℝ)
    (hc₂ : 0 < c₂) (hc₄ : 0 < c₄) (he : 0 < e)
    (hϕ₀ : ϕ₀^2 = c₂ / (2 * c₄)) :
    ∃ (f A : ℝ → ℝ),
      (ContinuousOn f (Set.Ici 0)) ∧ 
      (ContinuousOn A (Set.Ici 0)) ∧
      (DifferentiableOn ℝ f (Set.Ioi 0)) ∧
      (DifferentiableOn ℝ A (Set.Ioi 0)) ∧
      (DifferentiableOn ℝ (fun x => x * deriv f x) (Set.Ioi 0)) ∧
      (DifferentiableOn ℝ (fun x => (1 / x) * deriv (fun y => y * A y) x) (Set.Ioi 0)) ∧
      (Tendsto f atTop (nhds ϕ₀)) ∧ 
      (Tendsto (fun r => e * r * A r) atTop (nhds 1)) ∧ 
      (f 0 = 0) ∧ (A 0 = 0) ∧
      (∀ r > 0, 
        - (1 / r) * deriv (fun x => x * deriv f x) r + ((1 / r - e * A r)^2 - 2 * c₂ + 4 * c₄ * (f r)^2) * f r = 0) ∧
      (∀ r > 0, 
        - deriv (fun x => (1 / x) * deriv (fun y => y * A y) x) r + (f r)^2 * (A r * e^2 - e / r) = 0)

end Litlib.Y1973.nielsen1973vortex
