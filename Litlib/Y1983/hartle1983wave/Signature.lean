-- FILENAME: Litlib/Y1983/hartle1983wave/Signature.lean

import Litlib.Core
import Mathlib.Data.Real.Basic
import Mathlib.Algebra.Module.Basic
import Mathlib.Analysis.SpecialFunctions.Exponential
import Mathlib.Analysis.SpecialFunctions.Pow.Real
import Mathlib.Topology.Basic
import Mathlib.Order.Filter.Basic
import Mathlib.Analysis.Calculus.Deriv.Basic
import Mathlib.Analysis.Calculus.ContDiff.Basic

open Filter Topology

namespace Litlib.Y1983.hartle1983wave

Litlib.paper "hartle1983wave"
  type "article"
  title "Wave function of the universe"
  authors ["Hartle, James B", "Hawking, Stephen W"]
  journal "Physical Review D"
  volume "28"
  issue "12"
  pages "2960"
  year "1983"
  publisher "APS"
  doi "10.1103/PhysRevD.28.2960"

Litlib.equation "hartle1983wave"
  eq "2.13"
  page "2963"
  kind "equation"
class WheelerDeWittConstraint 
    (State : Type*) [AddCommGroup State] [Module ℝ State]
    (Hamiltonian : State → State)
    (IsPhysicalState : State → Prop) where
  /-- Equation 2.13: The Wheeler-DeWitt equation constraints the allowed physical states. 
  We require the state to be non-zero to avoid the trivial vacuum exploit. -/
  is_physical_iff : ∀ psi, IsPhysicalState psi ↔ psi ≠ 0 ∧ Hamiltonian psi = 0

Litlib.equation "hartle1983wave"
  eq "1.11"
  page "2961"
  kind "equation"
class NoBoundaryGroundState 
    (ThreeGeometry FourGeometry : Type*)
    (isCompact : FourGeometry → Prop)
    (boundaryOf : FourGeometry → ThreeGeometry)
    (EuclideanAction : FourGeometry → ℝ)
    (amplitude : ThreeGeometry → ℝ)
    (pathIntegral : (FourGeometry → ℝ) → Set FourGeometry → ℝ) where
  /-- Equation 1.11: The ground state amplitude is given by a path integral over all 
  *compact* Euclidean four-geometries bounded by the specified three-geometry. -/
  groundStateAmplitude :
    ∀ (h : ThreeGeometry), 
      amplitude h = pathIntegral (fun g => Real.exp (-EuclideanAction g)) {g | boundaryOf g = h ∧ isCompact g}

Litlib.equation "hartle1983wave"
  eq "4.1"
  page "2966"
  kind "approximation"
class SemiclassicalApproximation 
    (ThreeGeometry : Type*)
    (ClassicalAction : ThreeGeometry → ℝ)
    (WaveFunction : ℝ → ThreeGeometry → ℝ)
    (PreFactor : ThreeGeometry → ℝ) where
  /-- Equation 4.1: Evaluated by steepest descents, the semiclassical limit of the wave function 
  factors into a prefactor and the exponential of the classical Euclidean action. -/
  semiclassicalLimit :
    ∀ (h : ThreeGeometry), 
      Tendsto (fun ħ => WaveFunction ħ h * Real.exp (ClassicalAction h / ħ)) (𝓝[>] 0) (𝓝 (PreFactor h))

Litlib.equation "hartle1983wave"
  eq "5.11"
  page "2967"
  kind "equation"
class MinisuperspaceSeparatedODE 
    (c_n : ℝ → ℝ)
    (p lambda ε₀ : ℝ)
    (n : ℕ) where
  isTwiceDifferentiable : ContDiff ℝ 2 c_n
  /-- Equation 5.11: The separated 1D Wheeler-DeWitt ODE for the mini-superspace model.
  We restrict a > 0 to prevent trivial coordinate singularity exploits at the big bang. -/
  satisfiesODE :
    ∀ a : ℝ, a > 0 → 
      -(1 / a^p) * deriv (fun x => x^p * deriv c_n x) a + (a^2 - lambda * a^4) * c_n a = 2 * ((n : ℝ) + 1/2 - ε₀) * c_n a

end Litlib.Y1983.hartle1983wave
