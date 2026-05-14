-- FILENAME: Litlib/Y2003/nakahara2003geometry/Chapter07/Sec4_LeviCivita.lean

import Litlib.Core
import Mathlib.Data.Complex.Basic
import Mathlib.Algebra.BigOperators.Group.Finset.Basic
import Mathlib.Data.Fintype.Basic

open BigOperators

namespace Litlib.Y2003.nakahara2003geometry

Litlib.equation "nakahara2003geometry"
  eq "7.1"
  page "18"
  kind "theorem"
class FundamentalTheoremRiemannianGeometry
    (Metric Connection : Type _) [Nonempty Metric] [Nonempty Connection]
    (isSymmetric : Connection → Prop)
    (isMetricCompatible : Connection → Metric → Prop)
    (LeviCivita : Metric → Connection) where
  h_nontrivial_metric : ∃ g, isMetricCompatible (LeviCivita g) g
  fundamental_theorem :
    ∀ (g : Metric),
      isSymmetric (LeviCivita g) ∧
      isMetricCompatible (LeviCivita g) g ∧
      (∀ (nabla : Connection), isSymmetric nabla → isMetricCompatible nabla g → nabla = LeviCivita g)

Litlib.equation "nakahara2003geometry"
  eq "7.85"
  page "27"
  kind "equation"
class ContractedBianchiIdentity 
    (Point Index : Type _) [Fintype Index] [DecidableEq Index] [Nonempty Index] [Nonempty Point]
    (g g_inv : Index → Index → Point → ℂ)
    (christoffel : Index → Index → Index → Point → ℂ)
    (ricci : Index → Index → Point → ℂ)
    (scalarCurv : Point → ℂ)
    (G : Index → Index → Point → ℂ)
    (partialDeriv : Index → (Point → ℂ) → Point → ℂ) where
  
  derivCommute : ∀ mu nu f x, partialDeriv mu (fun p => partialDeriv nu f p) x = partialDeriv nu (fun p => partialDeriv mu f p) x
  derivLeibniz : ∀ mu f1 f2 x, partialDeriv mu (fun p => f1 p * f2 p) x = partialDeriv mu f1 x * f2 x + f1 x * partialDeriv mu f2 x
  h_g_symm : ∀ x i j, g i j x = g j i x
  h_g_inv_symm : ∀ x i j, g_inv i j x = g_inv j i x
  h_inv : ∀ x i j, (∑ k, g i k x * g_inv k j x) = if i = j then 1 else 0
  
  h_christoffel : ∀ x rho mu nu, 
    christoffel rho mu nu x = (1/2 : ℂ) * ∑ sigma, g_inv rho sigma x * (
      partialDeriv mu (fun p => g sigma nu p) x + 
      partialDeriv nu (fun p => g mu sigma p) x - 
      partialDeriv sigma (fun p => g mu nu p) x)
      
  h_ricci : ∀ x mu nu,
    ricci mu nu x = ∑ rho, (
      partialDeriv rho (fun p => christoffel rho mu nu p) x - 
      partialDeriv nu (fun p => christoffel rho mu rho p) x + 
      ∑ lambda, (christoffel rho lambda rho x * christoffel lambda mu nu x - 
                 christoffel rho lambda nu x * christoffel lambda mu rho x)
    )
    
  h_scalar : ∀ x, scalarCurv x = ∑ alpha, ∑ beta, g_inv alpha beta x * ricci alpha beta x
  h_G : ∀ x mu nu, G mu nu x = ricci mu nu x - (1/2 : ℂ) * g mu nu x * scalarCurv x

  -- Anti-BS constraint: Ensure the space isn't trivially flat
  h_curved : ∃ mu nu x, G mu nu x ≠ 0

  contractedBianchi :
    ∀ (nu : Index) (x : Point),
      ∑ mu : Index, ∑ alpha : Index, g_inv mu alpha x * (
        partialDeriv alpha (fun p => G mu nu p) x -
        ∑ lambda : Index, (christoffel lambda alpha mu x * G lambda nu x + 
                           christoffel lambda alpha nu x * G mu lambda x)
      ) = 0

end Litlib.Y2003.nakahara2003geometry
