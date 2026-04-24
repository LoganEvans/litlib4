-- FILENAME: Litlib/Y2003/nakahara2003geometry/Signature.lean

import Litlib.Core
import Mathlib.Data.Real.Basic
import Mathlib.Data.Complex.Basic
import Mathlib.Analysis.SpecialFunctions.Trigonometric.Basic
import Mathlib.Topology.Basic
import Mathlib.Topology.ContinuousOn
import Mathlib.Analysis.Calculus.Deriv.Basic

namespace Litlib.Y2003.nakahara2003geometry

Litlib.reference Eq6_8
  bibtex "nakahara2003geometry"
  authors ["Nakahara, Mikio"]
  status Standard
class Eq6_8 
    (Chain Form : Type*)
    (integral : Chain → Form → ℝ)
    (exteriorDeriv : Form → Form)
    (boundary : Chain → Chain) where
  stokesTheorem :
    ∀ (c : Chain) (omega : Form), 
      integral c (exteriorDeriv omega) = integral (boundary c) omega

Litlib.reference Eq10_32b
  bibtex "nakahara2003geometry"
  authors ["Nakahara, Mikio"]
  status Standard
class Eq10_32b 
    (Form : Type*) [AddCommGroup Form]
    (exteriorDeriv : Form → Form)
    (wedge : Form → Form → Form) where
  cartanStructureEq
    (omega Omega : Form) :
    Omega = exteriorDeriv omega + wedge omega omega

Litlib.reference Eq10_45
  bibtex "nakahara2003geometry"
  authors ["Nakahara, Mikio"]
  status Standard
class Eq10_45 
    (Form : Type*) [Zero Form]
    (covariantDeriv : Form → Form) where
  bianchiIdentity
    (Omega : Form) :
    covariantDeriv Omega = 0

Litlib.reference Eq10_128
  bibtex "nakahara2003geometry"
  authors["Nakahara, Mikio"]
  status Standard
class Eq10_128 
    (Map : Type*)
    (isSmooth : Map → Prop)
    (degree : Map → ℤ)
    (cartanMaurerIntegral : Map → ℝ) where
  windingNumberIntegral :
    ∀ (g : Map), isSmooth g → (degree g : ℝ) = (1 / (24 * Real.pi^2)) * cartanMaurerIntegral g

Litlib.reference CartanMaurerTopology
  bibtex "nakahara2003geometry"
  authors["Nakahara, Mikio"]
  status Standard
class CartanMaurerTopology 
    (GroupMap : Type*) [TopologicalSpace GroupMap]
    (isSmooth : GroupMap → Prop)
    (windingNumber : GroupMap → ℤ)
    (cartanMaurerIntegral : GroupMap → ℝ) where
  
  -- Nakahara Eq 10.128: The integral of the Cartan-Maurer form yields the topological degree.
  degreeTheorem :
    ∀ g : GroupMap, isSmooth g → cartanMaurerIntegral g = (windingNumber g : ℝ)

  -- Homotopy invariance of the topological degree
  homotopyInvariance
    (H : ℝ → GroupMap)
    (hCont : Continuous H) :
    ∀ t1 t2 : ℝ, windingNumber (H t1) = windingNumber (H t2)

Litlib.reference PontryaginActionVariation
  bibtex "nakahara2003geometry"
  authors ["Nakahara, Mikio"]
  status Standard
class PontryaginActionVariation 
    (Universe : Type*)
    (Action : Universe → ℝ)
    (isValidVariation : (ℝ → Universe) → Prop) where
  /-- 
  Nakahara 2003, Section 11.5.1 "Chern-Simons forms". 
  The Pontryagin density (P_2) is an exact form locally given by the exterior 
  derivative of the Chern-Simons 3-form (Q_3). By Stokes' theorem (Eq 11.102), 
  the integral over the manifold evaluates strictly to the boundary integral. 
  Because a valid physical variation has compact support (vanishes at boundaries), 
  the functional derivative of the action evaluates identically to zero.
  -/
  variation_zero (u : Universe) (v : ℝ → Universe) :
    isValidVariation v → v 0 = u → HasDerivAt (fun t => Action (v t)) 0 0

end Litlib.Y2003.nakahara2003geometry
