-- FILENAME: Litlib/Y2003/nakahara2003geometry/Chapter10/Sec5_GaugeTheories.lean

import Litlib.Core
import Mathlib.Data.Real.Basic
import Mathlib.Data.Complex.Basic
import Mathlib.Topology.Basic
import Mathlib.MeasureTheory.Measure.MeasureSpace
import Mathlib.Analysis.SpecialFunctions.Trigonometric.Basic

open BigOperators

namespace Litlib.Y2003.nakahara2003geometry

Litlib.equation "nakahara2003geometry"
  eq "10.85a"
  page "27"
  kind "equation"
class MaxwellAction
    (Space Form2 : Type _) [MeasureTheory.MeasureSpace Space] [TopologicalSpace Space] [Nonempty Form2]
    (F : Form2)
    (wedgeStar : Form2 → Form2 → Space → ℝ)
    (integral : (Space → ℝ) → ℝ)
    (action : Form2 → ℝ) where
  h_nontrivial : ∃ f, Continuous (wedgeStar f f) ∧ integral (wedgeStar f f) ≠ 0
  maxwell_action : Continuous (wedgeStar F F) → action F = - (1/4) * integral (wedgeStar F F)

Litlib.equation "nakahara2003geometry"
  eq "10.88a"
  page "27"
  kind "equation"
class VacuumMaxwellEquations
    (Index Point : Type _) [Fintype Index] [TopologicalSpace Point] [Nonempty Point]
    (F : Index → Index → Point → ℝ)
    (partialDeriv : Index → (Point → ℝ) → Point → ℝ)
    (isDifferentiable : (Point → ℝ) → Prop) where
  h_nontrivial : ∃ mu nu p, F mu nu p ≠ 0
  maxwell_eq : ∀ nu p, isDifferentiable (fun x => F mu nu x) → (∑ mu, partialDeriv mu (fun x => F mu nu x) p) = 0

Litlib.equation "nakahara2003geometry"
  eq "10.93"
  page "28"
  kind "equation"
class DiracQuantization
    (MagneticCharge : Type _) [Nonempty MagneticCharge]
    (deltaPhi : MagneticCharge → ℝ)
    (g : MagneticCharge → ℝ) where
  h_nontrivial : ∃ m, g m ≠ 0
  quantization : ∀ m, ∃ n : ℤ, deltaPhi m / (2 * Real.pi) = 2 * g m ∧ 2 * g m = (n : ℝ)

Litlib.equation "nakahara2003geometry"
  eq "10.100"
  page "30"
  kind "equation"
class AharonovBohmPhase
    (Flux : Type _) [Nonempty Flux]
    (phi : Flux → ℝ)
    (e : ℝ) where
  h_nontrivial : e ≠ 0
  ab_phase : ∀ a b : Flux, ∃ n : ℤ, e * (phi a - phi b) = 2 * Real.pi * (n : ℝ)

Litlib.equation "nakahara2003geometry"
  eq "10.108"
  page "32"
  kind "equation"
class YangMillsAction
    (Space Form2 : Type _) [MeasureTheory.MeasureSpace Space] [TopologicalSpace Space] [Nonempty Form2]
    (F : Form2)
    (wedgeStar : Form2 → Form2 → Space → ℝ)
    (trace : ℝ → ℝ)
    (integral : (Space → ℝ) → ℝ)
    (action : Form2 → ℝ) where
  h_nontrivial : ∃ f, Continuous (fun x => trace (wedgeStar f f x)) ∧ integral (fun x => trace (wedgeStar f f x)) ≠ 0
  ym_action : Continuous (fun x => trace (wedgeStar F F x)) → action F = (1/2) * integral (fun x => trace (wedgeStar F F x))

Litlib.equation "nakahara2003geometry"
  eq "10.111"
  page "32"
  kind "equation"
class InstantonCondition 
    (Index Point : Type _) [TopologicalSpace Point] [Nonempty Point] [Nonempty Index]
    (F : Index → Index → Point → ℝ)
    (hodgeStarF : Index → Index → Point → ℝ)
    (isInstanton : Point → Prop) where
  h_nontrivial : ∃ mu nu p, Continuous (fun p => F mu nu p) ∧ F mu nu p ≠ 0
  is_instanton_iff : 
    ∀ p, isInstanton p ↔ 
      (∀ mu nu, F mu nu p = hodgeStarF mu nu p) ∨ 
      (∀ mu nu, F mu nu p = - hodgeStarF mu nu p)

Litlib.equation "nakahara2003geometry"
  eq "10.113"
  page "32"
  kind "equation"
class PureGaugeAsymptotic
    (Point GaugePotential GroupElement : Type _) [TopologicalSpace Point] [TopologicalSpace GaugePotential] [TopologicalSpace GroupElement] [Nonempty GaugePotential] [Nonempty GroupElement]
    (norm : Point → ℝ)
    (A : Point → GaugePotential)
    (g : Point → GroupElement)
    (pureGauge : GroupElement → GaugePotential)
    (limit_at_inf : (Point → GaugePotential) → (Point → GaugePotential) → Prop) where
  h_nontrivial : ∃ p, norm p > 0 ∧ Continuous A ∧ Continuous g
  asymptotic_condition : limit_at_inf A (fun x => pureGauge (g x))

Litlib.equation "nakahara2003geometry"
  eq "10.120"
  page "34"
  kind "lemma"
class ChernSimonsThreeForm
    (Form : Type _) [TopologicalSpace Form] [AddCommGroup Form] [Nonempty Form]
    (A : Form)
    (extDeriv : Form → Form)
    (wedge : Form → Form → Form)
    (trace : Form → Form)
    (K : Form)
    (scalarMult : ℝ → Form → Form) where
  h_nontrivial : K ≠ 0 ∧ Continuous extDeriv
  chern_simons : K = trace (wedge A (extDeriv A) + scalarMult (2/3) (wedge A (wedge A A)))

Litlib.equation "nakahara2003geometry"
  eq "10.128"
  page "36"
  kind "theorem"
class CartanMaurerTopology 
    (GroupMap : Type _) [TopologicalSpace GroupMap] [Nonempty GroupMap]
    (isSmooth : GroupMap → Prop)
    (windingNumber : GroupMap → ℤ)
    (cartanMaurerIntegral : GroupMap → ℝ) where
  -- Anti-BS constraint
  h_nontrivial_map : ∃ g, isSmooth g ∧ windingNumber g ≠ 0
  degreeTheorem :
    ∀ g : GroupMap, isSmooth g → cartanMaurerIntegral g = (windingNumber g : ℝ)
  homotopyInvariance
    (H : ℝ → GroupMap)
    (hCont : Continuous H) :
    ∀ t1 t2 : ℝ, windingNumber (H t1) = windingNumber (H t2)

end Litlib.Y2003.nakahara2003geometry
