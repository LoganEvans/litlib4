-- FILENAME: Litlib/Y1976/rudin1976principles/Chapter11/LebesgueIntegral.lean

import Litlib.Core
import Mathlib.Analysis.Calculus.ContDiff.Basic
import Mathlib.Analysis.Calculus.Deriv.Basic
import Mathlib.MeasureTheory.Measure.Lebesgue.Basic
import Mathlib.MeasureTheory.Integral.Bochner.Basic
import Mathlib.Topology.Basic

namespace Litlib.Y1976.rudin1976principles

Litlib.equation "rudin1976principles"
  eq "Theorem 11.28 (Leibniz Integral Rule)"
  page "317"
  kind "theorem"
class LeibnizIntegralRule
    (f : ℝ → (Fin 4 → ℝ) → ℂ)
    where
  /--
  Leibniz Integral Rule via Dominated Convergence (Theorem 11.28):
  
  Topological Gatekeeping (Override Applied): A naive formalization requires 
  only pointwise differentiability, which allows pathological functions to generate 
  locally unbounded derivatives that Mathlib's default integral evaluates to zero 
  (Garbage-In Exploit). To prevent this, we mathematically enforce `ContDiff ℝ 1` 
  (joint continuous differentiability) on `f` over the product space, which 
  guarantees the local boundedness of `∂f/∂t` necessary for the rigorous application 
  of the Dominated Convergence Theorem. The variation is compactly supported 
  to prevent escape to spatial infinity.
  -/
  hf_smooth : ContDiff ℝ 1 (fun p : ℝ × (Fin 4 → ℝ) => f p.1 p.2)
  hf_integrable : ∀ t, MeasureTheory.Integrable (f t) MeasureTheory.volume
  hf_variation_compact : ∃ K : Set (Fin 4 → ℝ), IsCompact K ∧ ∀ t x, x ∉ K → f t x = f 0 x
  
  leibniz_commute :
    ∀ t, deriv (fun s => ∫ x, f s x ∂MeasureTheory.volume) t = 
         ∫ x, deriv (fun s => f s x) t ∂MeasureTheory.volume

end Litlib.Y1976.rudin1976principles
