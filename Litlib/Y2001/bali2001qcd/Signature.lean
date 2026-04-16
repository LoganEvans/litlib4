-- FILENAME: Litlib/Y2001/bali2001qcd/Signature.lean

import Litlib.Core
import Mathlib.Data.Real.Basic
import Mathlib.Analysis.SpecialFunctions.Trigonometric.Basic

namespace Litlib.Y2001.bali2001qcd

Litlib.reference Eq2_3_and_2_4
  bibtex "bali2001qcd"
  doi "10.1016/S0370-1573(00)00079-X"
  authors ["Bali, Gunnar S."]
  status Standard
class Eq2_3_and_2_4 where
  /--
  Equations (2.3) and (2.4) (page 10): The mass and angular momentum of a 
  rotating relativistic string.
  -/
  stringMassAndAngMom (d σ m J : ℝ) 
    (hD : d > 0) (hSigma : σ > 0)
    (hM : m = Real.pi * d * σ) 
    (hJ : J = (Real.pi * d^2 * σ) / 2) :
    J = (1 / (2 * Real.pi * σ)) * m^2

Litlib.reference Eq4_40
  bibtex "bali2001qcd"
  doi "10.1016/S0370-1573(00)00079-X"
  authors ["Bali, Gunnar S."]
  status Standard
class Eq4_40 where
  /--
  Equation (4.40) (page 36): The momentum space static potentials.
  -/
  singletOctetPotentials (N nA : ℝ) (g q : ℝ) (hN : N > 1) (hNa : nA = N^2 - 1) (hQ : q ≠ 0) :
    let cF := nA / (2 * N)
    let vS := - cF * g^2 * (1 / q^2)
    let vO := (g^2 / (2 * N)) * (1 / q^2)
    vO = - (1 / nA) * vS

Litlib.reference Eq5_11
  bibtex "bali2001qcd"
  doi "10.1016/S0370-1573(00)00079-X"
  authors["Bali, Gunnar S."]
  status Standard
class Eq5_11 where
  /--
  Equation (5.11) (page 65): The self-energy of the adjoint static source.
  -/
  adjointSelfEnergy (N cA cF vSelf : ℝ) 
    (hN : N > 1)
    (hCa : cA = N) 
    (hCf : cF = (N^2 - 1) / (2 * N)) :
    (cA / cF) * (vSelf / 2) = (N^2 / (N^2 - 1)) * vSelf

Litlib.reference Eq6_48_to_6_50
  bibtex "bali2001qcd"
  doi "10.1016/S0370-1573(00)00079-X"
  authors["Bali, Gunnar S."]
  status Standard
class Eq6_48_to_6_50 where
  /--
  Equations (6.80) to (6.91): Gromes and BBP Lorentz-invariance constraints.
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

Litlib.reference FluxTubeEnergyBounds
  bibtex "bali2001qcd"
  doi "10.1016/S0370-1573(00)00079-X"
  authors["Bali, Gunnar S."]
  status Standard
class FluxTubeEnergyBounds 
    (FluxTubeState : Type*)
    (spatialEnergy : FluxTubeState → ℝ)
    (intactFluxTube : ℝ → FluxTubeState)
    (snappedFluxTube : ℝ → FluxTubeState)
    (sigma M : ℝ) where
  /--
  Capstone Theorem: Macroscopic String Energy Bounds.
  The energy of an intact topological flux tube scales linearly with its length 
  (the string tension σ), while a snapped flux tube resolves into two isolated masses (2M).
  Secured by moving structural states out of universally quantified variables.
  -/
  intactEnergy (L : ℝ) :
    spatialEnergy (intactFluxTube L) = sigma * L
  
  snappedEnergy (L : ℝ) :
    spatialEnergy (snappedFluxTube L) = 2 * M

end Litlib.Y2001.bali2001qcd
