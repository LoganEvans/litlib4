-- FILENAME: Litlib/Y1989/capovilla1989general/Signature.lean

import Litlib.Core
import Mathlib.Data.Complex.Basic
import Mathlib.Data.Real.Basic

namespace Litlib.Y1989.capovilla1989general

abbrev SpacetimePoint := Fin 4 → ℝ
abbrev SO3C_Algebra := Fin 3 → ℂ
abbrev SpacetimeMetric := SpacetimePoint → Fin 4 → Fin 4 → ℝ
abbrev Connection := SpacetimePoint → Fin 4 → SO3C_Algebra
abbrev Curvature := SpacetimePoint → Fin 4 → Fin 4 → SO3C_Algebra
abbrev ScalarDensity := SpacetimePoint → ℂ

literature_citation Eq1
  bibtex_key "capovilla1989general"
  doi "10.1103/PhysRevLett.63.2325"
  authors ["Capovilla, Riccardo", "Jacobson, Ted", "Dell, John"]
  status Standard
class Eq1 where
  h_tensor (a b c d : Fin 3) : ℂ
  Action (η : ScalarDensity) (A : Connection) : ℂ

literature_citation Eq6_RicciFlat
  bibtex_key "capovilla1989general"
  doi "10.1103/PhysRevLett.63.2325"
  authors ["Capovilla, Riccardo", "Jacobson, Ted", "Dell, John"]
  status Standard
class Eq6_RicciFlat where
  satisfies_cdj_constraint (F : Curvature) : Prop
  urbantke_metric (F : Curvature) : SpacetimeMetric
  ricci_tensor (g : SpacetimeMetric) : SpacetimePoint → Fin 4 → Fin 4 → ℝ
  cdj_implies_ricci_flat (F : Curvature) :
    satisfies_cdj_constraint F → 
    ∀ (x : SpacetimePoint) (μ ν : Fin 4), ricci_tensor (urbantke_metric F) x μ ν = 0
