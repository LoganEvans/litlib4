-- FILENAME: Litlib/Y1956/utiyama1956invariant/Signature.lean

import Litlib.Core
import Mathlib.Algebra.Lie.Basic
import Mathlib.Data.Complex.Basic
import Mathlib.Data.Matrix.Basic

namespace Litlib.Y1956.utiyama1956invariant

literature_citation Eq1_20
  bibtex_key "utiyama1956invariant"
  doi "10.1103/PhysRev.101.1597"
  authors ["Utiyama, Ryoyu"]
  status Standard
class Eq1_20 where
  /-- 
  Equation (1.20) (page 1600): The Yang-Mills field strength tensor transforms 
  cogradiently (in the adjoint representation) under local gauge transformations.
  -/
  gauge_covariance
    (M g : Type*) [AddCommGroup g] [LieRing g]
    (deriv : Fin 4 → (M → g) → (M → g))
    (deriv_commute : ∀ μ ν f x, deriv μ (deriv ν f) x = deriv ν (deriv μ f) x)
    (deriv_leibniz : ∀ μ f₁ f₂ x, deriv μ (fun y => ⁅f₁ y, f₂ y⁆) x = ⁅deriv μ f₁ x, f₂ x⁆ + ⁅f₁ x, deriv μ f₂ x⁆)
    (A : Fin 4 → M → g)
    (ε : M → g)
    (F : Fin 4 → Fin 4 → M → g)
    (def_F : ∀ μ ν x, F μ ν x = deriv μ (A ν) x - deriv ν (A μ) x + ⁅A μ x, A ν x⁆)
    (δA : Fin 4 → M → g)
    (def_δA : ∀ μ x, δA μ x = deriv μ ε x + ⁅A μ x, ε x⁆)
    (δF : Fin 4 → Fin 4 → M → g)
    (def_δF : ∀ μ ν x, δF μ ν x = deriv μ (δA ν) x - deriv ν (δA μ) x + ⁅δA μ x, A ν x⁆ + ⁅A μ x, δA ν x⁆) :
    ∀ μ ν x, δF μ ν x = ⁅F μ ν x, ε x⁆

literature_citation UtiyamaExpansion
  bibtex_key "utiyama1956invariant"
  doi "10.1103/PhysRev.101.1597"
  authors ["Utiyama, Ryoyu"]
  status Standard
class UtiyamaExpansion where
  /--
  Capstone Theorem: Utiyama Expansion Theorem.
  Any gauge-invariant, renormalizable Lagrangian natively expands into the trace 
  of the field strength squared. Passed abstractly via the Weyl Pattern.
  -/
  utiyama_expansion 
    (ChiralM : Type*)[Ring ChiralM] [Algebra ℂ ChiralM]
    (isGaugeInvariant : ((Fin 4 → Fin 4 → ChiralM) → ℂ) → Prop)
    (isMassDimension4 : ((Fin 4 → Fin 4 → ChiralM) → ℂ) → Prop)
    (Trace : ChiralM → ℂ)
    (L : (Fin 4 → Fin 4 → ChiralM) → ℂ) :
    isGaugeInvariant L → isMassDimension4 L →
    ∃ (T : Fin 4 → Fin 4 → Fin 4 → Fin 4 → ℂ), ∀ F, L F = ∑ μ : Fin 4, ∑ ν : Fin 4, ∑ ρ : Fin 4, ∑ σ : Fin 4, T μ ν ρ σ * Trace (F μ ν * F ρ σ)
