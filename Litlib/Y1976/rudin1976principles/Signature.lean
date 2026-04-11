-- FILENAME: Litlib/Y1976/rudin1976principles/Signature.lean

import Litlib.Core
import Mathlib.Data.Real.Basic
import Mathlib.Algebra.Module.Basic

namespace Litlib.Y1976.rudin1976principles

literature_citation Eq9_39
  bibtex_key "rudin1976principles"
  authors ["Rudin, Walter"]
  status Standard
class Eq9_39 where
  /--
  Equation (39) (page 217): The definition of the directional derivative 
  and its equivalence to the Fréchet derivative evaluated on a vector.
  -/
  directional_derivative
    (V W : Type*) [AddCommGroup V] [Module ℝ V] [AddCommGroup W] [Module ℝ W]
    (f : V → W)
    (frechetDeriv : V → V → W)
    (isFrechetDerivative : (V → W) → (V → V → W) → Prop)
    (limitToZero : (ℝ → W) → W → Prop) :
    isFrechetDerivative f frechetDeriv →
    ∀ x u : V, limitToZero (fun t => (t⁻¹) • (f (x + t • u) - f x)) (frechetDeriv x u)

literature_citation Thm9_19
  bibtex_key "rudin1976principles"
  authors ["Rudin, Walter"]
  status Standard
class Thm9_19 where
  /--
  Theorem 9.19 (page 218): The Mean Value Theorem for functions of several variables.
  Projects the multidimensional bounds down to a 1D scalar function along a line segment.
  -/
  multidimensional_mvt
    (V W : Type*) [AddCommGroup V] [Module ℝ V] [AddCommGroup W] [Module ℝ W]
    (f : V → W)
    (normV : V → ℝ)
    (normW : W → ℝ)
    (frechetDeriv : V → V → W)
    (isFrechetDerivative : (V → W) → (V → V → W) → Prop)
    (a b : V)
    (M : ℝ) :
    isFrechetDerivative f frechetDeriv →
    (∀ x, normW (frechetDeriv x (b - a)) ≤ M * normV (b - a)) →
    normW (f b - f a) ≤ M * normV (b - a)

literature_citation FrechetToScalarProjection
  bibtex_key "rudin1976principles"
  authors ["Rudin, Walter"]
  status Standard
class FrechetToScalarProjection where
  /--
  Capstone Theorem for CGD: Fréchet to Scalar Projection.
  Mathematical theorem projecting multi-dimensional continuous Fréchet 
  derivatives down to 1D scalar limits (so that CGD can evaluate them algebraically).
  If g(t) = f(x + t u), then the scalar derivative g'(0) = Df(x)[u].
  -/
  project_frechet_to_1d
    (V W : Type*)[AddCommGroup V] [Module ℝ V]
    (f : V → W)
    (frechetDeriv : (V → W) → V → V → W)
    (scalarDeriv : (ℝ → W) → ℝ → W) :
    ∀ (x u : V),
      frechetDeriv f x u = scalarDeriv (fun t => f (x + t • u)) 0
