-- FILENAME: Litlib/Y1976/rudin1976principles/Signature.lean

import Litlib.Core
import Mathlib.Data.Real.Basic
import Mathlib.Analysis.Calculus.FDeriv.Basic
import Mathlib.Analysis.Calculus.Deriv.Basic
import Mathlib.Topology.Basic
import Mathlib.Order.Filter.Basic
import Mathlib.Analysis.Convex.Basic

open Filter Topology

namespace Litlib.Y1976.rudin1976principles

Litlib.paper "rudin1976principles"
  type "book"
  title "Principles of Mathematical Analysis"
  authors ["Rudin, Walter"]
  volume "3"
  year "1976"
  publisher "McGraw-Hill"
  address "New York"
  edition "3rd"
  series "International Series in Pure and Applied Mathematics"
  isbn "978-0070542358"

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
  
  ANTI-BS PROVISIONS:
  Upgraded from the previous translation to explicitly enforce the domain `E` as a 
  convex, open set. This correctly forces the line segment between `a` and `b` to exist 
  entirely within the domain of differentiability, eliminating the Garbage-In exploit 
  where non-convex domains could cross singularities.
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
