-- FILENAME: Litlib/Y1978/callan1978toward/Signature.lean

import Litlib.Core
import Mathlib.Data.Real.Basic
import Mathlib.Analysis.SpecialFunctions.Trigonometric.Basic
import Mathlib.Analysis.SpecialFunctions.Log.Basic
import Mathlib.Analysis.SpecialFunctions.Exp

namespace Litlib.Y1978.callan1978toward

Litlib.paper "callan1978toward"
  type "article"
  title "Toward a theory of the strong interactions"
  authors ["Callan, Curtis G.", "Dashen, Roger", "Gross, David J."]
  journal "Physical Review D"
  year "1978"

Litlib.equation "callan1978toward" eq "1.2" page "2718" kind "equation"
class Eq1_2
  (P : ℝ → ℝ → ℝ)
  (beta : ℝ → ℝ)
  (partial_mu : (ℝ → ℝ → ℝ) → ℝ → ℝ → ℝ)
  (partial_g : (ℝ → ℝ → ℝ) → ℝ → ℝ → ℝ)
  where
  eq1_2 : ∀ g mu, mu * partial_mu P g mu + beta g * partial_g P g mu = 0

Litlib.equation "callan1978toward" eq "2.25" page "2727" kind "equation"
class Eq2_25
  (E : ℝ → ℝ)
  (E_0 V D g : ℝ)
  where
  eq2_25 : ∀ theta, E theta = E_0 - 2 * Real.cos theta * V * D * Real.exp (- (8 * Real.pi ^ 2 / g ^ 2))

Litlib.equation "callan1978toward" eq "3.2" page "2735" kind "equation"
class Eq3_2
  (g_bar : ℝ → ℝ)
  (g_0 : ℝ)
  (mu : ℝ)
  (C : ℝ)
  where
  eq3_2 : ∀ rho, 8 * Real.pi ^ 2 / (g_bar rho) ^ 2 =
    8 * Real.pi ^ 2 / g_0 ^ 2 + (22 / 3) * Real.log (1 / (rho * mu)) + C

Litlib.equation "callan1978toward" eq "3.8" page "2736" kind "equation"
class Eq3_8
  (D : ℝ → ℝ)
  (g_bar : ℝ → ℝ)
  where
  eq3_8 : ∀ rho, D rho = (1 / rho ^ 5) * 0.26 * (8 * Real.pi ^ 2 / (g_bar rho) ^ 2) ^ 4 * Real.exp (- (8 * Real.pi ^ 2 / (g_bar rho) ^ 2))

end Litlib.Y1978.callan1978toward
