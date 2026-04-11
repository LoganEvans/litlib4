-- FILENAME: Litlib/Y1991/capovilla1991pure/Signature.lean

import Litlib.Core
import Mathlib.Data.Complex.Basic
import Mathlib.Data.Matrix.Basic

namespace Litlib.Y1991.capovilla1991pure

literature_citation Eq2_22
  bibtex_key "capovilla1991pure"
  doi "10.1088/0264-9381/8/1/01"
  authors["Capovilla, Riccardo", "Dell, John", "Jacobson, Ted"]
  status Standard
class Eq2_22 where
  /--
  Equation (2.22) (page 64): The reconstruction of the spacetime metric
  directly from the scalar density η and the spin-connection curvature R_{AB}.
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

literature_citation UrbantkeCDJ
  bibtex_key "capovilla1991pure"
  doi "10.1088/0264-9381/8/1/01"
  authors ["Capovilla, Riccardo", "Dell, John", "Jacobson, Ted"]
  status Standard
class UrbantkeCDJ where
  /--
  Capstone Theorem: Ricci Flatness of the Urbantke Metric.
  Using the Weyl Pattern, this theorem establishes that if a field configuration 
  satisfies the pure connection field equations, its corresponding Urbantke metric 
  is Ricci flat.
  -/
  urbantke_is_ricci_flat
    (SpacetimePoint SL2C : Type*)
    (satisfiesPureConnectionEq : (Fin 4 → Fin 4 → SpacetimePoint → SL2C) → Prop)
    (urbantkeMetric : (Fin 4 → Fin 4 → SL2C) → Matrix (Fin 4) (Fin 4) ℂ)
    (isRicciFlat : (SpacetimePoint → Matrix (Fin 4) (Fin 4) ℂ) → Prop)
    (F : Fin 4 → Fin 4 → SpacetimePoint → SL2C) :
    satisfiesPureConnectionEq F →
    isRicciFlat (fun x => urbantkeMetric (fun m n => F m n x))
