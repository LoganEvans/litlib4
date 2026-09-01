-- FILENAME: Tests/Fixtures/TypeclassDependencyOrder.lean

import Litlib.Core

namespace Tests.Fixtures.TypeclassDependencyOrder

class DummyTypeclass (α : Type) where
  dummy : α → α

/-- Class with type parameter and typeclass constraint depending on α -/
class DependentClass (α : Type) [DummyTypeclass α] where
  op : α → α

/-- Theorem parameterized by α and instance depending on α -/
@[litlib_track "Dependent Typeclass Ordering"]
theorem testDependentTypeclassOrder (α : Type) [DummyTypeclass α] (x : α) :
    DummyTypeclass.dummy x = DummyTypeclass.dummy x := rfl

end Tests.Fixtures.TypeclassDependencyOrder
