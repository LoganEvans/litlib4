-- FILENAME: Litlib/Y1974/guillemin1974differential/Chapter03/Sec06_HopfDegreeTheorem.lean

import Mathlib.Data.Fintype.Card
import Mathlib.Data.Real.Basic
import Mathlib.Topology.Connected.Basic
import Litlib.Core

namespace Litlib.Y1974.guillemin1974differential

/-!
# Chapter 3, Section 6: The Hopf Degree Theorem (pp. 141–148)

Proves the Isotopy Lemma, the Extension Theorem for boundary maps into spheres, the Hopf Degree
Theorem (homotopy classification of maps $X \to S^k$ via degree), and the characterization of
manifolds admitting nowhere-vanishing vector fields via $\chi(X) = 0$.
-/

Litlib.equation "guillemin1974differential"
  eq "Lemma_Isotopy" page "142" kind "lemma"
/-- Isotopy Lemma: Given any two points $y$ and $z$ in a connected manifold $Y$, there exists
a diffeomorphism $h : Y \to Y$ such that $h(y) = z$ and $h$ is isotopic to the identity via
a compactly supported isotopy. -/
class Lemma_Isotopy
    (Y : Type*) [TopologicalSpace Y] [ConnectedSpace Y]
    (y z : Y)
    (Diffeo : Type*)
    (h : Diffeo)
    (apply : Diffeo → Y → Y)
    (isotopicToId : Diffeo → Prop)
    (compactlySupported : Diffeo → Prop) where
  maps_y_to_z : apply h y = z
  isotopic_id : isotopicToId h
  compact_support : compactlySupported h

Litlib.equation "guillemin1974differential"
  eq "Corollary_MultiPointIsotopy" page "143" kind "corollary"
/-- Corollary: For a connected manifold $Y$ with $\dim Y > 1$, and distinct $n$-tuples
$y_1, \dots, y_n$ and $z_1, \dots, z_n$, there exists a compactly supported diffeomorphism
isotopic to the identity carrying each $y_i$ to $z_i$. -/
class Corollary_MultiPointIsotopy
    (n : ℕ) (Y : Type*) [TopologicalSpace Y] [ConnectedSpace Y]
    (y z : Fin n → Y)
    (h_distinct_y : ∀ i j, i ≠ j → y i ≠ y j)
    (h_distinct_z : ∀ i j, i ≠ j → z i ≠ z j)
    (Diffeo : Type*)
    (h : Diffeo)
    (apply : Diffeo → Y → Y)
    (isotopicToId : Diffeo → Prop) where
  maps_points : ∀ i : Fin n, apply h (y i) = z i
  isotopic_id : isotopicToId h

Litlib.equation "guillemin1974differential"
  eq "SphereSpecialCase" page "145" kind "theorem"
/-- Special Case: A smooth map $f : S^l \to S^l$ has degree zero if and only if it is homotopic
to a constant map. -/
class SphereSpecialCase
    (l : ℕ) (Sl : Type*)
    (f : Sl → Sl)
    (deg : (Sl → Sl) → ℤ)
    (homotopicToConst : (Sl → Sl) → Prop) where
  deg_zero_iff_nullhomotopic : deg f = 0 ↔ homotopicToConst f

Litlib.equation "guillemin1974differential"
  eq "Theorem_Extension" page "145" kind "theorem"
/-- Extension Theorem: Let $W$ be a compact, connected, oriented $(k+1)$-manifold with boundary,
and let $f : \partial W \to S^k$ be a smooth map. Then $f$ extends to a globally defined map
$F : W \to S^k$ with $\partial F = f$ if and only if $\deg(f) = 0$. -/
class Theorem_Extension
    (k : ℕ) (W BdryW Sk : Type*)
    (f : BdryW → Sk)
    (deg : (BdryW → Sk) → ℤ)
    (extendsGlobally : (BdryW → Sk) → Prop) where
  extendable_iff_degree_zero : extendsGlobally f ↔ deg f = 0

Litlib.equation "guillemin1974differential"
  eq "Theorem_HopfDegree" page "146" kind "theorem"
/-- The Hopf Degree Theorem: Two maps of a compact, connected, oriented $k$-manifold $X$ into
$S^k$ are homotopic if and only if they have the same degree: $f_0 \simeq f_1 \iff \deg(f_0) = \deg(f_1)$. -/
class Theorem_HopfDegree
    (k : ℕ) (X Sk : Type*)
    (f₀ f₁ : X → Sk)
    (deg : (X → Sk) → ℤ)
    (homotopic : (X → Sk) → (X → Sk) → Prop) where
  homotopy_iff_equal_degree : homotopic f₀ f₁ ↔ deg f₀ = deg f₁

Litlib.equation "guillemin1974differential"
  eq "Theorem_NowhereVanishingVectorField" page "146" kind "theorem"
/-- Theorem: A compact, connected, oriented manifold $X$ possesses a nowhere-vanishing vector
field if and only if its Euler characteristic is zero. -/
class Theorem_NowhereVanishingVectorField
    (X : Type*)
    (eulerChar : ℤ)
    (hasNowhereVanishingVectorField : Prop) where
  nowhere_vanishing_iff_euler_zero : hasNowhereVanishingVectorField ↔ eulerChar = 0

end Litlib.Y1974.guillemin1974differential
