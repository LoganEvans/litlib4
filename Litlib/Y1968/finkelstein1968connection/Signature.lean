-- FILENAME: Litlib/Y1968/finkelstein1968connection/Signature.lean

import Litlib.Core
import Mathlib.Topology.Homotopy.Basic
import Mathlib.Topology.ContinuousMap.Basic
import Mathlib.Topology.UnitInterval

/-!
# Connection between Spin, Statistics, and Kinks (Finkelstein & Rubinstein, 1968)

Formalizes the topological foundation of spin-statistics for kinks in nonlinear field theories:
- Section I: Classical fields φ : ℝ³ → Φ with boundary condition φ(x) → φ₀ as |x| → ∞.
  Configuration space Q = Φ^X(φ₀) partitioned into homotopy classes Q_n ≅ π₃(Φ).
- Section II: Multivalued quantization on covering space CQ_n; π₁(Q_n) ≅ π₄(Φ).
- Section III: Extrinsic 2π rotation loop Wᵉ with (Wᵉ)² ~ 1 in 3 dimensions (Eq. 21).
- Section IV: Two-kink exchange loop Xᵐ with (Xᵐ)² ~ 1 in 3 dimensions (Eq. 31).
- Section V: Theorem V.1: Homotopy equivalence between exchange Xᵐ and 2π rotation Wᵉ (Xᵐ ~ Wᵉ),
  establishing that a kink sector admits half-odd extrinsic spin iff it admits odd statistics.
- Section V.5: Even kink states have strictly integer spin.
-/

namespace Litlib.Y1968.finkelstein1968connection

Litlib.paper "finkelstein1968connection"
  type "article"
  title "Connection between Spin, Statistics, and Kinks"
  authors ["Finkelstein, David", "Rubinstein, Julio"]
  journal "Journal of Mathematical Physics"
  year "1968"

/-- 3-dimensional Euclidean space X = ℝ³. -/
abbrev Space3D := Fin 3 → ℝ

/-- Configuration space Q of continuous classical fields φ : ℝ³ → Φ asymptotic to φ₀. -/
structure AsymptoticField (Φ : Type*) [TopologicalSpace Φ] (ϕ₀ : Φ) where
  toFun : Space3D → Φ
  continuous_toFun : Continuous toFun
  asymptotic_at_infty : ∀ (ε : Set Φ), IsOpen ε → ϕ₀ ∈ ε →
    ∃ (R : ℝ), ∀ (x : Space3D), (∑ i, (x i) ^ 2) > R ^ 2 → toFun x ∈ ε

/-- Continuous flow (loop) in configuration space Q parameterized by s ∈ [0, 1]. -/
structure FieldLoop {Φ : Type*} [TopologicalSpace Φ] {ϕ₀ : Φ}
    (baseField : AsymptoticField Φ ϕ₀) where
  toFun : unitInterval → Space3D → Φ
  continuous_toFun : Continuous (fun (p : unitInterval × Space3D) ↦ toFun p.1 p.2)
  start_eq : ∀ x, toFun 0 x = baseField.toFun x
  end_eq : ∀ x, toFun 1 x = baseField.toFun x

/-- Homotopy relative to endpoints between two closed flows (loops) in Q. -/
def loopsHomotopic {Φ : Type*} [TopologicalSpace Φ] {ϕ₀ : Φ}
    {baseField : AsymptoticField Φ ϕ₀}
    (loopA loopB : FieldLoop baseField) : Prop :=
  ∃ (H : unitInterval → unitInterval → Space3D → Φ),
    Continuous (fun (p : unitInterval × unitInterval × Space3D) ↦ H p.1 p.2.1 p.2.2) ∧
    (∀ s x, H 0 s x = loopA.toFun s x) ∧
    (∀ s x, H 1 s x = loopB.toFun s x) ∧
    (∀ t x, H t 0 x = baseField.toFun x) ∧
    (∀ t x, H t 1 x = baseField.toFun x)

/-- Constant identity loop at baseField. -/
def constantLoop {Φ : Type*} [TopologicalSpace Φ] {ϕ₀ : Φ}
    (baseField : AsymptoticField Φ ϕ₀) : FieldLoop baseField where
  toFun _ x := baseField.toFun x
  continuous_toFun := baseField.continuous_toFun.comp continuous_snd
  start_eq _ := rfl
  end_eq _ := rfl

Litlib.equation "finkelstein1968connection" eq "21" page "1768" kind "theorem"
/-- Equation (21) / Section III.4:
A 4π spatial rotation (the double loop (Wᵉ)² of a 2π rotation loop Wᵉ) in 3 dimensions is
homotopic to the constant identity loop in configuration space Q: (Wᵉ)² ~ 1. -/
class Eq21_RotationDoubleLoopContractible {Φ : Type*} [TopologicalSpace Φ] {ϕ₀ : Φ}
    (baseField : AsymptoticField Φ ϕ₀)
    (We_4pi : FieldLoop baseField) : Prop where
  double_rotation_homotopic_to_id :
    loopsHomotopic We_4pi (constantLoop baseField)

Litlib.equation "finkelstein1968connection" eq "31" page "1770" kind "theorem"
/-- Equation (31) / Section IV.4:
A double exchange of two identical kinks of type m, (Xᵐ)², is homotopic to the constant loop:
(Xᵐ)² ~ 1. This forbids parastatistics in 3 dimensions. -/
class Eq31_ExchangeDoubleLoopContractible {Φ : Type*} [TopologicalSpace Φ] {ϕ₀ : Φ}
    (twoKinkField : AsymptoticField Φ ϕ₀)
    (Xm_double : FieldLoop twoKinkField) : Prop where
  double_exchange_homotopic_to_id :
    loopsHomotopic Xm_double (constantLoop twoKinkField)

Litlib.equation "finkelstein1968connection" eq "41-42" page "1771" kind "theorem"
/-- Theorem V.1 / Equations (41)-(42):
The exchange loop Xᵐ for two kinks of type m is homotopic to the 2π extrinsic spatial rotation loop
Wᵉ on a single kink (Xᵐ ~ Wᵉ). Consequently, Q_m admits half-odd extrinsic spin if and only if it
admits odd (Fermi-Dirac) exchange statistics. -/
class Theorem_SpinStatisticsKinks {Φ : Type*} [TopologicalSpace Φ] {ϕ₀ : Φ}
    (singleKinkField twoKinkField : AsymptoticField Φ ϕ₀)
    (We : FieldLoop singleKinkField)
    (Xm : FieldLoop twoKinkField)
    (rotSingleKinkOnTwoKink : FieldLoop twoKinkField) : Prop where
  exchange_homotopic_to_rotation :
    loopsHomotopic Xm rotSingleKinkOnTwoKink
  admit_half_odd_spin_iff_odd_statistics :
    (¬ loopsHomotopic We (constantLoop singleKinkField)) ↔
    (¬ loopsHomotopic Xm (constantLoop twoKinkField))

Litlib.equation "finkelstein1968connection" eq "SecV.5" page "1775" kind "theorem"
/-- Section V.5:
A 2n-kink state (where all kink particle numbers are even) cannot possess half-odd spin;
its total extrinsic spin is strictly integer. -/
class Theorem_EvenKinkIntegerSpin {Φ : Type*} [TopologicalSpace Φ] {ϕ₀ : Φ}
    (evenKinkField : AsymptoticField Φ ϕ₀)
    (We_even : FieldLoop evenKinkField) : Prop where
  even_kinks_nullhomotopic_spin_loop :
    loopsHomotopic We_even (constantLoop evenKinkField)

end Litlib.Y1968.finkelstein1968connection
