-- FILENAME: Litlib/Y1981/goldstone1981fractional/Signature.lean

import Litlib.Core
import Mathlib.Data.Real.Basic
import Mathlib.Analysis.SpecialFunctions.Trigonometric.Arctan
import Mathlib.Data.Fintype.Basic

open Finset

namespace Litlib.Y1981.goldstone1981fractional

Litlib.paper "goldstone1981fractional"
  type "article"
  title "Fractional Quantum Numbers on Solitons"
  authors ["Goldstone, Jeffrey", "Wilczek, Frank"]
  journal "Physical Review Letters"
  year "1981"

Litlib.equation "goldstone1981fractional" eq "2" page "988" kind "equation"
class Eq2
  (phi : Fin 2 → (Fin 2 → ℝ) → ℝ)
  (deriv_ : Fin 2 → ((Fin 2 → ℝ) → ℝ) → (Fin 2 → ℝ) → ℝ)
  (j : Fin 2 → (Fin 2 → ℝ) → ℝ)
  (eps : Fin 2 → Fin 2 → ℝ)
  where
  is_eps : eps 0 1 = 1 ∧ eps 1 0 = -1 ∧ eps 0 0 = 0 ∧ eps 1 1 = 0
  phi_not_zero : ∀ x, phi 0 x ^ 2 + phi 1 x ^ 2 ≠ 0
  eq2_part1 : ∀ (mu : Fin 2) (x : Fin 2 → ℝ),
    j mu x = (1 / (2 * Real.pi)) * ∑ nu : Fin 2, ∑ a : Fin 2, ∑ b : Fin 2,
      eps mu nu * eps a b * (phi a x * deriv_ nu (phi b) x) / (phi 0 x ^ 2 + phi 1 x ^ 2)
  eq2_part2 : ∀ (mu : Fin 2) (x : Fin 2 → ℝ),
    j mu x = (1 / (2 * Real.pi)) * ∑ nu : Fin 2,
      eps mu nu * deriv_ nu (fun y => Real.arctan (phi 1 y / phi 0 y)) x

Litlib.equation "goldstone1981fractional" eq "3" page "988" kind "equation"
class Eq3
  (Q g v m : ℝ)
  where
  eq3 : Q = (1 / Real.pi) * Real.arctan (g * v / m)

Litlib.equation "goldstone1981fractional" eq "6" page "989" kind "equation"
class Eq6
  (phi : Fin 4 → (Fin 4 → ℝ) → ℝ)
  (deriv_ : Fin 4 → ((Fin 4 → ℝ) → ℝ) → (Fin 4 → ℝ) → ℝ)
  (j : Fin 4 → (Fin 4 → ℝ) → ℝ)
  (eps : Fin 4 → Fin 4 → Fin 4 → Fin 4 → ℝ)
  where
  phi_not_zero : ∀ x, (∑ i : Fin 4, phi i x ^ 2) ≠ 0
  eq6 : ∀ (mu : Fin 4) (x : Fin 4 → ℝ),
    j mu x = (1 / (12 * Real.pi ^ 2 * (∑ i : Fin 4, phi i x ^ 2) ^ 2)) *
      ∑ alpha : Fin 4, ∑ beta : Fin 4, ∑ gamma : Fin 4,
      ∑ d : Fin 4, ∑ a : Fin 4, ∑ b : Fin 4, ∑ c : Fin 4,
      eps mu alpha beta gamma * eps d a b c *
      phi d x * deriv_ alpha (phi a) x * deriv_ beta (phi b) x * deriv_ gamma (phi c) x

Litlib.equation "goldstone1981fractional" eq "9" page "989" kind "equation"
class Eq9
  (fermionNumber e Phi g v m : ℝ)
  where
  eq9 : fermionNumber = (e * Phi / (4 * Real.pi ^ 2)) * Real.arctan (g * v / m)

end Litlib.Y1981.goldstone1981fractional
