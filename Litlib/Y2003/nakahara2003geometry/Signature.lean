-- FILENAME: Litlib/Y2003/nakahara2003geometry/Signature.lean

import Litlib.Core
import Mathlib.Data.Real.Basic
import Mathlib.Data.Complex.Basic
import Mathlib.Analysis.SpecialFunctions.Trigonometric.Basic
import Mathlib.Topology.Basic
import Mathlib.Topology.ContinuousOn
import Mathlib.Analysis.Calculus.Deriv.Basic

open BigOperators

namespace Litlib.Y2003.nakahara2003geometry

Litlib.reference StokesTheorem
  type "book"
  bibtex "nakahara2003geometry"
  title "Geometry, Topology and Physics"
  authors ["Nakahara, Mikio"]
  edition "2nd"
  year "2003"
  publisher "Institute of Physics Publishing"
  isbn "0750306068"
class StokesTheorem 
    (Chain Form : Type*)
    (integral : Chain → Form → ℝ)
    (exteriorDeriv : Form → Form)
    (boundary : Chain → Chain) where
  stokesTheorem :
    ∀ (c : Chain) (omega : Form), 
      integral c (exteriorDeriv omega) = integral (boundary c) omega

Litlib.reference ContractedBianchiIdentity
  type "book"
  bibtex "nakahara2003geometry"
  title "Geometry, Topology and Physics"
  authors ["Nakahara, Mikio"]
  edition "2nd"
  year "2003"
  publisher "Institute of Physics Publishing"
  isbn "0750306068"
class ContractedBianchiIdentity 
    (Point Index : Type*) [Fintype Index] [DecidableEq Index]
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

  contractedBianchi :
    ∀ (nu : Index) (x : Point),
      ∑ mu : Index, ∑ alpha : Index, g_inv mu alpha x * (
        partialDeriv alpha (fun p => G mu nu p) x -
        ∑ lambda : Index, (christoffel lambda alpha mu x * G lambda nu x + 
                           christoffel lambda alpha nu x * G mu lambda x)
      ) = 0

Litlib.reference CartanStructureEquation
  type "book"
  bibtex "nakahara2003geometry"
  title "Geometry, Topology and Physics"
  authors ["Nakahara, Mikio"]
  edition "2nd"
  year "2003"
  publisher "Institute of Physics Publishing"
  isbn "0750306068"
class CartanStructureEquation 
    (Form : Type*) [AddCommGroup Form]
    (exteriorDeriv : Form → Form)
    (wedge : Form → Form → Form) where
  cartanStructureEq
    (omega Omega : Form) :
    Omega = exteriorDeriv omega + wedge omega omega

Litlib.reference BianchiIdentity
  type "book"
  bibtex "nakahara2003geometry"
  title "Geometry, Topology and Physics"
  authors ["Nakahara, Mikio"]
  edition "2nd"
  year "2003"
  publisher "Institute of Physics Publishing"
  isbn "0750306068"
class BianchiIdentity 
    (Form : Type*) [Zero Form]
    (covariantDeriv : Form → Form) where
  bianchiIdentity
    (Omega : Form) :
    covariantDeriv Omega = 0

Litlib.reference WindingNumberIntegral
  type "book"
  bibtex "nakahara2003geometry"
  title "Geometry, Topology and Physics"
  authors ["Nakahara, Mikio"]
  edition "2nd"
  year "2003"
  publisher "Institute of Physics Publishing"
  isbn "0750306068"
class WindingNumberIntegral 
    (Map : Type*)
    (isSmooth : Map → Prop)
    (degree : Map → ℤ)
    (cartanMaurerIntegral : Map → ℝ) where
  windingNumberIntegral :
    ∀ (g : Map), isSmooth g → (degree g : ℝ) = (1 / (24 * Real.pi^2)) * cartanMaurerIntegral g

Litlib.reference CartanMaurerTopology
  type "book"
  bibtex "nakahara2003geometry"
  title "Geometry, Topology and Physics"
  authors ["Nakahara, Mikio"]
  edition "2nd"
  year "2003"
  publisher "Institute of Physics Publishing"
  isbn "0750306068"
class CartanMaurerTopology 
    (GroupMap : Type*) [TopologicalSpace GroupMap]
    (isSmooth : GroupMap → Prop)
    (windingNumber : GroupMap → ℤ)
    (cartanMaurerIntegral : GroupMap → ℝ) where
  degreeTheorem :
    ∀ g : GroupMap, isSmooth g → cartanMaurerIntegral g = (windingNumber g : ℝ)
  homotopyInvariance
    (H : ℝ → GroupMap)
    (hCont : Continuous H) :
    ∀ t1 t2 : ℝ, windingNumber (H t1) = windingNumber (H t2)

Litlib.reference PontryaginActionVariation
  type "book"
  bibtex "nakahara2003geometry"
  title "Geometry, Topology and Physics"
  authors ["Nakahara, Mikio"]
  edition "2nd"
  year "2003"
  publisher "Institute of Physics Publishing"
  isbn "0750306068"
class PontryaginActionVariation 
    (Universe β : Type*) [NormedAddCommGroup β] [NormedSpace ℝ β]
    (Action : Universe → β)
    (isValidVariation : (ℝ → Universe) → Prop) where
  variation_zero (u : Universe) (v : ℝ → Universe) :
    isValidVariation v → v 0 = u → HasDerivAt (fun t => Action (v t)) (0 : β) (0 : ℝ)

-- Downstream backwards compatibility alias
abbrev Eq7_85 := ContractedBianchiIdentity

end Litlib.Y2003.nakahara2003geometry
