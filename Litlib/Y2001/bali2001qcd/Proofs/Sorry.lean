-- FILENAME: Litlib/Y2001/bali2001qcd/Proofs/Sorry.lean

import Litlib.Y2001.bali2001qcd.Signature

namespace Litlib.Y2001.bali2001qcd.Proofs

-- By abstracting away the integration, this is reduced to a purely algebraic relationship.
@[litlib_difficulty easy, litlib_status Conjecture]
instance : Eq2_3_and_2_4 where
  string_mass_and_ang_mom := sorry

-- Purely algebraic field identity. `ring` should blast through this.
@[litlib_difficulty easy, litlib_status Conjecture]
instance : Eq4_40 where
  singlet_octet_potentials := sorry

-- Purely algebraic field identity. `ring` will blast through this.
@[litlib_difficulty easy, litlib_status Conjecture]
instance : Eq5_11 where
  adjoint_self_energy := sorry

-- This is a beautifully constructed system of polynomial relations parameterized by `r`. 
-- The `ring` tactic can prove this trivially.
@[litlib_difficulty easy, litlib_status Conjecture]
instance : Eq6_48_to_6_50 where
  gromes_and_bbp_relations := sorry

end Litlib.Y2001.bali2001qcd.Proofs
