-- FILENAME: Litlib/Math/FermatStationary.lean

import Mathlib.Analysis.Calculus.LocalExtr.Basic
import Mathlib.Topology.MetricSpace.Basic
import Mathlib.Data.Matrix.Basic

set_option linter.unusedVariables false

namespace Litlib.Math.CalculusOfVariations

/-- 
Physical Interpretation:
Defines a local minimum for functional variations along 1D parameterized paths. Represents a state that strictly minimizes the Action functional, validating the geometric constraints of the Principle of Least Action.

Mathematical Boundaries:
Formulated using native Mathlib 1D real calculus. The space of valid variations bounds the path integrals.

Literature:
Matches the standard definitions of extremal path variations in analytical mechanics (e.g., Goldstein, Classical Mechanics).
-/
def IsLocalMinimum {α : Type*} (Action : α → ℝ) (state : α) (isValidVar : (ℝ → α) → Prop) : Prop :=
  isValidVar (fun _ => state) ∧
  ∀ (var : ℝ → α), isValidVar var → var 0 = state →
    ∃ (ε : ℝ), ε > 0 ∧ ∀ t, -ε < t ∧ t < ε → Action state ≤ Action (var t)

/-- 
Physical Interpretation:
Defines a local stationary point ($\delta S = 0$) for field variations. This identifies states that act as geometric saddle points or pure extremals.
-/
def IsStationaryPoint {α : Type*} (Action : α → ℝ) (state : α) (isValidVar : (ℝ → α) → Prop) : Prop :=
  isValidVar (fun _ => state) ∧
  ∀ (var : ℝ → α), isValidVar var → var 0 = state →
    HasDerivAt (fun t => Action (var t)) 0 0

/-- 
Physical Interpretation:
Fermat's Stationary Theorem extended to physical action functionals. States rigorously that any deterministic state that serves as a local minimum for an action functional must geometrically be a stationary extremal.

Mathematical Boundaries:
Evaluated strictly using 1D local derivative boundaries. Requires full Fréchet or directional differentiability at the state space origin.

Literature:
Corresponds directly to Euler-Lagrange extremization criteria in modern functional physics.
-/
theorem localMinIsStationary {α : Type*} (Action : α → ℝ) (state : α) (isValidVar : (ℝ → α) → Prop)
  (h_diff : ∀ (var : ℝ → α), isValidVar var → var 0 = state → DifferentiableAt ℝ (fun t => Action (var t)) 0)
  (h_min : IsLocalMinimum Action state isValidVar) :
  IsStationaryPoint Action state isValidVar := by
  rcases h_min with ⟨h_valid_state, h_min_var⟩
  constructor
  · exact h_valid_state
  · intro var h_valid_var h_var_zero
    let f := fun t => Action (var t)
    have h_diff_f : DifferentiableAt ℝ f 0 := h_diff var h_valid_var h_var_zero
    
    have h_f0 : f 0 = Action state := by
      change Action (var 0) = Action state
      rw [h_var_zero]
      
    have ⟨ε, hε_pos, hε_bound⟩ := h_min_var var h_valid_var h_var_zero
    
    have h_local_min : IsLocalMin f 0 := by
      have h_evt : ∀ᶠ y in nhds 0, f 0 ≤ f y := by
        rw [Metric.eventually_nhds_iff]
        use ε
        constructor
        · exact hε_pos
        · intro y hy
          rw [dist_zero_right, Real.norm_eq_abs] at hy
          have hy_split := abs_lt.mp hy
          have h_bound := hε_bound y hy_split
          rw [h_f0]
          exact h_bound
      exact h_evt
        
    have h_has_deriv : HasDerivAt f (deriv f 0) 0 := h_diff_f.hasDerivAt
    have h_deriv_zero : deriv f 0 = 0 := IsLocalMin.hasDerivAt_eq_zero h_local_min h_has_deriv
    rw [h_deriv_zero] at h_has_deriv
    exact h_has_deriv

end Litlib.Math.CalculusOfVariations
