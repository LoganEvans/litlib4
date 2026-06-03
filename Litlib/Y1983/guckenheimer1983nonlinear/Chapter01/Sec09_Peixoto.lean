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
  (is_topologically_equivalent : V → V → Prop)
  (is_close : V → V → Prop)
  (is_structurally_stable_iff : ∀ v, is_structurally_stable v ↔ ∃ u_set : Set V, (∀ u ∈ u_set, is_topologically_equivalent u v) ∧ (∀ u, is_close u v → u ∈ u_set))
  (has_finite_fixed_points_and_closed_orbits : V → Prop)
  (all_fixed_and_closed_are_hyperbolic : V → Prop)
  (has_saddle_connections : V → Prop)
  (nonwandering_set_is_only_fixed_and_periodic : V → Prop)
  where
  /--
  Peixoto's Theorem: Theorem 1.9.1.
  A foundational theorem identifying the precise topological conditions under which a 
  dynamical system on a compact two-dimensional manifold maintains structural stability. 
  Topologically binds the system against saddle connections and non-hyperbolic degeneracies.
  -/
  peixoto_iff : ∀ (v : V), 
    is_structurally_stable v ↔ 
      (has_finite_fixed_points_and_closed_orbits v ∧ 
       all_fixed_and_closed_are_hyperbolic v ∧ 
       ¬ has_saddle_connections v ∧ 
       nonwandering_set_is_only_fixed_and_periodic v)

end Litlib.Y1983.guckenheimer1983nonlinear
