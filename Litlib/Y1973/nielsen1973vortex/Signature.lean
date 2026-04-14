-- FILENAME: Litlib/Y1973/nielsen1973vortex/Signature.lean

import Litlib.Core
import Mathlib.Data.Real.Basic
import Mathlib.Analysis.Calculus.Deriv.Basic
import Mathlib.Topology.Basic
import Mathlib.Order.Filter.Basic

open Filter Topology

namespace Litlib.Y1973.nielsen1973vortex

literature_citation Eq2_19
  bibtex_key "nielsen1973vortex"
  doi "10.1016/0550-3213(73)90350-7"
  authors["Nielsen, H.B.", "Olesen, P."]
  status Standard
class Eq2_19 where
  /-- Equation (2.19) (page 49): The vacuum-value of the field |ϕ| which 
      minimizes the classical potential V(|ϕ|) = -c₂|ϕ|² + c₄|ϕ|⁴. -/
  vacuum_value (c₂ c₄ : ℝ) (hc₂ : 0 < c₂) (hc₄ : 0 < c₄) (ϕ₀ : ℝ) (hϕ₀_pos : 0 < ϕ₀) (hϕ₀_sq : ϕ₀^2 = c₂ / (2 * c₄)) :
    ∀ x : ℝ, (- c₂ * ϕ₀^2 + c₄ * ϕ₀^4) ≤ (- c₂ * x^2 + c₄ * x^4)

literature_citation Eq2_21
  bibtex_key "nielsen1973vortex"
  doi "10.1016/0550-3213(73)90350-7"
  authors ["Nielsen, H.B.", "Olesen, P."]
  status Standard
class Eq2_21 where
  /-- Equation (2.21) (page 49): The mass square of the scalar particle is given by 
      the second derivative of the potential at the vacuum minimum. -/
  scalar_mass_sq (c₂ c₄ ϕ₀ : ℝ) (hc₂ : 0 < c₂) (hc₄ : 0 < c₄) (hϕ₀_sq : ϕ₀^2 = c₂ / (2 * c₄)) :
    let V := fun ρ => (1/2 : ℝ) * (- c₂ * (ϕ₀ + ρ)^2 + c₄ * (ϕ₀ + ρ)^4)
    deriv (deriv V) 0 = 2 * c₂

literature_citation NielsenOlesenVortex
  bibtex_key "nielsen1973vortex"
  doi "10.1016/0550-3213(73)90350-7"
  authors ["Nielsen, H.B.", "Olesen, P."]
  status Standard
class NielsenOlesenVortex where
  /--
  Capstone Theorem: Nielsen-Olesen Vortex.
  The classical Euler-Lagrange equations for the Abelian Higgs model 
  admit a regular vortex solution satisfying the topological boundary conditions.
  -/
  exists_vortex_solution
    (c₂ c₄ ϕ₀ : ℝ)
    (h_c₂ : 0 < c₂) (h_c₄ : 0 < c₄)
    (h_ϕ₀ : 0 < ϕ₀ ∧ ϕ₀^2 = c₂ / (2 * c₄)) :
    ∃ (f a : ℝ → ℝ),
      (Tendsto f atTop (nhds ϕ₀)) ∧ 
      (Tendsto a atTop (nhds 1)) ∧ 
      (f 0 = 0) ∧ (a 0 = 0) ∧
      (∀ r > 0, 
        deriv (deriv f) r + (1 / r) * deriv f r - ((1 - a r)^2 / r^2) * f r + c₂ * f r - 2 * c₄ * (f r)^3 = 0) ∧
      (∀ r > 0, 
        deriv (deriv a) r - (1 / r) * deriv a r + (f r)^2 * (1 - a r) = 0)

end Litlib.Y1973.nielsen1973vortex
