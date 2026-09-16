-- FILENAME: Litlib/Y1977/moncrief1977gauge/Signature.lean

import Litlib.Core
import Mathlib.Data.Matrix.Basic
import Mathlib.Data.Complex.Basic
import Mathlib.MeasureTheory.Measure.MeasureSpace
import Mathlib.MeasureTheory.Integral.Bochner.Basic
import Mathlib.MeasureTheory.Function.L1Space.Integrable

open BigOperators

namespace Litlib.Y1977.moncrief1977gauge

Litlib.paper "moncrief1977gauge"
  type "article"
  title "Gauge Symmetries of Yang-Mills Fields"
  authors ["Moncrief, Vincent"]
  journal "Annals of Physics"
  year "1977"

/-!
### General Formalism: Lie Algebra and Representations (Section 2)
-/

/- Equation (2.1), Page 388:
Commutation relations for a faithful representation of a g-dimensional compact,
semisimple Lie algebra in terms of purely imaginary, antisymmetric n × n matrices. -/
Litlib.equation "moncrief1977gauge" eq "2.1" page "388" kind "definition"
class Eq2_1 (g n : ℕ) (θ : Fin g → Matrix (Fin n) (Fin n) ℂ)
    (C : Fin g → Fin g → Fin g → ℝ) where
  antisymmetric_matrices : ∀ a i j, θ a i j = - θ a j i
  purely_imaginary : ∀ a i j, (θ a i j).re = 0
  structure_constants_antisymm : ∀ a b c, C a b c = - C b a c ∧ C a b c = - C a c b
  commutation_relation : ∀ a b,
    θ a * θ b - θ b * θ a = Complex.I • (∑ c : Fin g, (C c a b : ℂ) • θ c)

/- Equation (2.12), Page 390:
The initial value Gauss constraint function C_{(a)}(q, p) for the Yang-Mills-Higgs system
on a 3-dimensional spatial slice Σ. -/
Litlib.equation "moncrief1977gauge" eq "2.12" page "390" kind "definition"
class Eq2_12 (g n : ℕ) («Σ» : Type*)
    (C_struct : Fin g → Fin g → Fin g → ℝ)
    (θ : Fin g → Matrix (Fin n) (Fin n) ℂ)
    (divE : Fin g → «Σ» → ℝ)
    (E : Fin g → Fin 3 → «Σ» → ℝ)
    (A : Fin g → Fin 3 → «Σ» → ℝ)
    (π : «Σ» → Fin n → ℂ)
    (ϕ : «Σ» → Fin n → ℂ)
    (C_constraint : Fin g → «Σ» → ℂ) where
  constraint_eq : ∀ (a : Fin g) (x : «Σ»),
    C_constraint a x =
      - (divE a x : ℂ) -
      ∑ c : Fin g, ∑ b : Fin g, ∑ j : Fin 3,
        (C_struct a b c : ℂ) * (E c j x : ℂ) * (A b j x : ℂ) +
      Complex.I * (∑ k : Fin n, (π x k) * (∑ l : Fin n, θ a k l * ϕ x l))

/-!
### Gauge Symmetries (Section 3)
-/

/- Equation (3.5), Page 391:
Infinitesimal generator ω of a gauge symmetry leaving the background configuration (A_μ, ϕ) fixed. -/
Litlib.equation "moncrief1977gauge" eq "3.5" page "391" kind "definition"
class Eq3_5 (g n : ℕ) (M : Type*)
    (θ : Fin g → Matrix (Fin n) (Fin n) ℂ)
    (dω : Fin g → Fin 4 → M → ℝ)
    (ω : Fin g → M → ℝ)
    (A : Fin g → Fin 4 → M → ℝ)
    (C_struct : Fin g → Fin g → Fin g → ℝ)
    (ϕ : M → Fin n → ℂ)
    (δ_ω_ϕ : M → Fin n → ℂ)
    (δ_ω_A : Fin g → Fin 4 → M → ℝ) where
  delta_phi : ∀ (x : M) (k : Fin n),
    δ_ω_ϕ x k = Complex.I * ∑ a : Fin g, (ω a x : ℂ) * (∑ l : Fin n, θ a k l * ϕ x l)
  delta_phi_vanishes : ∀ x k, δ_ω_ϕ x k = 0
  delta_A : ∀ (a : Fin g) (μ : Fin 4) (x : M),
    δ_ω_A a μ x = dω a μ x + ∑ b : Fin g, ∑ c : Fin g, C_struct a b c * ω b x * A c μ x
  delta_A_vanishes : ∀ a μ x, δ_ω_A a μ x = 0

/- Equation (3.7), Page 391:
Necessary and sufficient Cauchy data conditions on a spatial hypersurface Σ for the
existence of a gauge symmetry. -/
Litlib.equation "moncrief1977gauge" eq "3.7" page "391" kind "theorem"
class Eq3_7 (g n : ℕ) («Σ» : Type*)
    (θ : Fin g → Matrix (Fin n) (Fin n) ℂ)
    (C_struct : Fin g → Fin g → Fin g → ℝ)
    (ω : Fin g → «Σ» → ℝ)
    (dω_spatial : Fin g → Fin 3 → «Σ» → ℝ)
    (ϕ : «Σ» → Fin n → ℂ)
    (π : «Σ» → Fin n → ℂ)
    (A : Fin g → Fin 3 → «Σ» → ℝ)
    (E : Fin g → Fin 3 → «Σ» → ℝ) where
  omega_nontrivial : ∃ a x, ω a x ≠ 0
  symm_phi : ∀ (x : «Σ») (k : Fin n),
    Complex.I * ∑ a : Fin g, (ω a x : ℂ) * (∑ l : Fin n, θ a k l * ϕ x l) = 0
  symm_pi : ∀ (x : «Σ») (k : Fin n),
    Complex.I * ∑ a : Fin g, (ω a x : ℂ) * (∑ l : Fin n, θ a k l * π x l) = 0
  symm_A : ∀ (a : Fin g) (j : Fin 3) (x : «Σ»),
    dω_spatial a j x + ∑ b : Fin g, ∑ c : Fin g, C_struct a b c * ω b x * A c j x = 0
  symm_E : ∀ (a : Fin g) (j : Fin 3) (x : «Σ»),
    ∑ b : Fin g, ∑ c : Fin g, C_struct a b c * ω b x * E c j x = 0

/-!
### Linearization Instabilities & Second-Order Constraints (Section 4 & 5)
-/

/- Equation (4.8), Page 394:
Second Fréchet derivative of the constraint D²C_{(a)}(q, p)((δq, δp), (δq, δp)) acting on
first-order perturbation data. -/
Litlib.equation "moncrief1977gauge" eq "4.8" page "394" kind "definition"
class Eq4_8 (g n : ℕ) («Σ» : Type*)
    (C_struct : Fin g → Fin g → Fin g → ℝ)
    (θ : Fin g → Matrix (Fin n) (Fin n) ℂ)
    (δE : Fin g → Fin 3 → «Σ» → ℝ)
    (δA : Fin g → Fin 3 → «Σ» → ℝ)
    (δπ : «Σ» → Fin n → ℂ)
    (δϕ : «Σ» → Fin n → ℂ)
    (D2C : Fin g → «Σ» → ℂ) where
  d2c_formula : ∀ (a : Fin g) (x : «Σ»),
    D2C a x =
      - 2 * (∑ c : Fin g, ∑ b : Fin g, ∑ j : Fin 3,
          (C_struct a b c : ℂ) * (δE c j x : ℂ) * (δA b j x : ℂ)) +
      2 * Complex.I * (∑ k : Fin n, δπ x k * (∑ l : Fin n, θ a k l * δϕ x l))

/- Equation (4.11), Page 395:
The second-order integral constraint Q_ω^{(2)} on a compact boundaryless Cauchy surface Σ.
First-order perturbations tangent to a curve of exact solutions must satisfy Q_ω^{(2)} = 0. -/
Litlib.equation "moncrief1977gauge" eq "4.11" page "395" kind "theorem"
class Eq4_11 (g n : ℕ) («Σ» : Type*) [MeasureTheory.MeasureSpace «Σ»]
    (C_struct : Fin g → Fin g → Fin g → ℝ)
    (θ : Fin g → Matrix (Fin n) (Fin n) ℂ)
    (ω : Fin g → «Σ» → ℝ)
    (δE : Fin g → Fin 3 → «Σ» → ℝ)
    (δA : Fin g → Fin 3 → «Σ» → ℝ)
    (δπ : «Σ» → Fin n → ℂ)
    (δϕ : «Σ» → Fin n → ℂ) where
  integrand (x : «Σ») : ℂ :=
    ∑ a : Fin g, (ω a x : ℂ) * (
      - (∑ c : Fin g, ∑ b : Fin g, ∑ j : Fin 3,
          (C_struct a b c : ℂ) * (δE c j x : ℂ) * (δA b j x : ℂ)) +
      Complex.I * (∑ k : Fin n, δπ x k * (∑ l : Fin n, θ a k l * δϕ x l))
    )
  integrable_integrand : MeasureTheory.Integrable integrand
  second_order_constraint : 2 * ∫ x, integrand x = 0

/- Equation (5.13), Page 398:
The second-order constraint in Minkowski space under the superselection rule that the conserved
charge Q_ω remains fixed under perturbation. -/
Litlib.equation "moncrief1977gauge" eq "5.13" page "398" kind "theorem"
class Eq5_13 (g n : ℕ) («Σ» : Type*) [MeasureTheory.MeasureSpace «Σ»]
    (C_struct : Fin g → Fin g → Fin g → ℝ)
    (θ : Fin g → Matrix (Fin n) (Fin n) ℂ)
    (ω : Fin g → «Σ» → ℝ)
    (δE : Fin g → Fin 3 → «Σ» → ℝ)
    (δA : Fin g → Fin 3 → «Σ» → ℝ)
    (δπ : «Σ» → Fin n → ℂ)
    (δϕ : «Σ» → Fin n → ℂ) where
  minkowski_integrand (x : «Σ») : ℂ :=
    ∑ b : Fin g, (ω b x : ℂ) * (
      - (∑ a : Fin g, ∑ c : Fin g, ∑ j : Fin 3,
          (C_struct b c a : ℂ) * (δE a j x : ℂ) * (δA c j x : ℂ)) +
      Complex.I * (∑ k : Fin n, δπ x k * (∑ l : Fin n, θ b k l * δϕ x l))
    )
  integrable_integrand : MeasureTheory.Integrable minkowski_integrand
  superselection_constraint : 2 * ∫ x, minkowski_integrand x = 0

end Litlib.Y1977.moncrief1977gauge
