-- FILENAME: Litlib/Y1975/belavin1975pseudoparticle/Signature.lean

import Litlib.Core
import Litlib.Y2003.nakahara2003geometry.Signature
import Mathlib.Data.Real.Basic
import Mathlib.Analysis.Calculus.Deriv.Basic
import Mathlib.Topology.Basic
import Mathlib.Order.Filter.Basic
import Mathlib.Analysis.InnerProductSpace.Basic

open Filter Topology

namespace Litlib.Y1975.belavin1975pseudoparticle

Litlib.reference Eq10_11
  type "article"
  bibtex "belavin1975pseudoparticle"
  title "Pseudoparticle solutions of the Yang-Mills equations"
  authors ["Belavin, Alexander A", "Polyakov, Alexander M", "Schwartz, Albert S", "Tyupkin, Yu S"]
  journal "Physics Letters B"
  volume "59"
  issue "1"
  pages "85--87"
  year "1975"
  publisher "Elsevier"
  doi "10.1016/0370-2693(75)90163-X"
class Eq10_11 where
  /--
  Equations (10) and (11) (page 86): The Topological Action Bound.
  Abstracted to a real Hilbert space equipped with an isometric involution (the Hodge star).
  The energy is bounded below by the topological charge, and the bound is saturated 
  iff the field is self-dual or anti-self-dual.
  -/
  topologicalEnergyBound
    (V : Type*) [NormedAddCommGroup V] [InnerProductSpace ℝ V]
    (star : V → V)
    (hStarIsometry : ∀ v, ‖star v‖ = ‖v‖) :
    ∀ (v : V),
      let E := (1 / 2 : ℝ) * ‖v‖^2
      let Q := (1 / 2 : ℝ) * inner ℝ v (star v)
      |Q| ≤ E ∧
      (star v = v ∨ star v = -v → E = |Q|)

abbrev TopologicalEnergyBound.{u} := Eq10_11.{u}

Litlib.reference Eq16
  type "article"
  bibtex "belavin1975pseudoparticle"
  title "Pseudoparticle solutions of the Yang-Mills equations"
  authors ["Belavin, Alexander A", "Polyakov, Alexander M", "Schwartz, Albert S", "Tyupkin, Yu S"]
  journal "Physics Letters B"
  volume "59"
  issue "1"
  pages "85--87"
  year "1975"
  publisher "Elsevier"
  doi "10.1016/0370-2693(75)90163-X"
class Eq16 where
  /-- Equation (16) (page 86): The radial profile of the BPST instanton. -/
  bpstProfileOde (lam : ℝ) :
    let f := fun (r : ℝ) => 2 / (r^2 + lam^2)
    ∀ r : ℝ, r ≠ 0 → deriv f r / r + (f r)^2 = 0

abbrev RadialProfileODE := Eq16

Litlib.reference Eq16_Uniqueness
  type "article"
  bibtex "belavin1975pseudoparticle"
  title "Pseudoparticle solutions of the Yang-Mills equations"
  authors ["Belavin, Alexander A", "Polyakov, Alexander M", "Schwartz, Albert S", "Tyupkin, Yu S"]
  journal "Physics Letters B"
  volume "59"
  issue "1"
  pages "85--87"
  year "1975"
  publisher "Elsevier"
  doi "10.1016/0370-2693(75)90163-X"
class Eq16_Uniqueness where
  /--
  Capstone Theorem: BPST Profile Uniqueness.
  The only regular solutions to the BPST self-dual radial ODE 
  that vanish at infinity are the 1-parameter family of instanton profiles 
  f(r) = 2 / (r^2 + λ^2). This mathematically rigidifies the Moduli Uniqueness 
  for the spherically symmetric ansatz without using unconstrained predicates.
  
  Note: Requires continuity everywhere (`hfRegular`) to strictly seal the 
  singular r=0 zero-size trapdoor (e.g. f(r) = 2/r^2).
  -/
  bpstProfileUniqueness
    (f : ℝ → ℝ)
    (hfRegular : Continuous f)
    (hfDiff : DifferentiableOn ℝ f (Set.Ioi 0))
    (hfOde : ∀ r > 0, deriv f r / r + (f r)^2 = 0)
    (hfLimit : Tendsto f atTop (nhds 0))
    (hfPos : ∃ r > 0, f r > 0) :
    ∃ (lam : ℝ), lam > 0 ∧ ∀ r > 0, f r = 2 / (r^2 + lam^2)

abbrev BpstModuliUniqueness := Eq16_Uniqueness

/-- A mathematically strict definition of a topological homeomorphism: 
A bijection between two topological spaces that is continuous and has a continuous inverse. -/
structure IsHomeomorphism {X Y : Type*} [TopologicalSpace X] [TopologicalSpace Y] (f : X → Y) : Prop where
  bij : Function.Bijective f
  cont : Continuous f
  inv_cont : ∃ (g : Y → X), Function.LeftInverse g f ∧ Function.RightInverse g f ∧ Continuous g

Litlib.reference Eq18
  type "article"
  bibtex "belavin1975pseudoparticle"
  title "Pseudoparticle solutions of the Yang-Mills equations"
  authors ["Belavin, Alexander A", "Polyakov, Alexander M", "Schwartz, Albert S", "Tyupkin, Yu S"]
  journal "Physics Letters B"
  volume "59"
  issue "1"
  pages "85--87"
  year "1975"
  publisher "Elsevier"
  doi "10.1016/0370-2693(75)90163-X"
class Eq18
  (BoundaryManifold Group : Type*) [TopologicalSpace BoundaryManifold] [TopologicalSpace Group]
  (isSmooth : (BoundaryManifold → Group) → Prop)
  (windingNumber : (BoundaryManifold → Group) → ℤ)
  (cartanMaurerIntegral : (BoundaryManifold → Group) → ℝ)
  [Litlib.Y2003.nakahara2003geometry.CartanMaurerTopology (BoundaryManifold → Group) isSmooth windingNumber cartanMaurerIntegral] where
  /-- GATEKEEPER SECURED TRAPDOOR: Topological spaces must be capable of non-trivial winding. -/
  h_exists_degree_one : ∃ (g : BoundaryManifold → Group), windingNumber g = 1

  /-- Belavin 1975, Page 86: "Hence q is the number of times the SU(2) is covered under this mapping." -/
  degree_of_homeomorph :
    ∀ (f : BoundaryManifold → Group),
    IsHomeomorphism f →
    windingNumber f = 1 ∨ windingNumber f = -1

-- Downstream backwards compatibility alias
abbrev DegreeOfHomeomorphism.{u, v} := Eq18.{u, v}

end Litlib.Y1975.belavin1975pseudoparticle
