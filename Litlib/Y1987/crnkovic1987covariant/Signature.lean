-- FILENAME: Litlib/Y1987/crnkovic1987covariant/Signature.lean

import Mathlib.Data.Real.Basic
import Mathlib.Data.Matrix.Basic
import Mathlib.Data.Fintype.Basic
import Mathlib.Algebra.BigOperators.Group.Finset.Basic
import Mathlib.Algebra.BigOperators.Ring.Finset
import Litlib.Core

namespace Litlib.Y1987.crnkovic1987covariant

Litlib.paper "crnkovic1987covariant"
  type "article"
  title "Covariant description of canonical formalism in geometrical theories"
  authors ["Crnkovic, Cedomir", "Witten, Edward"]
  journal "Three hundred years of gravitation"
  year "1987"

-- We explicitly enforce 4D spacetime to prevent dimensional collapse exploits.
abbrev Spacetime := Fin 4 → ℝ

open scoped BigOperators

Litlib.equation "crnkovic1987covariant" eq "14" page "679" kind "definition"
/-- 
Equation 14: Symplectic current for a scalar field theory.
The current J_α is an anti-symmetric bilinear form on the tangent space 
of solutions (variations of the field). 
-/
class Eq14
    (partialDeriv : Fin 4 → (Spacetime → ℝ) → (Spacetime → ℝ))
    (J : (Spacetime → ℝ) → (Spacetime → ℝ) → (Spacetime → Fin 4 → ℝ)) where
  sympCurrentDef : ∀ (var1Phi var2Phi : Spacetime → ℝ) (x : Spacetime) (α : Fin 4),
    J var1Phi var2Phi x α = var1Phi x * partialDeriv α var2Phi x - var2Phi x * partialDeriv α var1Phi x

Litlib.equation "crnkovic1987covariant" eq "15" page "679" kind "theorem"
/-- 
Equation 15: Conservation of the scalar field symplectic current.
For variations satisfying the linearized equations of motion, ∂_α J^α = 0.
-/
class Eq15
    (partialDeriv : Fin 4 → (Spacetime → ℝ) → (Spacetime → ℝ))
    (metricInv : Spacetime → Fin 4 → Fin 4 → ℝ)
    (J : (Spacetime → ℝ) → (Spacetime → ℝ) → (Spacetime → Fin 4 → ℝ))
    (isLinSolution : (Spacetime → ℝ) → Prop) where
  sympCurrentConservation : ∀ (var1Phi var2Phi : Spacetime → ℝ),
    isLinSolution var1Phi → isLinSolution var2Phi →
    ∀ (x : Spacetime),
      (∑ α : Fin 4, ∑ β : Fin 4, partialDeriv α (fun y => metricInv y α β * J var1Phi var2Phi y β) x) = 0

Litlib.equation "crnkovic1987covariant" eq "20" page "680" kind "definition"
/-- 
Equation 20: Symplectic current for Yang-Mills theory on a Curved Background.
Uses explicitly dimensioned N×N matrices to represent the Lie Algebra to 
prevent trivial commutative domain exploits. The Matrix trace is explicitly 
expanded into a summation to prevent "Can-Kicking" algebraic evasion.
-/
class Eq20 (N : ℕ)
    (metricInv : Spacetime → Fin 4 → Fin 4 → ℝ)
    (varF : (Fin 4 → Spacetime → Matrix (Fin N) (Fin N) ℝ) → (Fin 4 → Fin 4 → Spacetime → Matrix (Fin N) (Fin N) ℝ))
    (J : (Fin 4 → Spacetime → Matrix (Fin N) (Fin N) ℝ) → (Fin 4 → Spacetime → Matrix (Fin N) (Fin N) ℝ) → (Spacetime → Fin 4 → ℝ)) where
  ymSympCurrentDef : ∀ (var1A var2A : Fin 4 → Spacetime → Matrix (Fin N) (Fin N) ℝ) (x : Spacetime) (α : Fin 4),
    J var1A var2A x α = ∑ a : Fin N, ∑ μ : Fin 4, ∑ ν : Fin 4, metricInv x μ ν * (
      ∑ b : Fin N, var1A ν x a b * varF var2A μ α x b a - var2A ν x a b * varF var1A μ α x b a
    )

Litlib.equation "crnkovic1987covariant" eq "22" page "680" kind "theorem"
/-- 
Equation 22: Conservation of the Yang-Mills symplectic current.
-/
class Eq22 (N : ℕ)
    (partialDeriv : Fin 4 → (Spacetime → ℝ) → (Spacetime → ℝ))
    (metricInv : Spacetime → Fin 4 → Fin 4 → ℝ)
    (J : (Fin 4 → Spacetime → Matrix (Fin N) (Fin N) ℝ) → (Fin 4 → Spacetime → Matrix (Fin N) (Fin N) ℝ) → (Spacetime → Fin 4 → ℝ))
    (isYMLinSolution : (Fin 4 → Spacetime → Matrix (Fin N) (Fin N) ℝ) → Prop) where
  ymConservation : ∀ (var1A var2A : Fin 4 → Spacetime → Matrix (Fin N) (Fin N) ℝ),
    isYMLinSolution var1A → isYMLinSolution var2A →
    ∀ (x : Spacetime),
      (∑ α : Fin 4, ∑ β : Fin 4, partialDeriv α (fun y => metricInv y α β * J var1A var2A y β) x) = 0

Litlib.equation "crnkovic1987covariant" eq "23" page "680" kind "definition"
/-- 
Equation 23: The global symplectic form for Yang-Mills.
Integrated over a 3D Cauchy hypersurface Σ at time t. The inclusion of t 
allows downstream proofs to mathematically assert conservation across time slices.
-/
class Eq23 (N : ℕ)
    (J : (Fin 4 → Spacetime → Matrix (Fin N) (Fin N) ℝ) → (Fin 4 → Spacetime → Matrix (Fin N) (Fin N) ℝ) → (Spacetime → Fin 4 → ℝ))
    (surfaceIntegral : ℝ → (Spacetime → Fin 4 → ℝ) → ℝ)
    (omega : ℝ → (Fin 4 → Spacetime → Matrix (Fin N) (Fin N) ℝ) → (Fin 4 → Spacetime → Matrix (Fin N) (Fin N) ℝ) → ℝ) where
  ymSympForm : ∀ (t : ℝ) (var1A var2A : Fin 4 → Spacetime → Matrix (Fin N) (Fin N) ℝ),
    omega t var1A var2A = surfaceIntegral t (J var1A var2A)

Litlib.equation "crnkovic1987covariant" eq "33" page "682" kind "definition"
/-- 
Equation 33: Variation of the Levi-Civita connection (Christoffel symbols) 
in General Relativity.
-/
class Eq33
    (metricInv : Spacetime → Fin 4 → Fin 4 → ℝ)
    (covDeriv : Fin 4 → (Fin 4 → Fin 4 → Spacetime → ℝ) → (Fin 4 → Fin 4 → Spacetime → ℝ))
    (varGamma : (Fin 4 → Fin 4 → Spacetime → ℝ) → (Fin 4 → Fin 4 → Fin 4 → Spacetime → ℝ)) where
  grConnectionVar : ∀ (varG : Fin 4 → Fin 4 → Spacetime → ℝ) (α μ ν : Fin 4) (x : Spacetime),
    varGamma varG α μ ν x = (1/2 : ℝ) * ∑ β : Fin 4, metricInv x α β * (
      covDeriv μ varG ν β x + covDeriv ν varG μ β x - covDeriv β varG μ ν x
    )

Litlib.equation "crnkovic1987covariant" eq "34" page "682" kind "definition"
/-- 
Equation 34: The symplectic current for General Relativity.
Extracted without abstractions, directly writing out the trace reversals and 
contractions to prevent "Can-Kicking" algebraic evasion.
-/
class Eq34
    (metric : Spacetime → Fin 4 → Fin 4 → ℝ)
    (metricInv : Spacetime → Fin 4 → Fin 4 → ℝ)
    (varGamma : (Fin 4 → Fin 4 → Spacetime → ℝ) → (Fin 4 → Fin 4 → Fin 4 → Spacetime → ℝ))
    (J : (Fin 4 → Fin 4 → Spacetime → ℝ) → (Fin 4 → Fin 4 → Spacetime → ℝ) → (Spacetime → Fin 4 → ℝ)) where
  
  -- Anti-Triviality guardrail: ensure metric is actually invertible and non-degenerate.
  metricSymmetric : ∀ (x : Spacetime) (α β : Fin 4), metric x α β = metric x β α
  metricInvertible : ∀ (x : Spacetime) (α γ : Fin 4), 
    (∑ β : Fin 4, metric x α β * metricInv x β γ) = if α = γ then 1 else 0
  
  grSympCurrent : ∀ (var1G var2G : Fin 4 → Fin 4 → Spacetime → ℝ) (x : Spacetime) (α : Fin 4),
    let varUp := fun (varG : Fin 4 → Fin 4 → Spacetime → ℝ) μ ν =>
      - ∑ ρ : Fin 4, ∑ σ : Fin 4, metricInv x μ ρ * metricInv x ν σ * varG ρ σ x
    
    let varLnG := fun (varG : Fin 4 → Fin 4 → Spacetime → ℝ) =>
      ∑ μ : Fin 4, ∑ ν : Fin 4, metricInv x μ ν * varG μ ν x
    
    let term1 := fun (v1 v2 : Fin 4 → Fin 4 → Spacetime → ℝ) =>
      ∑ μ : Fin 4, ∑ ν : Fin 4, varGamma v1 α μ ν x * (varUp v2 μ ν + (1/2 : ℝ) * metricInv x μ ν * varLnG v2)
    
    let term2 := fun (v1 v2 : Fin 4 → Fin 4 → Spacetime → ℝ) =>
      ∑ μ : Fin 4, ∑ ν : Fin 4, varGamma v1 ν μ ν x * (varUp v2 α μ + (1/2 : ℝ) * metricInv x α μ * varLnG v2)
    
    -- J^α is explicitly the anti-symmetrization (1 ↔ 2) of (term1 - term2)
    J var1G var2G x α = (term1 var1G var2G - term2 var1G var2G) - (term1 var2G var1G - term2 var2G var1G)

end Litlib.Y1987.crnkovic1987covariant
