-- FILENAME: Litlib/Y1975/belavin1975pseudoparticle/Proofs/Sorry.lean

import Litlib.Y1975.belavin1975pseudoparticle.Signature

namespace Litlib.Y1975.belavin1975pseudoparticle.Proofs

@[litlib_difficulty intractable, litlib_status Conjecture]
instance : Eq11_SelfDuality where
  is_self_dual _ := True
  is_anti_self_dual _ := True

@[litlib_difficulty intractable, litlib_status Conjecture]
instance : Eq10_ActionBound where
  bogomolnyi_bound _ := sorry
  saturation_condition _ _ := sorry
