-- FILENAME: Litlib/Y2011/krasnov2011plebanski/Signature.lean

import Litlib.Core
import Mathlib.Data.Complex.Basic
import Mathlib.Data.Real.Basic
import Mathlib.Data.Matrix.Basic
import Mathlib.Analysis.SpecialFunctions.Trigonometric.Basic

namespace Litlib.Y2011.krasnov2011plebanski

Litlib.paper "krasnov2011plebanski"
  type "article"
  title "Plebański formulation of general relativity: a practical introduction"
  authors ["Krasnov, Kirill"]
  journal "General Relativity and Gravitation"
  volume "43"
  issue "1"
  pages "1--15"
  year "2011"
  publisher "Springer"
  doi "10.1007/s10714-010-1061-x"

Litlib.equation "krasnov2011plebanski"
  eq "3"
  page "3"
  kind "theorem"
/--
Physical Interpretation: Reformulates the Einstein vacuum field equations using the Hodge duality operator on the Riemann curvature tensor. A metric is an Einstein metric (its Ricci tensor is proportional to the metric) if and only if the left and right Hodge duals of the Riemann tensor coincide.
Mathematical Boundaries: The metric `g` must be strictly invertible (`g_is_inv`), which mathematically prevents topological collapse and rules out degenerate metrics (i.e. ensures `det g ≠ 0`). The curvature tensor `R` must be antisymmetric in its index pairs and satisfy the first Bianchi identity.
-/
class Eq3
    (g : Fin 4 → Fin 4 → ℝ)
    (g_inv : Fin 4 → Fin 4 → ℝ)
    (g_is_inv : ∀ mu nu, (∑ alpha : Fin 4, g mu alpha * g_inv alpha nu) = if mu = nu then 1 else 0)
    (epsilon_up_down : Fin 4 → Fin 4 → Fin 4 → Fin 4 → ℝ)
    (LeftHodge : (Fin 4 → Fin 4 → Fin 4 → Fin 4 → ℝ) → (Fin 4 → Fin 4 → Fin 4 → Fin 4 → ℝ))
    (RightHodge : (Fin 4 → Fin 4 → Fin 4 → Fin 4 → ℝ) → (Fin 4 → Fin 4 → Fin 4 → Fin 4 → ℝ))
    (R_mu_nu : (Fin 4 → Fin 4 → Fin 4 → Fin 4 → ℝ) → (Fin 4 → Fin 4 → ℝ))
    where
  LeftHodge_def : ∀ R mu nu rho sigma, 
    LeftHodge R mu nu rho sigma = 
      (1/2 : ℝ) * ∑ alpha : Fin 4, ∑ beta : Fin 4, epsilon_up_down mu nu alpha beta * R alpha beta rho sigma
  RightHodge_def : ∀ R mu nu rho sigma, 
    RightHodge R mu nu rho sigma = 
      (1/2 : ℝ) * ∑ alpha : Fin 4, ∑ beta : Fin 4, R mu nu alpha beta * epsilon_up_down alpha beta rho sigma
  R_mu_nu_def : ∀ R mu nu, 
    R_mu_nu R mu nu = ∑ rho : Fin 4, ∑ sigma : Fin 4, g_inv rho sigma * R rho mu sigma nu
  einstein_condition_iff : ∀ (R : Fin 4 → Fin 4 → Fin 4 → Fin 4 → ℝ),
    (∀ mu nu rho sigma, R mu nu rho sigma + R mu rho sigma nu + R mu sigma nu rho = 0) → 
    (∀ mu nu rho sigma, R mu nu rho sigma = - R nu mu rho sigma) → 
    (∀ mu nu rho sigma, R mu nu rho sigma = - R mu nu sigma rho) → 
    ((∃ (c : ℝ), ∀ mu nu, R_mu_nu R mu nu = c * g mu nu) ↔ 
     (∀ mu nu rho sigma, LeftHodge R mu nu rho sigma = RightHodge R mu nu rho sigma))

Litlib.equation "krasnov2011plebanski"
  eq "4"
  page "4"
  kind "definition"
/--
Physical Interpretation: Defines self-dual and anti-self-dual bivectors as the eigenspaces of the Hodge star operator with eigenvalues `i` and `-i` respectively. These are the fundamental building blocks of the Plebański formulation.
Mathematical Boundaries: Applies to complex-valued 2-forms over the 4-dimensional spacetime. The existence of imaginary eigenvalues requires the Hodge star operator to satisfy `HodgeStar^2 = -1` on 2-forms, strictly binding this formulation to Lorentzian metric signatures.
-/
class Eq4
    (HodgeStar : (Fin 4 → Fin 4 → ℂ) → (Fin 4 → Fin 4 → ℂ))
    (isSelfDual : (Fin 4 → Fin 4 → ℂ) → Prop)
    (isAntiSelfDual : (Fin 4 → Fin 4 → ℂ) → Prop)
    where
  self_dual_iff : ∀ (A : Fin 4 → Fin 4 → ℂ),
    isSelfDual A ↔ (∀ mu nu, HodgeStar A mu nu = Complex.I * A mu nu)
  anti_self_dual_iff : ∀ (A : Fin 4 → Fin 4 → ℂ),
    isAntiSelfDual A ↔ (∀ mu nu, HodgeStar A mu nu = -(Complex.I * A mu nu))

Litlib.equation "krasnov2011plebanski"
  eq "14"
  page "5"
  kind "theorem"
/--
Physical Interpretation: Decomposes the curvature of the self-dual connection into self-dual (`F_ij`) and anti-self-dual (`F_bar_ij`) components. The self-dual part corresponds to the Weyl curvature and the scalar curvature, while the anti-self-dual part relates to the trace-free Ricci tensor.
Mathematical Boundaries: The decomposition strictly requires that the background self-dual (`Sigma`) and anti-self-dual (`Sigma_bar`) 2-forms constitute a complete basis for the space of all antisymmetric 2-forms (`forms_basis`).
-/
class Eq14
    (Sigma : Fin 3 → Fin 4 → Fin 4 → ℂ)
    (Sigma_bar : Fin 3 → Fin 4 → Fin 4 → ℂ)
    (forms_basis : ∀ (F : Fin 4 → Fin 4 → ℂ), 
      (∀ mu nu, F mu nu = - F nu mu) → 
      ∃ (c c_bar : Fin 3 → ℂ), ∀ mu nu, 
        F mu nu = (∑ j : Fin 3, c j * Sigma j mu nu) + (∑ j : Fin 3, c_bar j * Sigma_bar j mu nu))
    where
  curvature_decomposition : ∀ (F_i : Fin 3 → Fin 4 → Fin 4 → ℂ),
    (∀ i mu nu, F_i i mu nu = - F_i i nu mu) →
    ∃ (F_ij F_bar_ij : Fin 3 → Fin 3 → ℂ),
      ∀ i mu nu, F_i i mu nu = 
        (∑ j : Fin 3, F_ij i j * Sigma j mu nu) + 
        (∑ j : Fin 3, F_bar_ij i j * Sigma_bar j mu nu)

Litlib.equation "krasnov2011plebanski"
  eq "15"
  page "6"
  kind "definition"
/--
Physical Interpretation: Formulates the vacuum Einstein equations in the Plebański formalism. The trace of the self-dual curvature matrix is strictly proportional to the cosmological constant, and its anti-self-dual part strictly vanishes.
Mathematical Boundaries: This replaces the traditional differential, tensorial Ricci-flatness conditions with a purely algebraic constraint on the curvature components in the self-dual basis.
-/
class Eq15
    (plebanski_vacuum : ℂ → (Fin 3 → Fin 3 → ℂ) → (Fin 3 → Fin 3 → ℂ) → Prop)
    where
  plebanski_vacuum_iff : ∀ (Lambda : ℂ) (F_ij F_bar_ij : Fin 3 → Fin 3 → ℂ),
    plebanski_vacuum Lambda F_ij F_bar_ij ↔ 
    ((∑ i : Fin 3, F_ij i i) = -Lambda ∧ (∀ i j, F_bar_ij i j = 0))

Litlib.equation "krasnov2011plebanski"
  eq "16"
  page "6"
  kind "definition"
/--
Physical Interpretation: Defines the projection of the trace-free macroscopic stress-energy tensor onto the mixed self-dual/anti-self-dual basis. This term serves as the source coupling matter to the gravitational field in the Plebański formalism.
Mathematical Boundaries: The construction explicitly requires raising the indices of the anti-self-dual basis forms (`Sigma_bar`) using the inverse background metric (`g_inv`), strictly binding the definition to domains where the metric is non-degenerate.
-/
class Eq16
    (Sigma : Fin 3 → Fin 4 → Fin 4 → ℂ)
    (Sigma_bar : Fin 3 → Fin 4 → Fin 4 → ℂ)
    (g_inv : Fin 4 → Fin 4 → ℂ)
    (T_tilde : Fin 4 → Fin 4 → ℂ)
    (T_ij : Fin 3 → Fin 3 → ℂ)
    where
  T_ij_def : ∀ (i j : Fin 3),
    T_ij i j = 
      ∑ mu : Fin 4, ∑ nu : Fin 4, ∑ rho : Fin 4, ∑ alpha : Fin 4, ∑ beta : Fin 4,
        T_tilde rho mu * 
        Sigma i nu rho * 
        g_inv mu alpha * 
        g_inv nu beta * 
        Sigma_bar j alpha beta

Litlib.equation "krasnov2011plebanski"
  eq "17"
  page "6"
  kind "definition"
/--
Physical Interpretation: The full non-vacuum Einstein equations coupled to macroscopic matter in the Plebański formulation. The trace of the self-dual curvature is determined by the cosmological constant and the trace of the stress-energy tensor. The anti-self-dual part is proportional to the trace-free stress-energy tensor.
Mathematical Boundaries: By coupling the curvature to the stress-energy components `T` and `T_ij`, these equations are strictly bound to domains where macroscopic matter fields are well-defined.
-/
class Eq17
    (Lambda : ℂ)
    (G : ℂ)
    (F_ij : Fin 3 → Fin 3 → ℂ)
    (F_bar_ij : Fin 3 → Fin 3 → ℂ)
    (T : ℂ)
    (T_ij : Fin 3 → Fin 3 → ℂ)
    (plebanski_matter_eqs : Prop)
    where
  einstein_eqs_iff : plebanski_matter_eqs ↔ 
    ((∑ i : Fin 3, F_ij i i) = -Lambda - 2 * (Real.pi : ℂ) * G * T ∧ 
     (∀ i j, F_bar_ij i j = -2 * (Real.pi : ℂ) * G * T_ij i j))

end Litlib.Y2011.krasnov2011plebanski
