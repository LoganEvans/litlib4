-- FILENAME: Litlib/Y2003/hall2003lie/Chapter04/Sec10_CompleteReducibility.lean


import Litlib.Core
import Litlib.Y2003.hall2003lie.Paper
import Mathlib.MeasureTheory.Group.Measure
import Mathlib.Topology.Algebra.Group.Basic

namespace Litlib.Y2003.hall2003lie

Litlib.equation "hall2003lie" eq "HaarMeasure" page "120" kind "definition"
class LeftHaarMeasure
    (G : Type*)
    [TopologicalSpace G] [Group G] [MeasurableSpace G] [BorelSpace G]
    (μ : MeasureTheory.Measure G) : Prop where
  is_nonzero : μ ≠ 0
  is_locally_finite : MeasureTheory.IsLocallyFiniteMeasure μ
  is_left_invariant : ∀ (g : G) (E : Set G),
    MeasurableSet E → μ ((fun x ↦ g * x) '' E) = μ E

Litlib.equation "hall2003lie" eq "Unimodular" page "121" kind "definition"
class Unimodular
    (G : Type*)
    [TopologicalSpace G] [Group G] [MeasurableSpace G] [BorelSpace G] : Prop where
  left_is_right : ∀ (μ : MeasureTheory.Measure G), LeftHaarMeasure G μ →
    ∀ (g : G) (E : Set G), MeasurableSet E → μ ((fun x ↦ x * g) '' E) = μ E

end Litlib.Y2003.hall2003lie
