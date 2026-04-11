-- FILENAME: Litlib/Y2024/gielen2024unimodular/Proofs/Sorry.lean

import Litlib.Y2024.gielen2024unimodular.Signature

namespace Litlib.Y2024.gielen2024unimodular.Proofs

-- By reducing this from abstract differential forms to components over finite types, 
-- Lean can evaluate this purely through brute-force finite expansion and `ring`.
@[litlib_difficulty easy, litlib_status Conjecture]
instance : Eq3 where
  plebanski_tetrad_reconstruction := sorry

-- This is a pure finite sum algebra evaluation exploiting symmetric 
-- and antisymmetric properties of the given tensors.
@[litlib_difficulty easy, litlib_status Conjecture]
instance : Eq7 where
  bianchi_trace_identity := sorry

-- A trivial consequence of matrix multiplication and symmetry rules.
@[litlib_difficulty easy, litlib_status Conjecture]
instance : Eq11 where
  pure_connection_matrix := sorry

end Litlib.Y2024.gielen2024unimodular.Proofs
