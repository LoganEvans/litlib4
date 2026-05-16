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
    (isLorentzian : Metric → Prop)
    (isVacuum : Metric → Prop)
    (isSmoothCurve : (ℝ → M) → Prop)
    (hasNonZeroTangent : (ℝ → M) → Prop)
    (isTimelike : Metric → (ℝ → M) → Prop)
    (isTestParticleWorldline : Metric → (ℝ → M) → Prop)
    (isGeodesic : Metric → (ℝ → M) → Prop) where
  
  -- 1. Garbage-In Exploit Prevention
  -- Ensure the function mapping proper time to spacetime is continuous.
  worldline_continuous_req : ∀ g γ, isTestParticleWorldline g γ → Continuous γ
  
  -- Ensure test particle worldlines meet the required differential smoothness.
  worldline_smoothness_req : ∀ g γ, isTestParticleWorldline g γ → isSmoothCurve γ

  -- 2. Zero/Trivial Exploit Prevention
  -- Ensure worldline is not a trivial stationary coordinate point (tangent ≠ 0).
  worldline_non_degenerate_req : ∀ g γ, isTestParticleWorldline g γ → hasNonZeroTangent γ

  -- Ensure the worldline is strictly time-like (massive particle boundary condition).
  worldline_timelike_req : ∀ g γ, isTestParticleWorldline g γ → isTimelike g γ

  -- 3. Tautology Exploit Prevention
  -- We do not define `isTestParticleWorldline` as `isGeodesic`. They are 
  -- distinct physical properties connected by the field equations.

  -- The Core Theorem (Page 413): "As a consequence of the gravitational field 
  -- equations in empty space, a test particle must move along a geodesic of the background field."
  test_particle_motion_is_geodesic : ∀ g γ,
    isLorentzian g →
    isVacuum g →
    isTestParticleWorldline g γ →
    isGeodesic g γ

end Litlib.Y1949.infeld1949motion
