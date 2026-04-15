-- FILENAME: Litlib/Y1991/capovilla1991pure/Proofs/Sorry.lean

import Litlib.Y1991.capovilla1991pure.Signature

namespace Litlib.Y1991.capovilla1991pure.Proofs

@[Litlib.difficulty hard, Litlib.status Conjecture]
instance (priority := 10) fallback_Eq2_22 : Eq2_22 where
  urbantkeMetricSymmetric := sorry

@[Litlib.difficulty hard, Litlib.status Conjecture]
instance (priority := 10) fallback_UrbantkeCDJ 
    {SpacetimePoint : Type*}
    {urbantkeMetric : (SpacetimePoint → Fin 4 → Fin 4 → Matrix (Fin 2) (Fin 2) ℂ) → (SpacetimePoint → Fin 4 → Fin 4 → ℝ)}
    {ricciTensor : (SpacetimePoint → Fin 4 → Fin 4 → ℝ) → SpacetimePoint → Fin 4 → Fin 4 → ℝ} : 
    UrbantkeCDJ SpacetimePoint urbantkeMetric ricciTensor where
  urbantkeIsRicciFlat := sorry

end Litlib.Y1991.capovilla1991pure.Proofs
