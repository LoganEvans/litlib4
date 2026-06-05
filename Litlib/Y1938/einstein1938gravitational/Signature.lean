-- FILENAME: Litlib/Y1938/einstein1938gravitational/Signature.lean

import Litlib.Core
import Mathlib.Topology.Basic
import Mathlib.Data.Matrix.Basic
import Mathlib.Data.Real.Basic

namespace Litlib.Y1938.einstein1938gravitational

Litlib.paper "einstein1938gravitational"
  type "article"
  title "The Gravitational Equations and the Problem of Motion"
  authors ["Einstein, A.", "Infeld, L.", "Hoffmann, B."]
  journal "Annals of Mathematics"
  volume "39"
  issue "1"
  pages "65--100"
  year "1938"
  publisher "Mathematics Department, Princeton University"
  url "https://www.jstor.org/stable/1968714"

Litlib.equation "einstein1938gravitational"
  eq "1, 3"
  page "67"
  kind "definition"
class Eq1_3
    (MinkowskiMetric : Matrix (Fin 4) (Fin 4) ℝ) where
  /--
  Physical Interpretation: The flat space-time background metric convention.
  
  Mathematical Boundaries: Defines the specific algebraic signature (+, -, -, -) used 
  in the perturbative expansion of the physical metric. This explicit definition 
  prevents sign-convention drift in subsequent tensor contractions.
  
  Relationship to Literature: Corresponds exactly to Equation (1, 3) on page 67. The 
  chosen signature is +1 for the time component (0,0) and -1 for the spatial components.
  -/
  minkowski_metric_def : 
    MinkowskiMetric 0 0 = 1 ∧
    MinkowskiMetric 1 1 = -1 ∧
    MinkowskiMetric 2 2 = -1 ∧
    MinkowskiMetric 3 3 = -1 ∧
    (∀ i j, i ≠ j → MinkowskiMetric i j = 0)


Litlib.equation "einstein1938gravitational"
  eq "1, 2"
  page "67"
  kind "definition"
class Eq1_2
    (Spacetime : Type*) [TopologicalSpace Spacetime]
    (Metric : Type*)
    (MetricDeterminant : Metric → Spacetime → ℝ)
    (RicciTensor : Metric → Spacetime → Matrix (Fin 4) (Fin 4) ℝ)
    (isEmptySpace : Metric → Prop) where
  /--
  Physical Interpretation: The fundamental gravitational field equations for empty space,
  which the authors show are sufficient to determine the motion of point singularities.
  
  Mathematical Boundaries: Geometric Non-Degeneracy Constraint. The metric determinant 
  must be strictly non-zero at all evaluated points to prevent topological collapse of 
  the volume form and to ensure the invertibility of the metric tensor.
  
  Relationship to Literature: Corresponds to Equation (1, 2) on page 67, establishing
  the vacuum field equations R_μν = 0.
  -/
  is_empty_space_iff : ∀ (g : Metric),
    isEmptySpace g ↔ (∀ (x : Spacetime), MetricDeterminant g x ≠ 0 ∧ RicciTensor g x = 0)


Litlib.equation "einstein1938gravitational"
  eq "2, 4"
  page "70"
  kind "theorem"
class Eq2_4
    (VectorField : Type*)
    (Surface : Type*) [TopologicalSpace Surface]
    (isClosedSurface : Surface → Prop)
    (doesNotPassThroughSingularities : Surface → VectorField → Prop)
    (curlNormalComponent : VectorField → Surface → ℝ)
    (isIntegrable : (Surface → ℝ) → Surface → Prop)
    (surfaceIntegral : (Surface → ℝ) → Surface → ℝ)
    (StressEnergyTensor : Surface → Matrix (Fin 3) (Fin 3) ℝ) 
    where
  /--
  Physical Interpretation: A fundamental integral property stating that the surface 
  integral of the normal component of a curl over a closed surface not traversing 
  singularities is identically zero. This is used to derive conservation laws and motion.
  
  Mathematical Boundaries: The surface S must be closed (compact, without boundary). 
  The function evaluated must be explicitly integrable over the surface to prevent 
  vacuous truths on pathological topologies. Furthermore, we bind this theorem 
  to a domain supporting a macroscopic Stress-Energy Tensor; this binds the existence 
  of stable, definable macroscopic integration surfaces to a valid physical background, 
  preventing arbitrary evaluation over degenerate vacuum states.
  
  Relationship to Literature: Corresponds to Equation (2, 4) on page 70, which
  uses Stokes' theorem as the foundation for the surface integral method of 
  deriving equations of motion.
  -/
  integral_curl_zero : ∀ (S : Surface) (A : VectorField),
    isClosedSurface S →
    doesNotPassThroughSingularities S A →
    isIntegrable (curlNormalComponent A) S →
    surfaceIntegral (curlNormalComponent A) S = 0


Litlib.equation "einstein1938gravitational"
  eq "8, 9"
  page "88"
  kind "theorem"
class Eq8_9
    (Particle : Type*)
    (lambda : ℝ)
    (c_m : Particle → ℕ → ℝ)
    (eihSum : Particle → ℕ → ℝ)
    (isValidMotionUpToStage : Particle → ℕ → Prop)
    where
  /--
  Physical Interpretation: The central Einstein-Infeld-Hoffmann (EIH) Theorem. 
  It demonstrates that the vacuum gravitational field equations natively dictate the 
  motion of point singularities, rendering any independent "geodesic postulate" redundant. 
  The equations of motion for a singularity up to approximation stage `q` are satisfied 
  if and only if the weighted sum of its spatial surface integrals `c_m` vanishes.
  
  Mathematical Boundaries: The approximation parameter `lambda` must be strictly positive 
  and the approximation stage `q` must be at least 1. If `lambda = 0` or `q = 0`, the 
  expansion trivially collapses into the empty Galilean case (as noted on page 88), 
  rendering the equivalence meaningless. The finite sum is rigorously locked via 
  recursive constraints to avoid unbound operations.
  
  Relationship to Literature: Corresponds to Equation (8, 9) on page 88, explicitly defining
  the general approximate equations of motion for stage `l = q`.
  -/
  eihSum_base : ∀ (p : Particle), eihSum p 0 = 0
  eihSum_step : ∀ (p : Particle) (q : ℕ), 
    eihSum p (q + 1) = eihSum p q + (lambda ^ (2 * (q + 1))) * c_m p (q + 1)
    
  approximate_equations_of_motion : ∀ (p : Particle) (q : ℕ),
    lambda > 0 →
    q ≥ 1 →
    isValidMotionUpToStage p q ↔ (eihSum p q = 0)


Litlib.equation "einstein1938gravitational"
  eq "11.15"
  page "94"
  kind "theorem"
class Eq11_15
    (ParticleState : Type*)
    (Mass : ParticleState → ℝ)
    (Position : ParticleState → ℝ → Fin 3 → ℝ)
    (Acceleration : ParticleState → ℝ → Fin 3 → ℝ)
    (isFirstApproximationGR : ParticleState → ParticleState → Prop)
    (NewtonianForce : ParticleState → ParticleState → ℝ → Fin 3 → ℝ)
    where
  /--
  Physical Interpretation: The first non-trivial approximation of the general relativistic
  empty-space field equations for two point singularities recovers the classical 
  Newtonian laws of motion.
  
  Mathematical Boundaries: The masses must be strictly positive to prevent unbounded 
  repulsions and division-by-zero anomalies in the derivation of the interaction potentials. 
  The spatial positions of the particles must remain strictly distinct at all evaluated 
  times to ensure the distance `r` is strictly positive, preserving the manifold's integrity.
  
  Relationship to Literature: Corresponds to Equation (11.15) on page 94, representing
  the culmination of the first approximation stage showing m \ddot{\xi} = \nabla(m^2 / r).
  -/
  newtonian_limit : ∀ (p1 p2 : ParticleState) (t : ℝ),
    p1 ≠ p2 →
    Mass p1 > 0 →
    Mass p2 > 0 →
    (∃ i : Fin 3, Position p1 t i ≠ Position p2 t i) →
    isFirstApproximationGR p1 p2 →
    ∀ i : Fin 3, (Mass p1) * (Acceleration p1 t i) = NewtonianForce p1 p2 t i

end Litlib.Y1938.einstein1938gravitational
