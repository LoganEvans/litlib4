-- FILENAME: Litlib/Y1976/rudin1976principles/Chapter09/Sec08_DerivativesOfHigherOrder.lean

import Litlib.Core
import Mathlib.Data.Real.Basic
import Mathlib.Analysis.Calculus.Deriv.Basic
import Mathlib.Topology.Basic

namespace Litlib.Y1976.rudin1976principles

Litlib.equation "rudin1976principles"
  eq "9.41"
  page "235"
  kind "theorem"
class SchwarzTheorem where
  /--
  Theorem 9.41 (page 235): Equality of mixed partial derivatives (Schwarz's / Clairaut's theorem).
  
  ANTI-BS PROVISIONS:
  Instead of postulating the existence of global partial derivative operators which
  could be trivialized, we strictly enforce local existence via Mathlib's `HasDerivAt`
  on the 1D slice mappings `(fun t => f (t, y))` and `(fun t => f (x, t))`. 
  The conclusion `HasDerivAt` directly bounds `D12f` to exist and equal `D21f`.
  -/
  schwarz_mixed_partials
    (E : Set (ℝ × ℝ)) (hOpen : IsOpen E)
    (f D1f D2f D21f : ℝ × ℝ → ℝ)
    (a b : ℝ) (hab : (a, b) ∈ E)
    (hD1 : ∀ x y, (x, y) ∈ E → HasDerivAt (fun t => f (t, y)) (D1f (x, y)) x)
    (hD2 : ∀ x y, (x, y) ∈ E → HasDerivAt (fun t => f (x, t)) (D2f (x, y)) y)
    (hD21 : ∀ x y, (x, y) ∈ E → HasDerivAt (fun t => D1f (x, t)) (D21f (x, y)) y)
    (hCont : ContinuousAt D21f (a, b)) :
    HasDerivAt (fun t => D2f (t, b)) (D21f (a, b)) a

end Litlib.Y1976.rudin1976principles
