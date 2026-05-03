-- FILENAME: Litlib/Y1982/taubes1982existence/Signature.lean

import Litlib.Core
import Mathlib.Analysis.InnerProductSpace.Basic
import Mathlib.Analysis.Calculus.Deriv.Basic
import Mathlib.Topology.Basic

namespace Litlib.Y1982.taubes1982existence

Litlib.paper "taubes1982existence"
  type "article"
  title "The existence of a non-minimal solution to the SU(2) Yang-Mills-Higgs equations on ℝ3. Part I"
  authors ["Taubes, Clifford Henry"]
  journal "Communications in Mathematical Physics"
  volume "86"
  issue "2"
  pages "257--298"
  year "1982"
  publisher "Springer"
  doi "10.1007/BF01206014"

Litlib.equation "taubes1982existence"
  eq "2.7, 2.8"
  page "263"
  kind "Unknown"
class YangMillsHiggsVariations where
  /-- Equations (2.7) and (2.8) (page 263): Gradient and Hessian of the YMH action functional. -/
  ymhVariations
    (V : Type*)[NormedAddCommGroup V][InnerProductSpace ℝ V]
    (fA dAPhi dAOmega dAEta bracketOmegaPhi omegaWedgeOmega bracketOmegaEta : V) :
    let F := fun (s : ℝ) => fA + s • dAOmega + (s^2) • omegaWedgeOmega
    let dPhi := fun (s : ℝ) => dAPhi + s • (dAEta + bracketOmegaPhi) + (s^2) • bracketOmegaEta
    let a := fun (s : ℝ) => (1/2 : ℝ) * (inner ℝ (F s) (F s) + inner ℝ (dPhi s) (dPhi s))
    let gradA := inner ℝ dAOmega fA + inner ℝ bracketOmegaPhi dAPhi + inner ℝ dAEta dAPhi
    let hessA := inner ℝ dAOmega dAOmega + inner ℝ dAEta dAEta + inner ℝ bracketOmegaPhi bracketOmegaPhi +
                  2 * inner ℝ omegaWedgeOmega fA + 2 * inner ℝ bracketOmegaEta dAPhi + 2 * inner ℝ bracketOmegaPhi dAEta
    deriv a 0 = gradA ∧ deriv (deriv a) 0 = hessA

Litlib.equation "taubes1982existence"
  eq "Unknown"
  page "Unknown"
  kind "Unknown"
class BogomolnyiExistence where
  /--
  Capstone Theorem: Bogomolnyi Existence.
  The infimum of the Yang-Mills-Higgs action is attained by a smooth function.
  -/
  existsW1Minimizer
    (Connection : Type*) [TopologicalSpace Connection]
    (Action : Connection → ℝ)
    (hNonempty : Nonempty Connection)
    (hContinuous : Continuous Action)
    (hCompactSublevel : ∀ (c : ℝ), IsCompact {A | Action A ≤ c}) :
    ∃ (aMin : Connection), ∀ A, Action aMin ≤ Action A

end Litlib.Y1982.taubes1982existence
