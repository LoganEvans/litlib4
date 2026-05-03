-- FILENAME: Litlib/Y1978/atiyah1978construction/Signature.lean

import Litlib.Core
import Mathlib.Data.Complex.Basic
import Mathlib.Algebra.Module.Basic
import Mathlib.Data.Matrix.Basic

namespace Litlib.Y1978.atiyah1978construction

Litlib.paper "atiyah1978construction"
  type "article"
  title "Construction of instantons"
  authors ["Atiyah, Michael F", "Hitchin, Nigel J", "Drinfeld, Vladimir G", "Manin, Yuri I"]
  journal "Physics Letters A"
  volume "65"
  issue "3"
  pages "185--187"
  year "1978"
  publisher "Elsevier Science"
  doi "10.1016/0375-9601(78)90141-X"

Litlib.equation "atiyah1978construction"
  eq "Unknown"
  page "185"
  kind "Unknown"
class Page185Algebra where
  /-- The core linear algebra lemma on page 185: Ensures that "real" lines of P3(C) are never jumping lines. -/
  jumpingLinesTrivial
    (V : Type*) [AddCommGroup V][Module ℂ V]
    (B : V → V → ℂ)
    (hBLin1 : ∀ u1 u2 v : V, ∀ c : ℂ, B (c • u1 + u2) v = c * B u1 v + B u2 v)
    (hBLin2 : ∀ u v1 v2 : V, ∀ c : ℂ, B u (c • v1 + v2) = c * B u v1 + B u v2)
    (hBSkew : ∀ v w : V, B v w = - B w v)
    (sigmaV : V → V)
    (hSigmaVAdd : ∀ v1 v2 : V, sigmaV (v1 + v2) = sigmaV v1 + sigmaV v2)
    (hSigmaVSmul : ∀ c : ℂ, ∀ v : V, sigmaV (c • v) = star c • sigmaV v)
    (hSigmaVInv : ∀ v : V, sigmaV (sigmaV v) = -v)
    (hBSigma : ∀ v1 v2 : V, B (sigmaV v1) (sigmaV v2) = star (B v1 v2))
    (hPosDef : ∀ v : V, v ≠ 0 → (B v (sigmaV v)).re > 0 ∧ (B v (sigmaV v)).im = 0)
    (Uz : Set V)
    (v : V)
    (hvInUSigmaZ : ∃ u ∈ Uz, sigmaV u = v)
    (hvInUzAnnihilator : ∀ u ∈ Uz, B u v = 0) :
    v = 0

Litlib.equation "atiyah1978construction"
  eq "Unknown"
  page "Unknown"
  kind "Unknown"
class AdhmModuliUniqueness where
  /--
  Capstone Theorem: ADHM Charge 1 Trivialization.
  The ADHM construction maps the self-dual PDEs to the algebraic constraint 
  [B1, B2] + IJ = 0. For an instanton of charge k=1, the B matrices are 
  scalars and natively commute, strictly forcing the incidence matrices 
  to annihilate (I * J = 0).
  -/
  adhmCharge1
    (B1 B2 : Matrix (Fin 1) (Fin 1) ℂ)
    (I : Matrix (Fin 1) (Fin 2) ℂ)
    (J : Matrix (Fin 2) (Fin 1) ℂ)
    (hAdhm : B1 * B2 - B2 * B1 + I * J = 0) :
    I * J = 0

end Litlib.Y1978.atiyah1978construction
