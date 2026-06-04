-- FILENAME: Litlib/Y2001/bali2001qcd/Signature.lean

import Litlib.Core
import Mathlib.Data.Real.Basic
import Mathlib.Analysis.SpecialFunctions.Trigonometric.Basic
import Mathlib.Topology.Basic

open Filter

namespace Litlib.Y2001.bali2001qcd

Litlib.paper "bali2001qcd"
  type "article"
  title "QCD forces and heavy quark bound states"
  authors ["Bali, Gunnar S."]
  journal "Physics Reports"
  volume "343"
  issue "1-2"
  pages "1--136"
  year "2001"
  publisher "Elsevier"
  doi "10.1016/S0370-1573(00)00079-X"

Litlib.equation "bali2001qcd"
  eq "2.3, 2.4"
  page "9"
  kind "equation"
class StringMassAndAngMom where
  /--
  # Equation: String Mass and Angular Momentum
  **Literature:** Bali 2001, Eq. 2.3 & 2.4, Page 9.
  **Physical Interpretation:** Relates the angular momentum of a rotating QCD string (flux tube) to its mass, demonstrating that the Regge trajectory is linear in $m^2$ with a slope proportional to the inverse of the string tension.
  **Mathematical Boundaries:** The parameters $d$ (string half-length) and $\sigma$ (string tension) must be strictly positive, preventing trivial zero-mass bounds or undefined divisions.
  -/
  stringMassAndAngMom (d σ m J : ℝ) 
    (hD : d > 0) (hSigma : σ > 0)
    (hM : m = Real.pi * d * σ) 
    (hJ : J = (Real.pi * d^2 * σ) / 2) :
    J = (1 / (2 * Real.pi * σ)) * m^2

Litlib.equation "bali2001qcd"
  eq "4.40"
  page "36"
  kind "equation"
class SingletOctetPotentials where
  /--
  # Equation: Singlet and Octet Potentials
  **Literature:** Bali 2001, Eq. 4.40, Page 36.
  **Physical Interpretation:** In the perturbative regime, the potential between fundamental colour sources (quarks) splits into an attractive singlet channel and a repulsive octet channel. The ratio of their strengths is strictly determined by the Casimir invariants of the $SU(N)$ gauge group.
  **Mathematical Boundaries:** The number of colours $N$ must be strictly greater than 1 to ensure a non-trivial semi-simple Lie group, and the momentum transfer $q$ must be non-zero to prevent a Coulomb singularity.
  -/
  singletOctetPotentials (N nA : ℝ) (g q : ℝ) (hN : N > 1) (hNa : nA = N^2 - 1) (hQ : q ≠ 0) :
    let cF := nA / (2 * N)
    let vS := - cF * g^2 * (1 / q^2)
    let vO := (g^2 / (2 * N)) * (1 / q^2)
    vO = - (1 / nA) * vS

Litlib.equation "bali2001qcd"
  eq "5.11"
  page "64"
  kind "equation"
class AdjointSelfEnergy where
  /--
  # Equation: Adjoint Self-Energy
  **Literature:** Bali 2001, Eq. 5.11, Page 64.
  **Physical Interpretation:** Describes the self-energy scaling for an adjoint static source (gluino) relative to fundamental sources. This relates the gluelump mass limit to the tree-level self-energy in the static potential.
  **Mathematical Boundaries:** The number of colours $N > 1$ mathematically guarantees that the Casimir invariants (and their ratios) are well-defined, non-zero values.
  -/
  adjointSelfEnergy (N cA cF vSelf : ℝ) 
    (hN : N > 1)
    (hCa : cA = N) 
    (hCf : cF = (N^2 - 1) / (2 * N)) :
    (cA / cF) * (vSelf / 2) = (N^2 / (N^2 - 1)) * vSelf

Litlib.equation "bali2001qcd"
  eq "6.48-6.50"
  page "91"
  kind "equation"
class GromesAndBbpRelations where
  /--
  # Equation: Gromes and BBP Relations
  **Literature:** Bali 2001, Eq. 6.48 - 6.50, Page 91.
  **Physical Interpretation:** The Gromes and Barchielli-Brambilla-Prosperi (BBP) relations impose strict constraints on the spin-dependent (spin-orbit, spin-spin, and tensor) and momentum-dependent relativistic corrections to the static potential, enforced by the underlying Lorentz/Poincaré invariance of the QCD vacuum.
  **Mathematical Boundaries:** Valid for strictly non-zero spatial separations ($r \neq 0$) to rigorously avoid short-distance Coulomb singularities.
  -/
  gromesAndBbpRelations (e h σ vSelf cB cD : ℝ) :
    let v0 := fun (r : ℝ) => vSelf - e / r + σ * r
    let v1Prime := fun (r : ℝ) => - h / r^2 - σ
    let v2Prime := fun (r : ℝ) => (e - h) / r^2
    let vB := fun (r : ℝ) => cB + (2 / 3) * (e / r) - (σ / 9) * r
    let vC := fun (r : ℝ) => - (1 / 2) * (e / r) - (σ / 6) * r
    let vD := fun (r : ℝ) => cD - (σ / 9) * r
    let vE := fun (r : ℝ) => - (σ / 6) * r
    let v0Prime := fun (r : ℝ) => e / r^2 + σ
    
    (∀ r, r ≠ 0 → v2Prime r - v1Prime r = v0Prime r) ∧
    (vSelf = - 2 * cB - 4 * cD → 
      ∀ r, r ≠ 0 → vB r + 2 * vD r = (r / 6) * v0Prime r - (1 / 2) * v0 r) ∧
    (∀ r, r ≠ 0 → vC r + 2 * vE r = - (r / 2) * v0Prime r)

Litlib.equation "bali2001qcd"
  eq "String Breaking"
  page "45"
  kind "phenomenology"
class FluxTubeStringBreaking 
    (FluxTubeState : Type*)
    (spatialEnergy : FluxTubeState → ℝ)
    (intactFluxTube : ℝ → FluxTubeState)
    (snappedFluxTube : ℝ → FluxTubeState)
    (sigma M : ℝ) where
  /-- Mass Positivity Constraint: The string tension and meson masses must be strictly positive. -/
  h_sigma_pos : sigma > 0
  h_M_pos : M > 0
  
  intactEnergy : ∀ r > 0, spatialEnergy (intactFluxTube r) = sigma * r
  snappedEnergy : ∀ r > 0, spatialEnergy (snappedFluxTube r) = 2 * M
  
  /--
  # Phenomenology: Flux Tube String Breaking
  **Literature:** Bali 2001, String Breaking, Page 45.
  **Physical Interpretation:** In full QCD with dynamical sea quarks, the colour flux tube between heavy static sources will spontaneously "break" when the stored string energy exceeds the rest mass threshold to create a pair of static-light mesons. 
  **Mathematical Boundaries:** The physical ground state energy is the minimum of the available topological states. This limit rigorously asserts that the physical ground state saturates at $2M$ as the spatial separation $r \to \infty$, precluding an infinitely rising potential in the unquenched regime.
  -/
  ground_state_energy_limit : 
    Tendsto (fun r => min (spatialEnergy (intactFluxTube r)) (spatialEnergy (snappedFluxTube r))) atTop (nhds (2 * M))

end Litlib.Y2001.bali2001qcd
