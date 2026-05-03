-- FILENAME: Litlib/Y1976/rudin1976principles/Signature.lean

import Litlib.Core
import Mathlib.Data.Real.Basic
import Mathlib.Analysis.Calculus.FDeriv.Basic
import Mathlib.Analysis.Calculus.Deriv.Basic
import Mathlib.Topology.Basic
import Mathlib.Order.Filter.Basic

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
  kind "Unknown"
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

Litlib.equation "rudin1976principles"
  eq "Unknown"
  page "218"
  kind "Unknown"
class Thm9_19 where
  /-- Theorem 9.19 (page 218): The Mean Value Theorem for functions of several variables. -/
  multidimensionalMvt
    (V W : Type*) [NormedAddCommGroup V] [NormedSpace ℝ V][NormedAddCommGroup W] [NormedSpace ℝ W]
    (f : V → W)
    (a b : V)
    (M : ℝ) :
    Differentiable ℝ f →
    (∀ x, ‖fderiv ℝ f x (b - a)‖ ≤ M * ‖b - a‖) →
    ‖f b - f a‖ ≤ M * ‖b - a‖

Litlib.equation "rudin1976principles"
  eq "Unknown"
  page "Unknown"
  kind "Unknown"
class FrechetToScalarProjection where
  /-- Mathematical theorem projecting multi-dimensional continuous Fréchet limits. -/
  projectFrechetTo1d
    (V W : Type*) [NormedAddCommGroup V][NormedSpace ℝ V] [NormedAddCommGroup W] [NormedSpace ℝ W]
    (f : V → W)
    (x u : V)
    (hf : DifferentiableAt ℝ f x) :
    (fderiv ℝ f x) u = deriv (fun t : ℝ => f (x + t • u)) 0

end Litlib.Y1976.rudin1976principles
