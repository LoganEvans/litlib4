-- FILENAME: Litlib/Y2000/hall2000elementary/Signature.lean

import Litlib.Core
import Mathlib.Data.Complex.Basic
import Mathlib.Analysis.SpecialFunctions.Trigonometric.Basic
import Mathlib.Topology.Basic
import Mathlib.Order.Filter.Basic
import Mathlib.Data.Matrix.Basic
import Mathlib.LinearAlgebra.Matrix.Trace
import Mathlib.LinearAlgebra.Matrix.Determinant.Basic
import Mathlib.Analysis.Calculus.Deriv.Basic
import Mathlib.Data.Nat.Factorial.Basic
import Mathlib.Analysis.Matrix.Normed
import Mathlib.Analysis.Complex.Basic

open Filter Topology BigOperators

namespace Litlib.Y2000.hall2000elementary

Litlib.reference Prop3_3
  bibtex "hall2000elementary"
  doi "10.48550/arXiv.math-ph/0005032"
  authors ["Hall, Brian C."]
  status Standard
class Prop3_3 
    (n : Type*) [Fintype n] [DecidableEq n]
    (exp : Matrix n n ℂ → Matrix n n ℂ) where
  /-- exp is mathematically constrained to be the Taylor series limit -/
  hIsExp : ∀ X, Tendsto (fun m : ℕ => ∑ k ∈ Finset.range m, (1 / (Nat.factorial k : ℂ)) • X^k) atTop (𝓝 (exp X))
  /-- Proposition 3.3 (Page 34): If X and Y commute, then e^{X+Y} = e^X e^Y. -/
  commutingExp :
    ∀ X Y : Matrix n n ℂ, X * Y = Y * X → exp (X + Y) = exp X * exp Y

Litlib.reference Thm3_9
  bibtex "hall2000elementary"
  doi "10.48550/arXiv.math-ph/0005032"
  authors ["Hall, Brian C."]
  status Standard
class Thm3_9 
    (n : Type*) [Fintype n] [DecidableEq n]
    (exp : Matrix n n ℂ → Matrix n n ℂ) where
  /-- Theorem 3.9 (Page 40): The Lie Product Formula (Trotter product formula). -/
  hIsExp : ∀ X, Tendsto (fun m : ℕ => ∑ k ∈ Finset.range m, (1 / (Nat.factorial k : ℂ)) • X^k) atTop (𝓝 (exp X))
  lieProductFormula :
    ∀ X Y : Matrix n n ℂ, 
      Tendsto (fun m : ℕ => (exp ((1 / (m : ℂ)) • X) * exp ((1 / (m : ℂ)) • Y)) ^ m) atTop (𝓝 (exp (X + Y)))

Litlib.reference Thm3_10
  bibtex "hall2000elementary"
  doi "10.48550/arXiv.math-ph/0005032"
  authors ["Hall, Brian C."]
  status Standard
class Thm3_10 
    (n : Type*) [Fintype n] [DecidableEq n]
    (exp : Matrix n n ℂ → Matrix n n ℂ) where
  /-- Theorem 3.10 (Page 40): det(e^X) = e^{trace(X)}. -/
  hIsExp : ∀ X, Tendsto (fun m : ℕ => ∑ k ∈ Finset.range m, (1 / (Nat.factorial k : ℂ)) • X^k) atTop (𝓝 (exp X))
  detExp :
    ∀ X : Matrix n n ℂ, Matrix.det (exp X) = Complex.exp (Matrix.trace X)

Litlib.reference MatrixCalculus
  bibtex "hall2000elementary"
  doi "10.48550/arXiv.math-ph/0005032"
  authors ["Hall, Brian C."]
  status Standard
class MatrixCalculus 
    (n : Type*) [Fintype n] [DecidableEq n]
    (exp : Matrix n n ℂ → Matrix n n ℂ) where
  /-- Capstone Theorem for CGD: Matrix Calculus and Holonomy. -/
  hIsExp : ∀ X, Tendsto (fun m : ℕ => ∑ k ∈ Finset.range m, (1 / (Nat.factorial k : ℂ)) • X^k) atTop (𝓝 (exp X))
  
  holonomySelfCommuting
    (A : ℝ → Matrix n n ℂ)
    (holonomy : ℝ → ℝ → Matrix n n ℂ)
    (integral : ℝ → ℝ → Matrix n n ℂ)
    (hHolonomyOde : ∀ t0 t, HasDerivAt (fun s => holonomy t0 s) (A t * holonomy t0 t) t)
    (hHolonomyInit : ∀ t0, holonomy t0 t0 = 1)
    (hIntegralDeriv : ∀ t0 t, HasDerivAt (fun s => integral t0 s) (A t) t)
    (hIntegralInit : ∀ t0, integral t0 t0 = 0) :
    ∀ (t0 t1 : ℝ), 
      (∀ s t, A s * A t = A t * A s) → 
      holonomy t0 t1 = exp (integral t0 t1)

  involutoryEulerFormula
    (mVal : Matrix n n ℂ)
    (hInvolutory : mVal * mVal = 1) :
    ∀ (θ : ℝ), exp ((Complex.I * (θ : ℂ)) • mVal) = 
      (Real.cos θ : ℂ) • (1 : Matrix n n ℂ) + (Complex.I * (Real.sin θ : ℂ)) • mVal

end Litlib.Y2000.hall2000elementary
