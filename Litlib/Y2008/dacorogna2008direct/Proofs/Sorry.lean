-- FILENAME: Litlib/Y2008/dacorogna2008direct/Proofs/Sorry.lean

import Litlib.Y2008.dacorogna2008direct.Signature

namespace Litlib.Y2008.dacorogna2008direct.Proofs

@[litlib_difficulty easy, litlib_status Conjecture]
instance 
    {M : Type*}
    {isConvex isPolyconvex isQuasiconvex isRankOneConvex : (M → ℝ) → Prop} : 
    ConvexityHierarchy M isConvex isPolyconvex isQuasiconvex isRankOneConvex where
  hierarchy := sorry

@[litlib_difficulty hard, litlib_status Conjecture]
instance 
    {State : Type*} [TopologicalSpace State]
    {Action : State → ℝ} : 
    DirectMethod State Action where
  exists_global_minimum := sorry

@[litlib_difficulty intractable, litlib_status Conjecture]
instance 
    {State : Type*}
    {Action RelaxedAction : State → ℝ}
    {isQuasiconvexEnvelope : (State → ℝ) → (State → ℝ) → Prop} : 
    RelaxationTheorem State Action RelaxedAction isQuasiconvexEnvelope where
  inf_P_eq_inf_QP := sorry

end Litlib.Y2008.dacorogna2008direct.Proofs
