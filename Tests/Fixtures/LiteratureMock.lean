-- FILENAME: Tests/Fixtures/LiteratureMock.lean

import Litlib.Core

namespace Tests.Fixtures.LiteratureMock

Litlib.paper "mock1984spacetime"
  type "article"
  title "On the Geometry of Emergent Spacetime"
  authors ["Mock, Arthur", "Example, Bertrand"]
  journal "Journal of Mathematical Physics"
  year "1984"
  doi "10.1063/mock.1984.001"

Litlib.equation "mock1984spacetime" eq "3.1" page "12" kind "definition"
class Eq3_1_EmergentMetric (dim : Nat) (g : Fin dim → Fin dim → Nat) where
  metric_symm : ∀ i j, g i j = g j i

Litlib.equation "mock1984spacetime" eq "3.2" page "13" kind "theorem"
class Eq3_2_CurvatureContraction (dim : Nat) (g : Fin dim → Fin dim → Nat) where
  contract_pos : ∀ i, g i i ≥ 0

/-- Concrete proved instance of Equation 3.1 -/
instance provedEq3_1 : Eq3_1_EmergentMetric 2 (fun _ _ => 1) where
  metric_symm _ _ := rfl

/-- Concrete proved instance of Equation 3.2 -/
instance provedEq3_2 : Eq3_2_CurvatureContraction 2 (fun _ _ => 1) where
  contract_pos _ := Nat.zero_le 1

/-- Standalone theorem consuming literature equations -/
@[litlib_track "Emergent Spacetime Metric Soundness"]
theorem mockMetricSoundness (dim : Nat) (g : Fin dim → Fin dim → Nat)
    [hMetric : Eq3_1_EmergentMetric dim g]
    [hCurv : Eq3_2_CurvatureContraction dim g] :
    ∀ i, g i i ≥ 0 :=
  hCurv.contract_pos

end Tests.Fixtures.LiteratureMock
