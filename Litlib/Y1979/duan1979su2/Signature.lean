-- FILENAME: Litlib/Y1979/duan1979su2/Signature.lean

import Litlib.Core
import Mathlib.Data.Real.Basic
import Mathlib.Algebra.Group.Defs

namespace Litlib.Y1979.duan1979su2

literature_citation Eq1_13_Decomposition
  bibtex_key "duan1979su2"
  doi "10.1142/9789813237278_0001"
  authors ["Duan, Yi-Shi", "Ge, Mo-Lin"]
  status Standard
class Eq1_13_Decomposition where
  /-- Equation (1.13): The decomposition of the SU(2) gauge potential W 
      into a parallel Abelian part A and an orthogonal topological part b. -/
  gauge_decomposition
    (V : Type*) [AddCommGroup V] [SMul ℝ V]
    (dot : V → V → ℝ)
    (cross : V → V → V)
    (h_dot_symm : ∀ a b, dot a b = dot b a)
    (h_scalar_triple : ∀ a b c, dot a (cross b c) = dot (cross a b) c)
    (h_cross_self : ∀ a, cross a a = 0)
    (e : ℝ) (he : e ≠ 0)
    (W : Fin 4 → V)
    (n : V) (hn : dot n n = 1)
    (dn : Fin 4 → V) (hdn : ∀ μ, dot n (dn μ) = 0)
    (A : Fin 4 → ℝ) (hA : ∀ μ, A μ = dot n (W μ))
    (b : Fin 4 → V) (hb : ∀ μ, b μ = (1 / e) • cross (dn μ) n)
    (hW : ∀ μ, W μ = A μ • n + b μ) :
    ∀ μ, dot n (b μ) = 0

literature_citation Eq1_33_ElectromagneticTensor
  bibtex_key "duan1979su2"
  doi "10.1142/9789813237278_0001"
  authors ["Duan, Yi-Shi", "Ge, Mo-Lin"]
  status Standard
class Eq1_33_ElectromagneticTensor where
  /-- Equation (1.33): The U(1) electromagnetic field strength tensor F_μν 
      emerging from the SU(2) field strength G_μν projected along n. -/
  electromagnetic_tensor
    (V : Type*) [AddCommGroup V] [SMul ℝ V]
    (dot : V → V → ℝ)
    (cross : V → V → V)
    (h_cross_antisymm : ∀ a b, cross a b = - cross b a)
    (h_dot_symm : ∀ a b, dot a b = dot b a)
    (h_dot_lin_add : ∀ a b c, dot a (b + c) = dot a b + dot a c)
    (h_dot_lin_smul : ∀ a b (x : ℝ), dot a (x • b) = x * dot a b)
    (h_cross_lin_add : ∀ a b c, cross a (b + c) = cross a b + cross a c)
    (h_cross_lin_smul : ∀ a b (x : ℝ), cross a (x • b) = x • cross a b)
    (h_scalar_triple : ∀ a b c, dot a (cross b c) = dot (cross a b) c)
    (h_cross_cross : ∀ a b c, cross a (cross b c) = (dot a c) • b - (dot a b) • c)
    (e : ℝ) (he : e ≠ 0)
    (n : V) (hn : dot n n = 1)
    (dn : Fin 4 → V) (hdn : ∀ μ, dot n (dn μ) = 0)
    (d2n : Fin 4 → Fin 4 → V) (hd2n_symm : ∀ μ ν, d2n μ ν = d2n ν μ)
    (A : Fin 4 → ℝ)
    (dA : Fin 4 → Fin 4 → ℝ)
    (W : Fin 4 → V) (hW : ∀ μ, W μ = A μ • n + (1 / e) • cross (dn μ) n)
    (dW : Fin 4 → Fin 4 → V)
    (hdW : ∀ μ ν, dW μ ν = dA μ ν • n + A ν • dn μ + (1 / e) • cross (d2n μ ν) n + (1 / e) • cross (dn ν) (dn μ))
    (G : Fin 4 → Fin 4 → V)
    (hG : ∀ μ ν, G μ ν = dW μ ν - dW ν μ + e • cross (W μ) (W ν)) :
    ∀ μ ν, dot n (G μ ν) = dA μ ν - dA ν μ - (1 / e) * dot n (cross (dn μ) (dn ν))

end Litlib.Y1979.duan1979su2
