-- FILENAME: Litlib/Y2000/hall2000elementary/Proofs/Sorry.lean

import Litlib.Y2000.hall2000elementary.Signature

namespace Litlib.Y2000.hall2000elementary.Proofs

@[litlib_difficulty easy, litlib_status Conjecture]
instance (priority := 10) fallback_Prop3_3 
    {n : Type*} [Fintype n] [DecidableEq n]
    {exp : Matrix n n ℂ → Matrix n n ℂ} : Prop3_3 n exp where
  h_is_exp := sorry
  commuting_exp := sorry

@[litlib_difficulty hard, litlib_status Conjecture]
instance (priority := 10) fallback_Thm3_9 
    {n : Type*} [Fintype n] [DecidableEq n]
    {exp : Matrix n n ℂ → Matrix n n ℂ} : Thm3_9 n exp where
  h_is_exp := sorry
  lie_product_formula := sorry

@[litlib_difficulty easy, litlib_status Conjecture]
instance (priority := 10) fallback_Thm3_10 
    {n : Type*} [Fintype n] [DecidableEq n]
    {exp : Matrix n n ℂ → Matrix n n ℂ} : Thm3_10 n exp where
  h_is_exp := sorry
  det_exp := sorry

@[litlib_difficulty medium, litlib_status Conjecture]
instance (priority := 10) fallback_MatrixCalculus 
    {n : Type*} [Fintype n] [DecidableEq n]
    {exp : Matrix n n ℂ → Matrix n n ℂ} : MatrixCalculus n exp where
  h_is_exp := sorry
  holonomy_self_commuting := sorry
  involutory_euler_formula := sorry

end Litlib.Y2000.hall2000elementary.Proofs
