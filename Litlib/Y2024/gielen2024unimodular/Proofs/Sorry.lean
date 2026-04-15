-- FILENAME: Litlib/Y2024/gielen2024unimodular/Proofs/Sorry.lean

import Litlib.Y2024.gielen2024unimodular.Signature

namespace Litlib.Y2024.gielen2024unimodular.Proofs

@[Litlib.difficulty medium, Litlib.status Conjecture]
instance (priority := 10) fallback_Eq3 : Eq3 where
  plebanskiTetradReconstruction := sorry

@[Litlib.difficulty medium, Litlib.status Conjecture]
instance (priority := 10) fallback_Eq7 : Eq7 where
  bianchiTraceIdentity := sorry

@[Litlib.difficulty easy, Litlib.status Conjecture]
instance (priority := 10) fallback_Eq11 : Eq11 where
  pureConnectionMatrix := sorry

attribute [deprecated "Formalized proof available. Add `import Litlib.Y2024.gielen2024unimodular.Proofs.Eq11` alongside this import." (since := "2024-10-24")] fallback_Eq11

@[Litlib.difficulty hard, Litlib.status Conjecture]
instance (priority := 10) fallback_UnimodularCDJ 
    {SpacetimePoint : Type*}
    {urbantkeMetric : (Fin 4 → Fin 4 → Matrix (Fin 3) (Fin 3) ℂ) → Matrix (Fin 4) (Fin 4) ℂ} : 
    UnimodularCDJ SpacetimePoint urbantkeMetric where
  cdjImpliesConstantVolume := sorry

end Litlib.Y2024.gielen2024unimodular.Proofs
