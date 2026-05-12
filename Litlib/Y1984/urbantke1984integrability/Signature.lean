-- FILENAME: Litlib/Y1984/urbantke1984integrability/Signature.lean

import Litlib.Core
import Mathlib.Topology.Basic
import Mathlib.Data.Complex.Basic
import Mathlib.Data.Matrix.Basic
import Mathlib.LinearAlgebra.Matrix.Determinant.Basic

namespace Litlib.Y1984.urbantke1984integrability

Litlib.paper "urbantke1984integrability"
  type "article"
  title "On integrability properties of SU (2) Yang-Mills fields. I. Infinitesimal part"
  authors ["Urbantke, H."]
  journal "Journal of Mathematical Physics"
  volume "25"
  issue "7"
  pages "2321--2324"
  year "1984"
  publisher "American Institute of Physics"
  doi "10.1063/1.526402"

Litlib.equation "urbantke1984integrability"
  eq "2, 6"
  page "2321"
  kind "identity"
class Eq2_and_6 where
  /-- 
  Equations (2) and (6) (page 2321): A simple bivector p^μν = u^[μ v^ν] 
  annihilates the YM field strength if and only if F^a_μν u^μ v^ν = 0.
  -/
  simpleBivectorAnnihilation
    (F : Fin 3 → Fin 4 → Fin 4 → ℂ) :
    ∀ (u v : Fin 4 → ℂ) (a : Fin 3),
      (∀ μ ν, F a μ ν = - F a ν μ) →
      ((Finset.sum Finset.univ (fun μ => Finset.sum Finset.univ (fun ν => F a μ ν * (u μ * v ν - u ν * v μ))) = 0) ↔
      (Finset.sum Finset.univ (fun μ => Finset.sum Finset.univ (fun ν => F a μ ν * u μ * v ν)) = 0))

Litlib.equation "urbantke1984integrability"
  eq "4"
  page "2321"
  kind "definition"
class Eq4 where
  /-- 
  Equation (4) (page 2321): Definition of the dual tensor.
  p_dual_μν := (1/2) * ε_μναβ * p^αβ
  -/
  dualTensor
    (epsilon4 : Fin 4 → Fin 4 → Fin 4 → Fin 4 → ℂ)
    (p : Fin 4 → Fin 4 → ℂ)
    (p_dual : Fin 4 → Fin 4 → ℂ) : Prop

  dualTensor_iff : ∀ epsilon4 p p_dual,
    dualTensor epsilon4 p p_dual ↔
    ∀ μ ν, p_dual μ ν = (1 / 2 : ℂ) * Finset.sum Finset.univ (fun α => Finset.sum Finset.univ (fun β => epsilon4 μ ν α β * p α β))

Litlib.equation "urbantke1984integrability"
  eq "10"
  page "2322"
  kind "definition"
class Eq10 where
  /-- 
  Equation (10) (page 2322): The definition of the Urbantke metric.
  g_μν := (-1/3!) ε_acb F^a_μα F_dual^cαβ F^b_βν
  -/
  quasimetricDef
    (F : Fin 3 → Fin 4 → Fin 4 → ℂ)
    (F_dual : Fin 3 → Fin 4 → Fin 4 → ℂ)
    (epsilon3 : Fin 3 → Fin 3 → Fin 3 → ℂ)
    (g : Fin 4 → Fin 4 → ℂ) : Prop

  quasimetricDef_iff : ∀ F F_dual epsilon3 g,
    quasimetricDef F F_dual epsilon3 g ↔
    ∀ μ ν, g μ ν = (-1 / 6 : ℂ) * Finset.sum Finset.univ (fun a => Finset.sum Finset.univ (fun b => Finset.sum Finset.univ (fun c => 
      Finset.sum Finset.univ (fun α => Finset.sum Finset.univ (fun β => 
        epsilon3 a c b * F a μ α * F_dual c α β * F b β ν)))))

Litlib.equation "urbantke1984integrability"
  eq "11"
  page "2322"
  kind "theorem"
class Eq11 where
  /--
  Equation (11) (page 2322): If the metric evaluated on any vector in the plane 
  spanned by u and v vanishes, then u and v are totally null with respect to g_μν.
  -/
  totallyNull
    (g : Fin 4 → Fin 4 → ℂ) :
    ∀ (u v : Fin 4 → ℂ),
      (∀ μ ν, g μ ν = g ν μ) →
      (∀ c1 c2 : ℂ, 
        Finset.sum Finset.univ (fun μ => Finset.sum Finset.univ (fun ν => 
          g μ ν * (c1 * u μ + c2 * v μ) * (c1 * u ν + c2 * v ν))) = 0) →
      (Finset.sum Finset.univ (fun μ => Finset.sum Finset.univ (fun ν => g μ ν * u μ * u ν)) = 0) ∧ 
      (Finset.sum Finset.univ (fun μ => Finset.sum Finset.univ (fun ν => g μ ν * v μ * v ν)) = 0) ∧ 
      (Finset.sum Finset.univ (fun μ => Finset.sum Finset.univ (fun ν => g μ ν * u μ * v ν)) = 0)

Litlib.equation "urbantke1984integrability"
  eq "12"
  page "2322"
  kind "definition"
class Eq12 where
  /--
  Equation (12) (page 2322): The definition of the 3x3 M matrix.
  M^ab := F_dual^aμν F^b_μν
  -/
  mMatrixDef
    (F : Fin 3 → Fin 4 → Fin 4 → ℂ)
    (F_dual : Fin 3 → Fin 4 → Fin 4 → ℂ)
    (M : Fin 3 → Fin 3 → ℂ) : Prop

  mMatrixDef_iff : ∀ F F_dual M,
    mMatrixDef F F_dual M ↔
    ∀ a b, M a b = Finset.sum Finset.univ (fun μ => Finset.sum Finset.univ (fun ν => F_dual a μ ν * F b μ ν))

Litlib.equation "urbantke1984integrability"
  eq "1.1"
  page "2322"
  kind "classification"
class Case1_1 where
  /--
  Case 1.1 (page 2322): The generic classification. The 3x3 matrix M^ab has full rank 
  (m = 3) if and only if the induced Urbantke quasimetric g_μν is non-degenerate.
  -/
  generic_rank_iff
    (F : Fin 3 → Fin 4 → Fin 4 → ℂ)
    (F_dual : Fin 3 → Fin 4 → Fin 4 → ℂ)
    (epsilon3 : Fin 3 → Fin 3 → Fin 3 → ℂ)
    (g : Fin 4 → Fin 4 → ℂ)
    (M : Fin 3 → Fin 3 → ℂ)
    (hG : ∀ μ ν, g μ ν = (-1 / 6 : ℂ) * Finset.sum Finset.univ (fun a => Finset.sum Finset.univ (fun b => Finset.sum Finset.univ (fun c => 
      Finset.sum Finset.univ (fun α => Finset.sum Finset.univ (fun β => 
        epsilon3 a c b * F a μ α * F_dual c α β * F b β ν))))))
    (hM : ∀ a b, M a b = Finset.sum Finset.univ (fun μ => Finset.sum Finset.univ (fun ν => F_dual a μ ν * F b μ ν))) :
    (Matrix.det M ≠ 0 ↔ Matrix.det (Matrix.of g) ≠ 0)

end Litlib.Y1984.urbantke1984integrability
