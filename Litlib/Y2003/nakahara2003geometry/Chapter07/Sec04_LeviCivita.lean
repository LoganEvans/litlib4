-- FILENAME: Litlib/Y2003/nakahara2003geometry/Chapter07/Sec04_LeviCivita.lean

import Litlib.Core
import Mathlib.Data.Real.Basic
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

Litlib.equation "nakahara2003geometry"
  eq "7.30b"
  page "10"
  kind "equation"
class InverseMetricCompatibility
    (Point Index : Type _) [Fintype Index] [DecidableEq Index] [Nonempty Index] [Nonempty Point]
    (g g_inv : Index → Index → Point → ℝ)
    (christoffel : Index → Index → Index → Point → ℝ)
    (partialDeriv : Index → (Point → ℝ) → Point → ℝ) where
  -- Anti-BS constraint: strictly invertible
  h_inv : ∀ x i j, (∑ k, g i k x * g_inv k j x) = if i = j then 1 else 0

  inverseMetricComp :
    ∀ (mu nu lambda : Index) (x : Point),
      partialDeriv mu (fun p => g_inv nu lambda p) x + 
      ∑ rho, (christoffel nu mu rho x * g_inv rho lambda x + 
              christoffel lambda mu rho x * g_inv nu rho x) = 0

Litlib.equation "nakahara2003geometry"
  eq "7.85"
  page "27"
  kind "theorem"
class DivergenceIndexRaising
    (Point Index : Type _) [Fintype Index] [DecidableEq Index] [Nonempty Index] [Nonempty Point]
    (g g_inv : Index → Index → Point → ℝ)
    (christoffel : Index → Index → Index → Point → ℝ)
    (G T : Index → Index → Point → ℝ)
    (partialDeriv : Index → (Point → ℝ) → Point → ℝ) where
  -- Anti-BS constraints
  h_inv : ∀ x i j, (∑ k, g i k x * g_inv k j x) = if i = j then 1 else 0
  h_G_symm : ∀ x i j, G i j x = G j i x
  h_T_symm : ∀ x i j, T i j x = T j i x

  -- Hypothesis 1: G satisfies the covariant divergence sum equating to 0.
  covDivG : 
    ∀ (nu : Index) (x : Point),
      ∑ mu, ∑ alpha, g_inv mu alpha x * (
        partialDeriv alpha (fun p => G mu nu p) x -
        ∑ lambda, (christoffel lambda alpha mu x * G lambda nu x + 
                   christoffel lambda alpha nu x * G mu lambda x)
      ) = 0

  -- Hypothesis 2: T is G with indices raised.
  h_T_def : 
    ∀ (a b : Index) (x : Point), 
      T a b x = ∑ mu, ∑ nu, g_inv a mu x * g_inv b nu x * G mu nu x

  -- Conclusion: T satisfies the contravariant divergence sum equating to 0.
  contraDivT : 
    ∀ (b : Index) (x : Point),
      ∑ a, (
        partialDeriv a (fun p => T a b p) x + 
        ∑ c, (christoffel a a c x * T c b x + christoffel b a c x * T a c x)
      ) = 0

end Litlib.Y2003.nakahara2003geometry
