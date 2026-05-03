-- FILENAME: Litlib/Y1983/hartle1983wave/Signature.lean

import Litlib.Core
import Mathlib.Data.Real.Basic
import Mathlib.Algebra.Module.Basic
import Mathlib.Analysis.SpecialFunctions.Exponential
import Mathlib.Topology.Basic
import Mathlib.Order.Filter.Basic
import Mathlib.Analysis.InnerProductSpace.Basic

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
  page "Unknown"
  kind "Unknown"
class WheelerDeWittConstraint 
    (State : Type*) [AddCommGroup State] [Module ℝ State]
    (Hamiltonian : State → State)
    (IsPhysicalState : State → Prop) where
  /-- Equation 2.13: The Wheeler-DeWitt equation constraints the allowed physical states. -/
  is_physical_iff : ∀ psi, IsPhysicalState psi ↔ psi ≠ 0 ∧ Hamiltonian psi = 0

Litlib.equation "hartle1983wave"
  eq "Unknown"
  page "Unknown"
  kind "Unknown"
class NoBoundaryProposal 
    (ThreeGeometry FourGeometry : Type*)
    (boundaryOf : FourGeometry → ThreeGeometry)
    (EuclideanAction : FourGeometry → ℝ)
    (amplitude : ThreeGeometry → ℝ)
    (pathIntegral : (FourGeometry → ℝ) → Set FourGeometry → ℝ) where
  groundStateAmplitude :
    ∀ (h : ThreeGeometry), 
      amplitude h = pathIntegral (fun g => Real.exp (-EuclideanAction g)) {g | boundaryOf g = h}

Litlib.equation "hartle1983wave"
  eq "Unknown"
  page "Unknown"
  kind "Unknown"
class SemiclassicalGroundState 
    (ThreeGeometry : Type*)
    (Action : ThreeGeometry → ℝ)
    (WaveFunction : ℝ → ThreeGeometry → ℝ)
    (PreFactor : ThreeGeometry → ℝ) where
  semiclassicalApproximation :
    ∀ (h : ThreeGeometry), 
      Tendsto (fun ħ => WaveFunction ħ h) (𝓝[>] 0) (𝓝 (PreFactor h * Real.exp (-Action h)))

Litlib.equation "hartle1983wave"
  eq "Unknown"
  page "Unknown"
  kind "Unknown"
class BigBangInstantonBoundary 
    (State : Type*) [NormedAddCommGroup State] [InnerProductSpace ℝ State]
    (star : State → State)
    (Connection : ℝ → State) where
  bigBangIsInstanton :
    star (Connection 0) = Connection 0

end Litlib.Y1983.hartle1983wave
