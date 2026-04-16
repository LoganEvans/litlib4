-- FILENAME: Litlib/Y2003/nakahara2003geometry/Signature.lean

import Litlib.Core
import Mathlib.Data.Real.Basic
import Mathlib.Data.Complex.Basic
import Mathlib.Analysis.SpecialFunctions.Trigonometric.Basic
import Mathlib.Topology.Basic
import Mathlib.Topology.ContinuousOn

namespace Litlib.Y2003.nakahara2003geometry

Litlib.reference Eq6_8
  bibtex "nakahara2003geometry"
  authors ["Nakahara, Mikio"]
  status Standard
class Eq6_8 where
  stokesTheorem :
    ∀ (Chain Form : Type*) [Zero Form]
      (integral : Chain → Form → ℝ)
      (exteriorDeriv : Form → Form)
      (boundary : Chain → Chain)
      (_h_ext_zero : exteriorDeriv 0 = 0),
      ∀ (c : Chain) (omega : Form), 
        integral c (exteriorDeriv omega) = integral (boundary c) omega

Litlib.reference Eq10_32b
  bibtex "nakahara2003geometry"
  authors ["Nakahara, Mikio"]
  status Standard
class Eq10_32b where
  cartanStructureEq :
    ∀ (Form : Type*) [AddCommGroup Form]
      (exteriorDeriv : Form → Form)
      (wedge : Form → Form → Form)
      (omega Omega : Form),
      Omega = exteriorDeriv omega + wedge omega omega

Litlib.reference Eq10_45
  bibtex "nakahara2003geometry"
  authors ["Nakahara, Mikio"]
  status Standard
class Eq10_45 where
  bianchiIdentity :
    ∀ (Form : Type*) [Zero Form]
      (covariantDeriv : Form → Form)
      (_h_cov_zero : covariantDeriv 0 = 0)
      (Omega : Form),
      covariantDeriv Omega = 0

Litlib.reference Eq10_128
  bibtex "nakahara2003geometry"
  authors["Nakahara, Mikio"]
  status Standard
class Eq10_128 where
  windingNumberIntegral :
    ∀ (Map : Type*)
      (degree : Map → ℤ)
      (cartanMaurerIntegral : Map → ℝ)
      (_h_degree_zero : (degree = fun _ => (0 : ℤ)) → (cartanMaurerIntegral = fun _ => (0 : ℝ))),
      ∀ (g : Map), (degree g : ℝ) = (1 / (24 * Real.pi^2)) * cartanMaurerIntegral g

Litlib.reference TopologicalCalculus
  bibtex "nakahara2003geometry"
  authors["Nakahara, Mikio"]
  status Standard
class TopologicalCalculus where
  homotopyInvariance :
    ∀ (Map : Type*) [TopologicalSpace Map] (windingNumber : Map → ℤ)
      (H : ℝ → Map) (_hCont : Continuous H)
      (_hWindCont : Continuous windingNumber),
      ∀ t1 t2 : ℝ, windingNumber (H t1) = windingNumber (H t2)

  degreeTheorem :
    ∀ (Map : Type*) (windingNumber : Map → ℤ) (cartanMaurerIntegral : Map → ℝ)
      (_h_degree_zero : (windingNumber = fun _ => (0 : ℤ)) → (cartanMaurerIntegral = fun _ => (0 : ℝ))),
      ∀ g, cartanMaurerIntegral g = (windingNumber g : ℝ)

  gaugeAndTranslationInvariance :
    ∀ (Map : Type*) [Zero Map] (cartanMaurerIntegral : Map → ℝ)
      (applyTranslation : Map → Map)
      (applyGauge : Map → Map)
      (_h_integral_zero : cartanMaurerIntegral 0 = 0),
      ∀ g, cartanMaurerIntegral (applyTranslation g) = cartanMaurerIntegral g ∧
           cartanMaurerIntegral (applyGauge g) = cartanMaurerIntegral g

  bpstBoundaryDegree :
    ∀ (Map : Type*) (cartanMaurerIntegral : Map → ℝ) (bpstEnvelope : Map)
      (_h_wind_one : cartanMaurerIntegral bpstEnvelope = 1),
      cartanMaurerIntegral bpstEnvelope = 1

end Litlib.Y2003.nakahara2003geometry
