-- FILENAME: Litlib/Y2017/bengtsson2017geometry/Chapter03/Sec06_FibreBundles.lean

import Litlib.Core
import Mathlib.Topology.Basic
import Litlib.Y2017.bengtsson2017geometry.Paper

namespace Litlib.Y2017.bengtsson2017geometry

Litlib.equation "bengtsson2017geometry"
  eq "thm_global_section"
  page "82"
  kind "theorem"
/--
Physical Interpretation: Establishes whether a principal fibre bundle is topologically trivial, which physical correlates to whether a global continuous gauge choice (section) exists for the system.
Mathematical Boundaries: The base space, bundle space, and the projection map between them must be topologically continuous. A trivial bundle is strictly equivalent to the existence of a globally continuous section map.
-/
class ThmGlobalSection
    (M P : Type) 
    [TopologicalSpace M] [TopologicalSpace P]
    (proj : P → M)
    (isPrincipalBundle : (P → M) → Prop)
    (isTrivialBundle : (P → M) → Prop)
    (hasGlobalSection : (P → M) → Prop) where
  -- Topological Bound: The projection defining the bundle must be continuous.
  proj_cont : Continuous proj
  hasGlobalSection_iff : ∀ p, hasGlobalSection p ↔ ∃ s : M → P, Continuous s ∧ ∀ x, p (s x) = x
  principal_bundle_trivial_iff_global_section :
    isPrincipalBundle proj →
    (hasGlobalSection proj ↔ isTrivialBundle proj)

end Litlib.Y2017.bengtsson2017geometry
