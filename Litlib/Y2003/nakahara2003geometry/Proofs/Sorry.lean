-- FILENAME: Litlib/Y2003/nakahara2003geometry/Proofs/Sorry.lean

import Litlib.Y2003.nakahara2003geometry.Signature

namespace Litlib.Y2003.nakahara2003geometry.Proofs

@[litlib_difficulty easy, litlib_status Conjecture]
instance (priority := 10) fallback_Eq6_8 
    {Chain Form : Type*}
    {integral : Chain → Form → ℝ}
    {exterior_deriv : Form → Form}
    {boundary : Chain → Chain} : Eq6_8 Chain Form integral exterior_deriv boundary where
  stokes_theorem := sorry

@[litlib_difficulty easy, litlib_status Conjecture]
instance (priority := 10) fallback_Eq10_32b 
    {Form : Type*} [AddCommGroup Form]
    {exterior_deriv : Form → Form}
    {wedge : Form → Form → Form} : Eq10_32b Form exterior_deriv wedge where
  cartan_structure_eq := sorry

@[litlib_difficulty easy, litlib_status Conjecture]
instance (priority := 10) fallback_Eq10_45 
    {Form : Type*} [Zero Form]
    {covariant_deriv : Form → Form} : Eq10_45 Form covariant_deriv where
  bianchi_identity := sorry

@[litlib_difficulty hard, litlib_status Conjecture]
instance (priority := 10) fallback_Eq10_128 
    {Map : Type*}
    {degree : Map → ℤ}
    {cartan_maurer_integral : Map → ℝ} : Eq10_128 Map degree cartan_maurer_integral where
  winding_number_integral := sorry

@[litlib_difficulty hard, litlib_status Conjecture]
instance (priority := 10) fallback_TopologicalCalculus 
    {Map : Type*} [TopologicalSpace Map]
    {windingNumber : Map → ℤ}
    {cartanMaurerIntegral : Map → ℝ}
    {applyTranslation : Map → Map}
    {applyGauge : Map → Map}
    {bpstEnvelope : Map} : TopologicalCalculus Map windingNumber cartanMaurerIntegral applyTranslation applyGauge bpstEnvelope where
  homotopy_invariance := sorry
  degree_theorem := sorry
  gauge_and_translation_invariance := sorry
  bpst_boundary_degree := sorry

end Litlib.Y2003.nakahara2003geometry.Proofs
