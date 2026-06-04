-- FILENAME: Litlib/Y2003/nakahara2003geometry/Chapter09/Sec04_PrincipalBundles.lean

import Litlib.Core
import Litlib.Y2003.nakahara2003geometry.Paper
import Mathlib.Topology.Basic
import Mathlib.Algebra.Group.Defs
import Mathlib.Data.Real.Basic

namespace Litlib.Y2003.nakahara2003geometry

Litlib.equation "nakahara2003geometry"
  eq "9.2"
  page "25"
  kind "theorem"
class PrincipalBundleTriviality
    (Bundle Base GroupType : Type _) [TopologicalSpace Bundle] [TopologicalSpace Base] [TopologicalSpace GroupType] [Group GroupType]
    [TopologicalSpace (Base × GroupType)]
    (p : Bundle → Base)
    (isPrincipalBundle : (Bundle → Base) → Prop)
    where
  
  h_principal : isPrincipalBundle p
  
  /-- Global Section Constraint: A principal bundle is trivial if and only if it admits a global continuous section. The triviality is witnessed by a homeomorphism to the product space. -/
  trivial_iff_global_section :
    (∃ (h : Bundle ≃ Base × GroupType), Continuous h ∧ Continuous h.symm ∧ ∀ x, (h x).1 = p x) ↔ 
    (∃ s : Base → Bundle, Continuous s ∧ ∀ x, p (s x) = x)

Litlib.equation "nakahara2003geometry"
  eq "9.2"
  page "25"
  kind "corollary"
class VectorBundleTriviality
    (Bundle PrincipalBundle Base F : Type _) 
    [TopologicalSpace Bundle] [TopologicalSpace PrincipalBundle] [TopologicalSpace Base] [TopologicalSpace F]
    [TopologicalSpace (Base × F)]
    (p_vec : Bundle → Base)
    (p_prin : PrincipalBundle → Base)
    (isVectorBundle : (Bundle → Base) → Prop)
    (isAssociatedPrincipalBundle : (PrincipalBundle → Base) → (Bundle → Base) → Prop)
    where
  
  h_vector : isVectorBundle p_vec
  h_associated : isAssociatedPrincipalBundle p_prin p_vec
  
  /-- Associated Section Constraint: A vector bundle is trivial if and only if its associated principal bundle admits a global continuous section. -/
  trivial_iff_associated_global_section :
    (∃ (h : Bundle ≃ Base × F), Continuous h ∧ Continuous h.symm ∧ ∀ x, (h x).1 = p_vec x) ↔ 
    (∃ s : Base → PrincipalBundle, Continuous s ∧ ∀ x, p_prin (s x) = x)

Litlib.equation "nakahara2003geometry"
  eq "9.53a-c"
  page "20"
  kind "equation"
class HopfMap
    (hopf : (ℝ × ℝ × ℝ × ℝ) → (ℝ × ℝ × ℝ)) where
  hopf_def : ∀ x1 x2 x3 x4,
    hopf (x1, x2, x3, x4) =
      (2 * (x1 * x3 + x2 * x4),
       2 * (x2 * x3 - x1 * x4),
       x1^2 + x2^2 - x3^2 - x4^2)
  
  maps_S3_to_S2 : ∀ x1 x2 x3 x4,
    x1^2 + x2^2 + x3^2 + x4^2 = 1 →
    let (xi1, xi2, xi3) := hopf (x1, x2, x3, x4)
    xi1^2 + xi2^2 + xi3^2 = 1

end Litlib.Y2003.nakahara2003geometry
