-- FILENAME: Litlib/Y1982/taubes1982existence/Signature.lean

import Litlib.Core
import Mathlib.Analysis.InnerProductSpace.Basic
import Mathlib.Analysis.Calculus.Deriv.Basic

namespace Litlib.Y1982.taubes1982existence

literature_axiom Eq2_7_and_2_8
  bibtex_key "taubes1982existence"
  doi "10.1007/BF01206014"
  authors ["Taubes, Clifford Henry"]
  status Standard
class Eq2_7_and_2_8 where
  /--
  Equations (2.7) and (2.8) (page 263): The first and second variation 
  (gradient and Hessian) of the Yang-Mills-Higgs action functional.
  -/
  ymh_variations
    (V : Type*)[NormedAddCommGroup V][InnerProductSpace ℝ V]
    (F_A D_A_Phi D_A_omega D_A_eta bracket_omega_Phi omega_wedge_omega bracket_omega_eta : V) :
    let F := fun (s : ℝ) => F_A + s • D_A_omega + (s^2) • omega_wedge_omega
    let DPhi := fun (s : ℝ) => D_A_Phi + s • (D_A_eta + bracket_omega_Phi) + (s^2) • bracket_omega_eta
    let a := fun (s : ℝ) => (1/2 : ℝ) * (inner ℝ (F s) (F s) + inner ℝ (DPhi s) (DPhi s))
    
    let grad_a := inner ℝ D_A_omega F_A + inner ℝ bracket_omega_Phi D_A_Phi + inner ℝ D_A_eta D_A_Phi
    
    let hess_a := inner ℝ D_A_omega D_A_omega + inner ℝ D_A_eta D_A_eta + inner ℝ bracket_omega_Phi bracket_omega_Phi +
                  2 * inner ℝ omega_wedge_omega F_A + 2 * inner ℝ bracket_omega_eta D_A_Phi + 2 * inner ℝ bracket_omega_Phi D_A_eta
    
    deriv a 0 = grad_a ∧ deriv (deriv a) 0 = hess_a

literature_axiom BogomolnyiExistence
  bibtex_key "taubes1982existence"
  doi "10.1007/BF01206014"
  authors ["Taubes, Clifford Henry"]
  status Standard
class BogomolnyiExistence where
  /--
  Capstone Theorem: Bogomolnyi Existence.
  The infimum of the Yang-Mills-Higgs action is attained by a smooth function.
  -/
  exists_w1_minimizer
    (Connection : Type*)
    (isW1Minimizer : Connection → Prop) :
    ∃ (A : Connection), isW1Minimizer A
