-- FILENAME: Litlib/Y1976/rudin1976principles/Signature.lean

import Litlib.Core
import Mathlib.Data.Real.Basic
import Mathlib.Analysis.Calculus.FDeriv.Basic
import Mathlib.Analysis.Calculus.Deriv.Basic
import Mathlib.Topology.Basic
import Mathlib.Order.Filter.Basic

open Filter Topology

namespace Litlib.Y1976.rudin1976principles

Litlib.reference Eq9_39
  bibtex "rudin1976principles"
  authors ["Rudin, Walter"]
  status Standard
class Eq9_39 where
  /--
  Equation (39) (page 217): The definition of the directional derivative 
  and its equivalence to the Fréchet derivative evaluated on a vector.
  -/
  directionalDerivative
    (V W : Type*) [NormedAddCommGroup V] [NormedSpace ℝ V] [NormedAddCommGroup W][NormedSpace ℝ W]
    (f : V → W) (x u : V)
    (hf : DifferentiableAt ℝ f x) :
    Tendsto (fun t : ℝ => t⁻¹ • (f (x + t • u) - f x)) (𝓝[≠] 0) (𝓝 ((fderiv ℝ f x) u))

Litlib.reference Thm9_19
  bibtex "rudin1976principles"
  authors ["Rudin, Walter"]
  status Standard
class Thm9_19 where
  /--
  Theorem 9.19 (page 218): The Mean Value Theorem for functions of several variables.
  -/
  multidimensionalMvt
    (V W : Type*) [NormedAddCommGroup V] [NormedSpace ℝ V][NormedAddCommGroup W] [NormedSpace ℝ W]
    (f : V → W)
    (a b : V)
    (M : ℝ) :
    Differentiable ℝ f →
    (∀ x, ‖fderiv ℝ f x (b - a)‖ ≤ M * ‖b - a‖) →
    ‖f b - f a‖ ≤ M * ‖b - a‖

Litlib.reference FrechetToScalarProjection
  bibtex "rudin1976principles"
  authors["Rudin, Walter"]
  status Standard
class FrechetToScalarProjection where
  /--
  Capstone Theorem for CGD: Fréchet to Scalar Projection.
  Mathematical theorem projecting multi-dimensional continuous Fréchet 
  derivatives down to 1D scalar limits using Mathlib's native topologies.
  -/
  projectFrechetTo1d
    (V W : Type*) [NormedAddCommGroup V][NormedSpace ℝ V] [NormedAddCommGroup W] [NormedSpace ℝ W]
    (f : V → W)
    (x u : V)
    (hf : DifferentiableAt ℝ f x) :
    (fderiv ℝ f x) u = deriv (fun t : ℝ => f (x + t • u)) 0

end Litlib.Y1976.rudin1976principles
