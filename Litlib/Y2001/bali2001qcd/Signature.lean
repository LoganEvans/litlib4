-- FILENAME: Litlib/Y2001/bali2001qcd/Signature.lean

import Litlib.Core
import Mathlib.Data.Real.Basic
import Mathlib.Analysis.SpecialFunctions.Trigonometric.Basic

namespace Litlib.Y2001.bali2001qcd

literature_axiom Eq2_3_and_2_4
  bibtex_key "bali2001qcd"
  doi "10.1016/S0370-1573(00)00079-X"
  authors ["Bali, Gunnar S."]
  status Standard
class Eq2_3_and_2_4 where
  /--
  Equations (2.3) and (2.4) (page 10): The mass and angular momentum of a 
  rotating relativistic string.
  -/
  string_mass_and_ang_mom (d σ m J : ℝ) 
    (hd : d > 0) (hσ : σ > 0)
    (hm : m = Real.pi * d * σ) 
    (hJ : J = (Real.pi * d^2 * σ) / 2) :
    J = (1 / (2 * Real.pi * σ)) * m^2

literature_axiom Eq4_40
  bibtex_key "bali2001qcd"
  doi "10.1016/S0370-1573(00)00079-X"
  authors ["Bali, Gunnar S."]
  status Standard
class Eq4_40 where
  /--
  Equation (4.40) (page 36): The momentum space static potentials.
  -/
  singlet_octet_potentials (N N_A : ℝ) (g q : ℝ) (hN : N > 0) (hN_A : N_A = N^2 - 1) (hq : q ≠ 0) :
    let C_F := N_A / (2 * N)
    let V_s := - C_F * g^2 * (1 / q^2)
    let V_o := (g^2 / (2 * N)) * (1 / q^2)
    V_o = - (1 / N_A) * V_s

literature_axiom Eq5_11
  bibtex_key "bali2001qcd"
  doi "10.1016/S0370-1573(00)00079-X"
  authors["Bali, Gunnar S."]
  status Standard
class Eq5_11 where
  /--
  Equation (5.11) (page 65): The self-energy of the adjoint static source.
  -/
  adjoint_self_energy (N C_A C_F V_self : ℝ) 
    (hC_A : C_A = N) 
    (hC_F : C_F = (N^2 - 1) / (2 * N)) :
    (C_A / C_F) * (V_self / 2) = (N^2 / (N^2 - 1)) * V_self

literature_axiom Eq6_48_to_6_50
  bibtex_key "bali2001qcd"
  doi "10.1016/S0370-1573(00)00079-X"
  authors["Bali, Gunnar S."]
  status Standard
class Eq6_48_to_6_50 where
  /--
  Equations (6.80) to (6.91): Gromes and BBP Lorentz-invariance constraints.
  -/
  gromes_and_bbp_relations (e h σ V_self C_b C_d : ℝ) :
    let V_0 := fun (r : ℝ) => V_self - e / r + σ * r
    let V_1_prime := fun (r : ℝ) => - h / r^2 - σ
    let V_2_prime := fun (r : ℝ) => (e - h) / r^2
    let V_b := fun (r : ℝ) => C_b + (2 / 3) * (e / r) - (σ / 9) * r
    let V_c := fun (r : ℝ) => - (1 / 2) * (e / r) - (σ / 6) * r
    let V_d := fun (r : ℝ) => C_d - (σ / 9) * r
    let V_e := fun (r : ℝ) => - (σ / 6) * r
    let V_0_prime := fun (r : ℝ) => e / r^2 + σ
    
    (∀ r, V_2_prime r - V_1_prime r = V_0_prime r) ∧
    (V_self = - 2 * C_b - 4 * C_d → 
      ∀ r, V_b r + 2 * V_d r = (r / 6) * V_0_prime r - (1 / 2) * V_0 r) ∧
    (∀ r, V_c r + 2 * V_e r = - (r / 2) * V_0_prime r)

literature_axiom FluxTubeEnergyBounds
  bibtex_key "bali2001qcd"
  doi "10.1016/S0370-1573(00)00079-X"
  authors["Bali, Gunnar S."]
  status Standard
class FluxTubeEnergyBounds where
  /--
  Capstone Theorem: Macroscopic String Energy Bounds.
  The energy of an intact topological flux tube scales linearly with its length 
  (the string tension σ), while a snapped flux tube resolves into two isolated masses (2M).
  -/
  intact_energy
    (FluxTubeState : Type*)
    (spatialEnergy : FluxTubeState → ℝ)
    (intactFluxTube : ℝ → FluxTubeState)
    (sigma L : ℝ) :
    spatialEnergy (intactFluxTube L) = sigma * L
  
  snapped_energy
    (FluxTubeState : Type*)
    (spatialEnergy : FluxTubeState → ℝ)
    (snappedFluxTube : ℝ → FluxTubeState)
    (M L : ℝ) :
    spatialEnergy (snappedFluxTube L) = 2 * M
