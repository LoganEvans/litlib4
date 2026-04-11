-- FILENAME: Litlib/Y1979/duan1979su2/Signature.lean

import Litlib.Core
import Mathlib.Data.Real.Basic

namespace Litlib.Y1979.duan1979su2

abbrev SpacetimePoint := Fin 4 → ℝ
abbrev IsospinVector := Fin 3 → ℝ
abbrev GaugePotential := SpacetimePoint → Fin 4 → IsospinVector
abbrev EMPotential := SpacetimePoint → Fin 4 → ℝ
abbrev UnitIsospinField := SpacetimePoint → IsospinVector

opaque isospin_dot (a b : IsospinVector) : ℝ
opaque isospin_cross (a b : IsospinVector) : IsospinVector
opaque partial_deriv (n : UnitIsospinField) (μ : Fin 4) : SpacetimePoint → IsospinVector
opaque covar_deriv (n : UnitIsospinField) (μ : Fin 4) : SpacetimePoint → IsospinVector

literature_axiom Eq1_13_Decomposition
  bibtex_key "duan1979su2"
  doi "10.1142/9789813237278_0001"
  authors ["Duan, Yi-Shi", "Ge, Mo-Lin"]
  status Standard
class Eq1_13_Decomposition where
  e : ℝ
  A (W : GaugePotential) (n : UnitIsospinField) : EMPotential
  Gamma (A_pot : EMPotential) (n : UnitIsospinField) : GaugePotential
  b (n : UnitIsospinField) : GaugePotential
  decomposition (W : GaugePotential) (n : UnitIsospinField) : Prop

literature_axiom Eq1_33_ElectromagneticTensor
  bibtex_key "duan1979su2"
  doi "10.1142/9789813237278_0001"
  authors ["Duan, Yi-Shi", "Ge, Mo-Lin"]
  status Standard
class Eq1_33_ElectromagneticTensor where
  e : ℝ
  G : SpacetimePoint → Fin 4 → Fin 4 → IsospinVector
  F (n : UnitIsospinField) : SpacetimePoint → Fin 4 → Fin 4 → ℝ
  physical_tensor_def (n : UnitIsospinField) (x : SpacetimePoint) (μ ν : Fin 4) : Prop
