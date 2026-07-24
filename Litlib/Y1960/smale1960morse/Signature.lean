-- FILENAME: Litlib/Y1960/smale1960morse/Signature.lean

import Litlib.Core
import Mathlib

open Finset

Litlib.paper "smale1960morse"
  type "article"
  title "Morse inequalities for a dynamical system"
  authors ["Smale, S."]
  journal "Bulletin of the American Mathematical Society"
  year "1960"

Litlib.equation "smale1960morse" eq "1.1" page "44" kind "theorem"
class Theorem1_1 (n : ℕ) (a b R : ℕ → ℕ) (chi : ℤ) : Prop where
  morse_inequalities : ∀ m : ℕ, m ≤ n →
    (∑ k ∈ range (m + 1), (-1 : ℤ) ^ (m - k) * ((a k + b k + b (k + 1)) : ℤ)) ≥
    (∑ k ∈ range (m + 1), (-1 : ℤ) ^ (m - k) * (R k : ℤ))
  euler_characteristic :
    (∑ k ∈ range (n + 1), (-1 : ℤ) ^ k * ((a k + b k + b (k + 1)) : ℤ)) = (-1 : ℤ) ^ n * chi

Litlib.equation "smale1960morse" eq "1.3" page "43" kind "condition"
class Condition3 (M : Type*) [TopologicalSpace M]
  (phi : ℝ → M → M) -- 1-parameter group of transformations
  (beta : Set M) -- The union of the β_i (singular points and closed orbits)
  where
  -- Anti-BS Protocol: The flow must actually be a valid dynamical flow.
  flow_zero : ∀ x, phi 0 x = x
  flow_add : ∀ s t x, phi (s + t) x = phi s (phi t x)
  
  -- Condition 3: "The limit points of all the orbits of X as t -> ±∞ lie on the β_i."
  -- We explicitly define the ω-limit and α-limit sets using rigorous topological 
  -- sequences to prevent "Opaque Function" boundary exploits.
  omega_limit_in_beta : ∀ (y x : M),
    (∃ (seq : ℕ → ℝ), Filter.Tendsto seq Filter.atTop Filter.atTop ∧
      Filter.Tendsto (fun n => phi (seq n) y) Filter.atTop (nhds x)) →
    x ∈ beta
    
  alpha_limit_in_beta : ∀ (y x : M),
    (∃ (seq : ℕ → ℝ), Filter.Tendsto seq Filter.atTop Filter.atBot ∧
      Filter.Tendsto (fun n => phi (seq n) y) Filter.atTop (nhds x)) →
    x ∈ beta

Litlib.equation "smale1960morse" eq "4.1" page "48" kind "theorem"
class Theorem4_1 (n : ℕ) (mSeq bSeq : ℕ → ℕ) : Prop where
  morse_inequalities : ∀ m : ℕ, m ≤ n →
    (∑ k ∈ range (m + 1), (-1 : ℤ) ^ (m - k) * (mSeq k : ℤ)) ≥
    (∑ k ∈ range (m + 1), (-1 : ℤ) ^ (m - k) * (bSeq k : ℤ))
  euler_characteristic :
    (∑ k ∈ range (n + 1), (-1 : ℤ) ^ k * (mSeq k : ℤ)) =
    (∑ k ∈ range (n + 1), (-1 : ℤ) ^ k * (bSeq k : ℤ))
