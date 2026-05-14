-- FILENAME: Litlib/Y2003/nakahara2003geometry/Chapter10/Sec06_BerryPhase.lean

import Litlib.Core
import Mathlib.Data.Real.Basic
import Mathlib.Data.Complex.Basic
import Mathlib.Topology.Basic
import Mathlib.MeasureTheory.Measure.MeasureSpace
import Mathlib.Analysis.SpecialFunctions.Trigonometric.Basic

open BigOperators

namespace Litlib.Y2003.nakahara2003geometry

Litlib.equation "nakahara2003geometry"
  eq "10.136"
  page "38"
  kind "equation"
class BerryPhase
    (Curve State Param : Type _) [TopologicalSpace Param] [TopologicalSpace State] [Nonempty Curve] [Nonempty State]
    (integral : Curve → (Param → ℂ) → ℂ)
    (nabla : Param → State → State)
    (innerProd : State → State → ℂ)
    (eigenstate : Param → State)
    (phase : Curve → ℂ) where
  -- Anti-BS constraint: Fixed eigenstate must inherently be continuous
  eigenstate_continuous : Continuous eigenstate
  
  h_nontrivial : ∃ c, phase c ≠ 0
  berry_phase_def : ∀ c, phase c = Complex.I * integral c (fun R => innerProd (eigenstate R) (nabla R (eigenstate R)))

Litlib.equation "nakahara2003geometry"
  eq "10.140"
  page "39"
  kind "equation"
class BerrysConnection 
    (Index ParameterSpace State : Type _) [TopologicalSpace ParameterSpace] [Nonempty Index] [Nonempty ParameterSpace] [Nonempty State]
    (innerProduct : State → State → ℂ)
    (partialDeriv : Index → (ParameterSpace → State) → ParameterSpace → State)
    (eigenstate : ParameterSpace → State)
    (berryConnection : Index → ParameterSpace → ℂ)
    (isDifferentiable : (ParameterSpace → State) → Prop) where
  -- Anti-BS constraint: Fixed eigenstate must inherently be differentiable
  eigenstate_differentiable : isDifferentiable eigenstate
  
  h_nontrivial : ∃ mu R, berryConnection mu R ≠ 0
  connection_def : ∀ mu R, berryConnection mu R = innerProduct (eigenstate R) (partialDeriv mu eigenstate R)

Litlib.equation "nakahara2003geometry"
  eq "10.142"
  page "40"
  kind "equation"
class BerryCurvature
    (Form : Type _) [TopologicalSpace Form] [AddCommGroup Form] [Nonempty Form]
    (berryConnection : Form)
    (extDeriv : Form → Form)
    (berryCurvature : Form) where
  -- Anti-BS constraint: Fixed derivative must inherently be continuous
  extDeriv_continuous : Continuous extDeriv
  
  h_nontrivial : berryCurvature ≠ 0
  curvature_def : berryCurvature = extDeriv berryConnection

Litlib.equation "nakahara2003geometry"
  eq "10.149"
  page "41"
  kind "equation"
class EffectiveBornOppenheimerHamiltonian
    (Index Param : Type _) [TopologicalSpace Param] [Fintype Index] [Nonempty Param]
    (mass : ℝ)
    (operatorSquared : Index → (Param → ℂ) → Param → ℂ)
    (energy : Param → ℝ)
    (Heff : (Param → ℂ) → Param → ℂ) where
  -- Anti-BS constraint: Fixed energy must inherently be continuous
  energy_continuous : Continuous energy
  
  h_nontrivial : mass > 0
  heff_def : ∀ psi R, Heff psi R = 
    (- 1 / (2 * mass)) * (∑ mu, operatorSquared mu psi R) + energy R * psi R

end Litlib.Y2003.nakahara2003geometry
