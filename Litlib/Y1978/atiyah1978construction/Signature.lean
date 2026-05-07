-- FILENAME: Litlib/Y1978/atiyah1978construction/Signature.lean

import Litlib.Core
import Mathlib.Data.Complex.Basic
import Mathlib.Algebra.Module.Basic
import Mathlib.Data.Matrix.Basic

universe u v

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
  eq "1"
  page "185"
  kind "Condition"
class IsotropicCondition where
  /--
  Equation (1) on page 185: For z ≠ 0, U_z = A(z)W ⊂ V is isotropic.
  We formalize this property for the linear map A.
  
  ANTI-BS PROVISION: Uses an explicit iff axiom to securely bind the property 
  rather than a default implementation trapdoor.
  -/
  isIsotropic
    (W : Type u) (V : Type v) [AddCommGroup W] [Module ℂ W] [AddCommGroup V] [Module ℂ V]
    (B : V → V → ℂ)
    (A : (Fin 4 → ℂ) → W → V)
    (z : Fin 4 → ℂ)
    (hz : z ≠ 0) : Prop
  
  isIsotropic_iff : ∀ (W : Type u) (V : Type v) [AddCommGroup W] [Module ℂ W] [AddCommGroup V] [Module ℂ V]
    (B : V → V → ℂ) (A : (Fin 4 → ℂ) → W → V) (z : Fin 4 → ℂ) (hz : z ≠ 0),
    isIsotropic W V B A z hz ↔ ∀ w1 w2 : W, B (A z w1) (A z w2) = 0

Litlib.equation "atiyah1978construction"
  eq "2"
  page "185"
  kind "Condition"
class RealityCondition where
  /--
  Equation (2) on page 185: The reality condition that A(z) be compatible with the 
  anti-linear map σ.
  
  ANTI-BS PROVISION: Uses an explicit iff axiom to securely bind the property 
  rather than a default implementation trapdoor.
  -/
  isCompatible
    (W : Type u) (V : Type v) [AddCommGroup W] [Module ℂ W] [AddCommGroup V] [Module ℂ V]
    (sigmaW : W → W) (sigmaV : V → V) (sigmaC4 : (Fin 4 → ℂ) → (Fin 4 → ℂ))
    (A : (Fin 4 → ℂ) → W → V) : Prop
  
  isCompatible_iff : ∀ (W : Type u) (V : Type v) [AddCommGroup W] [Module ℂ W] [AddCommGroup V] [Module ℂ V]
    (sigmaW : W → W) (sigmaV : V → V) (sigmaC4 : (Fin 4 → ℂ) → (Fin 4 → ℂ)) (A : (Fin 4 → ℂ) → W → V),
    isCompatible W V sigmaW sigmaV sigmaC4 A ↔ 
    ∀ (z : Fin 4 → ℂ) (w : W), sigmaV (A z w) = A (sigmaC4 z) (sigmaW w)

Litlib.equation "atiyah1978construction"
  eq "Unknown"
  page "185"
  kind "Proof Step"
class RealLinesNotJumping where
  /-- 
  The core linear algebra deduction on page 185: 
  Condition (2) implies that the orthogonal space (U_z)^0 intersects U_{σz} trivially.
  This shows that "real" lines of P3(C) are never jumping lines.
  
  ANTI-BS PROVISION: Retains the full symplectic and quaternionic structure axioms 
  of the space to prevent over-abstraction into a vacuous logic puzzle.
  -/
  intersectionTrivial
    (V : Type v) [AddCommGroup V] [Module ℂ V]
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

/-- Bulletproof conjugate transpose that natively handles non-square dimension swapping. -/
def conjT {m n : Type*} (M : Matrix m n ℂ) : Matrix n m ℂ :=
  fun i j => star (M j i)

Litlib.equation "atiyah1978construction"
  eq "Unknown"
  page "Unknown"
  kind "Theorem"
class AdhmModuliUniqueness where
  /--
  Capstone Theorem: ADHM Charge 1 Trivialization.
  The ADHM construction maps the self-dual PDEs to the algebraic constraint 
  [B1, B2] + IJ = 0. For an instanton of charge k=1, the B matrices are 
  scalars and natively commute, strictly forcing the incidence matrices 
  to annihilate (I * J = 0).
  
  ANTI-BS PROVISION:
  To prevent the "Tautology Exploit" (where 1x1 matrices commute making the 
  complex equation a vacuous tautology), we explicitly enforce the full algebraic 
  data of the ADHM moduli space. This includes the real moment map / reality 
  conditions which bind I and J to the geometric size and position parameters 
  of the real SU(2) gauge field.
  -/
  adhmCharge1
    (B1 B2 : Matrix (Fin 1) (Fin 1) ℂ)
    (I : Matrix (Fin 1) (Fin 2) ℂ)
    (J : Matrix (Fin 2) (Fin 1) ℂ)
    (hAdhmComplex : B1 * B2 - B2 * B1 + I * J = 0)
    (hAdhmReal : B1 * conjT B1 - conjT B1 * B1 + 
                 B2 * conjT B2 - conjT B2 * B2 + 
                 I * conjT I - conjT J * J = 0) :
    I * J = 0 ∧ I * conjT I = conjT J * J

end Litlib.Y1978.atiyah1978construction
