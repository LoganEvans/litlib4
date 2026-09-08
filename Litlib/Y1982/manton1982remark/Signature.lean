-- FILENAME: Litlib/Y1982/manton1982remark/Signature.lean


import Litlib.Core
import Mathlib.Topology.Basic
import Mathlib.Analysis.Calculus.Deriv.Basic
import Mathlib.Data.Real.Basic
import Mathlib.Data.Complex.Basic
import Mathlib.Data.Matrix.Basic
import Mathlib.LinearAlgebra.Matrix.Trace
import Mathlib.Algebra.BigOperators.Group.Finset.Basic
import Mathlib.Algebra.BigOperators.Ring.Finset

namespace Litlib.Y1982.manton1982remark

noncomputable section

open scoped BigOperators
open Finset Matrix

Litlib.paper "manton1982remark"
  type "article"
  title "A remark on the scattering of BPS monopoles"
  authors ["Manton, N. S."]
  journal "Physics Letters B"
  year "1982"

def leviCivita3 (i j k : Fin 3) : ℝ :=
  if i = j ∨ i = k ∨ j = k then 0
  else
    let invs : Nat := (if i.val > j.val then 1 else 0) +
                      (if i.val > k.val then 1 else 0) +
                      (if j.val > k.val then 1 else 0)
    if invs % 2 = 0 then 1 else -1

def commutator (X Y : Matrix (Fin 2) (Fin 2) ℂ) : Matrix (Fin 2) (Fin 2) ℂ :=
  X * Y - Y * X

Litlib.equation "manton1982remark" eq "1" page "54" kind "theorem"
class Eq1_GaussLawConstraint
    (A0 : (Fin 3 → ℝ) → Matrix (Fin 2) (Fin 2) ℂ)
    (A : (Fin 3 → ℝ) → Fin 3 → Matrix (Fin 2) (Fin 2) ℂ)
    (phi : (Fin 3 → ℝ) → Matrix (Fin 2) (Fin 2) ℂ)
    (dotA : (Fin 3 → ℝ) → Fin 3 → Matrix (Fin 2) (Fin 2) ℂ)
    (dotPhi : (Fin 3 → ℝ) → Matrix (Fin 2) (Fin 2) ℂ)
    (covD : Fin 3 → ((Fin 3 → ℝ) → Matrix (Fin 2) (Fin 2) ℂ) →
      (Fin 3 → ℝ) → Matrix (Fin 2) (Fin 2) ℂ)
    (laplacianOperator : ((Fin 3 → ℝ) → Matrix (Fin 2) (Fin 2) ℂ) →
      (Fin 3 → ℝ) → Matrix (Fin 2) (Fin 2) ℂ) where
  laplacian_def : ∀ psi x,
    laplacianOperator psi x =
      ∑ i : Fin 3, covD i (covD i psi) x + commutator (phi x) (commutator (phi x) (psi x))
  gauss_law_eq : ∀ x,
    laplacianOperator A0 x =
      ∑ i : Fin 3, covD i (dotA · i) x + commutator (phi x) (dotPhi x)
  operator_invertible : ∀ psi, (∀ x, laplacianOperator psi x = 0) → ∀ x, psi x = 0

Litlib.equation "manton1982remark" eq "3" page "55" kind "definition"
class Eq3_BackgroundGaugeProjection
    (dotA : (Fin 3 → ℝ) → Fin 3 → Matrix (Fin 2) (Fin 2) ℂ)
    (covD : Fin 3 → ((Fin 3 → ℝ) → Matrix (Fin 2) (Fin 2) ℂ) →
      (Fin 3 → ℝ) → Matrix (Fin 2) (Fin 2) ℂ)
    (invBox : ((Fin 3 → ℝ) → Matrix (Fin 2) (Fin 2) ℂ) →
      (Fin 3 → ℝ) → Matrix (Fin 2) (Fin 2) ℂ)
    (piDotA : (Fin 3 → ℝ) → Fin 3 → Matrix (Fin 2) (Fin 2) ℂ) where
  projection_def : ∀ x i,
    piDotA x i = dotA x i - covD i (invBox (fun y ↦ ∑ j : Fin 3, covD j (dotA · j) y)) x

Litlib.equation "manton1982remark" eq "4" page "55" kind "definition"
class Eq4_ConfigurationMetric
    (piDotA : (Fin 3 → ℝ) → Fin 3 → Matrix (Fin 2) (Fin 2) ℂ)
    (integral : ((Fin 3 → ℝ) → ℝ) → ℝ)
    (hVal : ℝ) where
  metric_def :
    hVal = integral (fun x ↦
      ∑ i : Fin 3, (Matrix.trace (piDotA x i * piDotA x i)).re)

Litlib.equation "manton1982remark" eq "6" page "55" kind "definition"
class Eq6_HiggsPotential
    (F : (Fin 3 → ℝ) → Fin 3 → Fin 3 → Matrix (Fin 2) (Fin 2) ℂ)
    (covDPhi : (Fin 3 → ℝ) → Fin 3 → Matrix (Fin 2) (Fin 2) ℂ)
    (integral : ((Fin 3 → ℝ) → ℝ) → ℝ)
    (UVal : ℝ) where
  potential_def :
    UVal = integral (fun x ↦
      (1 / 4 : ℝ) * (∑ i : Fin 3, ∑ j : Fin 3, (Matrix.trace (F x i j * F x i j)).re) +
      (1 / 2 : ℝ) * (∑ i : Fin 3, (Matrix.trace (covDPhi x i * covDPhi x i)).re))

Litlib.equation "manton1982remark" eq "geodesic" page "55" kind "theorem"
class Theorem_GeodesicScattering
    (n : ℕ) (hn : 0 < n)
    (ModuliSpace : Type*) [TopologicalSpace ModuliSpace]
    (moduliDimension : ℕ)
    (isGeodesic : (ℝ → ModuliSpace) → Prop)
    (adiabaticFlow : ℝ → (ℝ → ModuliSpace)) where
  moduli_dimension_eq : moduliDimension = 4 * n - 1
  adiabatic_geodesic_limit : ∀ gamma : ℝ → ModuliSpace,
    (∀ t, Filter.Tendsto (fun v ↦ adiabaticFlow v t) (nhds 0) (nhds (gamma t))) →
    isGeodesic gamma

end

end Litlib.Y1982.manton1982remark
