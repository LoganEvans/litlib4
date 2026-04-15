-- FILENAME: Litlib/Y2024/gielen2024unimodular/Proofs/Sorry.lean

import Litlib.Y2024.gielen2024unimodular.Signature

namespace Litlib.Y2024.gielen2024unimodular.Proofs

@[litlib_difficulty medium, litlib_status Conjecture]
instance (priority := 10) fallback_Eq3 : Eq3 where
  plebanski_tetrad_reconstruction := sorry

@[litlib_difficulty medium, litlib_status Conjecture]
instance (priority := 10) fallback_Eq7 : Eq7 where
  bianchi_trace_identity := sorry

@[litlib_difficulty easy, litlib_status Conjecture]
instance (priority := 10) fallback_Eq11 : Eq11 where
  pure_connection_matrix := sorry

attribute [deprecated "Formalized proof available. Add `import Litlib.Y2024.gielen2024unimodular.Proofs.Eq11` alongside this import." (since := "2024-10-24")] fallback_Eq11

@[litlib_difficulty hard, litlib_status Conjecture]
instance (priority := 10) fallback_UnimodularCDJ 
    {SpacetimePoint : Type*}
    {urbantkeMetric : (Fin 4 → Fin 4 → Matrix (Fin 3) (Fin 3) ℂ) → Matrix (Fin 4) (Fin 4) ℂ} : 
    UnimodularCDJ SpacetimePoint urbantkeMetric where
  cdj_implies_constant_volume := sorry

end Litlib.Y2024.gielen2024unimodular.Proofs
