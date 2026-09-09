-- FILENAME: Litlib/Y1994/stuart1994geodesic/Signature.lean


import Litlib.Core
import Mathlib.Data.Real.Basic
import Mathlib.Data.Complex.Basic
import Mathlib.Data.Matrix.Basic
import Mathlib.LinearAlgebra.Matrix.Trace
import Mathlib.Algebra.BigOperators.Group.Finset.Basic
import Mathlib.Algebra.BigOperators.Ring.Finset

namespace Litlib.Y1994.stuart1994geodesic

noncomputable section

open scoped BigOperators Matrix
open Finset Matrix

Litlib.paper "stuart1994geodesic"
  type "article"
  title "The Geodesic Approximation for the Yang-Mills-Higgs Equations"
  authors ["Stuart, D."]
  journal "Communications in Mathematical Physics"
  volume "166"
  issue "1"
  pages "149--190"
  year "1994"

def matrixCommutator (X Y : Matrix (Fin 2) (Fin 2) ℂ) : Matrix (Fin 2) (Fin 2) ℂ :=
  X * Y - Y * X

def su2Inner (X Y : Matrix (Fin 2) (Fin 2) ℂ) : ℝ :=
  - (1 / 2 : ℝ) * (Matrix.trace (X * Y)).re

Litlib.equation "stuart1994geodesic" eq "1.1" page "150" kind "theorem"
/-- The Yang-Mills-Higgs equations on (3+1) Minkowski space:
(1.1) ∑_{i=1}^3 D_i F_{i0} = -[Φ, D_0 Φ]
(1.2) -D_0 F_{j0} + ∑_{i=1}^3 D_i F_{ji} = -[Φ, D_j Φ]  (j = 1,2,3)
(1.3) D_0^2 Φ - ∑_{i=1}^3 D_i^2 Φ = 0. -/
class Eq1_1_YangMillsHiggsEquations
    (D : Fin 4 → Matrix (Fin 2) (Fin 2) ℂ → Matrix (Fin 2) (Fin 2) ℂ)
    (F : Fin 4 → Fin 4 → Matrix (Fin 2) (Fin 2) ℂ)
    (Phi : Matrix (Fin 2) (Fin 2) ℂ)
    (D0Phi : Matrix (Fin 2) (Fin 2) ℂ)
    (D0D0Phi : Matrix (Fin 2) (Fin 2) ℂ)
    (D2Phi : Fin 3 → Matrix (Fin 2) (Fin 2) ℂ) where
  eq1_1 :
    (∑ i : Fin 3, D (Fin.succ i) (F (Fin.succ i) 0)) = - matrixCommutator Phi D0Phi
  eq1_2 : ∀ j : Fin 3,
    - D 0 (F (Fin.succ j) 0) + (∑ i : Fin 3, D (Fin.succ i) (F (Fin.succ j) (Fin.succ i))) =
      - matrixCommutator Phi (D (Fin.succ j) Phi)
  eq1_3 :
    D0D0Phi - (∑ i : Fin 3, D2Phi i) = 0

Litlib.equation "stuart1994geodesic" eq "1.4" page "151" kind "definition"
/-- A variation ψ = (ã, φ̃) satisfies the gauge orthogonality condition with respect to a
monopole Ψ₀ = (a, ϕ) if ∑_{i=1}^3 (∇_a)_i ã_i + [ϕ, φ̃] = 0. -/
class Eq1_4_GaugeOrthogonalityCondition
    (covD_a : Fin 3 → Matrix (Fin 2) (Fin 2) ℂ → Matrix (Fin 2) (Fin 2) ℂ)
    (phi : Matrix (Fin 2) (Fin 2) ℂ)
    (aTilde : Fin 3 → Matrix (Fin 2) (Fin 2) ℂ)
    (phiTilde : Matrix (Fin 2) (Fin 2) ℂ) where
  gauge_orthogonality :
    (∑ i : Fin 3, covD_a i (aTilde i)) + matrixCommutator phi phiTilde = 0

Litlib.equation "stuart1994geodesic" eq "1.6" page "152" kind "definition"
/-- The dynamic condition: A perturbation section ψ is L²-orthogonal to all 4k zero modes
n_μ ∈ Ker L_{Ψ₀} of the background monopole Ψ₀, removing the finite-dimensional degeneracy:
(ψ, n_μ)_{L²} = 0 for all μ = 0, ..., 4k - 1. -/
class Eq1_6_DynamicCondition
    (k : ℕ) [NeZero k]
    (innerL2 : (Fin 4 → Matrix (Fin 2) (Fin 2) ℂ) → (Fin 4 → Matrix (Fin 2) (Fin 2) ℂ) → ℝ)
    (n : Fin (4 * k) → (Fin 4 → Matrix (Fin 2) (Fin 2) ℂ))
    (psi : Fin 4 → Matrix (Fin 2) (Fin 2) ℂ) where
  dynamic_orthogonality : ∀ mu : Fin (4 * k), innerL2 psi (n mu) = 0

Litlib.equation "stuart1994geodesic" eq "geodesic" page "154" kind "definition"
/-- The Manton kinetic metric g_{μν} = (n_μ, n_ν)_{L²} on the 4k-dimensional monopole moduli
space M_k, and the corresponding geodesic equation:
q̈_μ + ∑_{ν, λ} (g⁻¹)_{μν} (n_ν, ṅ_λ)_{L²} q̇_λ = 0. -/
class Eq_ModuliMetricAndGeodesic
    (k : ℕ) [NeZero k]
    (innerL2 : (Fin 4 → Matrix (Fin 2) (Fin 2) ℂ) → (Fin 4 → Matrix (Fin 2) (Fin 2) ℂ) → ℝ)
    (n : Fin (4 * k) → (Fin 4 → Matrix (Fin 2) (Fin 2) ℂ))
    (dotN : Fin (4 * k) → (Fin 4 → Matrix (Fin 2) (Fin 2) ℂ))
    (g gInv : Matrix (Fin (4 * k)) (Fin (4 * k)) ℝ)
    (qDot qDDot : Fin (4 * k) → ℝ) where
  metric_def : ∀ mu nu : Fin (4 * k),
    g mu nu = innerL2 (n mu) (n nu)
  matrix_inverse : g * gInv = 1
  geodesic_eq : ∀ mu : Fin (4 * k),
    qDDot mu + (∑ nu : Fin (4 * k), ∑ lambda : Fin (4 * k),
      gInv mu nu * innerL2 (n nu) (dotN lambda) * qDot lambda) = 0

Litlib.equation "stuart1994geodesic" eq "Theorem 1.1" page "154" kind "theorem"
/-- David Stuart's Geodesic Approximation Theorem:
For the Yang-Mills-Higgs equations on Minkowski space with initial data of the form
Ψ(0, x) = Ψ₀(q(0)) + ε² ψ(0, x),  Ψ_t(0, x) = ε ∑_μ q̇_μ n_μ + ε² ψ_t(0, x),
there exists ε* > 0 and time T = O(1/ε) such that the true field trajectory remains
within O(ε) of the moduli space geodesic q^(0)(εt):
(∑_μ (q_μ(t) - q^(0)_μ(εt))²)^(1/2) ≤ C_q ε,
and the error field norm satisfies ‖ψ(t)‖_{3, Ψ₀(q(t))} + ‖ψ_t(t)‖_{2, Ψ₀(q(t))} ≤ C_ψ. -/
class Theorem1_1_GeodesicApproximation
    (k : ℕ) [NeZero k]
    (epsilon epsStar : ℝ) (heps_pos : 0 < epsilon) (heps_bound : epsilon < epsStar)
    (T : ℝ) (C_T : ℝ) (hT : T = C_T / epsilon)
    (q : ℝ → Fin (4 * k) → ℝ)
    (qGeodesic : ℝ → Fin (4 * k) → ℝ)
    (psiErrorNorm : ℝ → ℝ)
    (C_q C_psi : ℝ) where
  trajectory_deviation_bound : ∀ t, 0 ≤ t → t ≤ T →
    (∑ mu : Fin (4 * k), (q t mu - qGeodesic (epsilon * t) mu)^2) ≤ (C_q * epsilon)^2
  error_field_bound : ∀ t, 0 ≤ t → t ≤ T →
    psiErrorNorm t ≤ C_psi

end

end Litlib.Y1994.stuart1994geodesic
