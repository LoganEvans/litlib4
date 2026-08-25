-- FILENAME: Litlib/Y2017/bengtsson2017geometry/Chapter15/Sec02_ProductMeasures.lean


import Litlib.Core
import Mathlib.Data.Real.Basic
import Mathlib.Data.Nat.Factorial.Basic
import Mathlib.Analysis.SpecialFunctions.Gamma.Basic
import Litlib.Y2017.bengtsson2017geometry.Paper

namespace Litlib.Y2017.bengtsson2017geometry

open Finset

Litlib.equation "bengtsson2017geometry"
  eq "15.24"
  page "372"
  kind "theorem"
/--
Physical Interpretation: The total volume of the complex flag manifold F^(N) = U(N)/[U(1)]^N
expressed as the product of volumes of complex projective spaces CP^k for k = 1 to N - 1.
Mathematical Boundaries: Valid for dimensions N ≥ 2.
-/
class Eq15_24
    (Xi : ℕ → ℝ)
    (volF : ℕ → ℝ)
    (volCP : ℕ → ℝ) where
  xi_def : ∀ N, Xi N = ∏ k : Fin N, Real.Gamma ((k.val + 1 : ℝ))
  volF_product_CP : ∀ N, 2 ≤ N →
    volF N = ∏ k : Fin (N - 1), volCP (k.val + 1)
  volF_closed_form : ∀ N, 2 ≤ N →
    volF N = (Real.pi ^ (N * (N - 1) / 2)) / (Xi N)

Litlib.equation "bengtsson2017geometry"
  eq "15.28"
  page "372"
  kind "theorem"
/--
Physical Interpretation: The total volume of the special unitary Lie group SU(N) equipped with its
standard bi-invariant Haar metric. For N = 2, Vol(SU(2)) = 2π² (the volume of the unit 3-sphere).
Mathematical Boundaries: Valid for N ≥ 2.
-/
class Eq15_28
    (Xi : ℕ → ℝ)
    (volSU : ℕ → ℝ) where
  volSU_closed_form : ∀ N, 2 ≤ N →
    volSU N = 2 ^ (((N : ℝ) - 1) / 2) * Real.sqrt N *
      (Real.pi ^ ((N + 2) * (N - 1) / 2)) / (Xi N)
  volSU2_eval : volSU 2 = 2 * (Real.pi ^ 2)

end Litlib.Y2017.bengtsson2017geometry
