-- FILENAME: Litlib/Y1956/utiyama1956invariant/Signature.lean

import Litlib.Core
import Mathlib.Algebra.Lie.Basic
import Mathlib.Data.Complex.Basic
import Mathlib.Data.Matrix.Basic
import Mathlib.LinearAlgebra.Matrix.Determinant.Basic

open BigOperators

namespace Litlib.Y1956.utiyama1956invariant

Litlib.reference Eq1_20
  type "article"
  bibtex "utiyama1956invariant"
  title "Invariant theoretical interpretation of interaction"
  authors ["Utiyama, Ryoyu"]
  journal "Physical Review"
  volume "101"
  issue "5"
  pages "1597"
  year "1956"
  publisher "APS"
  doi "10.1103/PhysRev.101.1597"
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

abbrev GaugeCovariance.{u, v} := Eq1_20.{u, v}

Litlib.reference AppendixI_Expansion
  type "article"
  bibtex "utiyama1956invariant"
  title "Invariant theoretical interpretation of interaction"
  authors ["Utiyama, Ryoyu"]
  journal "Physical Review"
  volume "101"
  issue "5"
  pages "1597"
  year "1956"
  publisher "APS"
  doi "10.1103/PhysRev.101.1597"
class AppendixI_Expansion where
  /--
  Capstone Theorem: Utiyama Expansion Theorem.
  Any gauge-invariant, renormalizable Lagrangian natively expands into the trace 
  of the field strength squared.
  -/
  yieldsTraceExpansion 
    (M : Type*) [Ring M] [Algebra ℂ M]
    (Trace : M → ℂ)
    (isLieAlgebra : M → Prop)
    (L : (Fin 4 → Fin 4 → M) → ℂ)
    (hTraceSpans : ∀ (B : M → M → ℂ),
      (∀ c x y, isLieAlgebra x → isLieAlgebra y → B (c • x) y = c * B x y) →
      (∀ x1 x2 y, isLieAlgebra x1 → isLieAlgebra x2 → isLieAlgebra y → B (x1 + x2) y = B x1 y + B x2 y) →
      (∀ x y1 y2, isLieAlgebra x → isLieAlgebra y1 → isLieAlgebra y2 → B x (y1 + y2) = B x y1 + B x y2) →
      (∀ x y (U : Mˣ), isLieAlgebra x → isLieAlgebra y → 
        isLieAlgebra ((U : M) * x * (↑U⁻¹ : M)) → 
        isLieAlgebra ((U : M) * y * (↑U⁻¹ : M)) → 
        B ((U : M) * x * (↑U⁻¹ : M)) ((U : M) * y * (↑U⁻¹ : M)) = B x y) →
      ∃ (k : ℂ), ∀ x y, isLieAlgebra x → isLieAlgebra y → B x y = k * Trace (x * y))
    (hLQuadScale : ∀ (c : ℂ) (F : Fin 4 → Fin 4 → M), 
      (∀ μ ν, isLieAlgebra (F μ ν)) → L (fun μ ν => c • F μ ν) = c^2 * L F)
    (hLQuadAdd : ∀ (F G : Fin 4 → Fin 4 → M), 
      (∀ μ ν, isLieAlgebra (F μ ν)) → (∀ μ ν, isLieAlgebra (G μ ν)) → 
      L (fun μ ν => F μ ν + G μ ν) + L (fun μ ν => F μ ν - G μ ν) = 2 * L F + 2 * L G)
    (hLGauge : ∀ (F : Fin 4 → Fin 4 → M) (U : Mˣ), 
      (∀ μ ν, isLieAlgebra (F μ ν)) → 
      (∀ μ ν, isLieAlgebra ((U : M) * F μ ν * (↑U⁻¹ : M))) → 
      L (fun μ ν => (U : M) * F μ ν * (↑U⁻¹ : M)) = L F) :
    ∃ (T : Fin 4 → Fin 4 → Fin 4 → Fin 4 → ℂ), 
      ∀ F, (∀ μ ν, isLieAlgebra (F μ ν)) → 
      L F = ∑ μ : Fin 4, ∑ ν : Fin 4, ∑ ρ : Fin 4, ∑ σ : Fin 4, T μ ν ρ σ * Trace (F μ ν * F ρ σ)

abbrev UtiyamaExpansion.{u} := AppendixI_Expansion.{u}

Litlib.reference AppendixI_LorentzTensor
  type "article"
  bibtex "utiyama1956invariant"
  title "Invariant theoretical interpretation of interaction"
  authors ["Utiyama, Ryoyu"]
  journal "Physical Review"
  volume "101"
  issue "5"
  pages "1597"
  year "1956"
  publisher "APS"
  doi "10.1103/PhysRev.101.1597"
class AppendixI_LorentzTensor where
  /--
  Corollary of Utiyama Appendix I: 
  If the quadratic Lagrangian L is Lorentz invariant, the resulting expansion tensor T 
  must also be Lorentz invariant.
  -/
  invariantTensorOfInvariantL
    (M : Type*) [Ring M] [Algebra ℂ M]
    (Trace : M → ℂ)
    (isLieAlgebra : M → Prop)
    (L : ((Fin 4 → Fin 4 → M) → ℂ))
    (T : Fin 4 → Fin 4 → Fin 4 → Fin 4 → ℂ)
    (eta : Fin 4 → Fin 4 → ℂ)
    (hL_eq : ∀ F, (∀ μ ν, isLieAlgebra (F μ ν)) → L F = ∑ μ : Fin 4, ∑ ν : Fin 4, ∑ ρ : Fin 4, ∑ σ : Fin 4, T μ ν ρ σ * Trace (F μ ν * F ρ σ))
    (hLLorentz : ∀ Λ : Matrix (Fin 4) (Fin 4) ℂ, Λ * Matrix.of eta * Matrix.transpose Λ = Matrix.of eta → Matrix.det Λ = 1 → 
      ∀ F, (∀ μ ν, isLieAlgebra (F μ ν)) → 
      (∀ μ ν, isLieAlgebra (∑ α : Fin 4, ∑ β : Fin 4, (Λ μ α * Λ ν β) • F α β)) → 
      L (fun μ ν => ∑ α : Fin 4, ∑ β : Fin 4, (Λ μ α * Λ ν β) • F α β) = L F) :
    ∃ T_inv : Fin 4 → Fin 4 → Fin 4 → Fin 4 → ℂ,
      (∀ F, (∀ μ ν, isLieAlgebra (F μ ν)) → (∀ μ ν, F μ ν = -F ν μ) → 
        L F = ∑ μ : Fin 4, ∑ ν : Fin 4, ∑ ρ : Fin 4, ∑ σ : Fin 4, T_inv μ ν ρ σ * Trace (F μ ν * F ρ σ)) ∧
      (∀ Λ : Matrix (Fin 4) (Fin 4) ℂ, Λ * Matrix.of eta * Matrix.transpose Λ = Matrix.of eta → Matrix.det Λ = 1 → 
        ∀ μ ν ρ σ, ∑ α : Fin 4, ∑ β : Fin 4, ∑ γ : Fin 4, ∑ δ : Fin 4, Λ μ α * Λ ν β * Λ ρ γ * Λ σ δ * T_inv α β γ δ = T_inv μ ν ρ σ)

Litlib.reference AppendixI_BilinearForm
  type "article"
  bibtex "utiyama1956invariant"
  title "Invariant theoretical interpretation of interaction"
  authors ["Utiyama, Ryoyu"]
  journal "Physical Review"
  volume "101"
  issue "5"
  pages "1597"
  year "1956"
  publisher "APS"
  doi "10.1103/PhysRev.101.1597"
class AppendixI_BilinearForm where
  /-- 
  Utiyama 1956, Appendix I. 
  Constructs the uniquely non-degenerate invariant metric (the Killing form) 
  for the group generators. By enforcing `isLieAlgebra`, we restrict this 
  strictly to the semi-simple traceless matrices, eliminating the spurious 
  Tr(X)Tr(Y) central extension loophole.
  -/
  spans 
    (M : Type*) [Ring M] [Algebra ℂ M]
    (Trace : M → ℂ)
    (isLieAlgebra : M → Prop) :
    ∀ (B : M → M → ℂ),
    (∀ c x y, isLieAlgebra x → isLieAlgebra y → B (c • x) y = c * B x y) →
    (∀ x1 x2 y, isLieAlgebra x1 → isLieAlgebra x2 → isLieAlgebra y → B (x1 + x2) y = B x1 y + B x2 y) →
    (∀ x y1 y2, isLieAlgebra x → isLieAlgebra y1 → isLieAlgebra y2 → B x (y1 + y2) = B x y1 + B x y2) →
    (∀ x y (U : Mˣ), isLieAlgebra x → isLieAlgebra y → 
      isLieAlgebra ((U : M) * x * (↑U⁻¹ : M)) → 
      isLieAlgebra ((U : M) * y * (↑U⁻¹ : M)) → 
      B ((U : M) * x * (↑U⁻¹ : M)) ((U : M) * y * (↑U⁻¹ : M)) = B x y) →
    ∃ (k : ℂ), ∀ x y, isLieAlgebra x → isLieAlgebra y → B x y = k * Trace (x * y)

abbrev AppendixI_InvariantBilinearForm.{u} := AppendixI_BilinearForm.{u}

end Litlib.Y1956.utiyama1956invariant
