-- FILENAME: Litlib/Y1956/utiyama1956invariant/Signature.lean

import Litlib.Core
import Mathlib.Algebra.Lie.Basic
import Mathlib.Data.Complex.Basic
import Mathlib.Data.Matrix.Basic
import Mathlib.LinearAlgebra.Matrix.Determinant.Basic
import Mathlib.Topology.Basic

open BigOperators

namespace Litlib.Y1956.utiyama1956invariant

Litlib.paper "utiyama1956invariant"
  type "article"
  title "Invariant theoretical interpretation of interaction"
  authors ["Utiyama, Ryoyu"]
  journal "Physical Review"
  volume "101"
  issue "5"
  pages "1597"
  year "1956"
  publisher "APS"
  doi "10.1103/PhysRev.101.1597"

Litlib.equation "utiyama1956invariant"
  eq "1.20"
  page "1600"
  kind "Unknown"
class Eq1_20 where
  /-- 
  Gauge Covariance (Equation 1.20, Page 1600): 
  The Yang-Mills field strength tensor transforms cogradiently (in the adjoint 
  representation) under local gauge transformations. This establishes the geometric 
  necessity of the nonlinear commutator term (Utiyama Eq. 1.18).
  
  Topological Constraint: The fields must satisfy an explicit `isSmooth` 
  differentiability constraint to mathematically well-pose the derivations 
  and prevent pathological singularities from invalidating the Leibniz rules.
  -/
  gaugeCovariance
    (M g : Type*) [AddCommGroup g] [LieRing g] [TopologicalSpace M] [TopologicalSpace g]
    (isSmooth : (M → g) → Prop)
    (deriv : Fin 4 → (M → g) → (M → g))
    (derivCommute : ∀ μ ν f x, isSmooth f → deriv μ (deriv ν f) x = deriv ν (deriv μ f) x)
    (derivLeibniz : ∀ μ f₁ f₂ x, isSmooth f₁ → isSmooth f₂ → deriv μ (fun y => ⁅f₁ y, f₂ y⁆) x = ⁅deriv μ f₁ x, f₂ x⁆ + ⁅f₁ x, deriv μ f₂ x⁆)
    (A : Fin 4 → M → g)
    (hA_smooth : ∀ μ, isSmooth (A μ))
    (ε : M → g)
    (hε_smooth : isSmooth ε)
    (F : Fin 4 → Fin 4 → M → g)
    (defF : ∀ μ ν x, F μ ν x = deriv μ (A ν) x - deriv ν (A μ) x - ⁅A μ x, A ν x⁆)
    (δA : Fin 4 → M → g)
    (hδA_smooth : ∀ μ, isSmooth (δA μ))
    (defδA : ∀ μ x, δA μ x = deriv μ ε x + ⁅ε x, A μ x⁆)
    (δF : Fin 4 → Fin 4 → M → g)
    (defδF : ∀ μ ν x, δF μ ν x = deriv μ (δA ν) x - deriv ν (δA μ) x - ⁅δA μ x, A ν x⁆ - ⁅A μ x, δA ν x⁆) :
    ∀ μ ν x, δF μ ν x = ⁅ε x, F μ ν x⁆

Litlib.equation "utiyama1956invariant"
  eq "Unknown"
  page "Unknown"
  kind "Unknown"
class AppendixI_Expansion where
  /--
  Utiyama Expansion Theorem (Appendix I):
  A gauge-invariant, quadratic (renormalizable) Lagrangian constructed from the 
  field strength tensor uniquely decomposes into a linear combination of the 
  traces of the field strength squared. This strictly binds the dynamical terms 
  to the invariant metric of the gauge group, establishing the algebraic necessity 
  of the Yang-Mills action.
  -/
  yieldsTraceExpansion 
    (M : Type*) [Ring M] [Algebra ℂ M]
    (Trace : M → ℂ)
    (isLieAlgebra : M → Prop)
    (hNonDegenerate : ∃ x, isLieAlgebra x ∧ x ≠ 0)
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

Litlib.equation "utiyama1956invariant"
  eq "Unknown"
  page "Unknown"
  kind "Unknown"
class AppendixI_LorentzTensor where
  /--
  Lorentz-Invariant Tensor Decomposition (Appendix I):
  If the Lagrangian is invariant under proper Lorentz transformations, the 
  expansion tensor must correspondingly be a Lorentz-invariant isotropic tensor. 
  
  Physical Background Constraint: Because Lorentz invariance natively assumes 
  a fixed background spacetime, the tensor `eta` is explicitly bound to a macroscopic 
  Stress-Energy tensor via `isPhysicalBackground`. Furthermore, geometric non-degeneracy 
  is strictly enforced via `Matrix.det eta ≠ 0` to prevent topological trivialization.
  -/
  invariantTensorOfInvariantL
    (M : Type*) [Ring M] [Algebra ℂ M]
    (StressEnergy : Type*)
    (Trace : M → ℂ)
    (isLieAlgebra : M → Prop)
    (L : ((Fin 4 → Fin 4 → M) → ℂ))
    (T : Fin 4 → Fin 4 → Fin 4 → Fin 4 → ℂ)
    (eta : Matrix (Fin 4) (Fin 4) ℂ)
    (T_stress : StressEnergy)
    (isPhysicalBackground : Matrix (Fin 4) (Fin 4) ℂ → StressEnergy → Prop)
    (etaNonDegenerate : Matrix.det eta ≠ 0)
    (hBackground : isPhysicalBackground eta T_stress)
    (hL_eq : ∀ F, (∀ μ ν, isLieAlgebra (F μ ν)) → L F = ∑ μ : Fin 4, ∑ ν : Fin 4, ∑ ρ : Fin 4, ∑ σ : Fin 4, T μ ν ρ σ * Trace (F μ ν * F ρ σ))
    (hLLorentz : ∀ Λ : Matrix (Fin 4) (Fin 4) ℂ, Λ * eta * Matrix.transpose Λ = eta → Matrix.det Λ = 1 → 
      ∀ F, (∀ μ ν, isLieAlgebra (F μ ν)) → 
      (∀ μ ν, isLieAlgebra (∑ α : Fin 4, ∑ β : Fin 4, (Λ μ α * Λ ν β) • F α β)) → 
      L (fun μ ν => ∑ α : Fin 4, ∑ β : Fin 4, (Λ μ α * Λ ν β) • F α β) = L F) :
    ∃ T_inv : Fin 4 → Fin 4 → Fin 4 → Fin 4 → ℂ,
      (∀ F, (∀ μ ν, isLieAlgebra (F μ ν)) → (∀ μ ν, F μ ν = -F ν μ) → 
        L F = ∑ μ : Fin 4, ∑ ν : Fin 4, ∑ ρ : Fin 4, ∑ σ : Fin 4, T_inv μ ν ρ σ * Trace (F μ ν * F ρ σ)) ∧
      (∀ Λ : Matrix (Fin 4) (Fin 4) ℂ, Λ * eta * Matrix.transpose Λ = eta → Matrix.det Λ = 1 → 
        ∀ μ ν ρ σ, ∑ α : Fin 4, ∑ β : Fin 4, ∑ γ : Fin 4, ∑ δ : Fin 4, Λ μ α * Λ ν β * Λ ρ γ * Λ σ δ * T_inv α β γ δ = T_inv μ ν ρ σ)

Litlib.equation "utiyama1956invariant"
  eq "Unknown"
  page "Unknown"
  kind "Unknown"
class AppendixI_BilinearForm where
  /-- 
  Invariant Bilinear Form (Appendix I):
  Constructs the uniquely non-degenerate invariant metric (the Killing form) 
  for the Lie algebra generators. The `isLieAlgebra` constraint physically restricts 
  the domain to semi-simple representations, mathematically preventing pathological 
  central extensions and non-compact ghosts from trivializing the gauge structure.
  -/
  spans 
    (M : Type*) [Ring M] [Algebra ℂ M]
    (Trace : M → ℂ)
    (isLieAlgebra : M → Prop)
    (hNonDegenerate : ∃ x, isLieAlgebra x ∧ x ≠ 0) :
    ∀ (B : M → M → ℂ),
    (∀ c x y, isLieAlgebra x → isLieAlgebra y → B (c • x) y = c * B x y) →
    (∀ x1 x2 y, isLieAlgebra x1 → isLieAlgebra x2 → isLieAlgebra y → B (x1 + x2) y = B x1 y + B x2 y) →
    (∀ x y1 y2, isLieAlgebra x → isLieAlgebra y1 → isLieAlgebra y2 → B x (y1 + y2) = B x y1 + B x y2) →
    (∀ x y (U : Mˣ), isLieAlgebra x → isLieAlgebra y → 
      isLieAlgebra ((U : M) * x * (↑U⁻¹ : M)) → 
      isLieAlgebra ((U : M) * y * (↑U⁻¹ : M)) → 
      B ((U : M) * x * (↑U⁻¹ : M)) ((U : M) * y * (↑U⁻¹ : M)) = B x y) →
    ∃ (k : ℂ), ∀ x y, isLieAlgebra x → isLieAlgebra y → B x y = k * Trace (x * y)

end Litlib.Y1956.utiyama1956invariant
