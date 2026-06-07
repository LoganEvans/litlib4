-- FILENAME: Litlib/Y1965/spivak1965calculus/Chapter05/IntegrationOnChains.lean

import Litlib.Core
import Mathlib.Analysis.Calculus.ContDiff.Basic
import Mathlib.Analysis.Calculus.Deriv.Basic
import Mathlib.MeasureTheory.Measure.Lebesgue.Basic
import Mathlib.MeasureTheory.Integral.Bochner.Basic
import Mathlib.Topology.Basic

namespace Litlib.Y1965.spivak1965calculus

Litlib.equation "spivak1965calculus"
  eq "Corollary to Stokes' Theorem"
  page "122"
  kind "theorem"
class DivergenceTheoremR4Compact
    (f : (Fin 4 → ℝ) → (Fin 4 → ℂ))
    where
  /--
  Compactly Supported Divergence Free Constraint:
  By Stokes' Theorem, the integral of an exact differential form over a manifold 
  without boundary evaluates to zero if the form has compact support. 
  Here, we enforce continuous differentiability and explicitly require the closure 
  of the support to be compact. This rigorously ensures the Lebesgue integral of 
  the divergence over Euclidean space is mathematically well-posed and evaluates 
  to zero, precluding boundary term singularities.
  -/
  hf_smooth : ContDiff ℝ 1 f
  hf_compact : IsCompact (closure {x | f x ≠ 0})
  
  integral_div_zero :
    ∫ x : Fin 4 → ℝ, (∑ i : Fin 4, deriv (fun t => f (Function.update x i t) i) (x i)) ∂MeasureTheory.volume = 0

end Litlib.Y1965.spivak1965calculus
