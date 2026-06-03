-- FILENAME: Litlib/Y1979/duan1979su2/Signature.lean

import Litlib.Core
import Mathlib.Data.Real.Basic
import Mathlib.Algebra.Module.Basic

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
  page "3"
  kind "theorem"
class GaugePotentialDecomposition where
  /-- 
  Physical Interpretation: Equations (1.13-1.15) (pages 3-4): The Cho-Duan-Ge 
  decomposition of the SU(2) gauge potential W isolates the massive vector 
  particle part b_mu. This theorem verifies that b_mu is strictly orthogonal 
  to the fundamental isospin field n in the internal space.
  
  Mathematical Boundaries: The parameter e represents the coupling constant and 
  must be strictly non-zero (`he : e ≠ 0`) to mathematically prevent a pathological 
  division by zero. The internal isospin space is abstracted as a real module equipped 
  with a valid antisymmetric cross product and symmetric inner product.
  -/
  b_is_orthogonal
    (V : Type*) [AddCommGroup V] [Module ℝ V]
    (inner : V → V → ℝ)
    (cross : V → V → V)
    (hCrossAntisymm : ∀ a b, cross a b = - cross b a)
    (hInnerSymm : ∀ a b, inner a b = inner b a)
    (hInnerLinSmul : ∀ a b (x : ℝ), inner a (x • b) = x * inner a b)
    (hScalarTriple : ∀ a b c, inner a (cross b c) = inner (cross a b) c)
    (hCrossSelf : ∀ a, cross a a = 0)
    (e : ℝ) (he : e ≠ 0)
    (Idx : Type*)
    (n : V)
    (nabla_n : Idx → V)
    (b : Idx → V) (hb : ∀ μ, b μ = -(1 / e) • cross (nabla_n μ) n) :
    ∀ μ, inner n (b μ) = 0

Litlib.equation "duan1979su2"
  eq "1.33"
  page "6"
  kind "theorem"
class PhysicalElectromagneticTensor where
  /-- 
  Physical Interpretation: Equations (1.30, 1.32, 1.33) (pages 5-6): 
  The derivation of the physical U(1) electromagnetic tensor F_mu_nu 
  from the SU(2) field strength G_mu_nu. This algebraic identity establishes 
  the Cho-Duan-Ge decomposition, isolating the Abelian component and the 
  topological monopole source terms into a gauge-invariant structure.
  
  Mathematical Boundaries: This requires validating the full Lie algebraic 
  expansion of the SU(2) curvature. To prevent topological trivialization 
  (the "Zero Exploit"), the internal isospin field `n` must be properly 
  normalized to unity (`hn : inner n n = 1`), and its derivative must be 
  strictly orthogonal (`hdn : inner n (dn μ) = 0`). The gauge coupling 
  constant must also be strictly non-zero (`e ≠ 0`).
  -/
  physical_tensor_eq
    (V : Type*) [AddCommGroup V] [Module ℝ V]
    (inner : V → V → ℝ)
    (cross : V → V → V)
    (hCrossAntisymm : ∀ a b, cross a b = - cross b a)
    (hInnerSymm : ∀ a b, inner a b = inner b a)
    (hInnerLinAdd : ∀ a b c, inner a (b + c) = inner a b + inner a c)
    (hInnerLinSmul : ∀ a b (x : ℝ), inner a (x • b) = x * inner a b)
    (hCrossLinAdd : ∀ a b c, cross a (b + c) = cross a b + cross a c)
    (hCrossLinSmul : ∀ a b (x : ℝ), cross a (x • b) = x • cross a b)
    (hScalarTriple : ∀ a b c, inner a (cross b c) = inner (cross a b) c)
    (hCrossCross : ∀ a b c, cross a (cross b c) = (inner a c) • b - (inner a b) • c)
    (e : ℝ) (he : e ≠ 0)
    (Idx : Type*)
    (n : V) (hn : inner n n = 1)
    (dn : Idx → V) (hdn : ∀ μ, inner n (dn μ) = 0)
    (d2n : Idx → Idx → V) (hd2nSymm : ∀ μ ν, d2n μ ν = d2n ν μ)
    (A : Idx → ℝ)
    (dA : Idx → Idx → ℝ)
    (W : Idx → V) (hW : ∀ μ, W μ = A μ • n + (1 / e) • cross (dn μ) n)
    (dW : Idx → Idx → V)
    (hdW : ∀ μ ν, dW μ ν = dA μ ν • n + A ν • dn μ + (1 / e) • cross (d2n μ ν) n + (1 / e) • cross (dn ν) (dn μ))
    (nabla_n : Idx → V) (hNabla_n : ∀ μ, nabla_n μ = dn μ + e • cross (W μ) n)
    (G : Idx → Idx → V) (hG : ∀ μ ν, G μ ν = dW μ ν - dW ν μ + e • cross (W μ) (W ν))
    (F : Idx → Idx → ℝ) (hF : ∀ μ ν, F μ ν = (dA μ ν - dA ν μ) - (1 / e) * inner n (cross (dn μ) (dn ν))) :
    ∀ μ ν, F μ ν = inner (G μ ν) n - (1 / e) * inner n (cross (nabla_n μ) (nabla_n ν))

end Litlib.Y1979.duan1979su2
