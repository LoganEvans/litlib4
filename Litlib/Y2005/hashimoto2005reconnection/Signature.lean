-- FILENAME: Litlib/Y2005/hashimoto2005reconnection/Signature.lean


import Litlib.Core
import Mathlib.Data.Real.Basic
import Mathlib.Data.Complex.Basic
import Mathlib.Data.Matrix.Basic
import Mathlib.LinearAlgebra.Matrix.Trace
import Mathlib.Algebra.BigOperators.Group.Finset.Basic
import Mathlib.Algebra.BigOperators.Ring.Finset
import Mathlib.Topology.Basic

namespace Litlib.Y2005.hashimoto2005reconnection

noncomputable section

open scoped BigOperators Matrix
open Finset Matrix

Litlib.paper "hashimoto2005reconnection"
  type "article"
  title "Reconnection of non-abelian cosmic strings"
  authors ["Hashimoto, Koji", "Tong, David"]
  journal "Journal of Cosmology and Astroparticle Physics"
  volume "2005"
  issue "09"
  pages "004"
  year "2005"

def matrixCommutator {n : ℕ} (A B : Matrix (Fin n) (Fin n) ℂ) : Matrix (Fin n) (Fin n) ℂ :=
  A * B - B * A

Litlib.equation "hashimoto2005reconnection" eq "3.1" page "10" kind "definition"
/-- The D-brane / symplectic quotient constraint for the moduli space M_{k,N} of k vortices
in U(N) gauge theory: [Z, Z†] + Ψ Ψ† = r · 1_{k×k}, where Z is a k × k complex matrix,
Ψ is a k × N complex matrix, and r = 2π / e² > 0. -/
class Eq3_1_ModuliSpaceConstraint
    (k N : ℕ) [NeZero k] [NeZero N]
    (r : ℝ) (hr : 0 < r)
    (Z : Matrix (Fin k) (Fin k) ℂ)
    (Psi : Matrix (Fin k) (Fin N) ℂ) where
  constraint_eq :
    matrixCommutator Z Z.conjTranspose + Psi * Psi.conjTranspose =
      (r : ℂ) • (1 : Matrix (Fin k) (Fin k) ℂ)
  gauge_invariance : ∀ (U : Matrix (Fin k) (Fin k) ℂ),
    U * U.conjTranspose = 1 →
    let Z' := U * Z * U.conjTranspose
    let Psi' := U * Psi
    matrixCommutator Z' Z'.conjTranspose + Psi' * Psi'.conjTranspose =
      (r : ℂ) • (1 : Matrix (Fin k) (Fin k) ℂ)

Litlib.equation "hashimoto2005reconnection" eq "3.7" page "10" kind "theorem"
/-- The two-vortex constraints for k = 2 vortices in U(2) gauge theory in the upper-triangular
gauge for Z. Factoring out the center of mass (Tr Z = 0), the relative coordinates z, ω and
orientation parameters a_i, b_i satisfy:
∑_{i=1}^2 |a_i|² = r - |ω|²,  ∑_{i=1}^2 |b_i|² = r + |ω|²,  a₁ b̄₁ + a₂ b̄₂ = 2 z̄ ω. -/
class Eq3_7_TwoVortexConstraints
    (r : ℝ) (hr : 0 < r)
    (z omega : ℂ)
    (a b : Fin 2 → ℂ) where
  norm_a_eq :
    Complex.normSq (a 0) + Complex.normSq (a 1) = r - Complex.normSq omega
  norm_b_eq :
    Complex.normSq (b 0) + Complex.normSq (b 1) = r + Complex.normSq omega
  orthogonality_eq :
    a 0 * star (b 0) + a 1 * star (b 1) = 2 * star z * omega
  omega_bound :
    Complex.normSq omega ≤ r

Litlib.equation "hashimoto2005reconnection" eq "3.17" page "14" kind "theorem"
/-- The collision manifold M|_{z=0} of complex dimension 2N - 2 describing two coincident
vortices at z = 0 in U(N) gauge theory:
∑_{i=1}^N |a_i|² + |ω|² = r,  ∑_{i=1}^N |b_i|² - |ω|² = r,  ∑_{i=1}^N a_i b̄_i = 0. -/
class Eq3_17_UNCollisionConstraints
    (N : ℕ) [NeZero N]
    (r : ℝ) (hr : 0 < r)
    (omega : ℂ)
    (a b : Fin N → ℂ) where
  sum_a_eq :
    (∑ i : Fin N, Complex.normSq (a i)) + Complex.normSq omega = r
  sum_b_eq :
    (∑ i : Fin N, Complex.normSq (b i)) - Complex.normSq omega = r
  inner_ab_eq :
    (∑ i : Fin N, a i * star (b i)) = 0

Litlib.equation "hashimoto2005reconnection" eq "reconnection" page "16" kind "theorem"
/-- Classical reconnection theorem: Non-Abelian cosmic strings in U(N) gauge theory reconnect
with unit classical probability P = 1. Right-angle scattering (reconnection) occurs for all
trajectories except those lying on the complex codimension 2 submanifold
M|_{z=0} ∩ M|_{ω=0} ≅ G(2,N), which forms a set of measure zero in the collision moduli space. -/
class Theorem_ClassicalReconnection
    (N : ℕ) (hN : 2 ≤ N)
    (classicalReconnectionProb : ℝ)
    (exceptionalSubmanifoldCodim : ℕ) where
  reconnection_prob_one : classicalReconnectionProb = 1
  exceptional_codimension : exceptionalSubmanifoldCodim = 2

Litlib.equation "hashimoto2005reconnection" eq "low_energy_P" page "18" kind "theorem"
/-- Low-energy reconnection probability with broken flavor symmetry: When scalar masses m_i
break SU(N)_{diag} → U(1)^{N-1}_{diag}, the internal moduli space is lifted into N isolated
types of abelian vortex strings. At collision energies E ≪ Δm_i, strings of the same type
reconnect while strings of different types pass through each other, giving reconnection
probability P = 1/N. -/
class Theorem_BrokenSymmetryReconnection
    (N : ℕ) (hN : 1 ≤ N)
    (energyScale deltaM : ℝ) (hE : energyScale < deltaM)
    (lowEnergyReconnectionProb : ℝ) where
  reconnection_prob_broken : lowEnergyReconnectionProb = (1 : ℝ) / (N : ℝ)

end

end Litlib.Y2005.hashimoto2005reconnection
