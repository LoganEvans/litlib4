-- FILENAME: Litlib/Y1975/belavin1975pseudoparticle/Signature.lean

import Litlib.Core
import Mathlib.Data.Complex.Basic
import Mathlib.Data.Real.Basic
import Mathlib.Data.Matrix.Basic
import Mathlib.Analysis.SpecialFunctions.Trigonometric.Basic

namespace Litlib.Y1975.belavin1975pseudoparticle

abbrev SpacetimePoint := Fin 4 → ℝ
abbrev SU2_Algebra := Matrix (Fin 2) (Fin 2) ℂ
abbrev GaugeField := SpacetimePoint → Fin 4 → SU2_Algebra
abbrev FieldStrength := SpacetimePoint → Fin 4 → Fin 4 → SU2_Algebra

opaque field_strength (A : GaugeField) : FieldStrength
opaque topological_charge (F : FieldStrength) : ℤ
opaque action_energy (F : FieldStrength) : ℝ

literature_axiom Eq11_SelfDuality
  bibtex_key "belavin1975pseudoparticle"
  doi "10.1016/0370-2693(75)90163-X"
  authors ["Belavin, A.A.", "Polyakov, A.M.", "Schwartz, A.S.", "Tyupkin, Yu.S."]
  status Standard
class Eq11_SelfDuality where
  is_self_dual (F : FieldStrength) : Prop
  is_anti_self_dual (F : FieldStrength) : Prop

literature_axiom Eq10_ActionBound
  bibtex_key "belavin1975pseudoparticle"
  doi "10.1016/0370-2693(75)90163-X"
  authors ["Belavin, A.A.", "Polyakov, A.M.", "Schwartz, A.S.", "Tyupkin, Yu.S."]
  status Standard
class Eq10_ActionBound where
  is_self_dual (F : FieldStrength) : Prop
  is_anti_self_dual (F : FieldStrength) : Prop
  bogomolnyi_bound (F : FieldStrength) : action_energy F ≥ 2 * Real.pi^2 * |(topological_charge F : ℝ)|
  saturation_condition (F : FieldStrength) :
    (is_self_dual F ∨ is_anti_self_dual F) → action_energy F = 2 * Real.pi^2 * |(topological_charge F : ℝ)|
