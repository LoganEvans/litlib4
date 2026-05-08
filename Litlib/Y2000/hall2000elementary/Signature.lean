-- FILENAME: Litlib/Y2000/hall2000elementary/Signature.lean

import Litlib.Core
import Mathlib.Data.Complex.Basic
import Mathlib.Topology.Basic
import Mathlib.Order.Filter.Basic
import Mathlib.Data.Matrix.Basic
import Mathlib.LinearAlgebra.Matrix.Trace
import Mathlib.LinearAlgebra.Matrix.Determinant.Basic
import Mathlib.Analysis.Calculus.Deriv.Basic
import Mathlib.Data.Nat.Factorial.Basic
import Mathlib.Analysis.Matrix.Normed

open Filter Topology BigOperators

namespace Litlib.Y2000.hall2000elementary

Litlib.paper "hall2000elementary"
  type "article"
  title "An elementary introduction to groups and representations"
  authors ["Hall, Brian C."]
  journal "arXiv preprint math-ph/0005032"
  year "2000"
  doi "10.48550/arXiv.math-ph/0005032"

Litlib.equation "hall2000elementary"
  eq "Prop 3.3"
  page "28"
  kind "Proposition"
class CommutingExponential 
    (n : Type*) [Fintype n] [DecidableEq n]
    (exp : Matrix n n ℂ → Matrix n n ℂ) where
  hIsExp : ∀ X, Tendsto (fun m : ℕ => ∑ k ∈ Finset.range m, (1 / (Nat.factorial k : ℂ)) • X^k) atTop (𝓝 (exp X))
  commutingExp :
    ∀ X Y : Matrix n n ℂ, X * Y = Y * X → exp (X + Y) = exp X * exp Y

Litlib.equation "hall2000elementary"
  eq "Thm 3.9"
  page "34"
  kind "Theorem"
class LieProductFormula 
    (n : Type*) [Fintype n] [DecidableEq n]
    (exp : Matrix n n ℂ → Matrix n n ℂ) where
  hIsExp : ∀ X, Tendsto (fun m : ℕ => ∑ k ∈ Finset.range m, (1 / (Nat.factorial k : ℂ)) • X^k) atTop (𝓝 (exp X))
  lieProductFormula :
    ∀ X Y : Matrix n n ℂ, 
      Tendsto (fun m : ℕ => (exp ((1 / (m : ℂ)) • X) * exp ((1 / (m : ℂ)) • Y)) ^ m) atTop (𝓝 (exp (X + Y)))

Litlib.equation "hall2000elementary"
  eq "Thm 3.10"
  page "34"
  kind "Theorem"
class DeterminantExponential 
    (n : Type*) [Fintype n] [DecidableEq n]
    (exp : Matrix n n ℂ → Matrix n n ℂ) where
  hIsExp : ∀ X, Tendsto (fun m : ℕ => ∑ k ∈ Finset.range m, (1 / (Nat.factorial k : ℂ)) • X^k) atTop (𝓝 (exp X))
  detExp :
    ∀ X : Matrix n n ℂ, Matrix.det (exp X) = Complex.exp (Matrix.trace X)

Litlib.equation "hall2000elementary"
  eq "Thm 3.12"
  page "35"
  kind "Theorem"
class OneParameterSubgroups 
    (n : Type*) [Fintype n] [DecidableEq n]
    (exp : Matrix n n ℂ → Matrix n n ℂ) where
  hIsExp : ∀ X, Tendsto (fun m : ℕ => ∑ k ∈ Finset.range m, (1 / (Nat.factorial k : ℂ)) • X^k) atTop (𝓝 (exp X))
  oneParameterSubgroup :
    ∀ (A : ℝ → Matrix n n ℂ), 
      Continuous A → 
      A 0 = 1 → 
      (∀ t s : ℝ, A (t + s) = A t * A s) → 
      ∃! X : Matrix n n ℂ, ∀ t : ℝ, A t = exp ((t : ℂ) • X)

end Litlib.Y2000.hall2000elementary
