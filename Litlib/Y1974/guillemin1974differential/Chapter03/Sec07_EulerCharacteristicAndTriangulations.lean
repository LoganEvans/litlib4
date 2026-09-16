-- FILENAME: Litlib/Y1974/guillemin1974differential/Chapter03/Sec07_EulerCharacteristicAndTriangulations.lean

import Mathlib.Data.Fintype.Card
import Mathlib.Data.Fintype.BigOperators
import Mathlib.Data.Real.Basic
import Litlib.Core

namespace Litlib.Y1974.guillemin1974differential

/-!
# Chapter 3, Section 7: The Euler Characteristic and Triangulations (pp. 148–150)

Relates the differential-topological Euler characteristic $\chi(X) = I(\Delta, \Delta)$ to the
classical alternating sum of simplex/cell counts from triangulations:
$F - E + V = \chi(X)$ for surfaces, and $\sum_{j=0}^k (-1)^j N_j = \chi(X)$ in dimension $k$.
-/

Litlib.equation "guillemin1974differential"
  eq "Theorem_SurfaceEulerFormula" page "148" kind "theorem"
/-- Surface Euler Formula: For any triangulation or polygonal dissection of a compact surface $X$
into $F$ faces, $E$ edges, and $V$ vertices, $F - E + V = \chi(X)$. -/
class Theorem_SurfaceEulerFormula
    (numFaces numEdges numVertices : ℕ)
    (eulerChar : ℤ) where
  surface_euler_formula : (numFaces : ℤ) - (numEdges : ℤ) + (numVertices : ℤ) = eulerChar

Litlib.equation "guillemin1974differential"
  eq "Theorem_HigherDimensionEulerFormula" page "149" kind "theorem"
/-- Higher-Dimensional Euler Formula: If $X$ is a compact $k$-dimensional manifold with a
generalized triangulation having $N_j$ faces of dimension $j$, then
$\chi(X) = \sum_{j=0}^k (-1)^j N_j$. -/
class Theorem_HigherDimensionEulerFormula
    (k : ℕ)
    (faceCounts : Fin (k + 1) → ℕ)
    (eulerChar : ℤ) where
  higher_dim_euler_sum :
    eulerChar = ∑ j : Fin (k + 1), (-1 : ℤ) ^ (j.val : ℕ) * (faceCounts j : ℤ)

Litlib.equation "guillemin1974differential"
  eq "Proposition_GenusEulerCharacteristic" page "150" kind "proposition"
/-- Exercise 3: By triangulating a sphere with $k$ tubes sewn in, the Euler characteristic of
the compact oriented surface of genus $k$ is $2 - 2k$. -/
class Proposition_GenusEulerCharacteristic
    (genus : ℕ)
    (eulerChar : ℤ) where
  genus_euler_char_eq : eulerChar = 2 - 2 * (genus : ℤ)

end Litlib.Y1974.guillemin1974differential
