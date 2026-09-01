-- FILENAME: Tests/Fixtures/ProofStripping.lean

import Litlib.Core

namespace Tests.Fixtures.ProofStripping

/-- P1: Standard inline `:= by` theorem -/
@[litlib_track "Standard Inline By"]
theorem testInlineBy (x : Nat) : x + 0 = x := by
  rfl

/-- P2: Multiline signature with newline before `:= by` -/
@[litlib_track "Multiline Signature By"]
theorem testMultilineBy
    (x : Nat)
    (_h : x > 0) :
    x + 0 = x
    := by
  rfl

/-- P3: Term-mode theorem without `by` -/
@[litlib_track "Term Mode Proof"]
theorem testTermMode (x : Nat) : x + 0 = x := rfl

/-- Class for testing `where` instance stripping -/
class DummyOp (α : Type) where
  op : α → α
  op_id : ∀ a : α, op a = a

/-- P4: Instance proof using `where` block -/
@[litlib_track "Where Instance Proof"]
instance : DummyOp Nat where
  op n := n
  op_id n := by rfl

/-- P5: Pattern matching proof with equations -/
@[litlib_track "Pattern Matching Proof"]
theorem testPatternMatching : (n : Nat) → n + 0 = n
  | 0 => rfl
  | _ + 1 => rfl

/-- P6: The Tricky Case: `by` used inside default parameter lists -/
@[litlib_track "Parameter Default By Tactic"]
theorem testParamDefaultBy (x : Nat) (_h : 1 ≤ 2 := by decide) : x + 0 = x := by
  rfl

/-- P7: Value definition with internal `have ... := by` proof -/
@[litlib_track "Definition With Inline Have Proof"]
def testDefInlineHave (x : Nat) : { n : Nat // n ≥ x } :=
  have h_ge : x ≥ x := Nat.le_refl x
  ⟨x, h_ge⟩

structure DummyEquiv (α β : Type) where
  toFun : α → β
  invFun : β → α
  left_inv : ∀ a, invFun (toFun a) = a
  right_inv : ∀ b, toFun (invFun b) = b

/-- P8: `def ... where` structure with tactic proofs in proof fields -/
@[litlib_track "Definition Where Structure Proofs"]
def testDefWhereEquiv (α : Type) : DummyEquiv α α where
  toFun a := a
  invFun a := a
  left_inv a := by
    rfl
  right_inv a := by
    rfl

end Tests.Fixtures.ProofStripping
