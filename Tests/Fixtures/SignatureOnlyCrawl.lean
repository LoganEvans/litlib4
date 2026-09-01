-- FILENAME: Tests/Fixtures/SignatureOnlyCrawl.lean

import Litlib.Core

namespace Tests.Fixtures.SignatureOnlyCrawl

/-- Internal computational lookup table -/
def internalLookupTable : Nat → Nat
  | 0 => 1
  | 1 => 2
  | _ => 0

/-- Public interface operator whose type signature is used by theorems -/
def publicOperator (n : Nat) : Nat :=
  internalLookupTable n

/-- Standalone tracked theorem referencing only publicOperator -/
@[litlib_track "Tracked Theorem With Interface Operator"]
theorem trackedTheoremWithDef (n : Nat) : publicOperator n ≥ 0 :=
  Nat.zero_le (publicOperator n)

end Tests.Fixtures.SignatureOnlyCrawl
