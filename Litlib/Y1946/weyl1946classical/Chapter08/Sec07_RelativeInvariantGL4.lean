-- FILENAME: Litlib/Y1946/weyl1946classical/Chapter08/Sec07_RelativeInvariantGL4.lean

import Mathlib
import Litlib.Core

open Matrix BigOperators

namespace Litlib.Y1946.weyl1946classical

Litlib.equation "weyl1946classical" eq "FFT" page "252" kind "theorem"
class RelativeInvariantGL4 (W : Type*) [AddCommGroup W] [Module ℂ W] where
  /--
  Physical Interpretation & Mathematical Boundaries:
  A consequence of Weyl's First Fundamental Theorem for GL(n). Any relative
  invariant polynomial of weight 1 under GL(4, C) built from a rank-2 covariant
  tensor F must be a linear combination of contractions against the
  Levi-Civita alternating tensor ε. This proves that weight-1 invariants
  require exactly 4 covariant indices, leading to exactly two copies of F.
  -/
  relativeInvariant :
    ∀ (L : (Fin 4 → Fin 4 → W) → ℂ)
      (epsilon4 : Fin 4 → Fin 4 → Fin 4 → Fin 4 → ℂ),
      (∀ α β γ δ, epsilon4 α β γ δ = -epsilon4 β α γ δ ∧
                  epsilon4 α β γ δ = -epsilon4 α γ β δ ∧
                  epsilon4 α β γ δ = -epsilon4 α β δ γ) →
      epsilon4 0 1 2 3 = 1 →
      (∀ (Λ : Matrix (Fin 4) (Fin 4) ℂ) (F : Fin 4 → Fin 4 → W),
        L (fun μ ν ↦ ∑ α : Fin 4, ∑ β : Fin 4, (Λ μ α * Λ ν β) • F α β) =
        Matrix.det Λ * L F) →
      ∃ (B : W → W → ℂ),
        (∀ (x y z : W), B (x + y) z = B x z + B y z) ∧
        (∀ (c : ℂ) (x y : W), B (c • x) y = c * B x y) ∧
        (∀ (x y z : W), B x (y + z) = B x y + B x z) ∧
        (∀ (c : ℂ) (x y : W), B x (c • y) = c * B x y) ∧
        ∀ (F : Fin 4 → Fin 4 → W),
          L F = ∑ μ : Fin 4, ∑ ν : Fin 4, ∑ ρ : Fin 4, ∑ σ : Fin 4,
            epsilon4 μ ν ρ σ * B (F μ ν) (F ρ σ)
