-- FILENAME: Litlib/Y2024/gielen2024unimodular/Proofs/Eq11.lean

import Litlib.Y2024.gielen2024unimodular.Signature
import Mathlib.Data.Matrix.Basic

open Matrix

namespace Litlib.Y2024.gielen2024unimodular.Proofs

@[litlib_difficulty easy, litlib_status Verified]
instance verified_Eq11 : Eq11 where
  pure_connection_matrix M Minv X hM_symm hMinv_symm h_inv h_eq := by
    -- In finite dimensions, a right inverse is a left inverse
    have h_comm : Minv * M = 1 := h_inv
    have h_comm2 : M * Minv = 1 := mul_eq_one_comm.mp h_inv
    
    -- X = 1 * X * 1 = (M * Minv) * X * (Minv * M)
    have h_left : (M * Minv) * X * (Minv * M) = X := by
      rw [h_comm, h_comm2, Matrix.one_mul, Matrix.mul_one]
      
    -- M * (Minv * X * Minv) * M = M * 1 * M = M * M
    have h_right : M * (Minv * X * Minv) * M = M * M := by
      rw [h_eq, Matrix.mul_one]
      
    -- Matrix multiplication is associative
    have h_assoc : (M * Minv) * X * (Minv * M) = M * (Minv * X * Minv) * M := by
      simp only [Matrix.mul_assoc]
      
    -- Combine to prove X = M * M
    rw [← h_left, h_assoc, h_right]

end Litlib.Y2024.gielen2024unimodular.Proofs
