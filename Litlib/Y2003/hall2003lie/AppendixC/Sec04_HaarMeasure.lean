-- FILENAME: Litlib/Y2003/hall2003lie/AppendixC/Sec04_HaarMeasure.lean


import Litlib.Core
import Litlib.Y2003.hall2003lie.Paper
import Mathlib.MeasureTheory.Group.Measure
import Mathlib.MeasureTheory.Measure.ProbabilityMeasure
import Mathlib.Topology.Algebra.Group.Basic
import Mathlib.LinearAlgebra.Matrix.Determinant.Basic

namespace Litlib.Y2003.hall2003lie

open MeasureTheory MeasureTheory.Measure

Litlib.equation "hall2003lie" eq "HaarMeasure" page "319" kind "theorem"
/--
Physical Interpretation: A compact Lie group admits a unique normalized Haar probability measure.
Mathematical Boundaries: The group G must be compact, Hausdorff, and topological with continuous
multiplication and inversion.
-/
class NormalizedHaarMeasure (G : Type*)
    [Group G] [TopologicalSpace G] [ContinuousMul G] [ContinuousInv G]
    [CompactSpace G] [T2Space G]
    [MeasurableSpace G] [BorelSpace G] where
  mu : Measure G
  is_haar : IsHaarMeasure mu
  is_normalized : IsProbabilityMeasure mu

Litlib.equation "hall2003lie" eq "Prop_C13" page "319" kind "theorem"
/--
Physical Interpretation: A connected Lie group is unimodular if and only if the adjoint action Ad_g
preserves the volume form (det(Ad_g) = 1). Every compact Lie group is unimodular, ensuring that Haar
measure is invariant under group conjugation g E g⁻¹.
Mathematical Boundaries: Requires connected Lie group G and Lie algebra representation Ad.
-/
class PropC13
    (G : Type*) [Group G] [TopologicalSpace G] [MeasurableSpace G] [BorelSpace G]
    (μ : Measure G)
    (ad_det : G → ℝ)
    (isUnimodular : (Measure G) → Prop) where
  unimodular_iff_ad_det :
    isUnimodular μ ↔ (∀ g : G, ad_det g = 1)
  conjugation_invariant :
    isUnimodular μ →
    ∀ (g : G) (E : Set G), MeasurableSet E → μ ((fun x ↦ g * x * g⁻¹) '' E) = μ E

end Litlib.Y2003.hall2003lie
