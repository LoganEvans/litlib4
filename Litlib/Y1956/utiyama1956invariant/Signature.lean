-- FILENAME: Litlib/Y1956/utiyama1956invariant/Signature.lean

import Litlib.Core
import Mathlib.Algebra.Lie.Basic
import Mathlib.Data.Complex.Basic
import Mathlib.Data.Matrix.Basic

open BigOperators

namespace Litlib.Y1956.utiyama1956invariant

Litlib.reference Eq1_20
  bibtex "utiyama1956invariant"
  doi "10.1103/PhysRev.101.1597"
  authors ["Utiyama, Ryoyu"]
  status Standard
class Eq1_20 where
  /-- 
  Equation (1.20) (page 1600): The Yang-Mills field strength tensor transforms 
  cogradiently (in the adjoint representation) under local gauge transformations.
  -/
  gaugeCovariance
    (M g : Type*) [AddCommGroup g] [LieRing g]
    (deriv : Fin 4 → (M → g) → (M → g))
    (derivCommute : ∀ μ ν f x, deriv μ (deriv ν f) x = deriv ν (deriv μ f) x)
    (derivLeibniz : ∀ μ f₁ f₂ x, deriv μ (fun y => ⁅f₁ y, f₂ y⁆) x = ⁅deriv μ f₁ x, f₂ x⁆ + ⁅f₁ x, deriv μ f₂ x⁆)
    (A : Fin 4 → M → g)
    (ε : M → g)
    (F : Fin 4 → Fin 4 → M → g)
    (defF : ∀ μ ν x, F μ ν x = deriv μ (A ν) x - deriv ν (A μ) x + ⁅A μ x, A ν x⁆)
    (δA : Fin 4 → M → g)
    (defδA : ∀ μ x, δA μ x = deriv μ ε x + ⁅A μ x, ε x⁆)
    (δF : Fin 4 → Fin 4 → M → g)
    (defδF : ∀ μ ν x, δF μ ν x = deriv μ (δA ν) x - deriv ν (δA μ) x + ⁅δA μ x, A ν x⁆ + ⁅A μ x, δA ν x⁆) :
    ∀ μ ν x, δF μ ν x = ⁅F μ ν x, ε x⁆

Litlib.reference UtiyamaExpansion
  bibtex "utiyama1956invariant"
  doi "10.1103/PhysRev.101.1597"
  authors ["Utiyama, Ryoyu"]
  status Standard
class UtiyamaExpansion where
  /--
  Capstone Theorem: Utiyama Expansion Theorem.
  Any gauge-invariant, renormalizable Lagrangian natively expands into the trace 
  of the field strength squared.
  -/
  yieldsTraceExpansion 
    (ChiralM : Type*) [Ring ChiralM] [Algebra ℂ ChiralM]
    (Trace : ChiralM → ℂ)
    (L : (Fin 4 → Fin 4 → ChiralM) → ℂ)
    (hTraceSpans : ∀ (B : ChiralM → ChiralM → ℂ),
      (∀ c x y, B (c • x) y = c * B x y) →
      (∀ x1 x2 y, B (x1 + x2) y = B x1 y + B x2 y) →
      (∀ x y1 y2, B x (y1 + y2) = B x y1 + B x y2) →
      (∀ x y (U : ChiralMˣ), B ((U : ChiralM) * x * (↑U⁻¹ : ChiralM)) ((U : ChiralM) * y * (↑U⁻¹ : ChiralM)) = B x y) →
      ∃ (k : ℂ), ∀ x y, B x y = k * Trace (x * y))
    (hLQuadScale : ∀ (c : ℂ) (F : Fin 4 → Fin 4 → ChiralM), L (fun μ ν => c • F μ ν) = c^2 * L F)
    (hLQuadAdd : ∀ (F G : Fin 4 → Fin 4 → ChiralM), L (fun μ ν => F μ ν + G μ ν) + L (fun μ ν => F μ ν - G μ ν) = 2 * L F + 2 * L G)
    (hLGauge : ∀ (F : Fin 4 → Fin 4 → ChiralM) (U : ChiralMˣ), L (fun μ ν => (U : ChiralM) * F μ ν * (↑U⁻¹ : ChiralM)) = L F) :
    ∃ (T : Fin 4 → Fin 4 → Fin 4 → Fin 4 → ℂ), 
      ∀ F, L F = ∑ μ : Fin 4, ∑ ν : Fin 4, ∑ ρ : Fin 4, ∑ σ : Fin 4, T μ ν ρ σ * Trace (F μ ν * F ρ σ)

end Litlib.Y1956.utiyama1956invariant
