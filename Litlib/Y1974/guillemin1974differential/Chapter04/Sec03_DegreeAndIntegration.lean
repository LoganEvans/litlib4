-- FILENAME: Litlib/Y1974/guillemin1974differential/Chapter04/Sec03_DegreeAndIntegration.lean

import Mathlib.Data.Real.Basic
import Mathlib.Topology.Connected.Basic
import Litlib.Core

namespace Litlib.Y1974.guillemin1974differential

/-!
# Chapter 4, Section 3: Integration on Manifolds (pp. 165–173)

Formalizes the connection between differential forms and intersection theory:
1. Stokes' Theorem: $\int_{\partial W} \omega = \int_W d\omega$.
2. The Degree-Integral Formula: $\int_X f^* \omega = \deg(f) \int_Y \omega$.
3. Vanishing of boundary pullback integrals for maps extending across a compact manifold.
4. Jordan-Brouwer / Winding Number containment: $z \in \operatorname{int}(D) \implies W = 1$.
5. The topological boundary crossing bridge linking aperture de Rham integrals to integer charge.
-/

Litlib.equation "guillemin1974differential"
  eq "Theorem_Stokes" page "183" kind "theorem"
/-- Stokes' Theorem on Manifolds with Boundary (§7, p. 183): For an oriented compact
$k$-dimensional manifold $X$ with boundary $\partial X$ and any smooth $(k-1)$-form $\omega$,
$\int_{\partial X} \omega = \int_X d\omega$. -/
class Theorem_Stokes
    (X BdryX : Type*) [TopologicalSpace X] [TopologicalSpace BdryX]
    (FormX FormBdry : Type*)
    (d : FormX → FormX)
    (pullbackIncl : FormX → FormBdry)
    (integralX : FormX → ℝ)
    (integralBdry : FormBdry → ℝ)
    (omega : FormX) where
  stokes_formula : integralX (d omega) = integralBdry (pullbackIncl omega)

Litlib.equation "guillemin1974differential"
  eq "Theorem_DegreeIntegralFormula" page "188" kind "theorem"
/-- The Degree-Integral Formula (§8, p. 188): Let $f : X \to Y$ be an arbitrary smooth map
of two compact, oriented manifolds of dimension $k$, and let $\omega$ be a $k$-form on $Y$.
Then $\int_X f^* \omega = \deg(f) \int_Y \omega$. -/
class Theorem_DegreeIntegralFormula
    (X Y : Type*) [TopologicalSpace X] [TopologicalSpace Y]
    (f : X → Y) (deg : ℤ)
    (FormX FormY : Type*)
    (pullback : (X → Y) → FormY → FormX)
    (integralX : FormX → ℝ)
    (integralY : FormY → ℝ)
    (omega : FormY) where
  degree_integral_eq : integralX (pullback f omega) = (deg : ℝ) * integralY omega

Litlib.equation "guillemin1974differential"
  eq "Theorem_NormalizedDegreeIntegral" page "188" kind "theorem"
/-- Corollary of the Degree-Integral Formula (§8, p. 188): If $\omega$ is normalized such that
$\int_Y \omega = 1$, then $\int_X f^* \omega = \deg(f)$. -/
class Theorem_NormalizedDegreeIntegral
    (X Y : Type*) [TopologicalSpace X] [TopologicalSpace Y]
    (f : X → Y) (deg : ℤ)
    (FormX FormY : Type*)
    (pullback : (X → Y) → FormY → FormX)
    (integralX : FormX → ℝ)
    (integralY : FormY → ℝ)
    (omega : FormY)
    (h_normalized : integralY omega = 1) where
  normalized_degree_integral_eq : integralX (pullback f omega) = (deg : ℝ)

Litlib.equation "guillemin1974differential"
  eq "Theorem_BoundaryExtensionIntegralZero" page "189" kind "theorem"
/-- Extension Vanishing Theorem (§8, p. 189): If $X = \partial W$ and $f : X \to Y$ extends
smoothly to all of $W$ ($X, Y, W$ compact and oriented, $\dim X = \dim Y = k$), then
$\int_X f^* \omega = 0$ for every $k$-form $\omega$ on $Y$. -/
class Theorem_BoundaryExtensionIntegralZero
    (X W Y : Type*) (f : X → Y) (F : W → Y)
    (boundaryEmbedding : X → W)
    (isBoundary : (X → W) → Prop)
    (isCompact : Set W → Prop)
    (extendsTo : (X → Y) → (W → Y) → Prop)
    (h_bdry : isBoundary boundaryEmbedding)
    (h_compactW : isCompact (Set.univ : Set W))
    (h_ext : extendsTo f F)
    (FormX FormY : Type*)
    (pullback : (X → Y) → FormY → FormX)
    (integralX : FormX → ℝ)
    (omega : FormY) where
  boundary_integral_zero : integralX (pullback f omega) = 0

Litlib.equation "guillemin1974differential"
  eq "Theorem_PointContainmentWinding" page "192" kind "theorem"
/-- Winding Number and Point Containment (§8, p. 192, Exercise 2): For a closed curve or
boundary $\gamma$, the integral $\frac{1}{2\pi} \oint_\gamma d\arg = W(\gamma, z)$ equals $1$
if $z \in \operatorname{int}(D)$ and $0$ if $z \notin \bar{D}$. -/
class Theorem_PointContainmentWinding
    (Point : Type*)
    (interiorDomain : Set Point)
    (exteriorDomain : Set Point)
    (z : Point)
    (degDirectionMap : Point → ℤ) where
  interior_winding_eq_one : z ∈ interiorDomain → degDirectionMap z = 1
  exterior_winding_eq_zero : z ∈ exteriorDomain → degDirectionMap z = 0

Litlib.equation "guillemin1974differential"
  eq "Theorem_TopologicalBoundaryCrossingBridge" page "188" kind "theorem"
/-- Topological Boundary Crossing Bridge: Combining the Degree Formula (§8, p. 188) with
the Winding Containment Theorem (§8, p. 192), when a particle trajectory $z$ lies in the
interior aperture domain $D$, the pullback integral of the normalized form over $\partial D$
evaluates to exactly $+1$. -/
class Theorem_TopologicalBoundaryCrossingBridge
    (Point BdryD TargetSphere : Type*)
    (interiorDomain : Set Point)
    (z : Point)
    (h_in_interior : z ∈ interiorDomain)
    (directionMap : Point → BdryD → TargetSphere)
    (deg : (BdryD → TargetSphere) → ℤ)
    (h_deg_containment : deg (directionMap z) = 1)
    (FormBdry FormSphere : Type*)
    (pullback : (BdryD → TargetSphere) → FormSphere → FormBdry)
    (integralBdry : FormBdry → ℝ)
    (integralSphere : FormSphere → ℝ)
    (omega : FormSphere)
    (h_normalized : integralSphere omega = 1)
    (qAperture : ℝ)
    (h_integral : integralBdry (pullback (directionMap z) omega) = qAperture) where
  aperture_charge_eq_one : qAperture = 1

end Litlib.Y1974.guillemin1974differential
