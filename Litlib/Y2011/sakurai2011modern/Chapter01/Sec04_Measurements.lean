-- FILENAME: Litlib/Y2011/sakurai2011modern/Chapter01/Sec04_Measurements.lean

import Litlib.Core
import Mathlib.Data.Complex.Basic
import Mathlib.Data.Matrix.Basic
import Mathlib.Data.Real.Sqrt
import Litlib.Y2011.sakurai2011modern.Paper

namespace Litlib.Y2011.sakurai2011modern

open Finset Matrix

/-- Levi-Civita permutation symbol in 3 dimensions returning ℤ. -/
def leviCivita (i j k : Fin 3) : ℤ :=
  if i = 0 ∧ j = 1 ∧ k = 2 then 1
  else if i = 1 ∧ j = 2 ∧ k = 0 then 1
  else if i = 2 ∧ j = 0 ∧ k = 1 then 1
  else if i = 2 ∧ j = 1 ∧ k = 0 then -1
  else if i = 0 ∧ j = 2 ∧ k = 1 then -1
  else if i = 1 ∧ j = 0 ∧ k = 2 then -1
  else 0

/-- Eigenket |Sx; +⟩ in the Sz basis. -/
noncomputable def ketSxPlus : Fin 2 → ℂ :=
  ![(1 / Real.sqrt 2 : ℂ), (1 / Real.sqrt 2 : ℂ)]

/-- Eigenket |Sx; -⟩ in the Sz basis. -/
noncomputable def ketSxMinus : Fin 2 → ℂ :=
  ![(1 / Real.sqrt 2 : ℂ), (-1 / Real.sqrt 2 : ℂ)]

/-- Eigenket |Sy; +⟩ in the Sz basis. -/
noncomputable def ketSyPlus : Fin 2 → ℂ :=
  ![(1 / Real.sqrt 2 : ℂ), (Complex.I / Real.sqrt 2)]

/-- Eigenket |Sy; -⟩ in the Sz basis. -/
noncomputable def ketSyMinus : Fin 2 → ℂ :=
  ![(1 / Real.sqrt 2 : ℂ), (-Complex.I / Real.sqrt 2)]

/-- Spin-1/2 observable Sx in the Sz basis. -/
noncomputable def sx (hbar : ℝ) : Matrix (Fin 2) (Fin 2) ℂ :=
  ![![0, (hbar / 2 : ℂ)], ![(hbar / 2 : ℂ), 0]]

/-- Spin-1/2 observable Sy in the Sz basis. -/
noncomputable def sy (hbar : ℝ) : Matrix (Fin 2) (Fin 2) ℂ :=
  ![![0, -Complex.I * (hbar / 2 : ℂ)], ![Complex.I * (hbar / 2 : ℂ), 0]]

Litlib.equation "sakurai2011modern"
  eq "1.4.4"
  page "24"
  kind "definition"
/--
Physical Interpretation: Measurement probability postulate (Born rule). The probability of
a system in state |α⟩ being found in eigenstate |a'⟩ is P(a') = |⟨a'|α⟩|².
Mathematical Boundaries: State vector α and eigenket a are normalized to unit length.
-/
class Eq1_4_4 (N : ℕ)
    (prob : (Fin N → ℂ) → (Fin N → ℂ) → ℝ) where
  prob_born_rule : ∀ (a α : Fin N → ℂ),
    (∑ i, star (α i) * α i) = 1 →
    (∑ i, star (a i) * a i) = 1 →
    prob a α = Complex.normSq (∑ i, star (a i) * α i)

Litlib.equation "sakurai2011modern"
  eq "1.4.5"
  page "24"
  kind "definition"
/--
Physical Interpretation: Expectation value of an observable operator A with respect to state |α⟩:
⟨A⟩ = ⟨α|A|α⟩.
Mathematical Boundaries: State vector α must be normalized to unit length; A is Hermitian.
-/
class Eq1_4_5 (N : ℕ)
    (expectation : Matrix (Fin N) (Fin N) ℂ → (Fin N → ℂ) → ℝ) where
  expectation_def : ∀ (A : Matrix (Fin N) (Fin N) ℂ) (α : Fin N → ℂ),
    (∀ i j, A i j = star (A j i)) →
    (∑ i, star (α i) * α i) = 1 →
    expectation A α = Complex.re (∑ i, ∑ j, star (α i) * A i j * α j)

Litlib.equation "sakurai2011modern"
  eq "1.4.17"
  page "27"
  kind "definition"
/--
Physical Interpretation: Normalized eigenkets of Sx and Sy expanded in the standard Sz basis.
Mathematical Boundaries: Distinct orthonormal pairs in C².
-/
class Eq1_4_17
    (plusX minusX plusY minusY : Fin 2 → ℂ) where
  plusX_eq : plusX = ketSxPlus
  minusX_eq : minusX = ketSxMinus
  plusY_eq : plusY = ketSyPlus
  minusY_eq : minusY = ketSyMinus

Litlib.equation "sakurai2011modern"
  eq "1.4.18"
  page "27"
  kind "definition"
/--
Physical Interpretation: Spin-1/2 operators Sx and Sy in the standard Sz basis.
Mathematical Boundaries: Reduced Planck's constant hbar is strictly positive.
-/
class Eq1_4_18 (hbar : ℝ)
    (Sx Sy : Matrix (Fin 2) (Fin 2) ℂ) where
  hbar_pos : 0 < hbar
  sx_matrix : Sx = sx hbar
  sy_matrix : Sy = sy hbar

Litlib.equation "sakurai2011modern"
  eq "1.4.20"
  page "28"
  kind "theorem"
/--
Physical Interpretation: Commutation relations for the spin-1/2 components:
[Si, Sj] = i ℏ ∑_k ε_ijk Sk.
Mathematical Boundaries: Operators act on C²; indices run over Fin 3 = {x, y, z}.
-/
class Eq1_4_20 (hbar : ℝ)
    (S : Fin 3 → Matrix (Fin 2) (Fin 2) ℂ) where
  hbar_pos : 0 < hbar
  spin_commutation : ∀ (i j : Fin 3),
    S i * S j - S j * S i =
      (Complex.I * (hbar : ℂ)) • (∑ k : Fin 3, ((leviCivita i j k : ℂ) • S k))

Litlib.equation "sakurai2011modern"
  eq "1.4.21"
  page "28"
  kind "theorem"
/--
Physical Interpretation: Anticommutation relations for spin-1/2 components:
{Si, Sj} = (1/2) ℏ² δ_ij 1.
Mathematical Boundaries: Specific to spin-1/2 systems with Clifford algebra structure.
-/
class Eq1_4_21 (hbar : ℝ)
    (S : Fin 3 → Matrix (Fin 2) (Fin 2) ℂ) where
  hbar_pos : 0 < hbar
  spin_anticommutation : ∀ (i j : Fin 3),
    S i * S j + S j * S i =
      ((1 / 2 : ℝ) * hbar ^ 2 * (if i = j then 1 else 0) : ℂ) • (1 : Matrix (Fin 2) (Fin 2) ℂ)

Litlib.equation "sakurai2011modern"
  eq "1.4.53"
  page "34"
  kind "theorem"
/--
Physical Interpretation: Generalized Robertson-Schrödinger uncertainty relation:
⟨(ΔA)²⟩ ⟨(ΔB)²⟩ ≥ (1/4) |⟨[A, B]⟩|².
Mathematical Boundaries: Universally holds for all Hermitian observables A, B and all normalized kets.
-/
class Eq1_4_53 (N : ℕ) where
  uncertainty_relation : ∀ (A B : Matrix (Fin N) (Fin N) ℂ) (α : Fin N → ℂ),
    (∀ i j, A i j = star (A j i)) →
    (∀ i j, B i j = star (B j i)) →
    (∑ i, star (α i) * α i) = 1 →
    let expA := Complex.re (∑ i, ∑ j, star (α i) * A i j * α j)
    let expB := Complex.re (∑ i, ∑ j, star (α i) * B i j * α j)
    let expA2 := Complex.re (∑ i, ∑ j, star (α i) * (A * A) i j * α j)
    let expB2 := Complex.re (∑ i, ∑ j, star (α i) * (B * B) i j * α j)
    let varA := expA2 - expA ^ 2
    let varB := expB2 - expB ^ 2
    let commExp := ∑ i, ∑ j, star (α i) * (A * B - B * A) i j * α j
    varA * varB ≥ (1 / 4 : ℝ) * Complex.normSq commExp

end Litlib.Y2011.sakurai2011modern
