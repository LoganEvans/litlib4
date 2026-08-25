-- FILENAME: Litlib/Y2017/bengtsson2017geometry/Chapter05/Sec01_QuantumMechanics.lean


import Litlib.Core
import Mathlib.Data.Complex.Basic
import Mathlib.Data.Matrix.Basic
import Mathlib.LinearAlgebra.Matrix.Trace
import Mathlib.Analysis.SpecialFunctions.Trigonometric.Basic
import Litlib.Y2017.bengtsson2017geometry.Paper

namespace Litlib.Y2017.bengtsson2017geometry

open Finset Matrix

Litlib.equation "bengtsson2017geometry"
  eq "5.2"
  page "127"
  kind "definition"
/--
Physical Interpretation: Pure quantum states correspond to rank-one projection operators onto
one-dimensional complex subspaces (rays).
Mathematical Boundaries: The state vector Z must be normalized to unit length.
-/
class Eq5_2 (N : ℕ)
    (rho : (Fin N → ℂ) → Matrix (Fin N) (Fin N) ℂ) where
  rho_pure_def : ∀ (Z : Fin N → ℂ) (α β : Fin N),
    (∑ i, Z i * star (Z i)) = 1 →
    rho Z α β = Z α * star (Z β)

Litlib.equation "bengtsson2017geometry"
  eq "5.9"
  page "129"
  kind "definition"
/--
Physical Interpretation: The Bloch ball representation of a qubit state (N = 2) parameterized by
the 3-dimensional Bloch vector τ. The boundary (radius |τ| = 1/2) is the Bloch sphere S² ≅ CP¹.
Mathematical Boundaries: The coordinates (x, y, z) must satisfy x² + y² + z² ≤ 1/4 to represent
a valid positive semi-definite density matrix.
-/
class Eq5_9
    (blochRho : ℝ → ℝ → ℝ → Matrix (Fin 2) (Fin 2) ℂ) where
  bloch_00 : ∀ x y z, blochRho x y z 0 0 = (1 / 2 + z : ℂ)
  bloch_11 : ∀ x y z, blochRho x y z 1 1 = (1 / 2 - z : ℂ)
  bloch_01 : ∀ x y z, blochRho x y z 0 1 = (x - Complex.I * y : ℂ)
  bloch_10 : ∀ x y z, blochRho x y z 1 0 = (x + Complex.I * y : ℂ)
  bloch_unit_trace : ∀ x y z, trace (blochRho x y z) = 1

Litlib.equation "bengtsson2017geometry"
  eq "5.17"
  page "132"
  kind "theorem"
/--
Physical Interpretation: Transition probability (fidelity) between two pure quantum states in
terms of the Fubini-Study distance DFS and inner products.
Mathematical Boundaries: Both state vectors must be strictly non-zero.
-/
class Eq5_17 (N : ℕ)
    (DFS : (Fin N → ℂ) → (Fin N → ℂ) → ℝ)
    (kappa : (Fin N → ℂ) → (Fin N → ℂ) → ℝ) where
  transition_prob_cos : ∀ (ψ φ : Fin N → ℂ),
    ψ ≠ 0 → φ ≠ 0 →
    Real.cos (DFS ψ φ) ^ 2 = kappa ψ φ
  kappa_inner_ratio : ∀ (ψ φ : Fin N → ℂ),
    ψ ≠ 0 → φ ≠ 0 →
    kappa ψ φ = Complex.re (
      (∑ i, ψ i * star (φ i)) * (∑ i, φ i * star (ψ i)) /
      ((∑ i, ψ i * star (ψ i)) * (∑ i, φ i * star (φ i)))
    )

end Litlib.Y2017.bengtsson2017geometry
