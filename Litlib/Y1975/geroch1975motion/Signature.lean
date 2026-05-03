-- FILENAME: Litlib/Y1975/geroch1975motion/Signature.lean

import Litlib.Core
import Mathlib.Topology.Basic
import Mathlib.Data.Matrix.Basic
import Mathlib.Data.Complex.Basic

namespace Litlib.Y1975.geroch1975motion

Litlib.paper "geroch1975motion"
  type "article"
  title "Motion of a body in general relativity"
  authors ["Geroch, Robert", "Jang, Pong Soo"]
  journal "Journal of Mathematical Physics"
  volume "16"
  issue "1"
  pages "65"
  year "1975"
  doi "10.1063/1.522416"

Litlib.equation "geroch1975motion"
  eq "Unknown"
  page "Unknown"
  kind "Unknown"
class Thm_MotionOfBody 
  (Point : Type) [TopologicalSpace Point]
  (Index : Type) [Fintype Index] [DecidableEq Index]
  (g g_inv : Index → Index → Point → ℂ)
  (Gamma_sym : Index → Index → Index → Point → ℂ)
  (partialDeriv : Index → (Point → ℂ) → Point → ℂ)
  (satisfiesEnergyCondition : (Index → Index → Point → ℂ) → Prop)
  (support : (Index → Index → Point → ℂ) → Set Point)
  (isTimelikeGeodesic : Set Point → Prop)
  where
  /-- 
  Geroch-Jang (1975) Theorem:
  If for every neighborhood U of a curve gamma, there exists a conserved, symmetric 
  stress-energy tensor satisfying the energy conditions with support strictly inside U, 
  then gamma must be a timelike geodesic.
  -/
  motion_is_geodesic :
    (∀ x, (Matrix.of fun i j => g i j x) * (Matrix.of fun i j => g_inv i j x) = 1) →
    ∀ (gamma : Set Point),
      (∀ U : Set Point, IsOpen U → gamma ⊆ U →
        ∃ (T : Index → Index → Point → ℂ),
          T ≠ 0 ∧
          (∀ mu nu x, T mu nu x = T nu mu x) ∧
          satisfiesEnergyCondition T ∧
          support T ⊆ U ∧
          (∀ nu x,
            ∑ mu : Index, ∑ alpha : Index, g_inv mu alpha x * (
              partialDeriv alpha (fun p => T mu nu p) x -
              ∑ lambda : Index, (Gamma_sym lambda alpha mu x * T lambda nu x + 
                                 Gamma_sym lambda alpha nu x * T mu lambda x)
            ) = 0)
      ) →
      isTimelikeGeodesic gamma

end Litlib.Y1975.geroch1975motion
