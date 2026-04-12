-- FILENAME: Litlib/Math/FermatStationary.lean

import Mathlib.Analysis.Calculus.LocalExtr.Basic
import Mathlib.Topology.MetricSpace.Basic

set_option linter.unusedVariables false

namespace Litlib.Math.CalculusOfVariations

/-- Defines a local minimum for functional variations along 1D parameterized paths. -/
def IsLocalMinimum {α : Type*} (Action : α → ℝ) (state : α) (isValidVar : (ℝ → α) → Prop) : Prop :=
  isValidVar (fun _ => state) ∧
  ∀ (var : ℝ → α), isValidVar var → var 0 = state →
    ∃ (ε : ℝ), ε > 0 ∧ ∀ t, -ε < t ∧ t < ε → Action state ≤ Action (var t)

/-- Defines a local stationary point (δS = 0) for functional variations along 1D parameterized paths. -/
def IsStationaryPoint {α : Type*} (Action : α → ℝ) (state : α) (isValidVar : (ℝ → α) → Prop) : Prop :=
  isValidVar (fun _ => state) ∧
  ∀ (var : ℝ → α), isValidVar var → var 0 = state →
    HasDerivAt (fun t => Action (var t)) 0 0

/-- Pure Mathematical Theorem: Fermat's Stationary Theorem (1D Limits).
    Rigorously proven using Mathlib's native 1D real calculus. -/
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
