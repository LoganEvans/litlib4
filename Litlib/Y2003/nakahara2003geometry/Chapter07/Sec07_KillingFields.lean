-- FILENAME: Litlib/Y2003/nakahara2003geometry/Chapter07/Sec07_KillingFields.lean

import Litlib.Core
import Mathlib.Algebra.Group.Basic
import Mathlib.Algebra.Module.Basic

namespace Litlib.Y2003.nakahara2003geometry

Litlib.equation "nakahara2003geometry"
  eq "7.120b"
  page "36"
  kind "equation"
class KillingEquation
    (Metric Vect : Type _)
    (lieDeriv : Vect → Metric → Metric)
    (zeroMetric : Metric)
    (isKillingField : Vect → Prop) where
  h_nontrivial : ∃ X, isKillingField X
  
  killingEq : ∀ (g : Metric) (X : Vect),
    isKillingField X ↔ lieDeriv X g = zeroMetric

Litlib.equation "nakahara2003geometry"
  eq "7.129a"
  page "39"
  kind "equation"
class ConformalKillingEquation
    (Metric Vect Func : Type _) [CommRing Func] [AddCommGroup Metric] [Module Func Metric]
    (lieDeriv : Vect → Metric → Metric)
    (isConformalKillingField : Vect → Prop) where
  h_nontrivial : ∃ X, isConformalKillingField X
  
  conformalKillingEq : ∀ (g : Metric) (X : Vect),
    isConformalKillingField X ↔ ∃ (psi : Func), lieDeriv X g = psi • g

end Litlib.Y2003.nakahara2003geometry
