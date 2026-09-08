-- FILENAME: Litlib/Y1975/belavin1975pseudoparticle/Signature.lean

import Litlib.Core
import Mathlib.Topology.Basic
import Litlib.Y2003.nakahara2003geometry.Chapter10.Sec05_GaugeTheories
import Mathlib.Data.Real.Basic
import Mathlib.Data.Real.Sqrt
import Mathlib.Analysis.SpecialFunctions.Trigonometric.Basic
import Mathlib.Data.Complex.Basic
import Mathlib.Data.Matrix.Basic
import Mathlib.LinearAlgebra.Matrix.Trace
import Mathlib.Algebra.BigOperators.Group.Finset.Basic
import Mathlib.Algebra.BigOperators.Ring.Finset

namespace Litlib.Y1975.belavin1975pseudoparticle

noncomputable section

open scoped BigOperators
open Finset Matrix

Litlib.paper "belavin1975pseudoparticle"
  type "article"
  title "Pseudoparticle solutions of the Yang-Mills equations"
  authors ["Belavin, A. A.", "Polyakov, A. M.", "Schwartz, A. S.", "Tyupkin, Yu. S."]
  journal "Physics Letters B"
  year "1975"

def leviCivita4 (mu nu lam gam : Fin 4) : ℝ :=
  if mu = nu ∨ mu = lam ∨ mu = gam ∨ nu = lam ∨ nu = gam ∨ lam = gam then 0
  else
    let invs : Nat := (if mu.val > nu.val then 1 else 0) +
                      (if mu.val > lam.val then 1 else 0) +
                      (if mu.val > gam.val then 1 else 0) +
                      (if nu.val > lam.val then 1 else 0) +
                      (if nu.val > gam.val then 1 else 0) +
                      (if lam.val > gam.val then 1 else 0)
    if invs % 2 = 0 then 1 else -1

def delta4 (mu nu : Fin 4) : ℝ :=
  if mu = nu then 1 else 0

def rNorm (x : Fin 4 → ℝ) : ℝ :=
  Real.sqrt (∑ i : Fin 4, (x i) * (x i))

structure IsHomeomorphism {α β : Type*} [TopologicalSpace α] [TopologicalSpace β]
    (f : α → β) : Prop where
  continuous_toFun : Continuous f
  bijective : Function.Bijective f
  continuous_invFun : Continuous (Function.surjInv bijective.2)

Litlib.equation "belavin1975pseudoparticle" eq "8" page "86" kind "theorem"
class Eq8
    (BoundaryManifold Group : Type*)
    [TopologicalSpace BoundaryManifold] [TopologicalSpace Group]
    [Nonempty BoundaryManifold] [Nonempty Group]
    (isSmooth : (BoundaryManifold → Group) → Prop)
    (windingNumber : (BoundaryManifold → Group) → ℤ)
    (cartanMaurerIntegral : (BoundaryManifold → Group) → ℝ)
    [Litlib.Y2003.nakahara2003geometry.CartanMaurerTopology
      (BoundaryManifold → Group) isSmooth windingNumber cartanMaurerIntegral] where
  h_exists_degree_one : ∃ (g : BoundaryManifold → Group), windingNumber g = 1
  degree_of_homeomorph : ∀ (f : BoundaryManifold → Group),
    IsHomeomorphism f → windingNumber f = 1 ∨ windingNumber f = -1

Litlib.equation "belavin1975pseudoparticle" eq "1" page "85" kind "definition"
class Eq1_FieldStrength (A : (Fin 4 → ℝ) → Fin 4 → Matrix (Fin 2) (Fin 2) ℂ)
    (partialA : Fin 4 → (Fin 4 → ℝ) → Fin 4 → Matrix (Fin 2) (Fin 2) ℂ)
    (F : (Fin 4 → ℝ) → Fin 4 → Fin 4 → Matrix (Fin 2) (Fin 2) ℂ) where
  field_strength_def : ∀ x mu nu,
    F x mu nu = partialA mu x nu - partialA nu x mu + (A x mu * A x nu - A x nu * A x mu)

Litlib.equation "belavin1975pseudoparticle" eq "3" page "85" kind "definition"
class Eq3_TopologicalCharge (q : ℤ)
    (F : (Fin 4 → ℝ) → Fin 4 → Fin 4 → Matrix (Fin 2) (Fin 2) ℂ)
    (integral : ((Fin 4 → ℝ) → ℝ) → ℝ) where
  topological_charge_eq :
    (q : ℝ) = (1 / ((8 : ℝ) * (Real.pi * Real.pi))) * integral (fun x ↦
      ∑ mu : Fin 4, ∑ nu : Fin 4, ∑ lam : Fin 4, ∑ gam : Fin 4,
        leviCivita4 mu nu lam gam * (Matrix.trace (F x mu nu * F x lam gam)).re)

Litlib.equation "belavin1975pseudoparticle" eq "4" page "85" kind "theorem"
class Eq4_CurrentIdentity
    (A : (Fin 4 → ℝ) → Fin 4 → Matrix (Fin 2) (Fin 2) ℂ)
    (partialA : Fin 4 → (Fin 4 → ℝ) → Fin 4 → Matrix (Fin 2) (Fin 2) ℂ)
    (F : (Fin 4 → ℝ) → Fin 4 → Fin 4 → Matrix (Fin 2) (Fin 2) ℂ)
    (J : (Fin 4 → ℝ) → Fin 4 → ℝ)
    (divJ : (Fin 4 → ℝ) → ℝ) where
  current_def : ∀ x alpha,
    J x alpha = ∑ beta : Fin 4, ∑ gam : Fin 4, ∑ delta : Fin 4,
      leviCivita4 alpha beta gam delta * (Matrix.trace (A x beta *
        (partialA gam x delta + (2 / 3 : ℂ) • (A x gam * A x delta)))).re
  divergence_identity : ∀ x,
    divJ x = ∑ mu : Fin 4, ∑ nu : Fin 4, ∑ lam : Fin 4, ∑ gam : Fin 4,
      leviCivita4 mu nu lam gam * (Matrix.trace (F x mu nu * F x lam gam)).re

def dualFieldStrength (F : (Fin 4 → ℝ) → Fin 4 → Fin 4 → Matrix (Fin 2) (Fin 2) ℂ)
    (x : Fin 4 → ℝ) (mu nu : Fin 4) : Matrix (Fin 2) (Fin 2) ℂ :=
  (1 / 2 : ℂ) • ∑ lam : Fin 4, ∑ gam : Fin 4,
    ((leviCivita4 mu nu lam gam : ℝ) : ℂ) • F x lam gam

Litlib.equation "belavin1975pseudoparticle" eq "9" page "86" kind "theorem"
class Eq9_PositiveActionSquare
    (F : (Fin 4 → ℝ) → Fin 4 → Fin 4 → Matrix (Fin 2) (Fin 2) ℂ)
    (integral : ((Fin 4 → ℝ) → ℝ) → ℝ) where
  action_nonneg : ∀ s : ℝ, s = 1 ∨ s = -1 →
    0 ≤ integral (fun x ↦
      ∑ mu : Fin 4, ∑ nu : Fin 4,
        (Matrix.trace ((F x mu nu - (s : ℂ) • dualFieldStrength F x mu nu) *
          (F x mu nu - (s : ℂ) • dualFieldStrength F x mu nu))).re)

Litlib.equation "belavin1975pseudoparticle" eq "10" page "86" kind "theorem"
class Eq10_BogomolnyBound (E : ℝ) (q : ℤ) (g2 : ℝ) (S : ℝ) where
  coupling_pos : 0 < g2
  action_energy_rel : S = E / g2
  energy_bound : (2 : ℝ) * (Real.pi * Real.pi) * (q.natAbs : ℝ) ≤ E

Litlib.equation "belavin1975pseudoparticle" eq "11" page "86" kind "definition"
class Eq11_SelfDuality
    (F : Fin 4 → Fin 4 → Matrix (Fin 2) (Fin 2) ℂ)
    (sign : ℝ) where
  sign_pm : sign = 1 ∨ sign = -1
  duality_eq : ∀ mu nu,
    F mu nu = (sign * (1 / 2) : ℂ) • ∑ lam : Fin 4, ∑ gam : Fin 4,
      ((leviCivita4 mu nu lam gam : ℝ) : ℂ) • F lam gam

def bpstGaugeField (f : ℝ → ℝ) (x : Fin 4 → ℝ) (mu alpha beta : Fin 4) : ℝ :=
  f (rNorm x) * (x alpha * delta4 mu beta - x beta * delta4 mu alpha)

Litlib.equation "belavin1975pseudoparticle" eq "14" page "86" kind "definition"
class Eq14_BPSTAnsatz (f : ℝ → ℝ)
    (A : (Fin 4 → ℝ) → Fin 4 → Fin 4 → Fin 4 → ℝ) where
  ansatz_eq : ∀ x mu alpha beta, A x mu alpha beta = bpstGaugeField f x mu alpha beta

Litlib.equation "belavin1975pseudoparticle" eq "15" page "86" kind "theorem"
class Eq15_FieldStrengthAnsatz (f f' : ℝ → ℝ)
    (F : (Fin 4 → ℝ) → Fin 4 → Fin 4 → Fin 4 → Fin 4 → ℝ) where
  field_strength_calc : ∀ x mu nu alpha beta,
    let r := rNorm x
    F x mu nu alpha beta =
      (2 * f r - (r * r) * (f r * f r)) *
        (delta4 mu alpha * delta4 nu beta - delta4 mu beta * delta4 nu alpha) +
      (f' r / r + f r * f r) *
        (x alpha * x mu * delta4 nu beta - x alpha * x nu * delta4 mu beta +
         x beta * x nu * delta4 mu alpha - x beta * x mu * delta4 nu alpha)

Litlib.equation "belavin1975pseudoparticle" eq "16" page "86" kind "theorem"
class Eq16_ProfileEquation (f f' : ℝ → ℝ) (scale : ℝ) where
  scale_pos : 0 < scale
  ode_condition : ∀ r > 0, f' r / r + f r * f r = 0
  solution_eq : ∀ r ≥ 0, f r = 2 / (r * r + scale * scale)

Litlib.equation "belavin1975pseudoparticle" eq "17" page "86" kind "theorem"
class Eq17_InstantonEnergy (E : ℝ)
    (F : (Fin 4 → ℝ) → Fin 4 → Fin 4 → Fin 4 → Fin 4 → ℝ)
    (integral : ((Fin 4 → ℝ) → ℝ) → ℝ) where
  energy_integral_def :
    E = (1 / 32) * integral (fun x ↦
      ∑ mu : Fin 4, ∑ nu : Fin 4, ∑ alpha : Fin 4, ∑ beta : Fin 4,
        (F x mu nu alpha beta) * (F x mu nu alpha beta))
  energy_saturates_bound : E = (2 : ℝ) * (Real.pi * Real.pi)

Litlib.equation "belavin1975pseudoparticle" eq "18" page "86" kind "definition"
class Eq18_SU2InstantonConnection (scale : ℝ)
    (A : (Fin 4 → ℝ) → Fin 4 → Matrix (Fin 2) (Fin 2) ℂ)
    (g : (Fin 4 → ℝ) → Matrix (Fin 2) (Fin 2) ℂ)
    (gInv : (Fin 4 → ℝ) → Matrix (Fin 2) (Fin 2) ℂ)
    (partialG : Fin 4 → (Fin 4 → ℝ) → Matrix (Fin 2) (Fin 2) ℂ) where
  scale_pos : 0 < scale
  unitary_g : ∀ x, gInv x * g x = 1
  connection_formula : ∀ x mu,
    let r := rNorm x
    A x mu = (((r * r) / (r * r + scale * scale)) : ℂ) • (gInv x * partialG mu x)

def bpstHedgehogMatrix (x : Fin 4 → ℝ) : Matrix (Fin 2) (Fin 2) ℂ :=
  fun i j ↦
    match i, j with
    | 0, 0 => (x 3 : ℂ) + Complex.I * (x 2 : ℂ)
    | 0, 1 => (x 1 : ℂ) + Complex.I * (x 0 : ℂ)
    | 1, 0 => -(x 1 : ℂ) + Complex.I * (x 0 : ℂ)
    | 1, 1 => (x 3 : ℂ) - Complex.I * (x 2 : ℂ)

def bpstGroupElement (x : Fin 4 → ℝ) : Matrix (Fin 2) (Fin 2) ℂ :=
  (1 / (rNorm x : ℂ)) • bpstHedgehogMatrix x

Litlib.equation "belavin1975pseudoparticle" eq "18_hedgehog" page "86" kind "theorem"
class Eq18_BPSTBoundaryHomeomorphism
    (BoundaryS3 SU2Group : Type*)
    [TopologicalSpace BoundaryS3] [TopologicalSpace SU2Group]
    (embedS3 : BoundaryS3 → (Fin 4 → ℝ))
    (toSU2 : Matrix (Fin 2) (Fin 2) ℂ → SU2Group) where
  embed_on_sphere : ∀ s, rNorm (embedS3 s) = 1
  hedgehog_is_homeomorphism :
    IsHomeomorphism (fun s ↦ toSU2 (bpstHedgehogMatrix (embedS3 s)))

end

end Litlib.Y1975.belavin1975pseudoparticle
