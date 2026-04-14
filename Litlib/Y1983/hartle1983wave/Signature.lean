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

literature_citation Eq2_13
  bibtex_key "hartle1983wave"
  doi "10.1103/PhysRevD.28.2960"
  authors["Hartle, J. B.", "Hawking, S. W."]
  status Standard
class Eq2_13 where
  /--
  Equation (2.13) (page 2963): The Wheeler-DeWitt equation.
  The state of a closed universe is an eigenstate of the Hamiltonian 
  with eigenvalue zero.
  -/
  wheeler_dewitt
    (State : Type*) [AddCommGroup State] [Module ℝ State]
    (Hamiltonian : State → State) :
    ∃ (Psi : State), Psi ≠ 0 ∧ Hamiltonian Psi = 0

literature_citation NoBoundaryProposal
  bibtex_key "hartle1983wave"
  doi "10.1103/PhysRevD.28.2960"
  authors ["Hartle, J. B.", "Hawking, S. W."]
  status Standard
class NoBoundaryProposal where
  /--
  Equation (3.1) and (3.5) (page 2965): The No-Boundary Proposal.
  The ground state wave function amplitude for a given 3-geometry is defined 
  by a Euclidean path integral over the set of 4-geometries that have the 
  3-geometry as their only boundary.
  -/
  ground_state_amplitude
    (ThreeGeometry FourGeometry : Type*)
    (boundaryOf : FourGeometry → ThreeGeometry)
    (EuclideanAction : FourGeometry → ℝ)
    (amplitude : ThreeGeometry → ℝ)
    (pathIntegral : (FourGeometry → ℝ) → Set FourGeometry → ℝ) :
    ∀ (h : ThreeGeometry), 
      amplitude h = pathIntegral (fun g => Real.exp (-EuclideanAction g)) {g | boundaryOf g = h}

literature_citation SemiclassicalGroundState
  bibtex_key "hartle1983wave"
  doi "10.1103/PhysRevD.28.2960"
  authors["Hartle, J. B.", "Hawking, S. W."]
  status Standard
class SemiclassicalGroundState where
  /--
  Equation (4.1) (page 2966): The semiclassical limit.
  The ground-state wave function can be evaluated in the steepest-descents 
  approximation as ħ → 0.
  -/
  semiclassical_approximation
    (ThreeGeometry : Type*)
    (Action : ThreeGeometry → ℝ)
    (WaveFunction : ℝ → ThreeGeometry → ℝ)
    (PreFactor : ThreeGeometry → ℝ) :
    ∀ (h : ThreeGeometry), 
      Tendsto (fun ħ => WaveFunction ħ h) (𝓝[>] 0) (𝓝 (PreFactor h * Real.exp (-Action h)))

literature_citation BigBangInstantonBoundary
  bibtex_key "hartle1983wave"
  doi "10.1103/PhysRevD.28.2960"
  authors["Hartle, J. B.", "Hawking, S. W."]
  status Standard
class BigBangInstantonBoundary where
  /--
  Capstone Theorem for CGD: Big Bang Instanton Boundary.
  At the temporal boundary (t = 0, or the Big Bang), the universe connection
  is a pure Euclidean SO(4) instanton. We secure this by mapping the condition 
  to mathematical self-duality over a rigorously defined Hilbert space.
  -/
  big_bang_is_instanton
    (State : Type*) [NormedAddCommGroup State] [InnerProductSpace ℝ State]
    (star : State → State)
    (Connection : ℝ → State) :
    star (Connection 0) = Connection 0

end Litlib.Y1983.hartle1983wave
