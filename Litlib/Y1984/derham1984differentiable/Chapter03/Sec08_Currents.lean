-- FILENAME: Litlib/Y1984/derham1984differentiable/Chapter03/Sec08_Currents.lean

import Mathlib.Analysis.InnerProductSpace.PiL2
import Litlib.Core
import Litlib.Y1984.derham1984differentiable.Paper

namespace Litlib.Y1984.derham1984differentiable.Chapter03

/-!
# Chapter III: Currents
## § 8. Definition of Currents

A current of dimension `p` on a manifold `M` is defined by Georges de Rham as a continuous
linear functional on the space of smooth differential `p`-forms with compact support on `M`.
-/

Litlib.equation "derham1984differentiable" eq "8.1" page "34" kind "definition"
class CurrentDefinition
    (TestForm : Type*) [AddCommGroup TestForm] [Module ℝ TestForm] [Nontrivial TestForm]
    (Current : Type*) [AddCommGroup Current] [Module ℝ Current] [Nontrivial Current]
    (pairing : Current → TestForm → ℝ) where
  pairing_linear_right (T : Current) (c1 c2 : ℝ) (phi1 phi2 : TestForm) :
    pairing T (c1 • phi1 + c2 • phi2) = c1 * pairing T phi1 + c2 * pairing T phi2
  pairing_linear_left (T1 T2 : Current) (c1 c2 : ℝ) (phi : TestForm) :
    pairing (c1 • T1 + c2 • T2) phi = c1 * pairing T1 phi + c2 * pairing T2 phi
  pairing_nondegenerate_left (T : Current) :
    (∀ phi : TestForm, pairing T phi = 0) ↔ T = 0
  pairing_nondegenerate_right (phi : TestForm) :
    (∀ T : Current, pairing T phi = 0) ↔ phi = 0

Litlib.equation "derham1984differentiable" eq "8.example1" page "34" kind "definition"
class ChainAsCurrent
    (TestForm : Type*) [AddCommGroup TestForm] [Module ℝ TestForm]
    (Chain : Type*) [AddCommGroup Chain] [Module ℝ Chain]
    (Current : Type*) [AddCommGroup Current] [Module ℝ Current]
    (pairing : Current → TestForm → ℝ)
    (chainIntegration : Chain → TestForm → ℝ)
    (toCurrent : Chain → Current) where
  toCurrent_linear (c1 c2 : ℝ) (C1 C2 : Chain) :
    toCurrent (c1 • C1 + c2 • C2) = c1 • toCurrent C1 + c2 • toCurrent C2
  chain_current_eval (C : Chain) (phi : TestForm) :
    pairing (toCurrent C) phi = chainIntegration C phi

Litlib.equation "derham1984differentiable" eq "8.example2" page "34" kind "definition"
class FormAsCurrent
    (TestForm : Type*) [AddCommGroup TestForm] [Module ℝ TestForm]
    (IntegrableForm : Type*) [AddCommGroup IntegrableForm] [Module ℝ IntegrableForm]
    (TopForm : Type*) [AddCommGroup TopForm] [Module ℝ TopForm]
    (Current : Type*) [AddCommGroup Current] [Module ℝ Current]
    (wedge : IntegrableForm → TestForm → TopForm)
    (integral : TopForm → ℝ)
    (pairing : Current → TestForm → ℝ)
    (formToCurrent : IntegrableForm → Current) where
  formToCurrent_linear (c1 c2 : ℝ) (alpha1 alpha2 : IntegrableForm) :
    formToCurrent (c1 • alpha1 + c2 • alpha2) =
      c1 • formToCurrent alpha1 + c2 • formToCurrent alpha2
  form_current_eval (alpha : IntegrableForm) (phi : TestForm) :
    pairing (formToCurrent alpha) phi = integral (wedge alpha phi)

Litlib.equation "derham1984differentiable" eq "8.exterior_product" page "36" kind "definition"
class CurrentExteriorProduct
    (SmoothForm : Type*) [AddCommGroup SmoothForm] [Module ℝ SmoothForm]
    (TestFormP : Type*) [AddCommGroup TestFormP] [Module ℝ TestFormP]
    (TestFormQ : Type*) [AddCommGroup TestFormQ] [Module ℝ TestFormQ]
    (CurrentP : Type*) [AddCommGroup CurrentP] [Module ℝ CurrentP]
    (CurrentQ : Type*) [AddCommGroup CurrentQ] [Module ℝ CurrentQ]
    (pairingP : CurrentP → TestFormP → ℝ)
    (pairingQ : CurrentQ → TestFormQ → ℝ)
    (wedgeForms : SmoothForm → TestFormQ → TestFormP)
    (wedgeCurrentForm : CurrentP → SmoothForm → CurrentQ) where
  wedgeCurrentForm_eval (T : CurrentP) (alpha : SmoothForm) (phi : TestFormQ) :
    pairingQ (wedgeCurrentForm T alpha) phi = pairingP T (wedgeForms alpha phi)

end Litlib.Y1984.derham1984differentiable.Chapter03
