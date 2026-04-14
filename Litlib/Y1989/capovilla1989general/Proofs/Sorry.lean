-- FILENAME: Litlib/Y1989/capovilla1989general/Proofs/Sorry.lean

import Litlib.Y1989.capovilla1989general.Signature

namespace Litlib.Y1989.capovilla1989general.Proofs

@[litlib_difficulty intractable, litlib_status Conjecture]
instance : Eq1 where
  cdj_integrand := sorry

@[litlib_difficulty intractable, litlib_status Conjecture]
instance {SpacetimePoint : Type*}
    {urbantke_metric : (SpacetimePoint → Fin 4 → Fin 4 → Matrix (Fin 3) (Fin 3) ℂ) → (SpacetimePoint → Fin 4 → Fin 4 → ℝ)}
    {ricci_tensor : (SpacetimePoint → Fin 4 → Fin 4 → ℝ) → SpacetimePoint → Fin 4 → Fin 4 → ℝ} :
    Eq6_RicciFlat SpacetimePoint urbantke_metric ricci_tensor where
  cdj_implies_ricci_flat := sorry

end Litlib.Y1989.capovilla1989general.Proofs
