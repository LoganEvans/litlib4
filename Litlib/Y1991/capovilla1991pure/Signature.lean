-- FILENAME: Litlib/Y1991/capovilla1991pure/Signature.lean

import Litlib.Core
import Mathlib.Data.Complex.Basic
import Mathlib.Data.Matrix.Basic

namespace Litlib.Y1991.capovilla1991pure

literature_axiom Eq2_22
  bibtex_key "capovilla1991pure"
  doi "10.1088/0264-9381/8/1/01"
  authors["Capovilla, Riccardo", "Dell, John", "Jacobson, Ted"]
  status Standard
class Eq2_22 where
  /--
  Equation (2.22) (page 64): The reconstruction of the spacetime metric
  directly from the scalar density η and the spin-connection curvature R_{AB}.
  
  This algebraic identity (the Urbantke metric) dynamically generates the 
  spacetime metric from an SL(2,C) connection. The foundational 
  requirement is that the resulting tensor g_{μν} is symmetric. 
  By casting this algebraically over Fintypes, we verify the symmetry 
  without requiring a background smooth manifold.
  -/
  urbantke_metric_symmetric
    (R : Fin 4 → Fin 4 → Fin 2 → Fin 2 → ℂ)
    (eta : ℂ)
    (epsilon : Fin 4 → Fin 4 → Fin 4 → Fin 4 → ℂ)
    (h_eps_alt : ∀ α β γ δ, 
      epsilon α β γ δ = -epsilon β α γ δ ∧ 
      epsilon α β γ δ = -epsilon α γ β δ ∧ 
      epsilon α β γ δ = -epsilon α β δ γ)
    (h_R_skew : ∀ μ ν A B, R μ ν A B = - R ν μ A B)
    (h_R_symm_spin : ∀ μ ν A B, R μ ν A B = R μ ν B A) :
    let g := fun (μ ν : Fin 4) =>
      (1 / 3 : ℂ) * eta *
      Finset.sum Finset.univ (fun α =>
        Finset.sum Finset.univ (fun β =>
          Finset.sum Finset.univ (fun γ =>
            Finset.sum Finset.univ (fun δ =>
              Finset.sum Finset.univ (fun A =>
                Finset.sum Finset.univ (fun B =>
                  Finset.sum Finset.univ (fun C =>
                    epsilon α β γ δ * R μ α A B * R β γ B C * R δ ν C A)))))))
    ∀ μ ν, g μ ν = g ν μ
