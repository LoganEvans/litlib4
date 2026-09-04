-- FILENAME: Litlib/Y2011/sakurai2011modern/Chapter01/Sec03_BaseKetsAndMatrixRepresentations.lean

import Litlib.Core
import Mathlib.Data.Complex.Basic
import Mathlib.Data.Matrix.Basic
import Litlib.Y2011.sakurai2011modern.Paper

namespace Litlib.Y2011.sakurai2011modern

open Finset Matrix

/-- Spin-up base ket |+⟩ in the Sz basis. -/
def ketPlus : Fin 2 → ℂ := ![1, 0]

/-- Spin-down base ket |-⟩ in the Sz basis. -/
def ketMinus : Fin 2 → ℂ := ![0, 1]

/-- Matrix representation of Sz in the standard basis. -/
noncomputable def sz (hbar : ℝ) : Matrix (Fin 2) (Fin 2) ℂ :=
  ![![(hbar / 2 : ℂ), 0], ![0, -(hbar / 2 : ℂ)]]

/-- Matrix representation of S+ ladder operator in the standard basis. -/
def splus (hbar : ℝ) : Matrix (Fin 2) (Fin 2) ℂ :=
  ![![0, (hbar : ℂ)], ![0, 0]]

/-- Matrix representation of S- ladder operator in the standard basis. -/
def sminus (hbar : ℝ) : Matrix (Fin 2) (Fin 2) ℂ :=
  ![![0, 0], ![(hbar : ℂ), 0]]

Litlib.equation "sakurai2011modern"
  eq "1.3.6"
  page "18"
  kind "definition"
/--
Physical Interpretation: Orthonormality relation for eigenkets: ⟨a'' | a'⟩ = δ_{a'' a'}.
Mathematical Boundaries: A set of N orthonormal vectors in a D-dimensional Hilbert space.
-/
class Eq1_3_6 (D N : ℕ)
    (basis : Fin N → (Fin D → ℂ)) where
  orthonormal : ∀ (i j : Fin N),
    (∑ k : Fin D, star (basis i k) * basis j k) = if i = j then 1 else 0

Litlib.equation "sakurai2011modern"
  eq "1.3.11"
  page "19"
  kind "theorem"
/--
Physical Interpretation: Completeness (closure) relation for an orthonormal basis:
∑_{a'} |a'⟩⟨a'| = 1.
Mathematical Boundaries: Sum of outer products forms the identity operator on C^D.
-/
class Eq1_3_11 (D : ℕ)
    (basis : Fin D → (Fin D → ℂ)) where
  completeness : ∀ (i j : Fin D),
    (∑ k : Fin D, basis k i * star (basis k j)) = if i = j then 1 else 0

Litlib.equation "sakurai2011modern"
  eq "1.3.36"
  page "22"
  kind "definition"
/--
Physical Interpretation: Spin-1/2 Sz operator spectral decomposition into spin-up and spin-down
projection operators.
Mathematical Boundaries: Reduced Planck's constant hbar > 0; kets form an orthonormal basis of C².
-/
class Eq1_3_36 (hbar : ℝ)
    (Sz : Matrix (Fin 2) (Fin 2) ℂ)
    (plus minus : Fin 2 → ℂ) where
  hbar_pos : 0 < hbar
  plus_norm : (∑ k, star (plus k) * plus k) = 1
  minus_norm : (∑ k, star (minus k) * minus k) = 1
  orthogonal : (∑ k, star (plus k) * minus k) = 0
  sz_spectral_decomp : ∀ (i j : Fin 2),
    Sz i j = (hbar / 2 : ℂ) * (plus i * star (plus j) - minus i * star (minus j))

Litlib.equation "sakurai2011modern"
  eq "1.3.39"
  page "23"
  kind "definition"
/--
Physical Interpretation: Matrix representation of basis kets and spin-1/2 operators Sz, S+,
and S- in the standard Sz basis.
Mathematical Boundaries: hbar is strictly positive.
-/
class Eq1_3_39 (hbar : ℝ)
    (Sz SPlus SMinus : Matrix (Fin 2) (Fin 2) ℂ) where
  hbar_pos : 0 < hbar
  sz_matrix : Sz = sz hbar
  splus_matrix : SPlus = splus hbar
  sminus_matrix : SMinus = sminus hbar

end Litlib.Y2011.sakurai2011modern
