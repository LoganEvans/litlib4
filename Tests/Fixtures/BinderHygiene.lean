-- FILENAME: Tests/Fixtures/BinderHygiene.lean

import Litlib.Core

namespace Tests.Fixtures.BinderHygiene

/-- Self-contained commutative addition class for testing typeclass binder hygiene -/
class DummyAddComm (α : Type) where
  add : α → α → α
  comm : ∀ x y : α, add x y = add y x

/-- B1: Anonymous typeclass instance binder -/
@[litlib_track "Anonymous Typeclass Binder"]
theorem testAnonTypeclass [DummyAddComm α] (x y : α) : DummyAddComm.add x y = DummyAddComm.add y x :=
  DummyAddComm.comm x y

/-- B2: Named typeclass instance binder -/
@[litlib_track "Named Typeclass Binder"]
theorem testNamedTypeclass [hAdd : DummyAddComm α] (x y : α) : DummyAddComm.add x y = DummyAddComm.add y x :=
  hAdd.comm x y

/-- B3: Function returning a function (return-type arrows) -/
@[litlib_track "Return Type Function Arrows"]
def testReturnArrows (scale : Nat) : (Fin 4 → Nat) → Fin 4 → Nat :=
  fun v idx => scale * v idx

/-- B4: Type-dependent binders with strict ordering -/
@[litlib_track "Dependent Binder Ordering"]
theorem testDependentOrder (n : Nat) (_h : n > 0) (i : Fin n) : i.val < n :=
  i.isLt

end Tests.Fixtures.BinderHygiene
