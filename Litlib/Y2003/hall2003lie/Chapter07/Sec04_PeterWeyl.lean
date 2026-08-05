-- FILENAME: Litlib/Y2003/hall2003lie/Chapter07/Sec04_PeterWeyl.lean

import Litlib.Core
import Litlib.Y2003.hall2003lie.Paper
import Mathlib.Analysis.SpecialFunctions.Complex.Analytic
import Mathlib.MeasureTheory.Integral.Bochner.Basic
import Mathlib.Data.Matrix.Basic
import Mathlib.Topology.Instances.Complex
import Mathlib.Topology.Algebra.Group.Basic
import Mathlib.MeasureTheory.Group.Measure
import Mathlib.MeasureTheory.Measure.ProbabilityMeasure
import Mathlib.Algebra.Module.Submodule.Basic

namespace Litlib.Y2003.hall2003lie

open MeasureTheory MeasureTheory.Measure

def IsUnitaryRep {G n : Type*} [Group G] [Fintype n] [DecidableEq n] (R : G →* Matrix n n ℂ) : Prop :=
  ∀ g : G, star (R g) * R g = 1

def IsIrreducibleMatrixRep {G n : Type*} [Group G] [Fintype n] [DecidableEq n] (R : G →* Matrix n n ℂ) : Prop :=
  ∀ (W : Submodule ℂ (n → ℂ)),
    (∀ (g : G) (w : n → ℂ), w ∈ W → Matrix.mulVec (R g) w ∈ W) →
    (W = ⊥ ∨ W = ⊤)

Litlib.equation "hall2003lie" eq "Orthogonality" page "210" kind "theorem"
class MatrixElementOrthogonality (G : Type*)
  [Group G] [TopologicalSpace G] [ContinuousMul G] [ContinuousInv G] 
  [CompactSpace G] [T2Space G]
  [MeasurableSpace G] [BorelSpace G]
  (mu : Measure G) [IsHaarMeasure mu] [IsProbabilityMeasure mu]
  (n : Type*) [Fintype n] [Nonempty n] [DecidableEq n]
  (R : G →* Matrix n n ℂ)
  (R_cont : Continuous R)
  (is_unitary : IsUnitaryRep R)
  (is_irreducible : IsIrreducibleMatrixRep R)
  where
  orthogonality :
    ∀ i j k l : n,
    ∫ g : G, (R g i j) * star (R g k l) ∂mu =
    if i = k ∧ j = l then (1 : ℂ) / (Fintype.card n : ℂ) else 0

end Litlib.Y2003.hall2003lie
