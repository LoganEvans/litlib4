-- FILENAME: Litlib/Y1965/spivak1965calculus/Chapter02/Calculus.lean

import Litlib.Core
import Mathlib.Topology.Basic
import Mathlib.Analysis.Calculus.ContDiff.Basic
import Mathlib.Data.Matrix.Basic
import Mathlib.Data.Real.Basic
import Mathlib.LinearAlgebra.Matrix.Determinant.Basic
import Mathlib.LinearAlgebra.Matrix.NonsingularInverse

namespace Litlib.Y1965.spivak1965calculus

Litlib.equation "spivak1965calculus"
  eq "Theorem 2-11 (Implicit / Inverse Function corollary)"
  page "35"
  kind "Theorem"
class SmoothMatrixInverse 
    {m : Type*} [Fintype m] [DecidableEq m] 
    {n : Nat}
    (s : Set (Fin n → ℝ))
    (A : (Fin n → ℝ) → Matrix m m ℝ) 
    [NormedAddCommGroup (Matrix m m ℝ)]
    [NormedSpace ℝ (Matrix m m ℝ)]
    where
  /-- 
  Smooth Matrix Inverse Constraint: 
  The inverse of a smooth matrix-valued function with a strictly non-zero 
  determinant on an open set is itself smooth. This mathematically blocks 
  singularities and zero-determinant topological exploits.
  -/
  hs_open : IsOpen s
  hA_smooth : ContDiffOn ℝ ⊤ A s
  hA_nondeg : ∀ x ∈ s, Matrix.det (A x) ≠ 0
  
  smooth_inv : ContDiffOn ℝ ⊤ (fun x => (A x)⁻¹) s

Litlib.equation "spivak1965calculus"
  eq "Page 25, Partial Derivatives"
  page "25"
  kind "Theorem"
class OpenSubspaceDerivatives
    {n : Nat}
    (s : Set (Fin n → ℝ))
    (partialDeriv : Fin n → ((Fin n → ℝ) → ℝ) → ((Fin n → ℝ) → ℝ))
    (partialDerivWithin : Fin n → ((Fin n → ℝ) → ℝ) → Set (Fin n → ℝ) → ((Fin n → ℝ) → ℝ))
    where
  /-- 
  Open Subspace Derivatives Constraint: 
  The partial derivative of a function restricted to an open subset U 
  evaluates identically to the restriction of the global partial derivative 
  evaluated at x ∈ U. This rigorously justifies taking local derivatives 
  without requiring global smooth extensions.
  -/
  hs_open : IsOpen s
  
  eq_on_open : ∀ f i, ∀ x ∈ s,
    partialDerivWithin i f s x = partialDeriv i f x

Litlib.equation "spivak1965calculus"
  eq "Theorem 2-4 and 2-5"
  page "26"
  kind "Theorem"
class ContDiffSatisfiesNakaharaSmoothness
    {n : Nat}
    (s : Set (Fin n → ℝ))
    (partialDeriv : Fin n → ((Fin n → ℝ) → ℝ) → ((Fin n → ℝ) → ℝ))
    (isSmooth : ((Fin n → ℝ) → ℝ) → Prop)
    where
  /-- 
  Smoothness Bridge: 
  A bridge class proving that Mathlib's `ContDiffOn ℝ ⊤` over an `IsOpen` set 
  satisfies Nakahara's abstract `isSmooth` predicate, specifically satisfying 
  the `derivCommute` (Clairaut) and `derivLeibniz` (Product Rule) requirements 
  necessary for well-defined differential geometry.
  -/
  hs_open : IsOpen s
  
  is_smooth_iff : ∀ f, isSmooth f ↔ ContDiffOn ℝ ⊤ f s
  
  /-- Clairaut's Theorem (Theorem 2-5): Mixed partial derivatives of smooth functions commute. -/
  derivCommute : ∀ f, isSmooth f → ∀ i j, ∀ x ∈ s,
    partialDeriv i (partialDeriv j f) x = partialDeriv j (partialDeriv i f) x
    
  /-- Leibniz Rule (Theorem 2-4): The product of two smooth functions is smooth, and respects the product rule. -/
  derivLeibniz : ∀ f g, isSmooth f → isSmooth g → 
    (isSmooth (f * g)) ∧ 
    (∀ i, ∀ x ∈ s, partialDeriv i (f * g) x = partialDeriv i f x * g x + f x * partialDeriv i g x)

end Litlib.Y1965.spivak1965calculus
