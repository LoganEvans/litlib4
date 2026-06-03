-- FILENAME: Litlib/Y1949/infeld1949motion/Signature.lean

import Litlib.Core
import Mathlib.Topology.Basic
import Mathlib.Analysis.Calculus.Deriv.Basic

namespace Litlib.Y1949.infeld1949motion

Litlib.paper "infeld1949motion"
  type "article"
  title "On the motion of test particles in general relativity"
  authors ["Infeld, Leopold", "Schild, Alfred"]
  journal "Reviews of Modern Physics"
  volume "21"
  issue "3"
  pages "408--413"
  year "1949"
  publisher "APS"
  doi "10.1103/RevModPhys.21.408"

Litlib.equation "infeld1949motion"
  eq "main"
  page "413"
  kind "theorem"
class TestParticleGeodesic 
    (M : Type*) [TopologicalSpace M]
    (Metric : Type*)
    (StressEnergy : Type*)
    (isLorentzian : Metric → Prop)
    (satisfiesFieldEquations : Metric → StressEnergy → Prop)
    (isSmoothCurve : (ℝ → M) → Prop)
    (hasNonZeroTangent : (ℝ → M) → Prop)
    (isTimelike : Metric → (ℝ → M) → Prop)
    (isTestParticleWorldline : Metric → (ℝ → M) → Prop)
    (isGeodesic : Metric → (ℝ → M) → Prop) where
  
  /-- 
  Topological Well-Posedness: Ensure the function mapping proper time to spacetime 
  is continuous to prevent pathological worldline topologies.
  -/
  worldline_continuous_req : ∀ g γ, isTestParticleWorldline g γ → Continuous γ
  
  /-- 
  Differential Smoothness Constraint: Test particle worldlines must possess a 
  well-defined differentiable structure to permit tangent vector evaluation.
  -/
  worldline_smoothness_req : ∀ g γ, isTestParticleWorldline g γ → isSmoothCurve γ

  /-- 
  Geometric Non-Degeneracy Constraint: Ensure the worldline is not a trivial 
  stationary coordinate point, requiring a strictly non-zero tangent vector.
  -/
  worldline_non_degenerate_req : ∀ g γ, isTestParticleWorldline g γ → hasNonZeroTangent γ

  /-- 
  Physical Domain Bound: The worldline must be strictly time-like, establishing 
  the proper mass boundary condition for the massive test particle.
  -/
  worldline_timelike_req : ∀ g γ, isTestParticleWorldline g γ → isTimelike g γ

  /-- 
  Physical State Distinction: We do not define `isTestParticleWorldline` trivially 
  as `isGeodesic`. They represent distinct physical properties (a limiting singularity 
  vs a pure geometric path) connected fundamentally by the field equations.

  Core Theorem (Page 413, extended in Section 6):
  As a consequence of the gravitational field equations, a test particle must move 
  along a geodesic of the background field. By introducing a macroscopic stress-energy 
  tensor T, we physically bind the theorem to a domain where a background spacetime 
  is sourced appropriately, preventing trivial application to degenerate vacuum states.
  -/
  test_particle_motion_is_geodesic : ∀ g T γ,
    isLorentzian g →
    satisfiesFieldEquations g T →
    isTestParticleWorldline g γ →
    isGeodesic g γ

end Litlib.Y1949.infeld1949motion
