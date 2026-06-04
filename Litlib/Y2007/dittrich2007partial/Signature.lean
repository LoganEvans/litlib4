-- FILENAME: Litlib/Y2007/dittrich2007partial/Signature.lean

import Litlib.Core
import Mathlib.Data.Real.Basic
import Mathlib.Data.Nat.Factorial.Basic
import Mathlib.Data.Matrix.Basic
import Mathlib.LinearAlgebra.Matrix.Determinant.Basic
import Mathlib.LinearAlgebra.Matrix.NonsingularInverse
import Mathlib.Topology.Algebra.InfiniteSum.Basic
import Mathlib.Analysis.Calculus.Deriv.Basic

open scoped BigOperators

namespace Litlib.Y2007.dittrich2007partial

Litlib.paper "dittrich2007partial"
  type "article"
  title "Partial and complete observables for Hamiltonian constrained systems"
  authors ["Dittrich, B."]
  journal "General Relativity and Gravitation"
  volume "39"
  issue "11"
  pages "1891--1927"
  year "2007"
  publisher "Springer"
  doi "10.1007/s10714-007-0493-x"

/--
Physical Interpretation: Represents the unconstrained macroscopic phase space of a physical system.
Mathematical Boundaries: Equipped with a Poisson bracket operation which maps functions on a topological space back to functions on that space. The bracket must preserve continuity to ensure physically well-behaved phase space observables.
-/
class PoissonSpace (M : Type) [TopologicalSpace M] where
  pb : (M → ℝ) → (M → ℝ) → M → ℝ
  pb_cont : ∀ f g, Continuous f → Continuous g → Continuous (pb f g)

Litlib.equation "dittrich2007partial"
  eq "2.2"
  page "3"
  kind "definition"
/--
Physical Interpretation: Defines a first-class constrained system where the constraints generate gauge transformations that close under the Poisson bracket.
Mathematical Boundaries: The Poisson bracket of any two constraints must be weakly zero, expressible as a linear combination of the constraints themselves via continuous structure functions.
-/
class Eq2_2
    {M : Type} [TopologicalSpace M] [PoissonSpace M] (n : ℕ)
    (C : Fin n → M → ℝ)
    (f : Fin n → Fin n → Fin n → M → ℝ) : Prop where
  -- Topological Constraint: Constraints and structure functions must be continuous.
  C_cont : ∀ i, Continuous (C i)
  f_cont : ∀ i j k, Continuous (f i j k)
  first_class : ∀ i j x, 
    PoissonSpace.pb (C i) (C j) x = ∑ k : Fin n, f i j k x * C k x

Litlib.equation "dittrich2007partial"
  eq "2.3"
  page "3"
  kind "definition"
/--
Physical Interpretation: Defines the canonical Hamiltonian of a constrained physical system. 
Mathematical Boundaries: The Hamiltonian is a sum of a base Hamiltonian (which vanishes on the constraint surface if the system is totally constrained) and a linear combination of the continuous constraints scaled by arbitrary continuous multiplier functions.
-/
class Eq2_3
    {M : Type} [TopologicalSpace M] (n : ℕ)
    (C : Fin n → M → ℝ)
    (h : M → ℝ)
    (lambda : Fin n → M → ℝ)
    (H : M → ℝ) : Prop where
  -- Topological Constraint: Phase space Hamiltonian components must be well-behaved.
  C_cont : ∀ i, Continuous (C i)
  h_cont : Continuous h
  lambda_cont : ∀ i, Continuous (lambda i)
  def_H : ∀ x, H x = h x + ∑ j : Fin n, lambda j x * C j x

Litlib.equation "dittrich2007partial"
  eq "3.1"
  page "5"
  kind "theorem"
/--
Physical Interpretation: Formalizes the construction of a complete (Dirac) observable from two partial observables (a generic function and a clock variable). The complete observable predicts the value of the function when the clock variable reads a specific time `τ`.
Mathematical Boundaries: The gauge flow `α` must be a valid group action. To prevent the Garbage-In exploit from discontinuous pathological maps, both the partial observable and the clock must be continuous on the topological space M.
-/
class Theorem3_1
    {M : Type} [TopologicalSpace M]
    (α : ℝ → M → M)
    (f T : M → ℝ)
    (F : ℝ → M → ℝ) : Prop where
  -- Topological Bounds: The partial observables must be continuous.
  f_cont : Continuous f
  T_cont : Continuous T
  -- Flow Constraint: Explicitly demand α is a valid group action (flow) to prevent pathological non-flow mappings.
  is_flow : ∀ s t x, α s (α t x) = α (s + t) x
  -- Observational Definition: The complete observable is defined implicitly by its relationship to the gauge orbit.
  def_F : ∀ τ x t, T (α t x) = τ → F τ x = f (α t x)
  -- Uniqueness Hypothesis: The partial observable must yield the same value at points on the gauge orbit that share the same clock value.
  hypothesis : ∀ x t s, T (α t x) = T (α s x) → f (α t x) = f (α s x)
  -- Gauge Invariance Conclusion: If the clock variable attains the value τ on the orbit, the complete observable is a gauge invariant constant of motion.
  conclusion : ∀ τ x ε, (∃ t, T (α t x) = τ) → F τ (α ε x) = F τ x

Litlib.equation "dittrich2007partial"
  eq "4.1"
  page "10"
  kind "theorem"
/--
Physical Interpretation: Generalizes the construction of complete observables to systems with multiple independent gauge constraints. It utilizes multiple clock variables to uniquely parametrize the multi-dimensional gauge orbits.
Mathematical Boundaries: The map `α` must form a valid multi-dimensional abelian flow. The evaluation points must uniquely align the continuous clock variables with the specified time parameters.
-/
class Theorem4_1
    {M : Type} [TopologicalSpace M] (n : ℕ)
    (α : (Fin n → ℝ) → M → M)
    (f : M → ℝ)
    (T : Fin n → M → ℝ)
    (F : (Fin n → ℝ) → M → ℝ) : Prop where
  -- Topological Bounds: The partial observables must be continuous.
  f_cont : Continuous f
  T_cont : ∀ i, Continuous (T i)
  -- Action Constraint: α represents the flow generated by n constraints and must form a multi-dimensional abelian flow.
  is_action : ∀ β γ x, α β (α γ x) = α (β + γ) x
  -- Observational Definition: F[f, T](τ, x) is the value of f on the gauge orbit of x where the clocks T intersect τ.
  def_F : ∀ τ x β, (∀ i, T i (α β x) = τ i) → F τ x = f (α β x)
  -- Uniqueness Hypothesis: f evaluated at the points in the intersection of the level set and gauge orbit always gives the same result.
  hypothesis : ∀ x β γ, (∀ i, T i (α β x) = T i (α γ x)) → f (α β x) = f (α γ x)
  -- Gauge Invariance Conclusion: Gauge invariance of the complete observable for an arbitrary number of constraints.
  conclusion : ∀ τ x ε, (∃ β, ∀ i, T i (α β x) = τ i) → F τ (α ε x) = F τ x

Litlib.equation "dittrich2007partial"
  eq "5.6"
  page "13"
  kind "definition"
/--
Physical Interpretation: Defines the Dirac matrix which captures the non-commutation between the gauge constraints and the chosen clock variables.
Mathematical Boundaries: To ensure the clock variables properly parameterize the gauge orbit, the determinant of the Dirac matrix must be strictly non-zero, preventing topological collapse or coordinate singularity. Both constraints and clocks must be continuous.
-/
class Eq5_6
    {M : Type} [TopologicalSpace M] [PoissonSpace M] (n : ℕ)
    (C T : Fin n → M → ℝ)
    (A : M → Matrix (Fin n) (Fin n) ℝ) : Prop where
  -- Topological Bounds:
  C_cont : ∀ i, Continuous (C i)
  T_cont : ∀ i, Continuous (T i)
  def_A : ∀ x k j, A x k j = PoissonSpace.pb (C k) (T j) x
  -- Geometric Non-Degeneracy Constraint: The clock variables MUST NOT commute with the constraints.
  is_invertible : ∀ x, Matrix.det (A x) ≠ 0

Litlib.equation "dittrich2007partial"
  eq "5.43"
  page "19"
  kind "definition"
/--
Physical Interpretation: Defines the sequential action of the abelianized constraint flows on a partial observable, forming the coefficients for the perturbative expansion of the complete observable.
Mathematical Boundaries: Requires explicit sequential ordered composition to guarantee that the multi-derivative operator is well-defined and computable without global non-commutative contradictions.
-/
class Eq5_43
    {M : Type} [TopologicalSpace M] (n : ℕ)
    (S : Fin n → (M → ℝ) → M → ℝ)
    (g : (Fin n → ℕ) → (M → ℝ) → M → ℝ) : Prop where
  -- Composition Constraint: Force exact, concrete sequential ordered composition to guarantee habitation.
  def_g : ∀ (f : M → ℝ) (K : Fin n → ℕ) (x : M), g K f x = 
    ((List.finRange n).map (fun i => (fun h => S i h)^[K i])).foldr Function.comp id f x

Litlib.equation "dittrich2007partial"
  eq "5.44"
  page "19"
  kind "definition"
/--
Physical Interpretation: Constructs the fundamental differential operator `S` used to evolve observables along the gauge orbit. It leverages the inverse of the Dirac matrix to project out the pure gauge directions.
Mathematical Boundaries: Implicitly requires the previously established invertibility of the matrix `A` (Eq 5.6) on the constraint surface.
-/
class Eq5_44
    {M : Type} [TopologicalSpace M] [PoissonSpace M] (n : ℕ)
    (C : Fin n → M → ℝ)
    (A : M → Matrix (Fin n) (Fin n) ℝ)
    (S : Fin n → (M → ℝ) → M → ℝ) : Prop where
  def_S : ∀ j h x, S j h x = ∑ l : Fin n, (A x)⁻¹ j l * PoissonSpace.pb (C l) h x

Litlib.equation "dittrich2007partial"
  eq "5.45"
  page "19"
  kind "definition"
/--
Physical Interpretation: Provides the formal power series solution for the complete observable, expanding the evolution operator around the clock variables.
Mathematical Boundaries: Explicitly demands topological and analytical convergence of the infinite series (`Summable`) to prevent the sum from vacuously collapsing to zero.
-/
class Eq5_45
    {M : Type} [TopologicalSpace M] (n : ℕ)
    (T : Fin n → M → ℝ)
    (g : (Fin n → ℕ) → (M → ℝ) → M → ℝ)
    (F : (M → ℝ) → (Fin n → ℝ) → M → ℝ) : Prop where
  -- Topological Bounds: Clocks must be continuous.
  T_cont : ∀ i, Continuous (T i)
  -- Convergence Constraint: Explicitly demand convergence of the series to guarantee it is well-defined.
  is_summable : ∀ (f : M → ℝ) (τ : Fin n → ℝ) (x : M), Summable (fun (K : Fin n → ℕ) => 
    (1 / ((∏ i, (K i).factorial) : ℝ)) * g K f x * ∏ i, (τ i - T i x) ^ K i)
  def_F : ∀ (f : M → ℝ) (τ : Fin n → ℝ) (x : M), F f τ x = 
    ∑' (K : Fin n → ℕ), 
      (1 / ((∏ i, (K i).factorial) : ℝ)) * 
      g K f x * 
      ∏ i, (τ i - T i x) ^ K i

Litlib.equation "dittrich2007partial"
  eq "5.46"
  page "19"
  kind "property"
/--
Physical Interpretation: Asserts that the differential operators generating the gauge flows commute, ensuring that the perturbative construction of the complete observable is path-independent.
Mathematical Boundaries: The commutation is only strictly required on the constraint surface (`C i x = 0`).
-/
class IntegrabilityCondition
    {M : Type} [TopologicalSpace M] (n : ℕ)
    (C : Fin n → M → ℝ)
    (S : Fin n → (M → ℝ) → M → ℝ) : Prop where
  -- Consistency Constraint: The differential operators must commute strictly ON the constraint surface.
  commute_on_constraint : ∀ x j k h, 
    (∀ i, C i x = 0) → 
    S j (S k h) x = S k (S j h) x

Litlib.equation "dittrich2007partial"
  eq "6.3"
  page "20"
  kind "definition"
/--
Physical Interpretation: Performs a weak abelianization of the original gauge constraints, creating an equivalent set of constraints whose flows weakly commute and linearly evolve the clock variables.
Mathematical Boundaries: Dependent on the invertibility of the matrix `A`.
-/
class Eq6_3
    {M : Type} [TopologicalSpace M] (n : ℕ)
    (C C_tilde : Fin n → M → ℝ)
    (A : M → Matrix (Fin n) (Fin n) ℝ) : Prop where
  -- Weak abelianization of the constraints
  def_C_tilde : ∀ m x, C_tilde m x = ∑ j : Fin n, (A x)⁻¹ m j * C j x

Litlib.equation "dittrich2007partial"
  eq "8.13"
  page "25"
  kind "theorem"
/--
Physical Interpretation: Establishes the equivalence between the Poisson bracket of two complete observables and the complete observable of their Dirac bracket. This is fundamental for preserving the symplectic structure during quantization.
Mathematical Boundaries: The equality holds weakly, meaning it is strictly enforced only on the constraint surface where `C i x = 0`.
-/
class Eq8_13
    {M : Type} [TopologicalSpace M] [PoissonSpace M] (n : ℕ)
    (C : Fin n → M → ℝ)
    (F : (M → ℝ) → (Fin n → ℝ) → M → ℝ)
    (diracBracket : (M → ℝ) → (M → ℝ) → M → ℝ) : Prop where
  poisson_of_complete_eq_complete_of_dirac : 
    ∀ (f g : M → ℝ) (τ : Fin n → ℝ) (x : M),
    (∀ i, C i x = 0) → 
    PoissonSpace.pb (F f τ) (F g τ) x = F (diracBracket f g) τ x

end Litlib.Y2007.dittrich2007partial
