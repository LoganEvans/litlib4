-- FILENAME: Litlib/Y1991/capovilla1991pure/Signature.lean

import Litlib.Core
import Mathlib.Data.Matrix.Basic
import Mathlib.Data.Complex.Basic

open BigOperators

namespace Litlib.Y1991.capovilla1991pure

-- Helper functions to completely bypass Mathlib's `∑` macro parser traps
def sumFin4 (f : Fin 4 → ℂ) : ℂ := Finset.sum Finset.univ f
def sumFin2 (f : Fin 2 → ℂ) : ℂ := Finset.sum Finset.univ f

Litlib.paper "capovilla1991pure"
  type "article"
  title "A pure spin-connection formulation of gravity"
  authors ["Capovilla, Riccardo", "Dell, John", "Jacobson, Ted"]
  journal "Classical and Quantum Gravity"
  volume "8"
  issue "1"
  pages "59--73"
  year "1991"
  doi "10.1088/0264-9381/8/1/01"

Litlib.equation "capovilla1991pure"
  eq "2.22"
  page "64"
  kind "Definition"
class Eq2_22 
    (Spacetime : Type*)
    (g : Spacetime → Fin 4 → Fin 4 → ℂ)
    (eta : Spacetime → ℂ)
    (R : Spacetime → Fin 4 → Fin 4 → Fin 2 → Fin 2 → ℂ)
    (epsilon4 : Fin 4 → Fin 4 → Fin 4 → Fin 4 → ℂ) where
  eq2_22_iff : ∀ x μ ν, g x μ ν = 
    (1 / 3 : ℂ) * eta x * 
    sumFin4 fun α => sumFin4 fun β => sumFin4 fun γ => sumFin4 fun δ =>
      sumFin2 fun A => sumFin2 fun B => sumFin2 fun C =>
        epsilon4 α β γ δ * R x μ α A B * R x β γ B C * R x δ ν C A

Litlib.equation "capovilla1991pure"
  eq "2.2c"
  page "61"
  kind "Equation of Motion"
class Eq2_2c 
    (Spacetime : Type*)
    (R : Spacetime → Fin 4 → Fin 4 → Fin 2 → Fin 2 → ℂ)
    (Psi : Spacetime → Fin 2 → Fin 2 → Fin 2 → Fin 2 → ℂ)
    (Sigma : Spacetime → Fin 4 → Fin 4 → Fin 2 → Fin 2 → ℂ) where
  -- Psi is a totally symmetric Lagrange multiplier field. 
  -- These three adjacent transpositions generate the full symmetric group S4.
  hPsiSymm : ∀ x A B C D, 
    Psi x A B C D = Psi x B A C D ∧ 
    Psi x A B C D = Psi x A C B D ∧ 
    Psi x A B C D = Psi x A B D C
  eq2_2c_iff : ∀ x μ ν A B, R x μ ν A B = 
    sumFin2 fun C => sumFin2 fun D => 
      Psi x A B C D * Sigma x μ ν C D

end Litlib.Y1991.capovilla1991pure
