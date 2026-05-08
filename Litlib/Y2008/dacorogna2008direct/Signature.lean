-- FILENAME: Litlib/Y2008/dacorogna2008direct/Signature.lean

import Litlib.Core
import Mathlib.Data.Real.Basic
import Mathlib.Data.Matrix.Basic
import Mathlib.Analysis.Convex.Basic
import Mathlib.Analysis.Normed.Module.Basic
import Mathlib.Analysis.SpecialFunctions.Pow.Real
import Mathlib.MeasureTheory.Integral.Bochner.Basic

namespace Litlib.Y2008.dacorogna2008direct

Litlib.paper "dacorogna2008direct"
  type "book"
  title "Direct methods in the calculus of variations"
  authors ["Dacorogna, Bernard"]
  year "2008"
  publisher "Springer"
  doi "10.1007/978-0-387-55249-1"

Litlib.equation "dacorogna2008direct"
  eq "Theorem 1.4"
  page "6"
  kind "Theorem"
class ExistenceMinimizerConvex 
    {n N : ℕ}
    (Ω : Type*) [MeasureTheory.MeasureSpace Ω]
    (X : Type*)
    (val : X → Ω → (Fin N → ℝ))
    (grad : X → Ω → Matrix (Fin N) (Fin n) ℝ)
    (f : Ω → (Fin N → ℝ) → Matrix (Fin N) (Fin n) ℝ → ℝ)
    [Norm (Matrix (Fin N) (Fin n) ℝ)]
    where
  f_coercive :
    ∃ (α₁ : ℝ) (α₂ : ℝ) (p : ℝ), α₁ > 0 ∧ p > 1 ∧
      ∀ x u ξ, α₁ * (‖ξ‖ ^ p) - α₂ ≤ f x u ξ
  f_convex_in_grad :
    ∀ x u, ConvexOn ℝ Set.univ (f x u)
  action_finite :
    ∃ (u₀ : X), MeasureTheory.Integrable (fun x => f x (val u₀ x) (grad u₀ x))
  exists_minimizer :
    ∃ (u_min : X), 
      MeasureTheory.Integrable (fun x => f x (val u_min x) (grad u_min x)) ∧
      ∀ (u : X), 
        MeasureTheory.Integrable (fun x => f x (val u x) (grad u x)) →
        ∫ x, f x (val u_min x) (grad u_min x) ∂MeasureTheory.volume ≤ 
        ∫ x, f x (val u x) (grad u x) ∂MeasureTheory.volume

Litlib.equation "dacorogna2008direct"
  eq "Theorem 1.7"
  page "10"
  kind "Theorem"
class ConvexityHierarchy 
    {N n : ℕ}
    (isPolyconvex isQuasiconvex isRankOneConvex : (Matrix (Fin N) (Fin n) ℝ → ℝ) → Prop) 
    where
  is_rank_one_convex_iff :
    ∀ f, isRankOneConvex f ↔
      ∀ (ξ η : Matrix (Fin N) (Fin n) ℝ) (t : ℝ),
        t ∈ Set.Icc (0 : ℝ) 1 →
        (∃ (a : Fin N → ℝ) (b : Fin n → ℝ), ξ - η = fun i j => a i * b j) →
        f (t • ξ + (1 - t) • η) ≤ t * f ξ + (1 - t) * f η
  hierarchy :
    ∀ (f : Matrix (Fin N) (Fin n) ℝ → ℝ),
      (ConvexOn ℝ Set.univ f → isPolyconvex f) ∧
      (isPolyconvex f → isQuasiconvex f) ∧
      (isQuasiconvex f → isRankOneConvex f)

Litlib.equation "dacorogna2008direct"
  eq "Theorem 1.16"
  page "18"
  kind "Theorem"
class RelaxationTheorem 
    {N n : ℕ}
    (Ω : Type*) [MeasureTheory.MeasureSpace Ω]
    (X : Type*)
    (grad : X → Ω → Matrix (Fin N) (Fin n) ℝ)
    (f Qf : Matrix (Fin N) (Fin n) ℝ → ℝ)
    (isQuasiconvex : (Matrix (Fin N) (Fin n) ℝ → ℝ) → Prop)
    where
  f_nonneg : ∀ ξ, 0 ≤ f ξ
  integrable_f : ∀ (u : X), MeasureTheory.Integrable (fun x => f (grad u x))
  integrable_Qf : ∀ (u : X), MeasureTheory.Integrable (fun x => Qf (grad u x))
  qf_is_envelope :
    ∀ ξ, IsLUB { y | ∃ g, (∀ x, g x ≤ f x) ∧ isQuasiconvex g ∧ y = g ξ } (Qf ξ)
  inf_eq :
    sInf (Set.range (fun u => ∫ x, f (grad u x) ∂MeasureTheory.volume)) = 
    sInf (Set.range (fun u => ∫ x, Qf (grad u x) ∂MeasureTheory.volume))

end Litlib.Y2008.dacorogna2008direct
