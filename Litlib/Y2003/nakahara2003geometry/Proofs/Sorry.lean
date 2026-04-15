-- FILENAME: Litlib/Y2003/nakahara2003geometry/Proofs/Sorry.lean

import Litlib.Y2003.nakahara2003geometry.Signature

namespace Litlib.Y2003.nakahara2003geometry.Proofs

@[Litlib.difficulty easy, Litlib.status Conjecture]
instance (priority := 10) fallback_Eq6_8 
    {Chain Form : Type*}
    {integral : Chain → Form → ℝ}
    {exteriorDeriv : Form → Form}
    {boundary : Chain → Chain} : Eq6_8 Chain Form integral exteriorDeriv boundary where
  stokesTheorem := sorry

@[Litlib.difficulty easy, Litlib.status Conjecture]
instance (priority := 10) fallback_Eq10_32b 
    {Form : Type*} [AddCommGroup Form]
    {exteriorDeriv : Form → Form}
    {wedge : Form → Form → Form} : Eq10_32b Form exteriorDeriv wedge where
  cartanStructureEq := sorry

@[Litlib.difficulty easy, Litlib.status Conjecture]
instance (priority := 10) fallback_Eq10_45 
    {Form : Type*} [Zero Form]
    {covariantDeriv : Form → Form} : Eq10_45 Form covariantDeriv where
  bianchiIdentity := sorry

@[Litlib.difficulty hard, Litlib.status Conjecture]
instance (priority := 10) fallback_Eq10_128 
    {Map : Type*}
    {degree : Map → ℤ}
    {cartanMaurerIntegral : Map → ℝ} : Eq10_128 Map degree cartanMaurerIntegral where
  windingNumberIntegral := sorry

@[Litlib.difficulty hard, Litlib.status Conjecture]
instance (priority := 10) fallback_TopologicalCalculus 
    {Map : Type*} [TopologicalSpace Map]
    {windingNumber : Map → ℤ}
    {cartanMaurerIntegral : Map → ℝ}
    {applyTranslation : Map → Map}
    {applyGauge : Map → Map}
    {bpstEnvelope : Map} : TopologicalCalculus Map windingNumber cartanMaurerIntegral applyTranslation applyGauge bpstEnvelope where
  homotopyInvariance := sorry
  degreeTheorem := sorry
  gaugeAndTranslationInvariance := sorry
  bpstBoundaryDegree := sorry

end Litlib.Y2003.nakahara2003geometry.Proofs
