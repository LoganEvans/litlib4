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
    (Bundle Base GroupType : Type _) [TopologicalSpace Bundle] [TopologicalSpace Base] [Group GroupType]
    (isPrincipalBundle : Type _ → Type _ → Type _ → Prop)
    (admitsGlobalSection : Type _ → Type _ → Prop)
    (isTrivialBundle : Type _ → Prop) where
  
  h_principal : isPrincipalBundle Bundle Base GroupType
  
  trivial_iff_global_section :
    isTrivialBundle Bundle ↔ admitsGlobalSection Bundle Base

Litlib.equation "nakahara2003geometry"
  eq "9.2"
  page "25"
  kind "corollary"
class VectorBundleTriviality
    (Bundle PrincipalBundle Base : Type _) 
    [TopologicalSpace Bundle] [TopologicalSpace PrincipalBundle] [TopologicalSpace Base]
    (isVectorBundle : Type _ → Type _ → Prop)
    (associatedPrincipalBundle : Type _ → Type _)
    (admitsGlobalSection : Type _ → Type _ → Prop)
    (isTrivialBundle : Type _ → Prop) where
  
  h_vector : isVectorBundle Bundle Base
  
  trivial_iff_associated_global_section :
    isTrivialBundle Bundle ↔ 
    admitsGlobalSection (associatedPrincipalBundle Bundle) Base

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
  
  -- Nakahara immediately notes that this algebraically maps S^3 to S^2
  maps_S3_to_S2 : ∀ x1 x2 x3 x4,
    x1^2 + x2^2 + x3^2 + x4^2 = 1 →
    let (xi1, xi2, xi3) := hopf (x1, x2, x3, x4)
    xi1^2 + xi2^2 + xi3^2 = 1

end Litlib.Y2003.nakahara2003geometry
