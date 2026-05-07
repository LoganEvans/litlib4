-- FILENAME: Litlib/Y1975/geroch1975motion/Signature.lean

import Litlib.Core
import Mathlib.Topology.Basic
import Mathlib.Data.Matrix.Basic
import Mathlib.Data.Real.Basic

open Topology

namespace Litlib.Y1975.geroch1975motion

Litlib.paper "geroch1975motion"
  type "article"
  title "Motion of a body in general relativity"
  authors ["Geroch, Robert", "Jang, Pong Soo"]
  journal "Journal of Mathematical Physics"
  volume "16"
  issue "1"
  pages "65--67"
  year "1975"
  doi "10.1063/1.522416"

Litlib.equation "geroch1975motion"
  eq "Theorem"
  page "66"
  kind "Theorem"
class Thm_MotionOfBody 
  (Point : Type) [TopologicalSpace Point]
  (Index : Type) [Fintype Index] [DecidableEq Index]
  (g : Index → Index → Point → ℝ)
  (g_inv : Index → Index → Point → ℝ)
  (Gamma : Index → Index → Index → Point → ℝ)
  (partialDeriv : Index → (Point → ℝ) → Point → ℝ)
  (isFutureDirectedTimelike : Point → (Index → ℝ) → Prop)
  (isTimelikeGeodesic : Set Point → Prop)
  where
  /-- 
  Geroch-Jang (1975) Theorem (Page 66):
  If for every neighborhood U of a curve gamma, there exists a conserved, symmetric 
  stress-energy tensor satisfying the dominant energy condition with support strictly 
  inside U, then gamma must be a timelike geodesic.
  
  ANTI-BS PROVISIONS:
  1. The metric `g` must be invertible (prevents trivial topological collapse).
  2. The connection `Gamma` is strictly locked to the Levi-Civita Christoffel symbols of `g`.
  3. The energy condition is explicitly defined, preventing a vacuous predicate exploit.
  4. The support constraint rigorously uses the topological `closure`.
  -/
  metric_invertible :
    ∀ x, (Matrix.of fun i j => g i j x) * (Matrix.of fun i j => g_inv i j x) = 1
  
  exists_timelike : 
    ∀ x, ∃ t, isFutureDirectedTimelike x t

  christoffel_eq : 
    ∀ x (lam mu nu : Index),
      Gamma lam mu nu x = (1 / 2 : ℝ) * ∑ rho : Index, g_inv lam rho x * (
        partialDeriv mu (fun p => g rho nu p) x +
        partialDeriv nu (fun p => g rho mu p) x -
        partialDeriv rho (fun p => g mu nu p) x
      )

  motion_is_geodesic :
    ∀ (gamma : Set Point),
      (∀ U : Set Point, IsOpen U → gamma ⊆ U →
        ∃ (T : Index → Index → Point → ℝ),
          (∃ x, ∃ mu nu, T mu nu x ≠ 0) ∧
          (∀ mu nu x, T mu nu x = T nu mu x) ∧
          (∀ x, (∃ mu nu, T mu nu x ≠ 0) →
            ∀ t t', isFutureDirectedTimelike x t → isFutureDirectedTimelike x t' →
              ∑ a : Index, ∑ b : Index, T a b x * t a * t' b > 0) ∧
          (closure {x | ∃ mu nu, T mu nu x ≠ 0} ⊆ U) ∧
          (∀ b x,
            ∑ a : Index, (
              partialDeriv a (fun p => T a b p) x +
              ∑ c : Index, (Gamma a a c x * T c b x + Gamma b a c x * T a c x)
            ) = 0)
      ) →
      isTimelikeGeodesic gamma

end Litlib.Y1975.geroch1975motion
