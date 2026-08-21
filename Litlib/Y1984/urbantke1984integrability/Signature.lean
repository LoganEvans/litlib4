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
  Establishes the local algebraic condition for a simple bivector, constructed from
  two linearly independent vectors u and v, to annihilate the SU(2) Yang-Mills field strength.
  The antisymmetry of the field strength F is explicitly enforced to mathematically guarantee
  the equivalence of the vanishing of the contraction.
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
  Defines the dual tensor in the complexified tangent space via contraction with the
  totally antisymmetric permutation symbol. Formulated as a strict equivalence to
  guarantee uniqueness of the dual structure.
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
  Defines the conformal geometric tensor naturally induced by the SU(2) Yang-Mills
  field strengths, coupling the field to its dual via the gauge structure constants.
  This tensor serves as a background-independent quasimetric for the resulting geometry.
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
  Geometric Non-Degeneracy Constraint: Case 1.1 (page 2322).
  The generic integrability classification establishes that the gauge-traced 3x3 matrix M^ab
  has full rank if and only if the induced Urbantke quasimetric g_μν is strictly non-degenerate
  (det g ≠ 0). This theorem formally requires the explicit antisymmetry of the field strength,
  the canonical orientation of the Hodge dual, and strict non-degeneracy bounds on the permutation
  symbols to prevent topological collapse of the volume form.
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
    (hepsilon3_nondeg : epsilon3 0 1 2 ≠ 0)
    (hepsilon4_nondeg : epsilon4 0 1 2 3 ≠ 0)
    (h_dual : ∀ a μ ν, F_dual a μ ν = (1 / 2 : ℂ) * Finset.sum Finset.univ (fun α => Finset.sum Finset.univ (fun β => epsilon4 μ ν α β * F a α β)))
    (hG : ∀ μ ν, g μ ν = (-1 / 6 : ℂ) * Finset.sum Finset.univ (fun a => Finset.sum Finset.univ (fun b => Finset.sum Finset.univ (fun c =>
      Finset.sum Finset.univ (fun α => Finset.sum Finset.univ (fun β =>
        epsilon3 a c b * F a μ α * F_dual c α β * F b β ν))))))
    (hM : ∀ a b, M a b = Finset.sum Finset.univ (fun μ => Finset.sum Finset.univ (fun ν => F_dual a μ ν * F b μ ν))) :
    (Matrix.det M ≠ 0 ↔ Matrix.det (Matrix.of g) ≠ 0)

Litlib.equation "urbantke1984integrability"
  eq "unnumbered"
  page "2322"
  kind "theorem"
class Theorem_F_AntiSelfDuality where
  /--
  Anti-Self-Duality of the Field Strength Definition.
  Defines what it means for F^a_{μν} to be anti-self-dual with respect to g.
  -/
  antiSelfDual
    (F : Fin 3 → Fin 4 → Fin 4 → ℂ)
    (g_inv : Fin 4 → Fin 4 → ℂ)
    (sqrt_det_g : ℂ)
    (epsilon4 : Fin 4 → Fin 4 → Fin 4 → Fin 4 → ℂ) : Prop

  antiSelfDual_iff : ∀ F g_inv sqrt_det_g epsilon4,
    antiSelfDual F g_inv sqrt_det_g epsilon4 ↔
    ∀ a μ ν,
      (1 / 2 : ℂ) * sqrt_det_g * Finset.sum Finset.univ (fun α =>
        Finset.sum Finset.univ (fun β =>
          Finset.sum Finset.univ (fun ρ =>
            Finset.sum Finset.univ (fun σ =>
              epsilon4 μ ν α β * g_inv α ρ * g_inv β σ * F a ρ σ)))) = - F a μ ν

  /--
  The literature result: Constructing the quasimetric from F guarantees F is Anti-Self-Dual.
  Explicit expansions for g_μν, g^μν, and F_dual are enforced to block degenerate implementations.
  -/
  urbantke_implies_asd
    (F F_dual : Fin 3 → Fin 4 → Fin 4 → ℂ)
    (epsilon3 : Fin 3 → Fin 3 → Fin 3 → ℂ)
    (epsilon4 : Fin 4 → Fin 4 → Fin 4 → Fin 4 → ℂ)
    (g g_inv : Fin 4 → Fin 4 → ℂ)
    (sqrt_det_g : ℂ)
    (hF_anti : ∀ a μ ν, F a μ ν = - F a ν μ)
    (hF_dual : ∀ a μ ν, F_dual a μ ν = (1 / 2 : ℂ) *
      Finset.sum Finset.univ (fun α => Finset.sum Finset.univ (fun β =>
        epsilon4 μ ν α β * F a α β)))
    (hg_def : ∀ μ ν, g μ ν = (-1 / 6 : ℂ) *
      Finset.sum Finset.univ (fun a => Finset.sum Finset.univ (fun b =>
        Finset.sum Finset.univ (fun c => Finset.sum Finset.univ (fun α =>
          Finset.sum Finset.univ (fun β =>
            epsilon3 a c b * F a μ α * F_dual c α β * F b β ν))))))
    (hg_inv : ∀ μ ν, Finset.sum Finset.univ (fun α => g μ α * g_inv α ν) =
      if μ = ν then 1 else 0)
    (hsqrt : sqrt_det_g ^ 2 = Matrix.det (Matrix.of g)) :
    antiSelfDual F g_inv sqrt_det_g epsilon4

end Litlib.Y1984.urbantke1984integrability
