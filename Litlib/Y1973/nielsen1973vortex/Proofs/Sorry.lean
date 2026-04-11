-- FILENAME: Litlib/Y1973/nielsen1973vortex/Proofs/Sorry.lean

import Litlib.Y1973.nielsen1973vortex.Signature

namespace Litlib.Y1973.nielsen1973vortex.Proofs

-- Eq 2.19 is fundamentally an algebraic statement equivalent to completing 
-- the square: c₄(x² - c₂/(2c₄))² ≥ 0. Therefore, it is 'easy' to formalize.
@[litlib_difficulty easy, litlib_status Conjecture]
instance : Eq2_19 where
  vacuum_value := sorry

-- Eq 2.21 simply involves evaluating the second Fréchet derivative of a 
-- polynomial at a specific point and simplifying algebraically.
@[litlib_difficulty easy, litlib_status Conjecture]
instance : Eq2_21 where
  scalar_mass_sq := sorry

end Litlib.Y1973.nielsen1973vortex.Proofs
