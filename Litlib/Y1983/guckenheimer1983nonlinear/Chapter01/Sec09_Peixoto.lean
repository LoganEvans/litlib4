-- FILENAME: Litlib/Y1983/guckenheimer1983nonlinear/Chapter01/Sec09_Peixoto.lean

import Litlib.Core
import Mathlib.Topology.Basic

namespace Litlib.Y1983.guckenheimer1983nonlinear

Litlib.equation "guckenheimer1983nonlinear"
  eq "Theorem 1.9.1"
  page "60"
  kind "theorem"
class Theorem1_9_1
  (M : Type*) [TopologicalSpace M] [CompactSpace M]
  (V : Type*)
  (is_structurally_stable : V → Prop)
  (has_finite_fixed_points_and_closed_orbits : V → Prop)
  (all_fixed_and_closed_are_hyperbolic : V → Prop)
  (has_saddle_connections : V → Prop)
  (nonwandering_set_is_only_fixed_and_periodic : V → Prop)
  where
  peixoto_iff : ∀ (v : V), 
    is_structurally_stable v ↔ 
      (has_finite_fixed_points_and_closed_orbits v ∧ 
       all_fixed_and_closed_are_hyperbolic v ∧ 
       ¬ has_saddle_connections v ∧ 
       nonwandering_set_is_only_fixed_and_periodic v)

end Litlib.Y1983.guckenheimer1983nonlinear
