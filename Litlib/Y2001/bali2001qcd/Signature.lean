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
  stringMassAndAngMom :
    ∀ (d σ m J : ℝ) 
      (_hD : d > 0) (_hSigma : σ > 0)
      (_hM : m = Real.pi * d * σ) 
      (_hJ : J = (Real.pi * d^2 * σ) / 2),
      J = (1 / (2 * Real.pi * σ)) * m^2

Litlib.reference Eq4_40
  bibtex "bali2001qcd"
  doi "10.1016/S0370-1573(00)00079-X"
  authors ["Bali, Gunnar S."]
  status Standard
class Eq4_40 where
  singletOctetPotentials :
    ∀ (N nA : ℝ) (g q : ℝ) (_hN : N > 1) (_hNa : nA = N^2 - 1) (_hQ : q ≠ 0),
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
  adjointSelfEnergy :
    ∀ (N cA cF vSelf : ℝ) 
      (_hN : N > 1)
      (_hCa : cA = N) 
      (_hCf : cF = (N^2 - 1) / (2 * N)),
      (cA / cF) * (vSelf / 2) = (N^2 / (N^2 - 1)) * vSelf

Litlib.reference Eq6_48_to_6_50
  bibtex "bali2001qcd"
  doi "10.1016/S0370-1573(00)00079-X"
  authors["Bali, Gunnar S."]
  status Standard
class Eq6_48_to_6_50 where
  gromesAndBbpRelations :
    ∀ (e h σ vSelf cB cD : ℝ),
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
class FluxTubeEnergyBounds where
  intactEnergy :
    ∀ (FluxTubeState : Type*) (spatialEnergy : FluxTubeState → ℝ)
      (intactFluxTube : ℝ → FluxTubeState) (sigma : ℝ)
      (_h_sigma_pos : sigma > 0)
      (_h_additive : ∀ L1 L2, spatialEnergy (intactFluxTube (L1 + L2)) = spatialEnergy (intactFluxTube L1) + spatialEnergy (intactFluxTube L2)),
      ∀ L, spatialEnergy (intactFluxTube L) = sigma * L
  
  snappedEnergy :
    ∀ (FluxTubeState : Type*) (spatialEnergy : FluxTubeState → ℝ)
      (snappedFluxTube : ℝ → FluxTubeState) (M : ℝ)
      (_h_M_pos : M > 0)
      (_h_indep : ∀ L1 L2, spatialEnergy (snappedFluxTube L1) = spatialEnergy (snappedFluxTube L2)),
      ∀ L, spatialEnergy (snappedFluxTube L) = 2 * M

end Litlib.Y2001.bali2001qcd
