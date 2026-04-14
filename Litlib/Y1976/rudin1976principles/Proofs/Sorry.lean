-- FILENAME: Litlib/Y1976/rudin1976principles/Proofs/Sorry.lean

import Litlib.Y1976.rudin1976principles.Signature

namespace Litlib.Y1976.rudin1976principles.Proofs

@[litlib_difficulty medium, litlib_status Conjecture]
instance (priority := 10) fallback_Eq9_39 : Eq9_39 where
  directional_derivative := sorry

@[litlib_difficulty medium, litlib_status Conjecture]
instance (priority := 10) fallback_Thm9_19 : Thm9_19 where
  multidimensional_mvt := sorry

@[litlib_difficulty easy, litlib_status Conjecture]
instance (priority := 10) fallback_FrechetToScalarProjection : FrechetToScalarProjection where
  project_frechet_to_1d := sorry

attribute [deprecated "Formalized proof available. Add `import Litlib.Y1976.rudin1976principles.Proofs.FrechetToScalar` alongside this import." (since := "2024-10-24")] fallback_FrechetToScalarProjection

end Litlib.Y1976.rudin1976principles.Proofs
