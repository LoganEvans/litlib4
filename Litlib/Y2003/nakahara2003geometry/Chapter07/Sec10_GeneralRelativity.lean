-- FILENAME: Litlib/Y2003/nakahara2003geometry/Chapter07/Sec10_GeneralRelativity.lean

import Litlib.Core
import Mathlib.Data.Real.Basic
import Mathlib.Data.Fintype.Basic
import Mathlib.Analysis.SpecialFunctions.Trigonometric.Basic

namespace Litlib.Y2003.nakahara2003geometry

Litlib.equation "nakahara2003geometry"
  eq "7.205"
  page "55"
  kind "theorem"
class PalatiniIdentity
    (Tensor1 Tensor2 : Type _) [AddCommGroup Tensor2]
    (deltaRicci : Tensor2)
    (deltaGamma : Tensor1)
    (covDeriv : Tensor1 → Tensor2)
    (contract1 contract2 : Tensor2 → Tensor2) where
  -- Anti-BS
  h_nontrivial : deltaRicci ≠ 0
  
  palatiniEq :
    deltaRicci = contract1 (covDeriv deltaGamma) - contract2 (covDeriv deltaGamma)

Litlib.equation "nakahara2003geometry"
  eq "7.208"
  page "56"
  kind "equation"
class VacuumEinsteinEquation
    (Point Index : Type _) [Fintype Index] [Nonempty Index] [Nonempty Point]
    (Metric Ricci : Index → Index → Point → ℝ)
    (ScalarCurv : Point → ℝ)
    (EinsteinTensor : Index → Index → Point → ℝ) where
  -- Anti-BS
  h_nontrivial : ∃ mu nu x, EinsteinTensor mu nu x ≠ 0
  
  einstein_tensor_def : ∀ mu nu x,
    EinsteinTensor mu nu x = Ricci mu nu x - (1/2 : ℝ) * Metric mu nu x * ScalarCurv x
    
  vacuum_eq : ∀ mu nu x, EinsteinTensor mu nu x = 0

Litlib.equation "nakahara2003geometry"
  eq "7.214"
  page "57"
  kind "equation"
class EinsteinEquation
    (Point Index : Type _) [Fintype Index] [Nonempty Index] [Nonempty Point]
    (G T : Index → Index → Point → ℝ) 
    (newtonG : ℝ) where
  -- Anti-BS constraint
  h_nontrivial_matter : ∃ mu nu x, T mu nu x ≠ 0
  h_positive_G : newtonG > 0
  
  einsteinEq :
    ∀ (mu nu : Index) (x : Point),
      G mu nu x = 8 * Real.pi * newtonG * T mu nu x

end Litlib.Y2003.nakahara2003geometry
