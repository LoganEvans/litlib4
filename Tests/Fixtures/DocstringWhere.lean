-- FILENAME: Tests/Fixtures/DocstringWhere.lean

import Litlib.Core

namespace Tests.Fixtures.DocstringWhere

/--
Tier 1 Docstring Test:
In any physical spacetime where the metric is flat, we verify that addition is symmetric.
-/
@[litlib_track "Docstring With Where Word"]
theorem testDocstringWithWhere (x : Nat) : x + 0 = x := by
  have h_inner : x = x := by
    rfl
  calc
    x + 0 = x := by rfl
    _ = x := by rfl

end Tests.Fixtures.DocstringWhere
