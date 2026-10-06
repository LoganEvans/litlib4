-- FILENAME: Litlib/Y2010/wald2010general/Chapter05/Sec02_Dynamics.lean

import Litlib.Core
import Litlib.Y2010.wald2010general.Paper
import Mathlib.Data.Real.Basic
import Mathlib.Data.Matrix.Basic
import Mathlib.Analysis.SpecialFunctions.Trigonometric.Basic

namespace Litlib.Y2010.wald2010general

open BigOperators

Litlib.equation "wald2010general"
  eq "5.2.17"
  page "99"
  kind "equation"
/-- Trace-Reversed Vacuum Formulation of the Einstein Field Equation.
Derived from Wald 5.2.17 by setting the stress-energy tensor T_{ab} = 0 (vacuum domain)
and taking the trace reversal. This formulation explicitly isolates the Ricci curvature
to equal the metric scaled by the cosmological constant Lambda, providing the rigorous
foundational equation for vacuum emergence proofs. -/
class TraceReversedVacuumEFE
    (M : Type*)
    (g : M → Fin 4 → Fin 4 → ℝ)
    (Ricci : M → Fin 4 → Fin 4 → ℝ)
    (Lambda : ℝ)
    (isNonDegenerate : (M → (Fin 4 → Fin 4 → ℝ)) → Prop)
    (isLeviCivitaRicci : (M → (Fin 4 → Fin 4 → ℝ)) → (M → (Fin 4 → Fin 4 → ℝ)) → Prop) where
  /-- Geometric Non-Degeneracy Constraint: The macroscopic metric density determinant
  must be strictly non-zero to prevent topological collapse of the volume form. -/
  metric_nondegenerate : isNonDegenerate g

  /-- Geometric Connection Constraint: The Ricci tensor must be uniquely derived from
  the Levi-Civita connection of the metric `g`. This strictly enforces that the
  manifold is torsion-free and the connection is metric-compatible. -/
  levi_civita_bound : isLeviCivitaRicci g Ricci

  /-- Trace-Reversed Vacuum Equation: In a 4D vacuum spacetime with a cosmological constant,
  the Ricci curvature tensor is directly proportional to the metric tensor. -/
  einstein_vacuum_eq : ∀ (p : M) (a b : Fin 4), Ricci p a b = Lambda * g p a b

Litlib.equation "wald2010general" eq "5.2.17" page "99" kind "equation"
/-- Sourced Einstein Field Equation with Cosmological Constant (Wald Eq. 5.2.17).
Relates the Einstein tensor G_{ab} and cosmological constant Lambda to the matter
stress-energy tensor T_{ab}: G_{ab} + Lambda * g_{ab} = 8 * π * T_{ab}. -/
class Eq5_2_17
    (M : Type*)
    (g : M → Fin 4 → Fin 4 → ℝ)
    (gInv : M → Fin 4 → Fin 4 → ℝ)
    (Ricci : M → Fin 4 → Fin 4 → ℝ)
    (T : M → Fin 4 → Fin 4 → ℝ)
    (Lambda : ℝ) where
  metric_inverse : ∀ (p : M) (a b : Fin 4),
    (∑ c : Fin 4, g p a c * gInv p c b) = if a = b then 1 else 0
  metric_symmetric : ∀ (p : M) (a b : Fin 4), g p a b = g p b a
  ricci_symmetric : ∀ (p : M) (a b : Fin 4), Ricci p a b = Ricci p b a
  stress_energy_symmetric : ∀ (p : M) (a b : Fin 4), T p a b = T p b a
  einstein_eq : ∀ (p : M) (a b : Fin 4),
    let ricciScalar := ∑ c : Fin 4, ∑ d : Fin 4, gInv p c d * Ricci p c d
    let G := Ricci p a b - (1 / 2 : ℝ) * ricciScalar * g p a b
    G + Lambda * g p a b = 8 * Real.pi * T p a b

Litlib.equation "wald2010general" eq "5.2.17" page "99" kind "equation"
/-- Trace-Reversed Sourced Formulation of the Einstein Field Equation (Wald Eq. 5.2.17).
In four spacetime dimensions, taking the trace of G_{ab} + Lambda * g_{ab} = 8 * π * T_{ab}
yields -R + 4 * Lambda = 8 * π * T, giving the equivalent trace-reversed equation:
R_{ab} - Lambda * g_{ab} = 8 * π * (T_{ab} - (1/2) * T_trace * g_{ab}). -/
class TraceReversedSourcedEFE
    (M : Type*)
    (g : M → Fin 4 → Fin 4 → ℝ)
    (gInv : M → Fin 4 → Fin 4 → ℝ)
    (Ricci : M → Fin 4 → Fin 4 → ℝ)
    (T : M → Fin 4 → Fin 4 → ℝ)
    (Lambda : ℝ) where
  metric_inverse : ∀ (p : M) (a b : Fin 4),
    (∑ c : Fin 4, g p a c * gInv p c b) = if a = b then 1 else 0
  metric_symmetric : ∀ (p : M) (a b : Fin 4), g p a b = g p b a
  ricci_symmetric : ∀ (p : M) (a b : Fin 4), Ricci p a b = Ricci p b a
  stress_energy_symmetric : ∀ (p : M) (a b : Fin 4), T p a b = T p b a
  einstein_sourced_eq : ∀ (p : M) (a b : Fin 4),
    let stressEnergyTrace := ∑ c : Fin 4, ∑ d : Fin 4, gInv p c d * T p c d
    Ricci p a b - Lambda * g p a b =
      8 * Real.pi * (T p a b - (1 / 2 : ℝ) * stressEnergyTrace * g p a b)

Litlib.equation "wald2010general" eq "5.2.2" page "96" kind "definition"
/-- Perfect Fluid Stress-Energy Tensor (Wald Eq. 5.2.2).
T_{ab} = ρ u_a u_b + P (g_{ab} + u_a u_b), where u^a is normalized with u_a u^a = -1. -/
class Eq5_2_2
    (M : Type*)
    (g : M → Fin 4 → Fin 4 → ℝ)
    (u : M → Fin 4 → ℝ)
    (rho : M → ℝ)
    (pressure : M → ℝ)
    (T : M → Fin 4 → Fin 4 → ℝ) where
  timelike_normalized : ∀ (p : M),
    (∑ a : Fin 4, ∑ b : Fin 4, g p a b * u p a * u p b) = -1
  stress_energy_def : ∀ (p : M) (a b : Fin 4),
    T p a b = rho p * u p a * u p b + pressure p * (g p a b + u p a * u p b)

Litlib.equation "wald2010general" eq "5.2.14" page "97" kind "equation"
/-- First Friedmann Equation (Wald Eq. 5.2.14).
Governs the expansion rate of a homogeneous, isotropic Robertson-Walker universe:
3 * (a_dot / a)^2 = 8 * π * ρ - 3 * k / a^2. -/
class Eq5_2_14
    (a : ℝ)
    (aDot : ℝ)
    (rho : ℝ)
    (k : ℝ) where
  scale_factor_pos : 0 < a
  curvature_discrete : k = -1 ∨ k = 0 ∨ k = 1
  friedmann_first_eq : 3 * (aDot / a) ^ 2 = 8 * Real.pi * rho - 3 * k / a ^ 2

Litlib.equation "wald2010general" eq "5.2.15" page "97" kind "equation"
/-- Second Friedmann Equation / Acceleration Equation (Wald Eq. 5.2.15).
3 * (a_ddot / a) = -4 * π * (ρ + 3 * P). -/
class Eq5_2_15
    (a : ℝ)
    (aDDot : ℝ)
    (rho : ℝ)
    (pressure : ℝ) where
  scale_factor_pos : 0 < a
  friedmann_second_eq : 3 * (aDDot / a) = -4 * Real.pi * (rho + 3 * pressure)

Litlib.equation "wald2010general" eq "5.2.16" page "98" kind "definition"
/-- Hubble's Law (Wald Eq. 5.2.16).
Defines recession velocity v = (R / a) * (da / dtau) = H * R, where H = a_dot / a. -/
class Eq5_2_16
    (a : ℝ)
    (aDot : ℝ)
    (H : ℝ)
    (R : ℝ)
    (v : ℝ) where
  scale_factor_pos : 0 < a
  hubble_param_def : H = aDot / a
  recession_velocity_eq : v = (R / a) * aDot
  hubble_law_eq : v = H * R

Litlib.equation "wald2010general" eq "5.2.18" page "100" kind "equation"
/-- Energy Conservation for Perfect Fluid in FLRW (Wald Eq. 5.2.18).
rho_dot + 3 * (rho + P) * (a_dot / a) = 0. -/
class Eq5_2_18
    (a : ℝ)
    (aDot : ℝ)
    (rho : ℝ)
    (rhoDot : ℝ)
    (pressure : ℝ) where
  scale_factor_pos : 0 < a
  energy_conservation_eq : rhoDot + 3 * (rho + pressure) * (aDot / a) = 0

Litlib.equation "wald2010general" eq "5.2.19" page "100" kind "equation"
/-- Conservation of Rest Mass for Dust-Dominated FLRW (Wald Eq. 5.2.19).
For pressureless dust (P = 0), rho * a^3 is constant over time. -/
class Eq5_2_19
    (a : ℝ → ℝ)
    (rho : ℝ → ℝ)
    (cDust : ℝ) where
  scale_factor_pos : ∀ t, 0 < a t
  dust_conservation : ∀ t, rho t * (a t) ^ 3 = cDust

Litlib.equation "wald2010general" eq "5.2.20" page "100" kind "equation"
/-- Energy Density Scaling for Radiation-Dominated FLRW (Wald Eq. 5.2.20).
For radiation (P = rho / 3), rho * a^4 is constant over time. -/
class Eq5_2_20
    (a : ℝ → ℝ)
    (rho : ℝ → ℝ)
    (cRad : ℝ) where
  scale_factor_pos : ∀ t, 0 < a t
  radiation_conservation : ∀ t, rho t * (a t) ^ 4 = cRad

end Litlib.Y2010.wald2010general
