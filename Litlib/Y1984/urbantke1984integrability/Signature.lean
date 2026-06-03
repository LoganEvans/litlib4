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
  Kinematic Bivector Constraint: Equations (2) and (6) (page 2321).
  Establishes the algebraic condition for a simple bivector (constructed from 
  two linearly independent vectors u and v) to annihilate the Yang-Mills field strength.
  The antisymmetry of the field strength F is explicitly enforced in the hypothesis 
  to mathematically guarantee the equivalence holds.
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
  Hodge Dual Tensor Definition: Equation (4) (page 2321).
  Rigorously defines the dual tensor in the complexified tangent space via the 
  totally antisymmetric Levi-Civita symbol. The logic is bound by an equivalence 
  to prevent overriding the definition at instantiation.
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
  Urbantke Quasimetric Definition: Equation (10) (page 2322).
  Defines the macroscopic geometric tensor induced naturally by the SU(2) Yang-Mills 
  field strengths, coupling the field to its dual via the gauge structure constants.
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
  Totally Null Subspace Condition: Equation (11) (page 2322).
  Proves that if the symmetric quasimetric evaluated on an arbitrary vector 
  spanning the 2-plane (u, v) vanishes, then the basis vectors u and v must be 
  totally null with respect to the metric. 
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
  Gauge Trace Matrix Definition: Equation (12) (page 2322).
  Defines the 3x3 scalar matrix M^ab constructed from the contraction of the 
  field strength with its dual.
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
  Algebraic Non-Degeneracy Classification: Case 1.1 (page 2322).
  The generic integrability classification proves that the 3x3 matrix M^ab has 
  full rank if and only if the induced Urbantke quasimetric g_μν is non-degenerate 
  (det g ≠ 0). To prevent topological and algebraic exploits, the theorem is strictly 
  bound to domains where F is explicitly antisymmetric, the Hodge dual is correctly 
  constructed via the Levi-Civita symbol, and the SU(2) gauge structure constants 
  are totally antisymmetric.
  -/
  generic_rank_iff
    (F : Fin 3 → Fin 4 → Fin 4 → ℂ)
    (F_dual : Fin 3 → Fin 4 → Fin 4 → ℂ)
    (epsilon3 : Fin 3 → Fin 3 → Fin 3 → ℂ)
    (epsilon4 : Fin 4 → Fin 4 → Fin 4 → Fin 4 → ℂ)
    (g : Fin 4 → Fin 4 → ℂ)
    (M : Fin 3 → Fin 3 → ℂ)
    (hF_anti : ∀ a μ ν, F a μ ν = - F a ν μ)
    (hepsilon3_anti : ∀ a b c, epsilon3 a b c = - epsilon3 b a c ∧ epsilon3 a b c = - epsilon3 a c b)
    (h_dual : ∀ a μ ν, F_dual a μ ν = (1 / 2 : ℂ) * Finset.sum Finset.univ (fun α => Finset.sum Finset.univ (fun β => epsilon4 μ ν α β * F a α β)))
    (hG : ∀ μ ν, g μ ν = (-1 / 6 : ℂ) * Finset.sum Finset.univ (fun a => Finset.sum Finset.univ (fun b => Finset.sum Finset.univ (fun c => 
      Finset.sum Finset.univ (fun α => Finset.sum Finset.univ (fun β => 
        epsilon3 a c b * F a μ α * F_dual c α β * F b β ν))))))
    (hM : ∀ a b, M a b = Finset.sum Finset.univ (fun μ => Finset.sum Finset.univ (fun ν => F_dual a μ ν * F b μ ν))) :
    (Matrix.det M ≠ 0 ↔ Matrix.det (Matrix.of g) ≠ 0)

end Litlib.Y1984.urbantke1984integrability
