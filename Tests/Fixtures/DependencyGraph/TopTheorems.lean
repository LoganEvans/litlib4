-- FILENAME: @litlib4/Tests/Fixtures/DependencyGraph/TopTheorems.lean

import Litlib.Core
import Tests.Fixtures.DependencyGraph.MidDefs

namespace Tests.Fixtures.DependencyGraph.TopTheorems

open Tests.Fixtures.DependencyGraph.BaseDefs
open Tests.Fixtures.DependencyGraph.MidDefs

/--
Top Theorem C: Combines midTheoremA and midTheoremB.
Direct dependencies: midTheoremA, midTheoremB.
Transitive dependencies: baseTheoremZ, baseHelper.
-/
@[litlib_track "Top Theorem C"]
theorem topTheoremC (n : Nat) : ((n + 0) + 0) + (0 + (0 + n)) = n + n := by
  rw [midTheoremA n]
  rw [midTheoremB n]

/--
Theorem testing separation between signature dependencies and proof dependencies.
Signature dependency: MidConfig (specifically MidConfig.scale).
Proof dependency: midTheoremA.
-/
@[litlib_track "Signature vs Proof Separation"]
theorem topSignatureProofSeparation (cfg : MidConfig) :
    (cfg.scale + 0) + 0 = cfg.scale := by
  exact midTheoremA cfg.scale

/--
Theorem consuming Litlib Equation 1.1 from the mock paper.
Direct dependencies: Eq1_1_MetricTensor, Eq1_1_MetricTensor.metric_symm.
-/
@[litlib_track "Litlib Equation Consumer"]
theorem topLitlibConsumer (dim : Nat) [hM : Eq1_1_MetricTensor dim] (i : Fin dim) :
    hM.metric_val i i = hM.metric_val i i :=
  hM.metric_symm i i

/--
Incomplete theorem with sorry to verify incomplete proof tracking.
-/
@[litlib_track "Incomplete Top Theorem"]
theorem topIncompleteSorry (n : Nat) : n * 0 = 0 := by
  sorry

/--
Theorem demonstrating Core/Mathlib external boundary cutoff.
Direct project dependency: midTheoremA.
Direct external Mathlib/Core boundary dependency: Nat.add_comm.
-/
@[litlib_track "Mathlib Boundary Demonstration"]
theorem topMathlibBoundary (a b : Nat) : ((a + 0) + 0) + b = b + a := by
  rw [midTheoremA a]
  exact Nat.add_comm a b

end Tests.Fixtures.DependencyGraph.TopTheorems
