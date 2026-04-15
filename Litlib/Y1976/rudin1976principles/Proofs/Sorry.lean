-- FILENAME: Litlib/Y1976/rudin1976principles/Proofs/Sorry.lean

import Litlib.Y1976.rudin1976principles.Signature

namespace Litlib.Y1976.rudin1976principles.Proofs

@[Litlib.difficulty medium, Litlib.status Conjecture]
instance (priority := 10) fallback_Eq9_39 : Eq9_39 where
  directionalDerivative := sorry

@[Litlib.difficulty medium, Litlib.status Conjecture]
instance (priority := 10) fallback_Thm9_19 : Thm9_19 where
  multidimensionalMvt := sorry

@[Litlib.difficulty easy, Litlib.status Conjecture]
instance (priority := 10) fallback_FrechetToScalarProjection : FrechetToScalarProjection where
  projectFrechetTo1d := sorry

attribute [deprecated "Formalized proof available. Add `import Litlib.Y1976.rudin1976principles.Proofs.FrechetToScalar` alongside this import." (since := "2024-10-24")] fallback_FrechetToScalarProjection

end Litlib.Y1976.rudin1976principles.Proofs
