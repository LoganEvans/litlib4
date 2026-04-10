-- FILENAME: Litlib/Y1989/capovilla1989general/Proofs/Sorry.lean

import Litlib.Y1989.capovilla1989general.Signature

namespace Litlib.Y1989.capovilla1989general.Proofs

@[litlib_difficulty intractable, litlib_status Conjecture]
instance : Eq1 where
  h_tensor _ _ _ _ := 0
  Action _ _ := 0

@[litlib_difficulty intractable, litlib_status Conjecture]
instance : Eq6_RicciFlat where
  satisfies_cdj_constraint _ := True
  urbantke_metric _ _ _ _ := 0
  ricci_tensor _ _ _ _ := 0
  cdj_implies_ricci_flat _ _ _ _ _ := rfl
