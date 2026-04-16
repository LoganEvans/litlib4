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
class Eq2_13 
    (State : Type*) [AddCommGroup State] [Module ℝ State]
    (Hamiltonian : State → State) where
  wheelerDewitt :
    ∃ (psi : State), psi ≠ 0 ∧ Hamiltonian psi = 0

Litlib.reference NoBoundaryProposal
  bibtex "hartle1983wave"
  doi "10.1103/PhysRevD.28.2960"
  authors ["Hartle, J. B.", "Hawking, S. W."]
  status Standard
class NoBoundaryProposal 
    (ThreeGeometry FourGeometry : Type*)
    (boundaryOf : FourGeometry → ThreeGeometry)
    (EuclideanAction : FourGeometry → ℝ)
    (amplitude : ThreeGeometry → ℝ)
    (pathIntegral : (FourGeometry → ℝ) → Set FourGeometry → ℝ) where
  groundStateAmplitude :
    ∀ (h : ThreeGeometry), 
      amplitude h = pathIntegral (fun g => Real.exp (-EuclideanAction g)) {g | boundaryOf g = h}

Litlib.reference SemiclassicalGroundState
  bibtex "hartle1983wave"
  doi "10.1103/PhysRevD.28.2960"
  authors["Hartle, J. B.", "Hawking, S. W."]
  status Standard
class SemiclassicalGroundState 
    (ThreeGeometry : Type*)
    (Action : ThreeGeometry → ℝ)
    (WaveFunction : ℝ → ThreeGeometry → ℝ)
    (PreFactor : ThreeGeometry → ℝ) where
  semiclassicalApproximation :
    ∀ (h : ThreeGeometry), 
      Tendsto (fun ħ => WaveFunction ħ h) (𝓝[>] 0) (𝓝 (PreFactor h * Real.exp (-Action h)))

Litlib.reference BigBangInstantonBoundary
  bibtex "hartle1983wave"
  doi "10.1103/PhysRevD.28.2960"
  authors["Hartle, J. B.", "Hawking, S. W."]
  status Standard
class BigBangInstantonBoundary 
    (State : Type*) [NormedAddCommGroup State] [InnerProductSpace ℝ State]
    (star : State → State)
    (Connection : ℝ → State) where
  bigBangIsInstanton :
    star (Connection 0) = Connection 0

end Litlib.Y1983.hartle1983wave
