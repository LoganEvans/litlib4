-- FILENAME: Tests/Fixtures/DependencyGraph/MidDefs.lean


import Litlib.Core
import Tests.Fixtures.DependencyGraph.BaseDefs

namespace Tests.Fixtures.DependencyGraph.MidDefs

open Tests.Fixtures.DependencyGraph.BaseDefs

Litlib.paper "mockDep2024"
  type "article"
  title "Foundations of Dependency Dynamics"
  authors ["Graph, Alice", "Node, Bob"]
  year "2024"

Litlib.equation "mockDep2024" eq "1.1" kind "definition"
class Eq1_1_MetricTensor (dim : Nat) where
  metric_val : Fin dim → Fin dim → Nat
  metric_symm : ∀ i j, metric_val i j = metric_val j i

/-- Extended configuration structure inheriting from BaseConfig -/
structure MidConfig extends BaseConfig where
  scale : Nat
  scale_pos : scale > 0

/-- Mid-level function depending on baseCompute, BaseConfig, and BaseCell -/
def midCompute (cfg : MidConfig) (c : BaseCell) : Nat :=
  match c with
  | BaseCell.point => baseCompute cfg.toBaseConfig * cfg.scale
  | BaseCell.edge _ _ => baseCompute cfg.toBaseConfig + cfg.scale

/-- Mid Theorem A: Directly invokes baseTheoremZ twice -/
@[litlib_track "Mid Theorem A"]
theorem midTheoremA (n : Nat) : (n + 0) + 0 = n :=
  (baseTheoremZ (n + 0)).trans (baseTheoremZ n)

/-- Mid Theorem B: Directly invokes baseHelper twice -/
@[litlib_track "Mid Theorem B"]
theorem midTheoremB (n : Nat) : 0 + (0 + n) = n :=
  (baseHelper (0 + n)).trans (baseHelper n)

end Tests.Fixtures.DependencyGraph.MidDefs
