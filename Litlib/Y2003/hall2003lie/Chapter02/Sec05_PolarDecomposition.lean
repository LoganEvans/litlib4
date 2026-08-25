-- FILENAME: Litlib/Y2003/hall2003lie/Chapter02/Sec05_PolarDecomposition.lean


import Litlib.Core
import Litlib.Y2003.hall2003lie.Paper
import Mathlib.Topology.ContinuousMap.Basic
import Mathlib.Analysis.InnerProductSpace.PiL2
import Mathlib.Topology.Algebra.Group.Basic
import Mathlib.Data.Matrix.Basic
import Mathlib.Data.Complex.Basic
import Mathlib.LinearAlgebra.Matrix.SpecialLinearGroup
import Mathlib.Topology.MetricSpace.Basic

namespace Litlib.Y2003.hall2003lie

abbrev Sphere3 := Metric.sphere (0 : EuclideanSpace ℝ (Fin 4)) (1 : ℝ)

def is_SU {n : Type*} [Fintype n] [DecidableEq n] (A : Matrix.SpecialLinearGroup n ℂ) : Prop :=
  star (A : Matrix n n ℂ) * (A : Matrix n n ℂ) = 1

Litlib.equation "hall2003lie" eq "PolarDecomposition" page "42" kind "theorem"
class PolarDecompositionRetraction
  (n : Type*) [Fintype n] [DecidableEq n] [TopologicalSpace (Matrix.SpecialLinearGroup n ℂ)]
  (degreeSU : ContinuousMap Sphere3 { A : Matrix.SpecialLinearGroup n ℂ // is_SU A } → ℤ)
  (degreeSL : ContinuousMap Sphere3 (Matrix.SpecialLinearGroup n ℂ) → ℤ)
  where
  H : ℝ → Matrix.SpecialLinearGroup n ℂ → Matrix.SpecialLinearGroup n ℂ
  H_continuous : Continuous (fun (p : ℝ × Matrix.SpecialLinearGroup n ℂ) ↦ H p.1 p.2)
  H_one : ∀ g, H 1 g = g
  H_zero : ∀ g, is_SU (H 0 g)
  H_id : ∀ (t : ℝ) (m : Matrix.SpecialLinearGroup n ℂ), is_SU m → H t m = m
  degree_preserved : ∀ (f : ContinuousMap Sphere3 { A : Matrix.SpecialLinearGroup n ℂ // is_SU A })
    (f' : ContinuousMap Sphere3 (Matrix.SpecialLinearGroup n ℂ)),
    (∀ x, f' x = (f x).val) → degreeSU f = degreeSL f'

end Litlib.Y2003.hall2003lie
