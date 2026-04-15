-- FILENAME: Litlib/Y1991/capovilla1991pure/Proofs/Sorry.lean

import Litlib.Y1991.capovilla1991pure.Signature

namespace Litlib.Y1991.capovilla1991pure.Proofs

@[litlib_difficulty hard, litlib_status Conjecture]
instance (priority := 10) fallback_Eq2_22 : Eq2_22 where
  urbantke_metric_symmetric := sorry

@[litlib_difficulty hard, litlib_status Conjecture]
instance (priority := 10) fallback_UrbantkeCDJ 
    {SpacetimePoint : Type*}
    {urbantke_metric : (SpacetimePoint → Fin 4 → Fin 4 → Matrix (Fin 2) (Fin 2) ℂ) → (SpacetimePoint → Fin 4 → Fin 4 → ℝ)}
    {ricci_tensor : (SpacetimePoint → Fin 4 → Fin 4 → ℝ) → SpacetimePoint → Fin 4 → Fin 4 → ℝ} : 
    UrbantkeCDJ SpacetimePoint urbantke_metric ricci_tensor where
  urbantke_is_ricci_flat := sorry

end Litlib.Y1991.capovilla1991pure.Proofs
