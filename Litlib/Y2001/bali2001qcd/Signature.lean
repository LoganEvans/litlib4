-- FILENAME: Litlib/Y2001/bali2001qcd/Signature.lean

import Litlib.Core
import Mathlib.Data.Real.Basic
import Mathlib.Analysis.SpecialFunctions.Trigonometric.Basic

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
  page "Unknown"
  kind "Unknown"
class Eq2_3_and_2_4 where
  stringMassAndAngMom (d σ m J : ℝ) 
    (hD : d > 0) (hSigma : σ > 0)
    (hM : m = Real.pi * d * σ) 
    (hJ : J = (Real.pi * d^2 * σ) / 2) :
    J = (1 / (2 * Real.pi * σ)) * m^2

Litlib.equation "bali2001qcd"
  eq "4.40"
  page "Unknown"
  kind "Unknown"
class Eq4_40 where
  singletOctetPotentials (N nA : ℝ) (g q : ℝ) (hN : N > 1) (hNa : nA = N^2 - 1) (hQ : q ≠ 0) :
    let cF := nA / (2 * N)
    let vS := - cF * g^2 * (1 / q^2)
    let vO := (g^2 / (2 * N)) * (1 / q^2)
    vO = - (1 / nA) * vS

Litlib.equation "bali2001qcd"
  eq "5.11"
  page "Unknown"
  kind "Unknown"
class Eq5_11 where
  adjointSelfEnergy (N cA cF vSelf : ℝ) 
    (hN : N > 1)
    (hCa : cA = N) 
    (hCf : cF = (N^2 - 1) / (2 * N)) :
    (cA / cF) * (vSelf / 2) = (N^2 / (N^2 - 1)) * vSelf

Litlib.equation "bali2001qcd"
  eq "6.48-6.50"
  page "Unknown"
  kind "Unknown"
class Eq6_48_to_6_50 where
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
  eq "Unknown"
  page "Unknown"
  kind "Unknown"
class FluxTubeEnergyBounds 
    (FluxTubeState : Type*)
    (spatialEnergy : FluxTubeState → ℝ)
    (intactFluxTube : ℝ → FluxTubeState)
    (snappedFluxTube : ℝ → FluxTubeState)
    (sigma M : ℝ) where
  h_M_nonneg : M ≥ 0
  intactEnergy (L : ℝ) (hL : L > 0) :
    spatialEnergy (intactFluxTube L) = sigma * L
  
  snappedEnergy (L : ℝ) (hL : L > 0) :
    spatialEnergy (snappedFluxTube L) = 2 * M

end Litlib.Y2001.bali2001qcd
