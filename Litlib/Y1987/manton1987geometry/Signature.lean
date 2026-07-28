-- FILENAME: Litlib/Y1987/manton1987geometry/Signature.lean

import Litlib.Core
import Mathlib.Data.Real.Sqrt
import Mathlib.Analysis.SpecialFunctions.Trigonometric.Basic
import Mathlib.Data.Complex.Basic
import Mathlib.Data.Matrix.Basic
import Mathlib.Data.Fintype.Basic

open Finset

namespace Litlib.Y1987.manton1987geometry

Litlib.paper "manton1987geometry"
  type "article"
  title "Geometry of Skyrmions"
  authors ["Manton, N. S."]
  journal "Communications in Mathematical Physics"
  year "1987"

Litlib.equation "manton1987geometry" eq "1.Hedgehog" page "469" kind "ansatz"
class HedgehogAnsatz
  (tau : Fin 3 → Matrix (Fin 2) (Fin 2) ℂ)
  (f : ℝ → ℝ)
  (matrixExp : Matrix (Fin 2) (Fin 2) ℂ → Matrix (Fin 2) (Fin 2) ℂ)
  (U : (Fin 3 → ℝ) → Matrix (Fin 2) (Fin 2) ℂ)
  where
  -- 1. The Spatial Normal Vector
  n_hat : (Fin 3 → ℝ) → Fin 3 → ℝ
  n_hat_def : ∀ (x : Fin 3 → ℝ) (a : Fin 3),
    n_hat x a = x a / Real.sqrt (∑ i : Fin 3, x i ^ 2)
  
  -- 2. The Isospin (Pauli) Vector is given by tau
  -- 3. The Hedgehog Mapping (Topological Lock between Spatial and Internal Indices)
  hedgehog_map : ∀ (x : Fin 3 → ℝ),
    U x = matrixExp (
      (Complex.I * (f (Real.sqrt (∑ i : Fin 3, x i ^ 2)) : ℂ)) •
      ∑ a : Fin 3, (n_hat x a : ℂ) • tau a
    )

Litlib.equation "manton1987geometry" eq "2.11" page "472" kind "bound"
class Eq2_11
  (E : ℝ)
  (degPi : ℝ)
  (volSigma : ℝ)
  where
  fadeev_bound : E ≥ 6 * degPi * volSigma

Litlib.equation "manton1987geometry" eq "4.1" page "474" kind "ansatz"
class Eq4_1
  (alpha : ℝ)
  (mu theta phi : ℝ)
  (mu' theta' phi' : ℝ)
  where
  alpha_pos : alpha > 0
  conformal_mu : Real.tan (mu' / 2) = alpha * Real.tan (mu / 2)
  conformal_theta : theta' = theta
  conformal_phi : phi' = phi

Litlib.equation "manton1987geometry" eq "4.3" page "475" kind "equation"
class Eq4_3
  (E L alpha : ℝ)
  where
  energy_val : E = 12 * Real.pi ^ 2 * ((2 * L) / (alpha + 1 / alpha + 2) + (1 / (4 * L)) * (alpha + 1 / alpha))

Litlib.equation "manton1987geometry" eq "4.6" page "475" kind "equation"
class Eq4_6
  (E L : ℝ)
  where
  min_energy : E = 12 * Real.pi ^ 2 * (Real.sqrt 2 - 1 / (2 * L))

end Litlib.Y1987.manton1987geometry
