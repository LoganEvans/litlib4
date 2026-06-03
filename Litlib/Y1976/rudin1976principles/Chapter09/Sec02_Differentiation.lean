-- FILENAME: Litlib/Y1976/rudin1976principles/Chapter09/Sec02_Differentiation.lean

import Litlib.Core
import Mathlib.Data.Real.Basic
import Mathlib.Analysis.Calculus.FDeriv.Basic
import Mathlib.Analysis.Calculus.Deriv.Basic
import Mathlib.Topology.Basic
import Mathlib.Order.Filter.Basic
import Mathlib.Analysis.Convex.Basic

open Filter Topology

namespace Litlib.Y1976.rudin1976principles

Litlib.equation "rudin1976principles"
  eq "39"
  page "217"
  kind "Definition"
class DirectionalDerivative where
  /--
  Equation (39) (page 217): The definition of the directional derivative 
  and its equivalence to the Fréchet derivative evaluated on a vector.
  -/
  directionalDerivative
    (V W : Type*) [NormedAddCommGroup V] [NormedSpace ℝ V] [NormedAddCommGroup W][NormedSpace ℝ W]
    (f : V → W) (x u : V)
    (hf : DifferentiableAt ℝ f x) :
    Tendsto (fun t : ℝ => t⁻¹ • (f (x + t • u) - f x)) (𝓝[≠] 0) (𝓝 ((fderiv ℝ f x) u))

Litlib.equation "rudin1976principles"
  eq "Theorem 9.19"
  page "218"
  kind "Theorem"
class MeanValueTheorem where
  /-- 
  Theorem 9.19 (page 218): The Mean Value Theorem for functions of several variables. 
  
  Topological Well-Posedness: To ensure well-posedness and prevent pathological evaluations, 
  the domain `E` is explicitly enforced as a convex, open set. This mathematically 
  guarantees that the line segment connecting `a` and `b` is entirely contained 
  within the domain of differentiability, avoiding boundaries or singularities.
  -/
  multidimensionalMvt
    (V W : Type*) [NormedAddCommGroup V] [NormedSpace ℝ V] [NormedAddCommGroup W] [NormedSpace ℝ W]
    (f : V → W) (E : Set V) (a b : V) (M : ℝ)
    (hOpen : IsOpen E)
    (hConvex : Convex ℝ E)
    (ha : a ∈ E) (hb : b ∈ E)
    (hDiff : DifferentiableOn ℝ f E)
    (hBound : ∀ x ∈ E, ‖fderiv ℝ f x‖ ≤ M) :
    ‖f b - f a‖ ≤ M * ‖b - a‖

Litlib.equation "rudin1976principles"
  eq "Unknown"
  page "217"
  kind "Lemma"
class FrechetToScalarProjection where
  /-- Mathematical theorem projecting multi-dimensional continuous Fréchet limits to 1D scalar derivatives. -/
  projectFrechetTo1d
    (V W : Type*) [NormedAddCommGroup V][NormedSpace ℝ V] [NormedAddCommGroup W] [NormedSpace ℝ W]
    (f : V → W)
    (x u : V)
    (hf : DifferentiableAt ℝ f x) :
    (fderiv ℝ f x) u = deriv (fun t : ℝ => f (x + t • u)) 0

end Litlib.Y1976.rudin1976principles
