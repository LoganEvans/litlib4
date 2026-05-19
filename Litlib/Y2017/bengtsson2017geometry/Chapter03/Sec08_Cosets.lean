-- FILENAME: Litlib/Y2017/bengtsson2017geometry/Chapter03/Sec08_Cosets.lean

import Litlib.Core
import Mathlib.Topology.Basic
import Litlib.Y2017.bengtsson2017geometry.Paper

namespace Litlib.Y2017.bengtsson2017geometry

Litlib.equation "bengtsson2017geometry"
  eq "3.144"
  page "91"
  kind "theorem"
class Eq3_144
    (G H G_mod_H : Type)
    (dim : Type → ℕ)
    (isLieGroup : Type → Prop)
    (isClosedSubgroup : Type → Type → Prop)
    (isCosetSpace : Type → Type → Type → Prop) where
  -- Theorem
  coset_manifold_dim :
    isLieGroup G →
    isLieGroup H →
    isClosedSubgroup H G →
    isCosetSpace G_mod_H G H →
    dim H ≤ dim G → -- Prevent pathological subtraction in ℕ where N - M = 0 for M > N
    dim G_mod_H = dim G - dim H

end Litlib.Y2017.bengtsson2017geometry
