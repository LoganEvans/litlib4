-- FILENAME: Litlib/Y1974/guillemin1974differential/Chapter03/Sec02_Orientation.lean

import Mathlib.LinearAlgebra.Determinant
import Mathlib.Topology.Connected.Basic
import Mathlib.Data.Fintype.BigOperators
import Mathlib.Data.Real.Basic
import Mathlib.Logic.Equiv.Basic
import Litlib.Core

namespace Litlib.Y1974.guillemin1974differential

/-!
# Chapter 3, Section 2: Orientation (pp. 95–107)

Defines orientations on finite-dimensional real vector spaces via ordered bases and determinants
of change-of-basis transformations, orientation of smooth manifolds with boundary, boundary
orientations, product orientations, direct sum orientations, and preimage orientations.
-/

Litlib.equation "guillemin1974differential"
  eq "EquivalentlyOrientedBases" page "95" kind "definition"
/-- Two ordered bases $\beta$ and $\beta'$ of a finite-dimensional real vector space $V$ are
equivalently oriented iff the unique linear isomorphism $A$ satisfying $\beta' = A\beta$
has positive determinant. -/
class EquivalentlyOrientedBases
    (k : ℕ) (V : Type*) [AddCommGroup V] [Module ℝ V]
    (β β' : Fin k → V)
    (A : V ≃ₗ[ℝ] V)
    (hA : ∀ i, β' i = A (β i))
    (equivOriented : (Fin k → V) → (Fin k → V) → Prop) where
  equiv_oriented_iff : equivOriented β β' ↔ 0 < LinearMap.det (A : V →ₗ[ℝ] V)

Litlib.equation "guillemin1974differential"
  eq "VectorSpaceOrientation" page "96" kind "definition"
/-- An orientation of a vector space $V$ assigns a sign $+1$ or $-1$ to each ordered basis,
constant on equivalence classes, and reversing sign upon swapping any two basis elements. -/
class VectorSpaceOrientation
    (k : ℕ) (V : Type*) [AddCommGroup V] [Module ℝ V]
    (signBasis : (Fin k → V) → ℤ) where
  sign_values : ∀ β, signBasis β = 1 ∨ signBasis β = -1
  sign_swap : ∀ (β : Fin k → V) (i j : Fin k), i ≠ j →
    signBasis (β ∘ Equiv.swap i j) = -signBasis β

Litlib.equation "guillemin1974differential"
  eq "Proposition_TwoOrientations" page "97" kind "proposition"
/-- A connected, orientable manifold with boundary admits exactly two orientations. -/
class Proposition_TwoOrientations
    (M : Type*) [TopologicalSpace M] [ConnectedSpace M]
    (Orientation : Type*)
    (orientable : Prop) where
  exactly_two_orientations :
    orientable → ∃ o₁ o₂ : Orientation, o₁ ≠ o₂ ∧ ∀ o : Orientation, o = o₁ ∨ o = o₂

Litlib.equation "guillemin1974differential"
  eq "ProductOrientation" page "97" kind "definition"
/-- Product orientation on $T_{(x,y)}(X \times Y)$:
$\operatorname{sign}(\alpha \times 0, 0 \times \beta) =
  \operatorname{sign}(\alpha) \operatorname{sign}(\beta)$. -/
class ProductOrientation
    (signX signY signXY : ℤ)
    (h_signX : signX = 1 ∨ signX = -1)
    (h_signY : signY = 1 ∨ signY = -1) where
  product_sign_eq : signXY = signX * signY

Litlib.equation "guillemin1974differential"
  eq "BoundaryOrientation" page "98" kind "definition"
/-- Boundary orientation on $\partial X$: determined by placing the outward-pointing normal
$n_x$ first in an ordered basis: $\operatorname{sign}_{\partial X}(\beta) =
\operatorname{sign}_X(n_x, \beta)$. -/
class BoundaryOrientation
    (signX signBdry : ℤ)
    (signCombined : ℤ)
    (h_signX : signX = 1 ∨ signX = -1)
    (h_signBdry : signBdry = 1 ∨ signBdry = -1) where
  bdry_sign_eq : signBdry = signCombined

Litlib.equation "guillemin1974differential"
  eq "HomotopyBoundaryOrientation" page "99" kind "equation"
/-- For the homotopy space $I \times X$, the boundary oriented manifold decomposes as
$\partial(I \times X) = (\{1\} \times X) \cup -(\{0\} \times X) = X_1 - X_0$. -/
class HomotopyBoundaryOrientation
    (signOne signZero : ℤ) where
  orientation_at_one : signOne = 1
  orientation_at_zero : signZero = -1

Litlib.equation "guillemin1974differential"
  eq "Observation_OneManifoldBoundarySum" page "100" kind "theorem"
/-- Observation: The sum of the orientation numbers at the boundary points of any compact
oriented one-dimensional manifold with boundary is zero. -/
class Observation_OneManifoldBoundarySum
    (BdryPoints : Type*) [Fintype BdryPoints]
    (orientationNumber : BdryPoints → ℤ)
    (h_values : ∀ p, orientationNumber p = 1 ∨ orientationNumber p = -1) where
  sum_orientations_eq_zero : ∑ p : BdryPoints, orientationNumber p = 0

Litlib.equation "guillemin1974differential"
  eq "DirectSumOrientation" page "100" kind "definition"
/-- Direct sum orientation: on $V_1 \oplus V_2$, $\operatorname{sign}(\beta_1, \beta_2) =
\operatorname{sign}(\beta_1) \cdot \operatorname{sign}(\beta_2)$. -/
class DirectSumOrientation
    (signV₁ signV₂ signSum : ℤ)
    (h_signV₁ : signV₁ = 1 ∨ signV₁ = -1)
    (h_signV₂ : signV₂ = 1 ∨ signV₂ = -1) where
  direct_sum_sign : signSum = signV₁ * signV₂

Litlib.equation "guillemin1974differential"
  eq "PreimageOrientation" page "101" kind "definition"
/-- Preimage orientation: for $f : X \to Y$ transversal to $Z$, $S = f^{-1}(Z)$, the orientation
on $T_x(S)$ is determined by the direct sums:
$df_x(N_x(S; X)) \oplus T_z(Z) = T_z(Y)$ and $N_x(S; X) \oplus T_x(S) = T_x(X)$. -/
class PreimageOrientation
    (dimX dimY dimZ : ℕ)
    (h_dim : dimZ ≤ dimY)
    (signN signS signX signZ signY : ℤ)
    (h_splitX : signN * signS = signX)
    (h_splitY : signN * signZ = signY) where
  preimage_sign_relation : signS = signX * signY * signZ

Litlib.equation "guillemin1974differential"
  eq "Proposition_BoundaryPreimage" page "101" kind "proposition"
/-- Proposition: $\partial[f^{-1}(Z)] = (-1)^{\operatorname{codim} Z} (\partial f)^{-1}(Z)$. -/
class Proposition_BoundaryPreimage
    (codimZ : ℕ)
    (signBdryPreimage signPreimageBdry : ℤ) where
  boundary_preimage_sign_eq :
    signBdryPreimage = (-1 : ℤ) ^ codimZ * signPreimageBdry

Litlib.equation "guillemin1974differential"
  eq "DirectSumSymmetry" page "103" kind "theorem"
/-- Direct sum orientation symmetry: $V_1 \oplus V_2 =
(-1)^{(\dim V_1)(\dim V_2)} (V_2 \oplus V_1)$. -/
class DirectSumSymmetry
    (dimV₁ dimV₂ : ℕ)
    (signV₁V₂ signV₂V₁ : ℤ) where
  commutation_sign : signV₁V₂ = (-1 : ℤ) ^ (dimV₁ * dimV₂) * signV₂V₁

Litlib.equation "guillemin1974differential"
  eq "SubmanifoldIntersectionOrientation" page "105" kind "theorem"
/-- Submanifold intersection orientation symmetry:
$X \cap Z = (-1)^{(\operatorname{codim} X)(\operatorname{codim} Z)} (Z \cap X)$. -/
class SubmanifoldIntersectionOrientation
    (codimX codimZ : ℕ)
    (signXZ signZX : ℤ) where
  intersection_commutation : signXZ = (-1 : ℤ) ^ (codimX * codimZ) * signZX

end Litlib.Y1974.guillemin1974differential
