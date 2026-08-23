-- FILENAME: Litlib/Y1983/witten1983current/Signature.lean

import Litlib.Core
import Mathlib.Topology.Basic
import Mathlib.Data.Complex.Basic
import Mathlib.Data.Matrix.Basic
import Mathlib.LinearAlgebra.Matrix.Trace

namespace Litlib.Y1983.witten1983current

Litlib.paper "witten1983current"
  type "article"
  title "Current Algebra, Baryons, and Quark Confinement"
  authors ["Witten, Edward"]
  journal "Nuclear Physics B"
  volume "223"
  pages "433--444"
  year "1983"
  doi "10.1016/0550-3213(83)90063-9"

Litlib.equation "witten1983current" eq "3" page "435" kind "definition"
class Eq3_BaryonNumberDensity
  (M : Type*) [TopologicalSpace M]
  (U : M → Matrix (Fin 2) (Fin 2) ℂ)
  (invU : M → Matrix (Fin 2) (Fin 2) ℂ)
  (partialDeriv : Fin 3 → (M → Matrix (Fin 2) (Fin 2) ℂ) → M → Matrix (Fin 2) (Fin 2) ℂ)
  (epsilon3 : Fin 3 → Fin 3 → Fin 3 → ℂ)
  (pi : ℂ)
  (B_0 : M → ℂ) : Prop where
  /--
  Topological Baryon Number Density Definition: Equation (3) (page 435).
  Defines the Cartan-Maurer topological invariant integrand for the SU(2)
  chiral boundary mapping. Evaluated by taking the matrix trace of the triple
  wedge product of the Maurer-Cartan form (U^{-1} ∂_i U).
  -/
  baryonDensity_iff : ∀ x,
    B_0 x = (1 / (24 * pi ^ 2)) *
      Finset.sum Finset.univ (fun i ↦
        Finset.sum Finset.univ (fun j ↦
          Finset.sum Finset.univ (fun k ↦
            epsilon3 i j k *
            Matrix.trace (
              (invU x * partialDeriv i U x) *
              (invU x * partialDeriv j U x) *
              (invU x * partialDeriv k U x)
            )
          )
        )
      )

end Litlib.Y1983.witten1983current
