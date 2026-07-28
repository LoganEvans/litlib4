-- FILENAME: Litlib/Y1984/atiyah1984moment/Signature.lean

import Litlib.Core
import Mathlib.Algebra.Module.Basic
import Mathlib.Algebra.Algebra.Basic
import Mathlib.RingTheory.Localization.Basic
import Mathlib.Topology.Basic
import Mathlib.Data.Complex.Basic
import Mathlib.Data.Fintype.Basic

open Finset

namespace Litlib.Y1984.atiyah1984moment

Litlib.paper "atiyah1984moment"
  type "article"
  title "The moment map and equivariant cohomology"
  authors ["Atiyah, M. F.", "Bott, R."]
  journal "Topology"
  year "1984"

Litlib.equation "atiyah1984moment" eq "3.5" page "8" kind "theorem"
class Theorem3_5
  (HT_pt : Type*) [CommRing HT_pt]
  (HT_M : Type*) [CommRing HT_M] [Algebra HT_pt HT_M]
  (HT_F : Type*) [CommRing HT_F] [Algebra HT_pt HT_F]
  (i_star : HT_M →ₐ[HT_pt] HT_F)
  (vanishes_on_proper_isotropy : HT_pt → Prop)
  where
  kernel_annihilated : ∀ (f : HT_pt) (x : HT_M),
    vanishes_on_proper_isotropy f → i_star x = 0 → ∃ (N : ℕ), f^N • x = 0
  cokernel_annihilated : ∀ (f : HT_pt) (y : HT_F),
    vanishes_on_proper_isotropy f → ∃ (N : ℕ) (x : HT_M), f^N • y = i_star x

Litlib.equation "atiyah1984moment" eq "3.6" page "8" kind "corollary"
class Corollary3_6
  (HT_pt : Type*) [CommRing HT_pt] [IsDomain HT_pt]
  (HT_M : Type*) [CommRing HT_M] [Algebra HT_pt HT_M]
  (H_F : Type*) [AddCommGroup H_F] [Module ℂ H_F]
  (rank_HT_M : ℕ)
  (dim_H_F : ℕ)
  where
  rank_eq_dim : rank_HT_M = dim_H_F

Litlib.equation "atiyah1984moment" eq "3.8" page "9" kind "theorem"
class Eq3_8
  (Components : Type*) [Fintype Components]
  (HT_pt : Type*) [CommRing HT_pt]
  (HT_M : Type*) [CommRing HT_M] [Algebra HT_pt HT_M]
  (HT_P : Components → Type*)
  [∀ P, CommRing (HT_P P)]
  [∀ P, Algebra HT_pt (HT_P P)]
  (pi_M_star : HT_M →ₗ[HT_pt] HT_pt)
  (pi_P_star : ∀ P, HT_P P →ₗ[HT_pt] HT_pt)
  (i_P_star : ∀ P, HT_M →ₐ[HT_pt] HT_P P)
  (E : ∀ P, HT_P P)
  (HT_pt_loc : Type*) [CommRing HT_pt_loc] [Algebra HT_pt HT_pt_loc]
  (HT_M_loc : Type*) [CommRing HT_M_loc] [Algebra HT_pt_loc HT_M_loc]
  (HT_P_loc : Components → Type*)
  [∀ P, CommRing (HT_P_loc P)]
  [∀ P, Algebra HT_pt_loc (HT_P_loc P)]
  [∀ P, Algebra (HT_P P) (HT_P_loc P)]
  (pi_M_star_loc : HT_M_loc →ₗ[HT_pt_loc] HT_pt_loc)
  (pi_P_star_loc : ∀ P, HT_P_loc P →ₗ[HT_pt_loc] HT_pt_loc)
  (i_P_star_loc : ∀ P, HT_M_loc →ₐ[HT_pt_loc] HT_P_loc P)
  (E_inv : ∀ P, HT_P_loc P)
  where
  E_is_inv : ∀ P, (algebraMap (HT_P P) (HT_P_loc P) (E P)) * E_inv P = 1
  integration_formula : ∀ (phi : HT_M_loc),
    pi_M_star_loc phi = ∑ P : Components, pi_P_star_loc P (i_P_star_loc P phi * E_inv P)

end Litlib.Y1984.atiyah1984moment
