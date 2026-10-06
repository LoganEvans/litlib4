-- FILENAME: Litlib/Y2010/wald2010general/Chapter05/Sec01_Homogeneity.lean

import Litlib.Core
import Litlib.Y2010.wald2010general.Paper
import Mathlib.Data.Real.Basic
import Mathlib.Data.Matrix.Basic

namespace Litlib.Y2010.wald2010general

open BigOperators

Litlib.equation "wald2010general" eq "5.1.2" page "94" kind "equation"
/-- Maximally Isotropic Spatial Riemann Tensor (Wald Eq. 5.1.2).
On a 3-dimensional Riemannian manifold of constant curvature K, the Riemann tensor satisfies:
{}^{(3)}R_{ab}{}^{cd} = K * delta^c_{[a} delta^d_{b]}. -/
class Eq5_1_2
    (Sigma : Type*)
    (riemann : Sigma → Fin 3 → Fin 3 → Fin 3 → Fin 3 → ℝ)
    (K : ℝ) where
  isotropic_riemann : ∀ (x : Sigma) (a b c d : Fin 3),
    let delta := fun i j : Fin 3 ↦ if i = j then (1 : ℝ) else 0
    riemann x a b c d =
      (K / 2) * (delta c a * delta d b - delta c b * delta d a)

Litlib.equation "wald2010general" eq "5.1.3" page "94" kind "equation"
/-- Spatial Riemann Tensor of Constant Curvature Space (Wald Eq. 5.1.3).
Lowering indices with the spatial metric h_{ab} yields:
{}^{(3)}R_{abcd} = K * h_{c[a} h_{b]d} = (K / 2) * (h_{ca} h_{bd} - h_{cb} h_{ad}). -/
class Eq5_1_3
    (Sigma : Type*)
    (h : Sigma → Fin 3 → Fin 3 → ℝ)
    (riemannLower : Sigma → Fin 3 → Fin 3 → Fin 3 → Fin 3 → ℝ)
    (K : ℝ) where
  h_symmetric : ∀ (x : Sigma) (a b : Fin 3), h x a b = h x b a
  riemann_lower_eq : ∀ (x : Sigma) (a b c d : Fin 3),
    riemannLower x a b c d =
      (K / 2) * (h x c a * h x b d - h x c b * h x a d)

Litlib.equation "wald2010general" eq "5.1.10" page "95" kind "equation"
/-- Spacetime Metric in Orthogonal Comoving Slicing (Wald Eq. 5.1.10).
For isotropic observers with unit 4-velocity u^a orthogonal to homogeneous hypersurfaces Sigma_t,
the 4D metric decomposes as: g_{ab} = -u_a u_b + h_{ab}(t), with h_{ab} u^b = 0. -/
class Eq5_1_10
    (M : Type*)
    (g : M → Fin 4 → Fin 4 → ℝ)
    (u : M → Fin 4 → ℝ)
    (h : M → Fin 4 → Fin 4 → ℝ) where
  timelike_unit : ∀ (p : M),
    (∑ a : Fin 4, ∑ b : Fin 4, g p a b * u p a * u p b) = -1
  orthogonal_decomposition : ∀ (p : M) (a b : Fin 4),
    g p a b = - u p a * u p b + h p a b
  spatial_orthogonal : ∀ (p : M) (a : Fin 4),
    (∑ b : Fin 4, h p a b * u p b) = 0

end Litlib.Y2010.wald2010general
