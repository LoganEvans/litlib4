-- FILENAME: Litlib/Y1983/guckenheimer1983nonlinear/Chapter01/Sec06_Asymptotic.lean

import Litlib.Core
import Mathlib.Topology.Basic
import Mathlib.Order.Filter.AtTopBot.Defs
import Mathlib.Data.Real.Basic

namespace Litlib.Y1983.guckenheimer1983nonlinear

open Filter Topology

def omega_limit_set {E : Type*} [TopologicalSpace E] (flow : ℝ → E → E) (x : E) : Set E :=
  { y | ∃ (t : ℕ → ℝ), Tendsto t atTop atTop ∧ Tendsto (fun n => flow (t n) x) atTop (nhds y) }

def basin_of_attraction {E : Type*} [TopologicalSpace E] (flow : ℝ → E → E) (A : Set E) : Set E :=
  { x | omega_limit_set flow x ⊆ A }

end Litlib.Y1983.guckenheimer1983nonlinear
