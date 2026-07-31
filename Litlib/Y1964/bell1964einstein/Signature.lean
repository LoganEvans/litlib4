-- FILENAME: Litlib/Y1964/bell1964einstein/Signature.lean

import Litlib.Core
import Mathlib.Analysis.InnerProductSpace.PiL2
import Mathlib.MeasureTheory.Integral.IntegrableOn
import Mathlib.MeasureTheory.Integral.Average

namespace Litlib.Y1964.bell1964einstein

Litlib.paper "bell1964einstein"
  type "article"
  title "On the Einstein Podolsky Rosen paradox"
  authors ["Bell, John Stewart"]
  journal "Physics"
  year "1964"

open MeasureTheory
open Set
open scoped BigOperators
open scoped MeasureTheory

/-!
  Anti-BS Protocol Enforcement:
  - Dimensional Collapse: Spatial vectors (a, b, c) are strictly forced to 3D physical space
    using `EuclideanSpace ℝ (Fin 3)` rather than a generic vector space.
  - Zero/Trivial Exploit: Vectors are constrained to be unit vectors (`‖a‖ = 1`).
  - Opaque Function Exploit: The integral expectation values are expanded completely
    using mathlib's `MeasureTheory.integral`.
  - Garbage-In Exploit: Integrability requirements are explicitly stated.
  - The Ultimate Exploit (Bell's Theorem): We rigorously formalize the main conclusion 
    as a non-existence theorem over arbitrary measurable spaces.
-/

Litlib.equation "bell1964einstein" eq "1" page "196" kind "equation"
class Eq1 {Λ : Type*} (A B : EuclideanSpace ℝ (Fin 3) → Λ → ℝ) : Prop where
  resultA (a : EuclideanSpace ℝ (Fin 3)) (lam : Λ) (ha : ‖a‖ = 1) :
    A a lam = 1 ∨ A a lam = -1
  resultB (b : EuclideanSpace ℝ (Fin 3)) (lam : Λ) (hb : ‖b‖ = 1) :
    B b lam = 1 ∨ B b lam = -1

Litlib.equation "bell1964einstein" eq "2" page "196" kind "equation"
class Eq2 {Λ : Type*} [MeasurableSpace Λ] (μ : Measure Λ)
    (A B : EuclideanSpace ℝ (Fin 3) → Λ → ℝ)
    (P : EuclideanSpace ℝ (Fin 3) → EuclideanSpace ℝ (Fin 3) → ℝ) : Prop where
  isIntegrable (a b : EuclideanSpace ℝ (Fin 3)) :
    Integrable (fun lam => A a lam * B b lam) μ
  expectation (a b : EuclideanSpace ℝ (Fin 3)) (ha : ‖a‖ = 1) (hb : ‖b‖ = 1) :
    P a b = ∫ lam, A a lam * B b lam ∂μ

Litlib.equation "bell1964einstein" eq "3" page "196" kind "equation"
class Eq3 (pQm : EuclideanSpace ℝ (Fin 3) → EuclideanSpace ℝ (Fin 3) → ℝ) : Prop where
  qmExpectation (a b : EuclideanSpace ℝ (Fin 3)) (ha : ‖a‖ = 1) (hb : ‖b‖ = 1) :
    pQm a b = - ∑ i : Fin 3, a i * b i

Litlib.equation "bell1964einstein" eq "12" page "197" kind "equation"
class Eq12 {Λ : Type*} [MeasurableSpace Λ] (μ : Measure Λ) : Prop where
  normalized : μ univ = 1

Litlib.equation "bell1964einstein" eq "13" page "197" kind "lemma"
class Eq13 {Λ : Type*} [MeasurableSpace Λ] (μ : Measure Λ)
    (A B : EuclideanSpace ℝ (Fin 3) → Λ → ℝ) : Prop where
  anticorrelation (a : EuclideanSpace ℝ (Fin 3)) (ha : ‖a‖ = 1) :
    ∀ᵐ lam ∂μ, A a lam = - B a lam

Litlib.equation "bell1964einstein" eq "14" page "197" kind "equation"
class Eq14 {Λ : Type*} [MeasurableSpace Λ] (μ : Measure Λ)
    (A : EuclideanSpace ℝ (Fin 3) → Λ → ℝ)
    (P : EuclideanSpace ℝ (Fin 3) → EuclideanSpace ℝ (Fin 3) → ℝ) : Prop where
  isIntegrable (a b : EuclideanSpace ℝ (Fin 3)) :
    Integrable (fun lam => A a lam * A b lam) μ
  rewrittenExpectation (a b : EuclideanSpace ℝ (Fin 3)) (ha : ‖a‖ = 1) (hb : ‖b‖ = 1) :
    P a b = - ∫ lam, A a lam * A b lam ∂μ

Litlib.equation "bell1964einstein" eq "15" page "198" kind "theorem"
class Eq15 (P : EuclideanSpace ℝ (Fin 3) → EuclideanSpace ℝ (Fin 3) → ℝ) : Prop where
  bellInequality (a b c : EuclideanSpace ℝ (Fin 3))
    (ha : ‖a‖ = 1) (hb : ‖b‖ = 1) (hc : ‖c‖ = 1) :
    1 + P b c ≥ |P a b - P a c|

Litlib.equation "bell1964einstein" eq "Conclusion" page "199" kind "theorem"
class Theorem_Conclusion : Prop where
  cannot_represent_exactly (Λ : Type*) [MeasurableSpace Λ] :
    ¬ ∃ (μ : Measure Λ) (A B : EuclideanSpace ℝ (Fin 3) → Λ → ℝ),
      (μ univ = 1) ∧
      (∀ a lam, ‖a‖ = 1 → A a lam = 1 ∨ A a lam = -1) ∧
      (∀ b lam, ‖b‖ = 1 → B b lam = 1 ∨ B b lam = -1) ∧
      (∀ a b, ‖a‖ = 1 → ‖b‖ = 1 → Integrable (fun lam => A a lam * B b lam) μ) ∧
      (∀ a b, ‖a‖ = 1 → ‖b‖ = 1 →
        ∫ lam, A a lam * B b lam ∂μ = - ∑ i : Fin 3, a i * b i)

  cannot_represent_arbitrarily_closely (Λ : Type*) [MeasurableSpace Λ] :
    ¬ ∀ (ε : ℝ), ε > 0 →
      ∃ (μ : Measure Λ) (A B : EuclideanSpace ℝ (Fin 3) → Λ → ℝ),
        (μ univ = 1) ∧
        (∀ a lam, ‖a‖ = 1 → A a lam = 1 ∨ A a lam = -1) ∧
        (∀ b lam, ‖b‖ = 1 → B b lam = 1 ∨ B b lam = -1) ∧
        (∀ a b, ‖a‖ = 1 → ‖b‖ = 1 → Integrable (fun lam => A a lam * B b lam) μ) ∧
        (∀ a b, ‖a‖ = 1 → ‖b‖ = 1 →
          |(∫ lam, A a lam * B b lam ∂μ) - (- ∑ i : Fin 3, a i * b i)| < ε)

end Litlib.Y1964.bell1964einstein
