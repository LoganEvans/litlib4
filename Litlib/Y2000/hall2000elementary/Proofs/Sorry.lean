-- FILENAME: Litlib/Y2000/hall2000elementary/Proofs/Sorry.lean

import Litlib.Y2000.hall2000elementary.Signature

namespace Litlib.Y2000.hall2000elementary.Proofs

@[Litlib.difficulty easy, Litlib.status Conjecture]
instance (priority := 10) fallback_Prop3_3 
    {n : Type*} [Fintype n] [DecidableEq n]
    {exp : Matrix n n ℂ → Matrix n n ℂ} : Prop3_3 n exp where
  hIsExp := sorry
  commutingExp := sorry

@[Litlib.difficulty hard, Litlib.status Conjecture]
instance (priority := 10) fallback_Thm3_9 
    {n : Type*} [Fintype n] [DecidableEq n]
    {exp : Matrix n n ℂ → Matrix n n ℂ} : Thm3_9 n exp where
  hIsExp := sorry
  lieProductFormula := sorry

@[Litlib.difficulty easy, Litlib.status Conjecture]
instance (priority := 10) fallback_Thm3_10 
    {n : Type*} [Fintype n] [DecidableEq n]
    {exp : Matrix n n ℂ → Matrix n n ℂ} : Thm3_10 n exp where
  hIsExp := sorry
  detExp := sorry

@[Litlib.difficulty medium, Litlib.status Conjecture]
instance (priority := 10) fallback_MatrixCalculus 
    {n : Type*} [Fintype n] [DecidableEq n]
    {exp : Matrix n n ℂ → Matrix n n ℂ} : MatrixCalculus n exp where
  hIsExp := sorry
  holonomySelfCommuting := sorry
  involutoryEulerFormula := sorry

end Litlib.Y2000.hall2000elementary.Proofs
