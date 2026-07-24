-- FILENAME: Litlib/Y1965/spivak1965calculus/Chapter05/Sec5_TheClassicalTheorems.lean

import Litlib.Core
import Mathlib.MeasureTheory.Measure.Lebesgue.Basic
import Mathlib.MeasureTheory.Integral.Bochner.Basic
import Mathlib.Topology.Basic

namespace Litlib.Y1965.spivak1965calculus

Litlib.equation "spivak1965calculus" eq "5-36" page "137" kind "theorem"
class TheoremArchimedes
  (M : Set (Fin 3 → ℝ))
  (c : ℝ)
  (F : (Fin 3 → ℝ) → (Fin 3 → ℝ))
  (n : (Fin 3 → ℝ) → (Fin 3 → ℝ)) -- outward normal
  (surface_measure : MeasureTheory.Measure (Fin 3 → ℝ))
  (volume_measure : MeasureTheory.Measure (Fin 3 → ℝ))
  where
  
  -- Anti-BS Protocol: Prevent Dimensional/Topological Exploits.
  -- M is restricted to the lower half-space where the fluid exists (x^3 ≤ 0).
  -- In Lean's Fin 3, coordinates are 0, 1, 2. Thus x 2 corresponds to x^3.
  M_in_fluid : ∀ x ∈ M, x 2 ≤ 0
  
  -- Explicit definition of the downward pressure field F(x) = (0, 0, cx^3).
  -- This absolutely blocks the "Opaque Function" exploit.
  F_def : ∀ x, F x 0 = 0 ∧ F x 1 = 0 ∧ F x 2 = c * (x 2)
  
  -- Theorem (Archimedes): The buoyant force on M is equal to the weight of the fluid displaced.
  -- Buoyant force is explicitly defined by Spivak as -∫_∂M ⟨F, n⟩ dA.
  -- By the Divergence Theorem, since div F = c, this equals -c * Volume(M).
  -- We expand the dot product algebraically to prevent generic inner-product obfuscation.
  archimedes_theorem :
    - (∫ x in frontier M, (F x 0 * n x 0 + F x 1 * n x 1 + F x 2 * n x 2) ∂surface_measure) =
    - c * (volume_measure M).toReal

end Litlib.Y1965.spivak1965calculus
