-- FILENAME: Litlib/Y1974/guillemin1974differential/Chapter03/Sec01_Motivation.lean

import Mathlib.Data.Set.Basic
import Mathlib.Data.Fintype.Card
import Mathlib.Data.ZMod.Basic
import Mathlib.Data.Real.Basic
import Litlib.Core

namespace Litlib.Y1974.guillemin1974differential

/-!
# Chapter 3, Section 1: Motivation (pp. 94–95)

Mod 2 intersection theory provides a homotopy invariant by counting the parity of the preimage
of a transversal submanifold of complementary dimension. For a homotopy $F : X \times I \to Y$,
the boundary of the preimage decomposes into the preimages at the ends $t = 0$ and $t = 1$.
-/

Litlib.equation "guillemin1974differential"
  eq "BoundaryPreimageCylinder" page "94" kind "proposition"
/-- The boundary of the preimage under a homotopy $F : X \times [0, 1] \to Y$ transversal to $Z$
equals $(f_0^{-1}(Z) \times \{0\}) \cup (f_1^{-1}(Z) \times \{1\})$. -/
class BoundaryPreimageCylinder
    (X Y : Type*) (Z : Set Y)
    (f₀ f₁ : X → Y)
    (F : X × ℝ → Y)
    (h_homotopy₀ : ∀ x, F (x, 0) = f₀ x)
    (h_homotopy₁ : ∀ x, F (x, 1) = f₁ x)
    (boundaryPreimage : Set (X × ℝ)) where
  preimage_boundary_eq :
    boundaryPreimage =
      {p : X × ℝ | p.1 ∈ f₀ ⁻¹' Z ∧ p.2 = 0} ∪ {p : X × ℝ | p.1 ∈ f₁ ⁻¹' Z ∧ p.2 = 1}

Litlib.equation "guillemin1974differential"
  eq "Mod2HomotopyInvariance" page "94" kind "theorem"
/-- Homotopy invariance of the mod 2 intersection number: if $f_0$ and $f_1$ are homotopic
and both transversal to $Z$, then $I_2(f_0, Z) = I_2(f_1, Z)$. -/
class Mod2HomotopyInvariance
    (X Y : Type*) (Z : Set Y)
    (f₀ f₁ : X → Y)
    [Fintype (f₀ ⁻¹' Z)] [Fintype (f₁ ⁻¹' Z)]
    (i₂ : (X → Y) → Set Y → ZMod 2)
    (TransversalTo : (X → Y) → Set Y → Prop)
    (Homotopic : (X → Y) → (X → Y) → Prop)
    (h_transverse₀ : TransversalTo f₀ Z)
    (h_transverse₁ : TransversalTo f₁ Z)
    (h_homotopic : Homotopic f₀ f₁) where
  card_parity_eq :
    (Fintype.card (f₀ ⁻¹' Z) : ZMod 2) = (Fintype.card (f₁ ⁻¹' Z) : ZMod 2)
  mod2_invariant :
    i₂ f₀ Z = i₂ f₁ Z

end Litlib.Y1974.guillemin1974differential
