-- FILENAME: Litlib/Y1979/duan1979su2/Signature.lean

import Litlib.Core
import Mathlib.Data.Real.Basic
import Mathlib.Algebra.Group.Defs

namespace Litlib.Y1979.duan1979su2

Litlib.paper "duan1979su2"
  type "incollection"
  title "SU(2) gauge theory and electrodynamics with N magnetic monopoles"
  authors ["Duan, Yi-Shi", "Ge, Mo-Lin"]
  booktitle "Memorial Volume for Yi-Shi Duan"
  pages "1--15"
  year "2018"
  publisher "World Scientific"
  doi "10.1142/9789813237278_0001"

Litlib.equation "duan1979su2"
  eq "1.13"
  page "Unknown"
  kind "Unknown"
class GaugeDecomposition where
  /-- Equation (1.13): The decomposition of the SU(2) gauge potential W 
      into a parallel Abelian part A and an orthogonal topological part b. -/
  gaugeDecomposition
    (V : Type*) [AddCommGroup V] [SMul ℝ V]
    (dot : V → V → ℝ)
    (cross : V → V → V)
    (hDotSymm : ∀ a b, dot a b = dot b a)
    (hScalarTriple : ∀ a b c, dot a (cross b c) = dot (cross a b) c)
    (hCrossSelf : ∀ a, cross a a = 0)
    (e : ℝ) (he : e ≠ 0)
    (W : Fin 4 → V)
    (n : V) (hn : dot n n = 1)
    (dn : Fin 4 → V) (hdn : ∀ μ, dot n (dn μ) = 0)
    (A : Fin 4 → ℝ) (hA : ∀ μ, A μ = dot n (W μ))
    (b : Fin 4 → V) (hb : ∀ μ, b μ = (1 / e) • cross (dn μ) n)
    (hW : ∀ μ, W μ = A μ • n + b μ) :
    ∀ μ, dot n (b μ) = 0

Litlib.equation "duan1979su2"
  eq "1.33"
  page "Unknown"
  kind "Unknown"
class ElectromagneticTensor where
  /-- Equation (1.33): The U(1) electromagnetic field strength tensor F_μν 
      emerging from the SU(2) field strength G_μν projected along n. -/
  electromagneticTensor
    (V : Type*) [AddCommGroup V] [SMul ℝ V]
    (dot : V → V → ℝ)
    (cross : V → V → V)
    (hCrossAntisymm : ∀ a b, cross a b = - cross b a)
    (hDotSymm : ∀ a b, dot a b = dot b a)
    (hDotLinAdd : ∀ a b c, dot a (b + c) = dot a b + dot a c)
    (hDotLinSmul : ∀ a b (x : ℝ), dot a (x • b) = x * dot a b)
    (hCrossLinAdd : ∀ a b c, cross a (b + c) = cross a b + cross a c)
    (hCrossLinSmul : ∀ a b (x : ℝ), cross a (x • b) = x • cross a b)
    (hScalarTriple : ∀ a b c, dot a (cross b c) = dot (cross a b) c)
    (hCrossCross : ∀ a b c, cross a (cross b c) = (dot a c) • b - (dot a b) • c)
    (e : ℝ) (he : e ≠ 0)
    (n : V) (hn : dot n n = 1)
    (dn : Fin 4 → V) (hdn : ∀ μ, dot n (dn μ) = 0)
    (d2n : Fin 4 → Fin 4 → V) (hd2nSymm : ∀ μ ν, d2n μ ν = d2n ν μ)
    (A : Fin 4 → ℝ)
    (dA : Fin 4 → Fin 4 → ℝ)
    (W : Fin 4 → V) (hW : ∀ μ, W μ = A μ • n + (1 / e) • cross (dn μ) n)
    (dW : Fin 4 → Fin 4 → V)
    (hdW : ∀ μ ν, dW μ ν = dA μ ν • n + A ν • dn μ + (1 / e) • cross (d2n μ ν) n + (1 / e) • cross (dn ν) (dn μ))
    (G : Fin 4 → Fin 4 → V)
    (hG : ∀ μ ν, G μ ν = dW μ ν - dW ν μ + e • cross (W μ) (W ν)) :
    ∀ μ ν, dot n (G μ ν) = dA μ ν - dA ν μ - (1 / e) * dot n (cross (dn μ) (dn ν))

end Litlib.Y1979.duan1979su2
