-- FILENAME: Litlib/Y2000/hall2000elementary/Proofs/Sorry.lean

import Litlib.Y2000.hall2000elementary.Signature

namespace Litlib.Y2000.hall2000elementary.Proofs

@[litlib_difficulty easy, litlib_status Conjecture]
instance : Prop3_3 where
  commuting_exp := sorry

-- The Trotter product formula is notoriously difficult to formalize as it
-- requires deep functional analysis and limit interchanges.
@[litlib_difficulty hard, litlib_status Conjecture]
instance : Thm3_9 where
  lie_product_formula := sorry

@[litlib_difficulty easy, litlib_status Conjecture]
instance : Thm3_10 where
  det_exp := sorry

-- Euler's formula is a trivial consequence of the power series expansion for an 
-- involutory matrix. The holonomy reduction is straightforward calculus.
@[litlib_difficulty medium, litlib_status Conjecture]
instance : MatrixCalculus where
  holonomy_self_commuting := sorry
  involutory_euler_formula := sorry

end Litlib.Y2000.hall2000elementary.Proofs
