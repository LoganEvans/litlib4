-- FILENAME: Litlib/Y1975/belavin1975pseudoparticle/Proofs/Sorry.lean

import Litlib.Y1975.belavin1975pseudoparticle.Signature

namespace Litlib.Y1975.belavin1975pseudoparticle.Proofs

@[litlib_difficulty easy, litlib_status Conjecture]
instance : Eq16 where
  bpst_profile_ode := sorry

@[litlib_difficulty hard, litlib_status Conjecture]
instance : BpstModuliUniqueness where
  bpst_uniqueness := sorry

@[litlib_difficulty easy, litlib_status Conjecture]
instance : BpstIsSelfDual where
  bpst_satisfies_self_duality := sorry

@[litlib_difficulty easy, litlib_status Conjecture]
instance : BpstCoreExpansion where
  bpst_core_trace_eq_hedgehog_core_trace := sorry

end Litlib.Y1975.belavin1975pseudoparticle.Proofs
