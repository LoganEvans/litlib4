-- FILENAME: Litlib/Y2003/hall2003lie/AppendixC/Sec04_HaarMeasure.lean

import Litlib.Core
import Litlib.Y2003.hall2003lie.Paper
import Mathlib.MeasureTheory.Group.Measure
import Mathlib.MeasureTheory.Measure.ProbabilityMeasure
import Mathlib.Topology.Algebra.Group.Basic

namespace Litlib.Y2003.hall2003lie

open MeasureTheory MeasureTheory.Measure

Litlib.equation "hall2003lie" eq "HaarMeasure" page "319" kind "theorem"
class NormalizedHaarMeasure (G : Type*)
  [Group G] [TopologicalSpace G] [ContinuousMul G] [ContinuousInv G] 
  [CompactSpace G] [T2Space G]
  [MeasurableSpace G] [BorelSpace G] where
  mu : Measure G
  is_haar : IsHaarMeasure mu
  is_normalized : IsProbabilityMeasure mu

end Litlib.Y2003.hall2003lie
