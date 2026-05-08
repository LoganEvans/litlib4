-- FILENAME: Litlib/Y2024/gielen2024unimodular/Proofs/Eq11.lean

import Litlib.Y2024.gielen2024unimodular.Signature
import Mathlib.Data.Matrix.Basic

open Matrix

namespace Litlib.Y2024.gielen2024unimodular.Proofs

instance verified_PureConnectionMatrixSolution : PureConnectionMatrixSolution where
  pureConnectionMatrix M Minv X hMSymm hMinvSymm hInv hEq := by
    -- In finite dimensions, a right inverse is a left inverse
    have hComm : Minv * M = 1 := hInv
    have hComm2 : M * Minv = 1 := mul_eq_one_comm.mp hInv
    
    -- X = 1 * X * 1 = (M * Minv) * X * (Minv * M)
    have hLeft : (M * Minv) * X * (Minv * M) = X := by
      rw [hComm, hComm2, Matrix.one_mul, Matrix.mul_one]
      
    -- M * (Minv * X * Minv) * M = M * 1 * M = M * M
    have hRight : M * (Minv * X * Minv) * M = M * M := by
      rw [hEq, Matrix.mul_one]
      
    -- Matrix multiplication is associative
    have hAssoc : (M * Minv) * X * (Minv * M) = M * (Minv * X * Minv) * M := by
      simp only [Matrix.mul_assoc]
      
    -- Combine to prove X = M * M
    rw [← hLeft, hAssoc, hRight]

end Litlib.Y2024.gielen2024unimodular.Proofs
