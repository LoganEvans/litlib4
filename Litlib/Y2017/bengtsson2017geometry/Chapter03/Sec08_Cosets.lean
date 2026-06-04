-- FILENAME: Litlib/Y2017/bengtsson2017geometry/Chapter03/Sec08_Cosets.lean

import Litlib.Core
import Mathlib.Topology.Basic
import Mathlib.GroupTheory.QuotientGroup.Basic
import Litlib.Y2017.bengtsson2017geometry.Paper

namespace Litlib.Y2017.bengtsson2017geometry

Litlib.equation "bengtsson2017geometry"
  eq "3.144"
  page "91"
  kind "theorem"
/--
Physical Interpretation: Calculates the dimension of a coset space, which corresponds to the remaining physical degrees of freedom of a system modulo its gauge or symmetry transformations.
Mathematical Boundaries: Assumes `G` and `H` are Lie groups. The dimension of the normal subgroup `H` must be less than or equal to `G` to prevent negative or vacuous dimensionality.
-/
class Eq3_144
    (G : Type) [Group G] [TopologicalSpace G]
    (H : Subgroup G) [Subgroup.Normal H]
    (dim : Type → ℕ)
    (isLieGroup : Type → Prop) where
  coset_manifold_dim :
    isLieGroup G →
    isLieGroup H →
    dim H ≤ dim G →
    dim (G ⧸ H) = dim G - dim H

end Litlib.Y2017.bengtsson2017geometry
