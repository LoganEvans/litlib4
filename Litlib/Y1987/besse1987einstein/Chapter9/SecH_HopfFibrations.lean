-- FILENAME: Litlib/Y1987/besse1987einstein/Chapter9/SecH_HopfFibrations.lean

import Litlib.Core
import Mathlib

Litlib.paper "besse1987einstein"
  type "book"
  title "Einstein Manifolds"
  authors ["Besse, Arthur L."]
  year "1987"

Litlib.equation "besse1987einstein" eq "9.81" page "257" kind "example"
class Example_9_81 (m : ℕ) [Fact (m ≥ 1)]
  (M B : Type*) [TopologicalSpace M] [TopologicalSpace B]
  (pi : M → B)
  (Metric : Type*)
  (g : Metric)
  (isEinstein : Metric → Prop)
  (canonicalVariation : Metric → ℝ → Metric)
  (scalarCurvature : Metric → ℝ)
  where

  -- Besse p. 257: "Notice that the standard SU(m+1)-invariant metric on S^{2m+1} is not Einstein."
  -- We strictly enforce this negative condition.
  g_not_einstein : ¬ isEinstein g

  -- The explicit scalar curvature polynomial for the canonical variation g_t.
  -- φ(t) = 2mt^{-1/(2m+1)}(2m + 2 - t)
  -- The exponent MUST be negative. We explicitly write the
  -- right-hand-side algebra so downstream users are forced to match it.
  canonicalVariationScalarCurvature : ∀ (t : ℝ), t > 0 →
    scalarCurvature (canonicalVariation g t) =
      2 * (m : ℝ) * (t ^ (-(1 : ℝ) / (2 * (m : ℝ) + 1))) * (2 * (m : ℝ) + 2 - t)
