-- FILENAME: Litlib/Y2008/dacorogna2008direct/Proofs/Sorry.lean

import Litlib.Y2008.dacorogna2008direct.Signature

namespace Litlib.Y2008.dacorogna2008direct.Proofs

@[Litlib.difficulty easy, Litlib.status Conjecture]
instance 
    {M : Type*}
    {isConvex isPolyconvex isQuasiconvex isRankOneConvex : (M → ℝ) → Prop} : 
    ConvexityHierarchy M isConvex isPolyconvex isQuasiconvex isRankOneConvex where
  hierarchy := sorry

@[Litlib.difficulty hard, Litlib.status Conjecture]
instance 
    {State : Type*} [TopologicalSpace State]
    {Action : State → ℝ} : 
    DirectMethod State Action where
  existsGlobalMinimum := sorry

@[Litlib.difficulty intractable, Litlib.status Conjecture]
instance 
    {State : Type*}
    {Action RelaxedAction : State → ℝ}
    {isQuasiconvexEnvelope : (State → ℝ) → (State → ℝ) → Prop} : 
    RelaxationTheorem State Action RelaxedAction isQuasiconvexEnvelope where
  infPEqInfQp := sorry

end Litlib.Y2008.dacorogna2008direct.Proofs
