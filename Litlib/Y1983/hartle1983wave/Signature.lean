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

Litlib.reference Eq2_13
  bibtex "hartle1983wave"
  doi "10.1103/PhysRevD.28.2960"
  authors["Hartle, J. B.", "Hawking, S. W."]
  status Standard
class Eq2_13 where
  wheelerDewitt :
    ∀ (State : Type*) [AddCommGroup State] [Module ℝ State]
      (Hamiltonian : State → State)
      (_h_hamiltonian_zero : Hamiltonian 0 = 0),
      ∃ (psi : State), psi ≠ 0 ∧ Hamiltonian psi = 0

Litlib.reference NoBoundaryProposal
  bibtex "hartle1983wave"
  doi "10.1103/PhysRevD.28.2960"
  authors ["Hartle, J. B.", "Hawking, S. W."]
  status Standard
class NoBoundaryProposal where
  groundStateAmplitude :
    ∀ (ThreeGeometry FourGeometry : Type*)
      (boundaryOf : FourGeometry → ThreeGeometry)
      (EuclideanAction : FourGeometry → ℝ)
      (amplitude : ThreeGeometry → ℝ)
      (pathIntegral : (FourGeometry → ℝ) → Set FourGeometry → ℝ)
      (_h_action_pos : ∀ g, EuclideanAction g ≥ 0),
      ∀ (h : ThreeGeometry), 
        amplitude h = pathIntegral (fun g => Real.exp (-EuclideanAction g)) {g | boundaryOf g = h}

Litlib.reference SemiclassicalGroundState
  bibtex "hartle1983wave"
  doi "10.1103/PhysRevD.28.2960"
  authors["Hartle, J. B.", "Hawking, S. W."]
  status Standard
class SemiclassicalGroundState where
  semiclassicalApproximation :
    ∀ (ThreeGeometry : Type*)
      (Action : ThreeGeometry → ℝ)
      (WaveFunction : ℝ → ThreeGeometry → ℝ)
      (PreFactor : ThreeGeometry → ℝ)
      (_h_action_pos : ∀ h, Action h ≥ 0),
      ∀ (h : ThreeGeometry), 
        Tendsto (fun ħ => WaveFunction ħ h) (𝓝[>] 0) (𝓝 (PreFactor h * Real.exp (-Action h)))

Litlib.reference BigBangInstantonBoundary
  bibtex "hartle1983wave"
  doi "10.1103/PhysRevD.28.2960"
  authors["Hartle, J. B.", "Hawking, S. W."]
  status Standard
class BigBangInstantonBoundary where
  bigBangIsInstanton :
    ∀ (State : Type*) [NormedAddCommGroup State] [InnerProductSpace ℝ State]
      (star : State → State)
      (Connection : ℝ → State)
      (_h_star_isometry : ∀ x, ‖star x‖ = ‖x‖)
      (_h_star_inv : ∀ x, star (star x) = x)
      (_h_is_instanton : ‖Connection 0 - star (Connection 0)‖ = 0),
      star (Connection 0) = Connection 0

end Litlib.Y1983.hartle1983wave
