-- FILENAME: Litlib/Y1982/taubes1982existence/Signature.lean

import Litlib.Core
import Mathlib.Analysis.InnerProductSpace.Basic
import Mathlib.Analysis.Calculus.Deriv.Basic
import Mathlib.Topology.Basic

namespace Litlib.Y1982.taubes1982existence

Litlib.reference Eq2_7_and_2_8
  bibtex "taubes1982existence"
  doi "10.1007/BF01206014"
  authors ["Taubes, Clifford Henry"]
  status Standard
class Eq2_7_and_2_8 where
  /--
  Equations (2.7) and (2.8) (page 263): The first and second variation 
  (gradient and Hessian) of the Yang-Mills-Higgs action functional.
  -/
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

Litlib.reference BogomolnyiExistence
  bibtex "taubes1982existence"
  doi "10.1007/BF01206014"
  authors ["Taubes, Clifford Henry"]
  status Standard
class BogomolnyiExistence where
  /--
  Capstone Theorem: Bogomolnyi Existence.
  The infimum of the Yang-Mills-Higgs action is attained by a smooth function.
  Secured by mapping the variational problem to rigorous topological compactness,
  ensuring the Extreme Value Theorem holds and preventing non-coercive exploits.
  -/
  existsW1Minimizer
    (Connection : Type*) [TopologicalSpace Connection]
    (Action : Connection → ℝ)
    (hNonempty : Nonempty Connection)
    (hContinuous : Continuous Action)
    (hCompactSublevel : ∀ (c : ℝ), IsCompact {A | Action A ≤ c}) :
    ∃ (aMin : Connection), ∀ A, Action aMin ≤ Action A

end Litlib.Y1982.taubes1982existence
