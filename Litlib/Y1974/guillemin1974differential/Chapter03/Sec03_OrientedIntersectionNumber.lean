-- FILENAME: Litlib/Y1974/guillemin1974differential/Chapter03/Sec03_OrientedIntersectionNumber.lean


import Mathlib.Data.Fintype.Card
import Mathlib.Data.Fintype.BigOperators
import Mathlib.Data.Complex.Basic
import Mathlib.Data.Real.Basic
import Mathlib.Analysis.InnerProductSpace.PiL2
import Mathlib.Topology.MetricSpace.Basic
import Mathlib.Topology.Basic
import Litlib.Core

namespace Litlib.Y1974.guillemin1974differential

/-!
# Chapter 3, Section 3: Oriented Intersection Number (pp. 107–119)

Defines the oriented intersection number $I(f, Z)$, proves homotopy invariance, introduces
the degree of a map, the Fundamental Theorem of Algebra, Jordan-Brouwer point containment and
winding numbers, intersections of arbitrary maps $I(f, g)$, and the Euler characteristic
$\chi(Y) = I(\Delta, \Delta)$.
-/

Litlib.equation "guillemin1974differential"
  eq "IntersectionNumberDefinition" page "107" kind "definition"
/-- The oriented intersection number $I(f, Z)$ is the sum of orientation numbers $\pm 1$
at all points of $f^{-1}(Z)$. -/
class IntersectionNumberDefinition
    (X Y : Type*) (Z : Set Y)
    (f : X → Y)
    [Fintype (f ⁻¹' Z)]
    (localSign : f ⁻¹' Z → ℤ)
    (h_sign : ∀ x, localSign x = 1 ∨ localSign x = -1)
    (intersectionNumber : ℤ) where
  sum_formula : intersectionNumber = ∑ x : f ⁻¹' Z, localSign x

Litlib.equation "guillemin1974differential"
  eq "Proposition_BoundaryExtensionNullity" page "108" kind "proposition"
/-- Proposition: If $X = \partial W$ and $f : X \to Y$ extends to $W$ ($W$ compact),
then $I(f, Z) = 0$. -/
class Proposition_BoundaryExtensionNullity
    (X W Y : Type*) (Z : Set Y)
    (f : X → Y) (F : W → Y)
    (boundaryEmbedding : X → W)
    (isBoundary : (X → W) → Prop)
    (isCompact : Set W → Prop)
    (extendsTo : (X → Y) → (W → Y) → Prop)
    (h_boundary : isBoundary boundaryEmbedding)
    (h_compactW : isCompact (Set.univ : Set W))
    (h_extends : extendsTo f F)
    (intersectionNumber : (X → Y) → Set Y → ℤ) where
  intersection_vanishes : intersectionNumber f Z = 0

Litlib.equation "guillemin1974differential"
  eq "Proposition_HomotopyInvariance" page "108" kind "proposition"
/-- Proposition: Homotopic maps always have the same intersection numbers. -/
class Proposition_HomotopyInvariance
    (X Y : Type*) (Z : Set Y)
    (f₀ f₁ : X → Y)
    (Homotopic : (X → Y) → (X → Y) → Prop)
    (h_homotopic : Homotopic f₀ f₁)
    (intersectionNumber : (X → Y) → Set Y → ℤ) where
  homotopy_invariance : intersectionNumber f₀ Z = intersectionNumber f₁ Z

Litlib.equation "guillemin1974differential"
  eq "DegreeDefinition" page "109" kind "definition"
/-- When $Y$ is connected and $\dim Y = \dim X$, the degree of a smooth map $f : X \to Y$
is the intersection number $I(f, \{y\})$ with any point $y \in Y$. -/
class DegreeDefinition
    (X Y : Type*)
    (f : X → Y)
    (deg : ℤ)
    (intersectionNumber : (X → Y) → Set Y → ℤ)
    (y : Y) where
  deg_eq_intersection : deg = intersectionNumber f {y}

Litlib.equation "guillemin1974differential"
  eq "Proposition_DegreeBoundaryExtension" page "110" kind "proposition"
/-- Proposition: If $f : X \to Y$ is a smooth map of compact oriented manifolds of the same
dimension and $X = \partial W$ ($W$ compact), and $f$ extends to $W$, then $\deg(f) = 0$. -/
class Proposition_DegreeBoundaryExtension
    (X W Y : Type*)
    (f : X → Y) (F : W → Y)
    (boundaryEmbedding : X → W)
    (isBoundary : (X → W) → Prop)
    (isCompact : Set W → Prop)
    (extendsTo : (X → Y) → (W → Y) → Prop)
    (h_boundary : isBoundary boundaryEmbedding)
    (h_compactW : isCompact (Set.univ : Set W))
    (h_extends : extendsTo f F)
    (deg : (X → Y) → ℤ) where
  deg_boundary_zero : deg f = 0

Litlib.equation "guillemin1974differential"
  eq "Theorem_FundamentalTheoremOfAlgebra" page "110" kind "theorem"
/-- The Fundamental Theorem of Algebra: Every nonconstant complex polynomial has a root. -/
class Theorem_FundamentalTheoremOfAlgebra
    (p : ℂ → ℂ)
    (m : ℕ) (h_m : 0 < m)
    (h_poly : ∀ z, ∃ c : Fin (m + 1) → ℂ, c ⟨m, lt_add_one m⟩ ≠ 0 ∧
      p z = ∑ i : Fin (m + 1), c i * z ^ (i.val : ℕ)) where
  has_root : ∃ z : ℂ, p z = 0

Litlib.equation "guillemin1974differential"
  eq "Proposition_PolynomialZerosDegree" page "110" kind "proposition"
/-- Proposition: The total number of zeros of $p$ inside a compact region $W \subset \mathbb{C}$,
counting multiplicities, equals the degree of the normalized map $p / |p| : \partial W \to S^1$. -/
class Proposition_PolynomialZerosDegree
    (totalZerosWithMultiplicity : ℕ)
    (degreeNormalized : ℤ) where
  zeros_equal_degree : (totalZerosWithMultiplicity : ℤ) = degreeNormalized

Litlib.equation "guillemin1974differential"
  eq "Theorem_JordanBrouwerWinding" page "110" kind "theorem"
/-- Winding Numbers and Jordan-Brouwer Point Containment (Chapter 3, §3, p. 110 & §6, p. 144):
For an open bounded domain $D \subset \mathbb{R}^n$ with smooth boundary $\partial D$, the radial
direction map $u_z(x) = (x - z) / \|x - z\|$ from $\partial D$ to $S^{n-1}$ has topological
degree $1$ if $z \in D$ (interior) and $0$ if $z \notin \overline{D}$ (exterior). -/
class Theorem_JordanBrouwerWinding
    (n : ℕ) [NeZero n]
    (D : Set (EuclideanSpace ℝ (Fin n)))
    (bdryD : Set (EuclideanSpace ℝ (Fin n)))
    (radialMap :
      EuclideanSpace ℝ (Fin n) → bdryD → Metric.sphere (0 : EuclideanSpace ℝ (Fin n)) 1)
    (h_radial : ∀ (z : EuclideanSpace ℝ (Fin n)) (x : bdryD),
      (radialMap z x).1 = (‖x.1 - z‖)⁻¹ • (x.1 - z))
    (deg : (bdryD → Metric.sphere (0 : EuclideanSpace ℝ (Fin n)) 1) → ℤ) where
  deg_interior : ∀ z ∈ D, deg (radialMap z) = 1
  deg_exterior : ∀ z, z ∉ closure D → deg (radialMap z) = 0

Litlib.equation "guillemin1974differential"
  eq "Proposition_IntersectionProductDiagonal" page "114" kind "proposition"
/-- Proposition: $f \pitchfork g \iff (f \times g) \pitchfork \Delta$, and
$I(f, g) = (-1)^{\dim Z} I(f \times g, \Delta)$. -/
class Proposition_IntersectionProductDiagonal
    (dimZ : ℕ)
    (intFG intProdDelta : ℤ) where
  intersection_product_formula : intFG = (-1 : ℤ) ^ dimZ * intProdDelta

Litlib.equation "guillemin1974differential"
  eq "Proposition_HomotopyInvarianceMaps" page "115" kind "proposition"
/-- Homotopy invariance of intersection numbers of maps:
$f_0 \simeq f_1 \wedge g_0 \simeq g_1 \implies I(f_0, g_0) = I(f_1, g_1)$. -/
class Proposition_HomotopyInvarianceMaps
    (X Y Z : Type*)
    (f₀ f₁ : X → Y)
    (g₀ g₁ : Z → Y)
    (HomotopicX : (X → Y) → (X → Y) → Prop)
    (HomotopicZ : (Z → Y) → (Z → Y) → Prop)
    (h_f_homotopic : HomotopicX f₀ f₁)
    (h_g_homotopic : HomotopicZ g₀ g₁)
    (intMap : (X → Y) → (Z → Y) → ℤ) where
  map_homotopy_invariant : intMap f₀ g₀ = intMap f₁ g₁

Litlib.equation "guillemin1974differential"
  eq "Proposition_IntersectionSymmetry" page "115" kind "proposition"
/-- Proposition: $I(f, g) = (-1)^{(\dim X)(\dim Z)} I(g, f)$. -/
class Proposition_IntersectionSymmetry
    (dimX dimZ : ℕ)
    (intFG intGF : ℤ) where
  commutation_formula : intFG = (-1 : ℤ) ^ (dimX * dimZ) * intGF

Litlib.equation "guillemin1974differential"
  eq "Corollary_SubmanifoldIntersectionSymmetry" page "115" kind "corollary"
/-- Corollary: If $X$ and $Z$ are compact submanifolds of $Y$, then
$I(X, Z) = (-1)^{(\dim X)(\dim Z)} I(Z, X)$. -/
class Corollary_SubmanifoldIntersectionSymmetry
    (dimX dimZ : ℕ)
    (intXZ intZX : ℤ) where
  submanifold_symmetry : intXZ = (-1 : ℤ) ^ (dimX * dimZ) * intZX

Litlib.equation "guillemin1974differential"
  eq "OddSelfIntersectionVanishing" page "115" kind "corollary"
/-- If $\dim Y = 2\dim X$ and $\dim X$ is odd, the self-intersection number $I(X, X) = 0$. -/
class OddSelfIntersectionVanishing
    (dimX : ℕ) (h_odd : Odd dimX)
    (selfIntersection : ℤ)
    (h_skew : selfIntersection = (-1 : ℤ) ^ (dimX * dimX) * selfIntersection) where
  self_intersection_zero : selfIntersection = 0

Litlib.equation "guillemin1974differential"
  eq "EulerCharacteristicDefinition" page "116" kind "definition"
/-- The Euler characteristic of a compact oriented manifold $Y$ is the self-intersection
number of the diagonal: $\chi(Y) = I(\Delta, \Delta)$. -/
class EulerCharacteristicDefinition
    (eulerChar : ℤ)
    (selfIntersectionDelta : ℤ) where
  euler_char_eq_self_intersection : eulerChar = selfIntersectionDelta

Litlib.equation "guillemin1974differential"
  eq "Proposition_OddEulerCharacteristicZero" page "116" kind "proposition"
/-- Proposition: The Euler characteristic of an odd-dimensional, compact, oriented manifold
is zero. -/
class Proposition_OddEulerCharacteristicZero
    (dimY : ℕ) (h_odd : Odd dimY)
    (eulerChar : ℤ) where
  odd_euler_characteristic_zero : eulerChar = 0

Litlib.equation "guillemin1974differential"
  eq "DegreeComposition" page "117" kind "theorem"
/-- Exercise 10: $\deg(g \circ f) = \deg(f) \cdot \deg(g)$. -/
class DegreeComposition
    (degF degG degGoF : ℤ) where
  composition_degree_formula : degGoF = degF * degG

Litlib.equation "guillemin1974differential"
  eq "EulerCharacteristicProduct" page "117" kind "theorem"
/-- Exercise 13: The Euler characteristic of the product of two compact oriented manifolds
is the product of their Euler characteristics: $\chi(X \times Y) = \chi(X) \chi(Y)$. -/
class EulerCharacteristicProduct
    (chiX chiY chiXY : ℤ) where
  product_euler_char : chiXY = chiX * chiY

end Litlib.Y1974.guillemin1974differential
