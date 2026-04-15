-- FILENAME: Litlib/Y1989/capovilla1989general/Proofs/Sorry.lean

import Litlib.Y1989.capovilla1989general.Signature

namespace Litlib.Y1989.capovilla1989general.Proofs

@[Litlib.difficulty intractable, Litlib.status Conjecture]
instance : Eq1 where
  cdjIntegrand := sorry

@[Litlib.difficulty intractable, Litlib.status Conjecture]
instance {SpacetimePoint : Type*}
    {urbantkeMetric : (SpacetimePoint → Fin 4 → Fin 4 → Matrix (Fin 3) (Fin 3) ℂ) → (SpacetimePoint → Fin 4 → Fin 4 → ℝ)}
    {ricciTensor : (SpacetimePoint → Fin 4 → Fin 4 → ℝ) → SpacetimePoint → Fin 4 → Fin 4 → ℝ} :
    Eq6_RicciFlat SpacetimePoint urbantkeMetric ricciTensor where
  cdjImpliesRicciFlat := sorry

end Litlib.Y1989.capovilla1989general.Proofs
