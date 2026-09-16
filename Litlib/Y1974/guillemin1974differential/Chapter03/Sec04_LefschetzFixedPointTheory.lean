-- FILENAME: Litlib/Y1974/guillemin1974differential/Chapter03/Sec04_LefschetzFixedPointTheory.lean

import Mathlib.LinearAlgebra.Determinant
import Mathlib.Data.Fintype.Card
import Mathlib.Data.Fintype.BigOperators
import Mathlib.Data.Real.Basic
import Mathlib.Topology.Connected.Basic
import Litlib.Core

namespace Litlib.Y1974.guillemin1974differential

/-!
# Chapter 3, Section 4: Lefschetz Fixed-Point Theory (pp. 119–132)

Introduces the global Lefschetz number $L(f) = I(\Delta, \operatorname{graph}(f))$, the Smooth
Lefschetz Fixed-Point Theorem, Lefschetz maps, local Lefschetz numbers $L_x(f) =
\operatorname{sign}\det(df_x - I)$, the splitting proposition, and Euler characteristics of spheres
and compact surfaces of genus $k$.
-/

Litlib.equation "guillemin1974differential"
  eq "LefschetzNumberDefinition" page "119" kind "definition"
/-- The global Lefschetz number of $f : X \to X$ is $L(f) = I(\Delta, \operatorname{graph}(f))$. -/
class LefschetzNumberDefinition
    (globalLefschetz : ℤ)
    (intersectionDeltaGraph : ℤ) where
  lefschetz_eq_intersection : globalLefschetz = intersectionDeltaGraph

Litlib.equation "guillemin1974differential"
  eq "Theorem_SmoothLefschetzFixedPoint" page "119" kind "theorem"
/-- Smooth Lefschetz Fixed-Point Theorem: Let $f : X \to X$ be a smooth map on a compact
orientable manifold. If $L(f) \neq 0$, then $f$ has a fixed point. -/
class Theorem_SmoothLefschetzFixedPoint
    (X : Type*) (f : X → X)
    (globalLefschetz : ℤ)
    (isCompact : Set X → Prop)
    (isOrientable : Set X → Prop)
    (isSmooth : (X → X) → Prop)
    (h_compact : isCompact (Set.univ : Set X))
    (h_orientable : isOrientable (Set.univ : Set X))
    (h_smooth : isSmooth f) where
  fixed_point_exists : globalLefschetz ≠ 0 → ∃ x : X, f x = x

Litlib.equation "guillemin1974differential"
  eq "Proposition_LefschetzHomotopyInvariance" page "120" kind "proposition"
/-- Proposition: $L(f)$ is a homotopy invariant. -/
class Proposition_LefschetzHomotopyInvariance
    (X : Type*) (f₀ f₁ : X → X)
    (Homotopic : (X → X) → (X → X) → Prop)
    (h_homotopic : Homotopic f₀ f₁)
    (globalLefschetz : (X → X) → ℤ) where
  lefschetz_homotopy_invariant : globalLefschetz f₀ = globalLefschetz f₁

Litlib.equation "guillemin1974differential"
  eq "Proposition_LefschetzIdentity" page "120" kind "proposition"
/-- Proposition: If $f$ is homotopic to the identity, then $L(f) = \chi(X)$. In particular,
if $X$ admits a smooth map homotopic to the identity with no fixed points, then $\chi(X) = 0$. -/
class Proposition_LefschetzIdentity
    (X : Type*) (f : X → X)
    (idX : X → X)
    (eulerChar : ℤ)
    (globalLefschetz : (X → X) → ℤ)
    (Homotopic : (X → X) → (X → X) → Prop)
    (h_id : ∀ x, idX x = x)
    (h_homotopic_id : Homotopic f idX) where
  lefschetz_id_eq_euler : globalLefschetz f = eulerChar
  no_fixed_points_implies_euler_zero : (∀ x : X, f x ≠ x) → eulerChar = 0

Litlib.equation "guillemin1974differential"
  eq "Proposition_LocalLefschetzNumber" page "121" kind "proposition"
/-- Proposition: The local Lefschetz number $L_x(f)$ at a Lefschetz fixed point $x$ equals the
sign of the determinant of $df_x - I$. -/
class Proposition_LocalLefschetzNumber
    (k : ℕ)
    (detDfMinusI : ℝ)
    (h_nonsingular : detDfMinusI ≠ 0)
    (localLefschetz : ℤ) where
  local_lefschetz_eq_sign_det :
    localLefschetz = if 0 < detDfMinusI then 1 else -1

Litlib.equation "guillemin1974differential"
  eq "LefschetzSumFormula" page "121" kind "theorem"
/-- For a Lefschetz map, the global Lefschetz number equals the sum of local Lefschetz numbers:
$L(f) = \sum_{f(x)=x} L_x(f)$. -/
class LefschetzSumFormula
    (X : Type*) (f : X → X)
    (fixedPoints : Set X)
    (h_fixed : fixedPoints = {x | f x = x})
    [Fintype fixedPoints]
    (localLefschetz : fixedPoints → ℤ)
    (globalLefschetz : ℤ) where
  sum_local_lefschetz : globalLefschetz = ∑ x : fixedPoints, localLefschetz x

Litlib.equation "guillemin1974differential"
  eq "Proposition_EulerCharacteristicSphere2" page "124" kind "proposition"
/-- Proposition: The Euler characteristic of $S^2$ is 2. -/
class Proposition_EulerCharacteristicSphere2
    (chiS2 : ℤ) where
  euler_char_sphere2_eq : chiS2 = 2

Litlib.equation "guillemin1974differential"
  eq "Corollary_Sphere2FixedPoint" page "124" kind "corollary"
/-- Corollary: Every map of $S^2$ that is homotopic to the identity must possess a fixed point.
In particular, the antipodal map is not homotopic to the identity. -/
class Corollary_Sphere2FixedPoint
    (S2 : Type*) (f : S2 → S2)
    (idS2 : S2 → S2)
    (Homotopic : (S2 → S2) → (S2 → S2) → Prop)
    (h_id : ∀ x, idS2 x = x)
    (h_homotopic_id : Homotopic f idS2) where
  sphere2_fixed_point_exists : ∃ x : S2, f x = x

Litlib.equation "guillemin1974differential"
  eq "Proposition_EulerCharacteristicGenus" page "125" kind "proposition"
/-- Proposition: The compact oriented surface of genus $k$ admits a Lefschetz map homotopic
to the identity with 1 source, 1 sink, and $2k$ saddles. Consequently, $\chi(\Sigma_k) = 2 - 2k$. -/
class Proposition_EulerCharacteristicGenus
    (k : ℕ)
    (numSources numSinks numSaddles : ℕ)
    (eulerChar : ℤ)
    (h_sources : numSources = 1)
    (h_sinks : numSinks = 1)
    (h_saddles : numSaddles = 2 * k) where
  euler_char_genus_formula :
    eulerChar = (numSources : ℤ) * 1 + (numSinks : ℤ) * 1 + (numSaddles : ℤ) * (-1)
  euler_char_genus_eq : eulerChar = 2 - 2 * (k : ℤ)

Litlib.equation "guillemin1974differential"
  eq "LocalComputationLefschetz" page "130" kind "theorem"
/-- Local Computation of the Lefschetz Number: Let $f : X \to X$ be any smooth map on a compact
manifold with only finitely many fixed points. Then $L(f) = \sum_{f(x)=x} L_x(f)$. -/
class LocalComputationLefschetz
    (FixedPoints : Type*) [Fintype FixedPoints]
    (localLefschetz : FixedPoints → ℤ)
    (globalLefschetz : ℤ) where
  local_sum_eq_global : globalLefschetz = ∑ x : FixedPoints, localLefschetz x

Litlib.equation "guillemin1974differential"
  eq "EulerCharacteristicSphereK" page "131" kind "theorem"
/-- Exercise 7: The Euler characteristic of $S^k$ is $2$ if $k$ is even and $0$ if $k$ is odd. -/
class EulerCharacteristicSphereK
    (k : ℕ) (chiSk : ℤ) where
  euler_char_sphere_k :
    chiSk = if Even k then 2 else 0

Litlib.equation "guillemin1974differential"
  eq "CompactLieGroupEulerZero" page "132" kind "theorem"
/-- Exercise 11: The Euler characteristic of any compact Lie group is zero. -/
class CompactLieGroupEulerZero
    (eulerChar : ℤ) where
  compact_lie_group_euler_zero : eulerChar = 0

end Litlib.Y1974.guillemin1974differential
