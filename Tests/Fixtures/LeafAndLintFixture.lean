-- FILENAME: Tests/Fixtures/LeafAndLintFixture.lean

import Litlib.Core

namespace Tests.Fixtures

/-- A project structure in the folder namespace `Tests.Fixtures`. -/
structure FixtureStruct where
  val : Nat

/-- A dot-notation method on an existing project structure (valid namespace). -/
@[litlib_track "Valid structure method"]
def FixtureStruct.double (s : FixtureStruct) : Nat :=
  s.val + s.val

/-- Another structure to ensure duplicate-type linter does not flag `Type` sorts. -/
structure AnotherFixtureStruct where
  count : Nat

/-- Tracked helper used by `trackedCulminationLeaf` (uses = 1, tracked non-leaf). -/
@[litlib_track "Tracked non-leaf helper"]
def trackedNonLeafHelper (n : Nat) : Nat :=
  n + 1

/-- Untracked helper used by `trackedCulminationLeaf` (uses = 1, untracked non-leaf). -/
def untrackedUsedHelper (n : Nat) : Nat :=
  n + 2

/--
Tracked culmination theorem (uses = 0, tracked leaf).
Multiline docstring and signature to test single-line outline collapsing.
-/
@[litlib_track "Tracked culmination leaf"]
theorem trackedCulminationLeaf
    (n : Nat) :
    trackedNonLeafHelper n + untrackedUsedHelper n = (n + 1) + (n + 2) := by
  rfl

/-- Untracked helper used ONLY by `untrackedDeadLeaf` (transitively dead). -/
def deadHelperOnlyUsedByDeadLeaf (n : Nat) : Nat :=
  n + 99

/-- Untracked leaf theorem (uses = 0, untracked leaf -> dead or forgotten track). -/
theorem untrackedDeadLeaf (n : Nat) :
    deadHelperOnlyUsedByDeadLeaf n = n + 99 := by
  rfl

/-- First theorem in an alpha-equivalent duplicate pair (uses bound vars `x y`). -/
@[litlib_track "Duplicate theorem alpha"]
theorem dupTheoremAlpha (x y : Nat) : x + y = y + x :=
  Nat.add_comm x y

/-- Second theorem in an alpha-equivalent duplicate pair (uses bound vars `a b`). -/
@[litlib_track "Duplicate theorem beta"]
theorem dupTheoremBeta (a b : Nat) : a + b = b + a :=
  Nat.add_comm a b

-- Necessary heartbeat adjustment for fixture testing (explained option: should PASS lint)
set_option maxHeartbeats 250000

@[litlib_track "Declaration separating options"]
def optionSeparatorDecl : Nat := 1

set_option maxHeartbeats 300000

/-- A declaration with a single line intentionally exceeding 100 characters for the line-length linter test. -/
@[litlib_track "Long line test declaration"]
def longLineDeclaration (n : Nat) : Nat := n + n + n + n + n + n + n + n + n + n + n + n + n + n + n + 1

end Tests.Fixtures

namespace Tests.Fixtures.LeafAndLintFixture

/-- Bad namespace: includes the filename `LeafAndLintFixture` instead of just the folder `Tests.Fixtures`. -/
@[litlib_track "Bad filename namespace declaration"]
def badFilenameNsDecl : Nat := 7

end Tests.Fixtures.LeafAndLintFixture

namespace WrongFolder.Sub

/-- Bad namespace: does not match the folder hierarchy `Tests.Fixtures`. -/
@[litlib_track "Bad folder namespace declaration"]
def badFolderNsDecl : Nat := 8

end WrongFolder.Sub
