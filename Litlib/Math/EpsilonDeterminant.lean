-- FILENAME: Litlib/Math/EpsilonDeterminant.lean

import Litlib.Math.Matrix4
import Litlib.Math.LeviCivita
import Mathlib.Data.Complex.Basic
import Mathlib.Tactic

set_option maxHeartbeats 4000000
set_option linter.unusedVariables false
set_option linter.unusedSimpArgs false
set_option linter.unnecessarySeqFocus false

open Complex Matrix BigOperators
open Litlib.Math.LeviCivita

namespace Litlib.Math.EpsilonDeterminant

lemma sum_fin_4 {α} [AddCommMonoid α] (f : Fin 4 → α) :
  (∑ i : Fin 4, f i) = f 0 + f 1 + f 2 + f 3 := by
  simp [Fin.sum_univ_succ, add_assoc]

-- Explicit structural pattern match to prevent `fin_cases` from generating `⟨0, _⟩` garbage.
lemma fin4_cases (x : Fin 4) : x = 0 ∨ x = 1 ∨ x = 2 ∨ x = 3 := by
  revert x; decide

-- ============================================================================
-- THE LOOKUP TABLE
-- Using exact_mod_cast ensures we get exactly `0 : Complex` and not `↑0`.
-- ============================================================================

lemma eps_val_0 (i j k l : Fin 4) (h : epsilon4 i j k l = 0) : 
  (epsilon4 i j k l : Complex) = 0 := by exact_mod_cast h

lemma eps_val_1 (i j k l : Fin 4) (h : epsilon4 i j k l = 1) : 
  (epsilon4 i j k l : Complex) = 1 := by exact_mod_cast h

lemma eps_val_m1 (i j k l : Fin 4) (h : epsilon4 i j k l = -1) : 
  (epsilon4 i j k l : Complex) = -1 := by exact_mod_cast h

lemma e0000 : (epsilon4 0 0 0 0 : Complex) = 0 := eps_val_0 0 0 0 0 (by decide)
lemma e0001 : (epsilon4 0 0 0 1 : Complex) = 0 := eps_val_0 0 0 0 1 (by decide)
lemma e0002 : (epsilon4 0 0 0 2 : Complex) = 0 := eps_val_0 0 0 0 2 (by decide)
lemma e0003 : (epsilon4 0 0 0 3 : Complex) = 0 := eps_val_0 0 0 0 3 (by decide)
lemma e0010 : (epsilon4 0 0 1 0 : Complex) = 0 := eps_val_0 0 0 1 0 (by decide)
lemma e0011 : (epsilon4 0 0 1 1 : Complex) = 0 := eps_val_0 0 0 1 1 (by decide)
lemma e0012 : (epsilon4 0 0 1 2 : Complex) = 0 := eps_val_0 0 0 1 2 (by decide)
lemma e0013 : (epsilon4 0 0 1 3 : Complex) = 0 := eps_val_0 0 0 1 3 (by decide)
lemma e0020 : (epsilon4 0 0 2 0 : Complex) = 0 := eps_val_0 0 0 2 0 (by decide)
lemma e0021 : (epsilon4 0 0 2 1 : Complex) = 0 := eps_val_0 0 0 2 1 (by decide)
lemma e0022 : (epsilon4 0 0 2 2 : Complex) = 0 := eps_val_0 0 0 2 2 (by decide)
lemma e0023 : (epsilon4 0 0 2 3 : Complex) = 0 := eps_val_0 0 0 2 3 (by decide)
lemma e0030 : (epsilon4 0 0 3 0 : Complex) = 0 := eps_val_0 0 0 3 0 (by decide)
lemma e0031 : (epsilon4 0 0 3 1 : Complex) = 0 := eps_val_0 0 0 3 1 (by decide)
lemma e0032 : (epsilon4 0 0 3 2 : Complex) = 0 := eps_val_0 0 0 3 2 (by decide)
lemma e0033 : (epsilon4 0 0 3 3 : Complex) = 0 := eps_val_0 0 0 3 3 (by decide)
lemma e0100 : (epsilon4 0 1 0 0 : Complex) = 0 := eps_val_0 0 1 0 0 (by decide)
lemma e0101 : (epsilon4 0 1 0 1 : Complex) = 0 := eps_val_0 0 1 0 1 (by decide)
lemma e0102 : (epsilon4 0 1 0 2 : Complex) = 0 := eps_val_0 0 1 0 2 (by decide)
lemma e0103 : (epsilon4 0 1 0 3 : Complex) = 0 := eps_val_0 0 1 0 3 (by decide)
lemma e0110 : (epsilon4 0 1 1 0 : Complex) = 0 := eps_val_0 0 1 1 0 (by decide)
lemma e0111 : (epsilon4 0 1 1 1 : Complex) = 0 := eps_val_0 0 1 1 1 (by decide)
lemma e0112 : (epsilon4 0 1 1 2 : Complex) = 0 := eps_val_0 0 1 1 2 (by decide)
lemma e0113 : (epsilon4 0 1 1 3 : Complex) = 0 := eps_val_0 0 1 1 3 (by decide)
lemma e0120 : (epsilon4 0 1 2 0 : Complex) = 0 := eps_val_0 0 1 2 0 (by decide)
lemma e0121 : (epsilon4 0 1 2 1 : Complex) = 0 := eps_val_0 0 1 2 1 (by decide)
lemma e0122 : (epsilon4 0 1 2 2 : Complex) = 0 := eps_val_0 0 1 2 2 (by decide)
lemma e0123 : (epsilon4 0 1 2 3 : Complex) = 1 := eps_val_1 0 1 2 3 (by decide)
lemma e0130 : (epsilon4 0 1 3 0 : Complex) = 0 := eps_val_0 0 1 3 0 (by decide)
lemma e0131 : (epsilon4 0 1 3 1 : Complex) = 0 := eps_val_0 0 1 3 1 (by decide)
lemma e0132 : (epsilon4 0 1 3 2 : Complex) = -1 := eps_val_m1 0 1 3 2 (by decide)
lemma e0133 : (epsilon4 0 1 3 3 : Complex) = 0 := eps_val_0 0 1 3 3 (by decide)
lemma e0200 : (epsilon4 0 2 0 0 : Complex) = 0 := eps_val_0 0 2 0 0 (by decide)
lemma e0201 : (epsilon4 0 2 0 1 : Complex) = 0 := eps_val_0 0 2 0 1 (by decide)
lemma e0202 : (epsilon4 0 2 0 2 : Complex) = 0 := eps_val_0 0 2 0 2 (by decide)
lemma e0203 : (epsilon4 0 2 0 3 : Complex) = 0 := eps_val_0 0 2 0 3 (by decide)
lemma e0210 : (epsilon4 0 2 1 0 : Complex) = 0 := eps_val_0 0 2 1 0 (by decide)
lemma e0211 : (epsilon4 0 2 1 1 : Complex) = 0 := eps_val_0 0 2 1 1 (by decide)
lemma e0212 : (epsilon4 0 2 1 2 : Complex) = 0 := eps_val_0 0 2 1 2 (by decide)
lemma e0213 : (epsilon4 0 2 1 3 : Complex) = -1 := eps_val_m1 0 2 1 3 (by decide)
lemma e0220 : (epsilon4 0 2 2 0 : Complex) = 0 := eps_val_0 0 2 2 0 (by decide)
lemma e0221 : (epsilon4 0 2 2 1 : Complex) = 0 := eps_val_0 0 2 2 1 (by decide)
lemma e0222 : (epsilon4 0 2 2 2 : Complex) = 0 := eps_val_0 0 2 2 2 (by decide)
lemma e0223 : (epsilon4 0 2 2 3 : Complex) = 0 := eps_val_0 0 2 2 3 (by decide)
lemma e0230 : (epsilon4 0 2 3 0 : Complex) = 0 := eps_val_0 0 2 3 0 (by decide)
lemma e0231 : (epsilon4 0 2 3 1 : Complex) = 1 := eps_val_1 0 2 3 1 (by decide)
lemma e0232 : (epsilon4 0 2 3 2 : Complex) = 0 := eps_val_0 0 2 3 2 (by decide)
lemma e0233 : (epsilon4 0 2 3 3 : Complex) = 0 := eps_val_0 0 2 3 3 (by decide)
lemma e0300 : (epsilon4 0 3 0 0 : Complex) = 0 := eps_val_0 0 3 0 0 (by decide)
lemma e0301 : (epsilon4 0 3 0 1 : Complex) = 0 := eps_val_0 0 3 0 1 (by decide)
lemma e0302 : (epsilon4 0 3 0 2 : Complex) = 0 := eps_val_0 0 3 0 2 (by decide)
lemma e0303 : (epsilon4 0 3 0 3 : Complex) = 0 := eps_val_0 0 3 0 3 (by decide)
lemma e0310 : (epsilon4 0 3 1 0 : Complex) = 0 := eps_val_0 0 3 1 0 (by decide)
lemma e0311 : (epsilon4 0 3 1 1 : Complex) = 0 := eps_val_0 0 3 1 1 (by decide)
lemma e0312 : (epsilon4 0 3 1 2 : Complex) = 1 := eps_val_1 0 3 1 2 (by decide)
lemma e0313 : (epsilon4 0 3 1 3 : Complex) = 0 := eps_val_0 0 3 1 3 (by decide)
lemma e0320 : (epsilon4 0 3 2 0 : Complex) = 0 := eps_val_0 0 3 2 0 (by decide)
lemma e0321 : (epsilon4 0 3 2 1 : Complex) = -1 := eps_val_m1 0 3 2 1 (by decide)
lemma e0322 : (epsilon4 0 3 2 2 : Complex) = 0 := eps_val_0 0 3 2 2 (by decide)
lemma e0323 : (epsilon4 0 3 2 3 : Complex) = 0 := eps_val_0 0 3 2 3 (by decide)
lemma e0330 : (epsilon4 0 3 3 0 : Complex) = 0 := eps_val_0 0 3 3 0 (by decide)
lemma e0331 : (epsilon4 0 3 3 1 : Complex) = 0 := eps_val_0 0 3 3 1 (by decide)
lemma e0332 : (epsilon4 0 3 3 2 : Complex) = 0 := eps_val_0 0 3 3 2 (by decide)
lemma e0333 : (epsilon4 0 3 3 3 : Complex) = 0 := eps_val_0 0 3 3 3 (by decide)
lemma e1000 : (epsilon4 1 0 0 0 : Complex) = 0 := eps_val_0 1 0 0 0 (by decide)
lemma e1001 : (epsilon4 1 0 0 1 : Complex) = 0 := eps_val_0 1 0 0 1 (by decide)
lemma e1002 : (epsilon4 1 0 0 2 : Complex) = 0 := eps_val_0 1 0 0 2 (by decide)
lemma e1003 : (epsilon4 1 0 0 3 : Complex) = 0 := eps_val_0 1 0 0 3 (by decide)
lemma e1010 : (epsilon4 1 0 1 0 : Complex) = 0 := eps_val_0 1 0 1 0 (by decide)
lemma e1011 : (epsilon4 1 0 1 1 : Complex) = 0 := eps_val_0 1 0 1 1 (by decide)
lemma e1012 : (epsilon4 1 0 1 2 : Complex) = 0 := eps_val_0 1 0 1 2 (by decide)
lemma e1013 : (epsilon4 1 0 1 3 : Complex) = 0 := eps_val_0 1 0 1 3 (by decide)
lemma e1020 : (epsilon4 1 0 2 0 : Complex) = 0 := eps_val_0 1 0 2 0 (by decide)
lemma e1021 : (epsilon4 1 0 2 1 : Complex) = 0 := eps_val_0 1 0 2 1 (by decide)
lemma e1022 : (epsilon4 1 0 2 2 : Complex) = 0 := eps_val_0 1 0 2 2 (by decide)
lemma e1023 : (epsilon4 1 0 2 3 : Complex) = -1 := eps_val_m1 1 0 2 3 (by decide)
lemma e1030 : (epsilon4 1 0 3 0 : Complex) = 0 := eps_val_0 1 0 3 0 (by decide)
lemma e1031 : (epsilon4 1 0 3 1 : Complex) = 0 := eps_val_0 1 0 3 1 (by decide)
lemma e1032 : (epsilon4 1 0 3 2 : Complex) = 1 := eps_val_1 1 0 3 2 (by decide)
lemma e1033 : (epsilon4 1 0 3 3 : Complex) = 0 := eps_val_0 1 0 3 3 (by decide)
lemma e1100 : (epsilon4 1 1 0 0 : Complex) = 0 := eps_val_0 1 1 0 0 (by decide)
lemma e1101 : (epsilon4 1 1 0 1 : Complex) = 0 := eps_val_0 1 1 0 1 (by decide)
lemma e1102 : (epsilon4 1 1 0 2 : Complex) = 0 := eps_val_0 1 1 0 2 (by decide)
lemma e1103 : (epsilon4 1 1 0 3 : Complex) = 0 := eps_val_0 1 1 0 3 (by decide)
lemma e1110 : (epsilon4 1 1 1 0 : Complex) = 0 := eps_val_0 1 1 1 0 (by decide)
lemma e1111 : (epsilon4 1 1 1 1 : Complex) = 0 := eps_val_0 1 1 1 1 (by decide)
lemma e1112 : (epsilon4 1 1 1 2 : Complex) = 0 := eps_val_0 1 1 1 2 (by decide)
lemma e1113 : (epsilon4 1 1 1 3 : Complex) = 0 := eps_val_0 1 1 1 3 (by decide)
lemma e1120 : (epsilon4 1 1 2 0 : Complex) = 0 := eps_val_0 1 1 2 0 (by decide)
lemma e1121 : (epsilon4 1 1 2 1 : Complex) = 0 := eps_val_0 1 1 2 1 (by decide)
lemma e1122 : (epsilon4 1 1 2 2 : Complex) = 0 := eps_val_0 1 1 2 2 (by decide)
lemma e1123 : (epsilon4 1 1 2 3 : Complex) = 0 := eps_val_0 1 1 2 3 (by decide)
lemma e1130 : (epsilon4 1 1 3 0 : Complex) = 0 := eps_val_0 1 1 3 0 (by decide)
lemma e1131 : (epsilon4 1 1 3 1 : Complex) = 0 := eps_val_0 1 1 3 1 (by decide)
lemma e1132 : (epsilon4 1 1 3 2 : Complex) = 0 := eps_val_0 1 1 3 2 (by decide)
lemma e1133 : (epsilon4 1 1 3 3 : Complex) = 0 := eps_val_0 1 1 3 3 (by decide)
lemma e1200 : (epsilon4 1 2 0 0 : Complex) = 0 := eps_val_0 1 2 0 0 (by decide)
lemma e1201 : (epsilon4 1 2 0 1 : Complex) = 0 := eps_val_0 1 2 0 1 (by decide)
lemma e1202 : (epsilon4 1 2 0 2 : Complex) = 0 := eps_val_0 1 2 0 2 (by decide)
lemma e1203 : (epsilon4 1 2 0 3 : Complex) = 1 := eps_val_1 1 2 0 3 (by decide)
lemma e1210 : (epsilon4 1 2 1 0 : Complex) = 0 := eps_val_0 1 2 1 0 (by decide)
lemma e1211 : (epsilon4 1 2 1 1 : Complex) = 0 := eps_val_0 1 2 1 1 (by decide)
lemma e1212 : (epsilon4 1 2 1 2 : Complex) = 0 := eps_val_0 1 2 1 2 (by decide)
lemma e1213 : (epsilon4 1 2 1 3 : Complex) = 0 := eps_val_0 1 2 1 3 (by decide)
lemma e1220 : (epsilon4 1 2 2 0 : Complex) = 0 := eps_val_0 1 2 2 0 (by decide)
lemma e1221 : (epsilon4 1 2 2 1 : Complex) = 0 := eps_val_0 1 2 2 1 (by decide)
lemma e1222 : (epsilon4 1 2 2 2 : Complex) = 0 := eps_val_0 1 2 2 2 (by decide)
lemma e1223 : (epsilon4 1 2 2 3 : Complex) = 0 := eps_val_0 1 2 2 3 (by decide)
lemma e1230 : (epsilon4 1 2 3 0 : Complex) = -1 := eps_val_m1 1 2 3 0 (by decide)
lemma e1231 : (epsilon4 1 2 3 1 : Complex) = 0 := eps_val_0 1 2 3 1 (by decide)
lemma e1232 : (epsilon4 1 2 3 2 : Complex) = 0 := eps_val_0 1 2 3 2 (by decide)
lemma e1233 : (epsilon4 1 2 3 3 : Complex) = 0 := eps_val_0 1 2 3 3 (by decide)
lemma e1300 : (epsilon4 1 3 0 0 : Complex) = 0 := eps_val_0 1 3 0 0 (by decide)
lemma e1301 : (epsilon4 1 3 0 1 : Complex) = 0 := eps_val_0 1 3 0 1 (by decide)
lemma e1302 : (epsilon4 1 3 0 2 : Complex) = -1 := eps_val_m1 1 3 0 2 (by decide)
lemma e1303 : (epsilon4 1 3 0 3 : Complex) = 0 := eps_val_0 1 3 0 3 (by decide)
lemma e1310 : (epsilon4 1 3 1 0 : Complex) = 0 := eps_val_0 1 3 1 0 (by decide)
lemma e1311 : (epsilon4 1 3 1 1 : Complex) = 0 := eps_val_0 1 3 1 1 (by decide)
lemma e1312 : (epsilon4 1 3 1 2 : Complex) = 0 := eps_val_0 1 3 1 2 (by decide)
lemma e1313 : (epsilon4 1 3 1 3 : Complex) = 0 := eps_val_0 1 3 1 3 (by decide)
lemma e1320 : (epsilon4 1 3 2 0 : Complex) = 1 := eps_val_1 1 3 2 0 (by decide)
lemma e1321 : (epsilon4 1 3 2 1 : Complex) = 0 := eps_val_0 1 3 2 1 (by decide)
lemma e1322 : (epsilon4 1 3 2 2 : Complex) = 0 := eps_val_0 1 3 2 2 (by decide)
lemma e1323 : (epsilon4 1 3 2 3 : Complex) = 0 := eps_val_0 1 3 2 3 (by decide)
lemma e1330 : (epsilon4 1 3 3 0 : Complex) = 0 := eps_val_0 1 3 3 0 (by decide)
lemma e1331 : (epsilon4 1 3 3 1 : Complex) = 0 := eps_val_0 1 3 3 1 (by decide)
lemma e1332 : (epsilon4 1 3 3 2 : Complex) = 0 := eps_val_0 1 3 3 2 (by decide)
lemma e1333 : (epsilon4 1 3 3 3 : Complex) = 0 := eps_val_0 1 3 3 3 (by decide)
lemma e2000 : (epsilon4 2 0 0 0 : Complex) = 0 := eps_val_0 2 0 0 0 (by decide)
lemma e2001 : (epsilon4 2 0 0 1 : Complex) = 0 := eps_val_0 2 0 0 1 (by decide)
lemma e2002 : (epsilon4 2 0 0 2 : Complex) = 0 := eps_val_0 2 0 0 2 (by decide)
lemma e2003 : (epsilon4 2 0 0 3 : Complex) = 0 := eps_val_0 2 0 0 3 (by decide)
lemma e2010 : (epsilon4 2 0 1 0 : Complex) = 0 := eps_val_0 2 0 1 0 (by decide)
lemma e2011 : (epsilon4 2 0 1 1 : Complex) = 0 := eps_val_0 2 0 1 1 (by decide)
lemma e2012 : (epsilon4 2 0 1 2 : Complex) = 0 := eps_val_0 2 0 1 2 (by decide)
lemma e2013 : (epsilon4 2 0 1 3 : Complex) = 1 := eps_val_1 2 0 1 3 (by decide)
lemma e2020 : (epsilon4 2 0 2 0 : Complex) = 0 := eps_val_0 2 0 2 0 (by decide)
lemma e2021 : (epsilon4 2 0 2 1 : Complex) = 0 := eps_val_0 2 0 2 1 (by decide)
lemma e2022 : (epsilon4 2 0 2 2 : Complex) = 0 := eps_val_0 2 0 2 2 (by decide)
lemma e2023 : (epsilon4 2 0 2 3 : Complex) = 0 := eps_val_0 2 0 2 3 (by decide)
lemma e2030 : (epsilon4 2 0 3 0 : Complex) = 0 := eps_val_0 2 0 3 0 (by decide)
lemma e2031 : (epsilon4 2 0 3 1 : Complex) = -1 := eps_val_m1 2 0 3 1 (by decide)
lemma e2032 : (epsilon4 2 0 3 2 : Complex) = 0 := eps_val_0 2 0 3 2 (by decide)
lemma e2033 : (epsilon4 2 0 3 3 : Complex) = 0 := eps_val_0 2 0 3 3 (by decide)
lemma e2100 : (epsilon4 2 1 0 0 : Complex) = 0 := eps_val_0 2 1 0 0 (by decide)
lemma e2101 : (epsilon4 2 1 0 1 : Complex) = 0 := eps_val_0 2 1 0 1 (by decide)
lemma e2102 : (epsilon4 2 1 0 2 : Complex) = 0 := eps_val_0 2 1 0 2 (by decide)
lemma e2103 : (epsilon4 2 1 0 3 : Complex) = -1 := eps_val_m1 2 1 0 3 (by decide)
lemma e2110 : (epsilon4 2 1 1 0 : Complex) = 0 := eps_val_0 2 1 1 0 (by decide)
lemma e2111 : (epsilon4 2 1 1 1 : Complex) = 0 := eps_val_0 2 1 1 1 (by decide)
lemma e2112 : (epsilon4 2 1 1 2 : Complex) = 0 := eps_val_0 2 1 1 2 (by decide)
lemma e2113 : (epsilon4 2 1 1 3 : Complex) = 0 := eps_val_0 2 1 1 3 (by decide)
lemma e2120 : (epsilon4 2 1 2 0 : Complex) = 0 := eps_val_0 2 1 2 0 (by decide)
lemma e2121 : (epsilon4 2 1 2 1 : Complex) = 0 := eps_val_0 2 1 2 1 (by decide)
lemma e2122 : (epsilon4 2 1 2 2 : Complex) = 0 := eps_val_0 2 1 2 2 (by decide)
lemma e2123 : (epsilon4 2 1 2 3 : Complex) = 0 := eps_val_0 2 1 2 3 (by decide)
lemma e2130 : (epsilon4 2 1 3 0 : Complex) = 1 := eps_val_1 2 1 3 0 (by decide)
lemma e2131 : (epsilon4 2 1 3 1 : Complex) = 0 := eps_val_0 2 1 3 1 (by decide)
lemma e2132 : (epsilon4 2 1 3 2 : Complex) = 0 := eps_val_0 2 1 3 2 (by decide)
lemma e2133 : (epsilon4 2 1 3 3 : Complex) = 0 := eps_val_0 2 1 3 3 (by decide)
lemma e2200 : (epsilon4 2 2 0 0 : Complex) = 0 := eps_val_0 2 2 0 0 (by decide)
lemma e2201 : (epsilon4 2 2 0 1 : Complex) = 0 := eps_val_0 2 2 0 1 (by decide)
lemma e2202 : (epsilon4 2 2 0 2 : Complex) = 0 := eps_val_0 2 2 0 2 (by decide)
lemma e2203 : (epsilon4 2 2 0 3 : Complex) = 0 := eps_val_0 2 2 0 3 (by decide)
lemma e2210 : (epsilon4 2 2 1 0 : Complex) = 0 := eps_val_0 2 2 1 0 (by decide)
lemma e2211 : (epsilon4 2 2 1 1 : Complex) = 0 := eps_val_0 2 2 1 1 (by decide)
lemma e2212 : (epsilon4 2 2 1 2 : Complex) = 0 := eps_val_0 2 2 1 2 (by decide)
lemma e2213 : (epsilon4 2 2 1 3 : Complex) = 0 := eps_val_0 2 2 1 3 (by decide)
lemma e2220 : (epsilon4 2 2 2 0 : Complex) = 0 := eps_val_0 2 2 2 0 (by decide)
lemma e2221 : (epsilon4 2 2 2 1 : Complex) = 0 := eps_val_0 2 2 2 1 (by decide)
lemma e2222 : (epsilon4 2 2 2 2 : Complex) = 0 := eps_val_0 2 2 2 2 (by decide)
lemma e2223 : (epsilon4 2 2 2 3 : Complex) = 0 := eps_val_0 2 2 2 3 (by decide)
lemma e2230 : (epsilon4 2 2 3 0 : Complex) = 0 := eps_val_0 2 2 3 0 (by decide)
lemma e2231 : (epsilon4 2 2 3 1 : Complex) = 0 := eps_val_0 2 2 3 1 (by decide)
lemma e2232 : (epsilon4 2 2 3 2 : Complex) = 0 := eps_val_0 2 2 3 2 (by decide)
lemma e2233 : (epsilon4 2 2 3 3 : Complex) = 0 := eps_val_0 2 2 3 3 (by decide)
lemma e2300 : (epsilon4 2 3 0 0 : Complex) = 0 := eps_val_0 2 3 0 0 (by decide)
lemma e2301 : (epsilon4 2 3 0 1 : Complex) = 1 := eps_val_1 2 3 0 1 (by decide)
lemma e2302 : (epsilon4 2 3 0 2 : Complex) = 0 := eps_val_0 2 3 0 2 (by decide)
lemma e2303 : (epsilon4 2 3 0 3 : Complex) = 0 := eps_val_0 2 3 0 3 (by decide)
lemma e2310 : (epsilon4 2 3 1 0 : Complex) = -1 := eps_val_m1 2 3 1 0 (by decide)
lemma e2311 : (epsilon4 2 3 1 1 : Complex) = 0 := eps_val_0 2 3 1 1 (by decide)
lemma e2312 : (epsilon4 2 3 1 2 : Complex) = 0 := eps_val_0 2 3 1 2 (by decide)
lemma e2313 : (epsilon4 2 3 1 3 : Complex) = 0 := eps_val_0 2 3 1 3 (by decide)
lemma e2320 : (epsilon4 2 3 2 0 : Complex) = 0 := eps_val_0 2 3 2 0 (by decide)
lemma e2321 : (epsilon4 2 3 2 1 : Complex) = 0 := eps_val_0 2 3 2 1 (by decide)
lemma e2322 : (epsilon4 2 3 2 2 : Complex) = 0 := eps_val_0 2 3 2 2 (by decide)
lemma e2323 : (epsilon4 2 3 2 3 : Complex) = 0 := eps_val_0 2 3 2 3 (by decide)
lemma e2330 : (epsilon4 2 3 3 0 : Complex) = 0 := eps_val_0 2 3 3 0 (by decide)
lemma e2331 : (epsilon4 2 3 3 1 : Complex) = 0 := eps_val_0 2 3 3 1 (by decide)
lemma e2332 : (epsilon4 2 3 3 2 : Complex) = 0 := eps_val_0 2 3 3 2 (by decide)
lemma e2333 : (epsilon4 2 3 3 3 : Complex) = 0 := eps_val_0 2 3 3 3 (by decide)
lemma e3000 : (epsilon4 3 0 0 0 : Complex) = 0 := eps_val_0 3 0 0 0 (by decide)
lemma e3001 : (epsilon4 3 0 0 1 : Complex) = 0 := eps_val_0 3 0 0 1 (by decide)
lemma e3002 : (epsilon4 3 0 0 2 : Complex) = 0 := eps_val_0 3 0 0 2 (by decide)
lemma e3003 : (epsilon4 3 0 0 3 : Complex) = 0 := eps_val_0 3 0 0 3 (by decide)
lemma e3010 : (epsilon4 3 0 1 0 : Complex) = 0 := eps_val_0 3 0 1 0 (by decide)
lemma e3011 : (epsilon4 3 0 1 1 : Complex) = 0 := eps_val_0 3 0 1 1 (by decide)
lemma e3012 : (epsilon4 3 0 1 2 : Complex) = -1 := eps_val_m1 3 0 1 2 (by decide)
lemma e3013 : (epsilon4 3 0 1 3 : Complex) = 0 := eps_val_0 3 0 1 3 (by decide)
lemma e3020 : (epsilon4 3 0 2 0 : Complex) = 0 := eps_val_0 3 0 2 0 (by decide)
lemma e3021 : (epsilon4 3 0 2 1 : Complex) = 1 := eps_val_1 3 0 2 1 (by decide)
lemma e3022 : (epsilon4 3 0 2 2 : Complex) = 0 := eps_val_0 3 0 2 2 (by decide)
lemma e3023 : (epsilon4 3 0 2 3 : Complex) = 0 := eps_val_0 3 0 2 3 (by decide)
lemma e3030 : (epsilon4 3 0 3 0 : Complex) = 0 := eps_val_0 3 0 3 0 (by decide)
lemma e3031 : (epsilon4 3 0 3 1 : Complex) = 0 := eps_val_0 3 0 3 1 (by decide)
lemma e3032 : (epsilon4 3 0 3 2 : Complex) = 0 := eps_val_0 3 0 3 2 (by decide)
lemma e3033 : (epsilon4 3 0 3 3 : Complex) = 0 := eps_val_0 3 0 3 3 (by decide)
lemma e3100 : (epsilon4 3 1 0 0 : Complex) = 0 := eps_val_0 3 1 0 0 (by decide)
lemma e3101 : (epsilon4 3 1 0 1 : Complex) = 0 := eps_val_0 3 1 0 1 (by decide)
lemma e3102 : (epsilon4 3 1 0 2 : Complex) = 1 := eps_val_1 3 1 0 2 (by decide)
lemma e3103 : (epsilon4 3 1 0 3 : Complex) = 0 := eps_val_0 3 1 0 3 (by decide)
lemma e3110 : (epsilon4 3 1 1 0 : Complex) = 0 := eps_val_0 3 1 1 0 (by decide)
lemma e3111 : (epsilon4 3 1 1 1 : Complex) = 0 := eps_val_0 3 1 1 1 (by decide)
lemma e3112 : (epsilon4 3 1 1 2 : Complex) = 0 := eps_val_0 3 1 1 2 (by decide)
lemma e3113 : (epsilon4 3 1 1 3 : Complex) = 0 := eps_val_0 3 1 1 3 (by decide)
lemma e3120 : (epsilon4 3 1 2 0 : Complex) = -1 := eps_val_m1 3 1 2 0 (by decide)
lemma e3121 : (epsilon4 3 1 2 1 : Complex) = 0 := eps_val_0 3 1 2 1 (by decide)
lemma e3122 : (epsilon4 3 1 2 2 : Complex) = 0 := eps_val_0 3 1 2 2 (by decide)
lemma e3123 : (epsilon4 3 1 2 3 : Complex) = 0 := eps_val_0 3 1 2 3 (by decide)
lemma e3130 : (epsilon4 3 1 3 0 : Complex) = 0 := eps_val_0 3 1 3 0 (by decide)
lemma e3131 : (epsilon4 3 1 3 1 : Complex) = 0 := eps_val_0 3 1 3 1 (by decide)
lemma e3132 : (epsilon4 3 1 3 2 : Complex) = 0 := eps_val_0 3 1 3 2 (by decide)
lemma e3133 : (epsilon4 3 1 3 3 : Complex) = 0 := eps_val_0 3 1 3 3 (by decide)
lemma e3200 : (epsilon4 3 2 0 0 : Complex) = 0 := eps_val_0 3 2 0 0 (by decide)
lemma e3201 : (epsilon4 3 2 0 1 : Complex) = -1 := eps_val_m1 3 2 0 1 (by decide)
lemma e3202 : (epsilon4 3 2 0 2 : Complex) = 0 := eps_val_0 3 2 0 2 (by decide)
lemma e3203 : (epsilon4 3 2 0 3 : Complex) = 0 := eps_val_0 3 2 0 3 (by decide)
lemma e3210 : (epsilon4 3 2 1 0 : Complex) = 1 := eps_val_1 3 2 1 0 (by decide)
lemma e3211 : (epsilon4 3 2 1 1 : Complex) = 0 := eps_val_0 3 2 1 1 (by decide)
lemma e3212 : (epsilon4 3 2 1 2 : Complex) = 0 := eps_val_0 3 2 1 2 (by decide)
lemma e3213 : (epsilon4 3 2 1 3 : Complex) = 0 := eps_val_0 3 2 1 3 (by decide)
lemma e3220 : (epsilon4 3 2 2 0 : Complex) = 0 := eps_val_0 3 2 2 0 (by decide)
lemma e3221 : (epsilon4 3 2 2 1 : Complex) = 0 := eps_val_0 3 2 2 1 (by decide)
lemma e3222 : (epsilon4 3 2 2 2 : Complex) = 0 := eps_val_0 3 2 2 2 (by decide)
lemma e3223 : (epsilon4 3 2 2 3 : Complex) = 0 := eps_val_0 3 2 2 3 (by decide)
lemma e3230 : (epsilon4 3 2 3 0 : Complex) = 0 := eps_val_0 3 2 3 0 (by decide)
lemma e3231 : (epsilon4 3 2 3 1 : Complex) = 0 := eps_val_0 3 2 3 1 (by decide)
lemma e3232 : (epsilon4 3 2 3 2 : Complex) = 0 := eps_val_0 3 2 3 2 (by decide)
lemma e3233 : (epsilon4 3 2 3 3 : Complex) = 0 := eps_val_0 3 2 3 3 (by decide)
lemma e3300 : (epsilon4 3 3 0 0 : Complex) = 0 := eps_val_0 3 3 0 0 (by decide)
lemma e3301 : (epsilon4 3 3 0 1 : Complex) = 0 := eps_val_0 3 3 0 1 (by decide)
lemma e3302 : (epsilon4 3 3 0 2 : Complex) = 0 := eps_val_0 3 3 0 2 (by decide)
lemma e3303 : (epsilon4 3 3 0 3 : Complex) = 0 := eps_val_0 3 3 0 3 (by decide)
lemma e3310 : (epsilon4 3 3 1 0 : Complex) = 0 := eps_val_0 3 3 1 0 (by decide)
lemma e3311 : (epsilon4 3 3 1 1 : Complex) = 0 := eps_val_0 3 3 1 1 (by decide)
lemma e3312 : (epsilon4 3 3 1 2 : Complex) = 0 := eps_val_0 3 3 1 2 (by decide)
lemma e3313 : (epsilon4 3 3 1 3 : Complex) = 0 := eps_val_0 3 3 1 3 (by decide)
lemma e3320 : (epsilon4 3 3 2 0 : Complex) = 0 := eps_val_0 3 3 2 0 (by decide)
lemma e3321 : (epsilon4 3 3 2 1 : Complex) = 0 := eps_val_0 3 3 2 1 (by decide)
lemma e3322 : (epsilon4 3 3 2 2 : Complex) = 0 := eps_val_0 3 3 2 2 (by decide)
lemma e3323 : (epsilon4 3 3 2 3 : Complex) = 0 := eps_val_0 3 3 2 3 (by decide)
lemma e3330 : (epsilon4 3 3 3 0 : Complex) = 0 := eps_val_0 3 3 3 0 (by decide)
lemma e3331 : (epsilon4 3 3 3 1 : Complex) = 0 := eps_val_0 3 3 3 1 (by decide)
lemma e3332 : (epsilon4 3 3 3 2 : Complex) = 0 := eps_val_0 3 3 3 2 (by decide)
lemma e3333 : (epsilon4 3 3 3 3 : Complex) = 0 := eps_val_0 3 3 3 3 (by decide)

-- ============================================================================
-- MAIN THEOREMS
-- ============================================================================

lemma expand_epsilon_complex (f : Fin 4 → Fin 4 → Fin 4 → Fin 4 → Complex) :
  (∑ α : Fin 4, ∑ β : Fin 4, ∑ γ : Fin 4, ∑ δ : Fin 4, (epsilon4 α β γ δ : Complex) * f α β γ δ) =
    f 0 1 2 3 - f 0 1 3 2 - f 0 2 1 3 + f 0 2 3 1 + f 0 3 1 2 - f 0 3 2 1
  - f 1 0 2 3 + f 1 0 3 2 + f 1 2 0 3 - f 1 2 3 0 - f 1 3 0 2 + f 1 3 2 0
  + f 2 0 1 3 - f 2 0 3 1 - f 2 1 0 3 + f 2 1 3 0 + f 2 3 0 1 - f 2 3 1 0
  - f 3 0 1 2 + f 3 0 2 1 + f 3 1 0 2 - f 3 1 2 0 - f 3 2 0 1 + f 3 2 1 0 := by
  simp only [
    sum_fin_4,
    e0000, e0001, e0002, e0003, e0010, e0011, e0012, e0013, e0020, e0021, e0022, e0023, e0030, e0031, e0032, e0033,
    e0100, e0101, e0102, e0103, e0110, e0111, e0112, e0113, e0120, e0121, e0122, e0123, e0130, e0131, e0132, e0133,
    e0200, e0201, e0202, e0203, e0210, e0211, e0212, e0213, e0220, e0221, e0222, e0223, e0230, e0231, e0232, e0233,
    e0300, e0301, e0302, e0303, e0310, e0311, e0312, e0313, e0320, e0321, e0322, e0323, e0330, e0331, e0332, e0333,
    e1000, e1001, e1002, e1003, e1010, e1011, e1012, e1013, e1020, e1021, e1022, e1023, e1030, e1031, e1032, e1033,
    e1100, e1101, e1102, e1103, e1110, e1111, e1112, e1113, e1120, e1121, e1122, e1123, e1130, e1131, e1132, e1133,
    e1200, e1201, e1202, e1203, e1210, e1211, e1212, e1213, e1220, e1221, e1222, e1223, e1230, e1231, e1232, e1233,
    e1300, e1301, e1302, e1303, e1310, e1311, e1312, e1313, e1320, e1321, e1322, e1323, e1330, e1331, e1332, e1333,
    e2000, e2001, e2002, e2003, e2010, e2011, e2012, e2013, e2020, e2021, e2022, e2023, e2030, e2031, e2032, e2033,
    e2100, e2101, e2102, e2103, e2110, e2111, e2112, e2113, e2120, e2121, e2122, e2123, e2130, e2131, e2132, e2133,
    e2200, e2201, e2202, e2203, e2210, e2211, e2212, e2213, e2220, e2221, e2222, e2223, e2230, e2231, e2232, e2233,
    e2300, e2301, e2302, e2303, e2310, e2311, e2312, e2313, e2320, e2321, e2322, e2323, e2330, e2331, e2332, e2333,
    e3000, e3001, e3002, e3003, e3010, e3011, e3012, e3013, e3020, e3021, e3022, e3023, e3030, e3031, e3032, e3033,
    e3100, e3101, e3102, e3103, e3110, e3111, e3112, e3113, e3120, e3121, e3122, e3123, e3130, e3131, e3132, e3133,
    e3200, e3201, e3202, e3203, e3210, e3211, e3212, e3213, e3220, e3221, e3222, e3223, e3230, e3231, e3232, e3233,
    e3300, e3301, e3302, e3303, e3310, e3311, e3312, e3313, e3320, e3321, e3322, e3323, e3330, e3331, e3332, e3333,
    zero_mul, mul_zero, zero_add, add_zero, sub_zero, zero_sub, neg_zero
  ]
  ring

lemma epsilon_det_inner (M : Matrix (Fin 4) (Fin 4) Complex) (μ ν ρ σ : Fin 4) :
  (∑ α : Fin 4, ∑ β : Fin 4, ∑ γ : Fin 4, ∑ δ : Fin 4,
    (epsilon4 α β γ δ : Complex) * M μ α * M ν β * M ρ γ * M σ δ) =
  (epsilon4 μ ν ρ σ : Complex) * M.det := by
  have h_group : (∑ α : Fin 4, ∑ β : Fin 4, ∑ γ : Fin 4, ∑ δ : Fin 4, (epsilon4 α β γ δ : Complex) * M μ α * M ν β * M ρ γ * M σ δ) = (∑ α : Fin 4, ∑ β : Fin 4, ∑ γ : Fin 4, ∑ δ : Fin 4, (epsilon4 α β γ δ : Complex) * (M μ α * M ν β * M ρ γ * M σ δ)) := by
    congr 1; ext α; congr 1; ext β; congr 1; ext γ; congr 1; ext δ; ring
  rw [h_group]
  rw [expand_epsilon_complex (fun α β γ δ => M μ α * M ν β * M ρ γ * M σ δ)]
  rw [Litlib.Math.Matrix4.expand_det_4]
  
  rcases fin4_cases μ with rfl | rfl | rfl | rfl <;>
  rcases fin4_cases ν with rfl | rfl | rfl | rfl <;>
  rcases fin4_cases ρ with rfl | rfl | rfl | rfl <;>
  rcases fin4_cases σ with rfl | rfl | rfl | rfl
  all_goals {
    try simp only [
      e0000, e0001, e0002, e0003, e0010, e0011, e0012, e0013, e0020, e0021, e0022, e0023, e0030, e0031, e0032, e0033,
      e0100, e0101, e0102, e0103, e0110, e0111, e0112, e0113, e0120, e0121, e0122, e0123, e0130, e0131, e0132, e0133,
      e0200, e0201, e0202, e0203, e0210, e0211, e0212, e0213, e0220, e0221, e0222, e0223, e0230, e0231, e0232, e0233,
      e0300, e0301, e0302, e0303, e0310, e0311, e0312, e0313, e0320, e0321, e0322, e0323, e0330, e0331, e0332, e0333,
      e1000, e1001, e1002, e1003, e1010, e1011, e1012, e1013, e1020, e1021, e1022, e1023, e1030, e1031, e1032, e1033,
      e1100, e1101, e1102, e1103, e1110, e1111, e1112, e1113, e1120, e1121, e1122, e1123, e1130, e1131, e1132, e1133,
      e1200, e1201, e1202, e1203, e1210, e1211, e1212, e1213, e1220, e1221, e1222, e1223, e1230, e1231, e1232, e1233,
      e1300, e1301, e1302, e1303, e1310, e1311, e1312, e1313, e1320, e1321, e1322, e1323, e1330, e1331, e1332, e1333,
      e2000, e2001, e2002, e2003, e2010, e2011, e2012, e2013, e2020, e2021, e2022, e2023, e2030, e2031, e2032, e2033,
      e2100, e2101, e2102, e2103, e2110, e2111, e2112, e2113, e2120, e2121, e2122, e2123, e2130, e2131, e2132, e2133,
      e2200, e2201, e2202, e2203, e2210, e2211, e2212, e2213, e2220, e2221, e2222, e2223, e2230, e2231, e2232, e2233,
      e2300, e2301, e2302, e2303, e2310, e2311, e2312, e2313, e2320, e2321, e2322, e2323, e2330, e2331, e2332, e2333,
      e3000, e3001, e3002, e3003, e3010, e3011, e3012, e3013, e3020, e3021, e3022, e3023, e3030, e3031, e3032, e3033,
      e3100, e3101, e3102, e3103, e3110, e3111, e3112, e3113, e3120, e3121, e3122, e3123, e3130, e3131, e3132, e3133,
      e3200, e3201, e3202, e3203, e3210, e3211, e3212, e3213, e3220, e3221, e3222, e3223, e3230, e3231, e3232, e3233,
      e3300, e3301, e3302, e3303, e3310, e3311, e3312, e3313, e3320, e3321, e3322, e3323, e3330, e3331, e3332, e3333,
      zero_mul, mul_zero, zero_add, add_zero, sub_zero, zero_sub, neg_zero
    ] <;> try ring
  }

/-- 🔵 ALGEBRAIC: Epsilon-Determinant Theorem -/
theorem epsilon_det_formula (M : Matrix (Fin 4) (Fin 4) Complex) :
  M.det = (1 / 24 : Complex) * ∑ μ : Fin 4, ∑ ν : Fin 4, ∑ ρ : Fin 4, ∑ σ : Fin 4,
    ∑ α : Fin 4, ∑ β : Fin 4, ∑ γ : Fin 4, ∑ δ : Fin 4,
      (epsilon4 μ ν ρ σ : Complex) * (epsilon4 α β γ δ : Complex) * M μ α * M ν β * M ρ γ * M σ δ := by
  have h_inner : ∀ μ ν ρ σ, (∑ α : Fin 4, ∑ β : Fin 4, ∑ γ : Fin 4, ∑ δ : Fin 4, (epsilon4 μ ν ρ σ : Complex) * (epsilon4 α β γ δ : Complex) * M μ α * M ν β * M ρ γ * M σ δ) = ((epsilon4 μ ν ρ σ : Complex) * (epsilon4 μ ν ρ σ : Complex)) * M.det := by
    intro μ ν ρ σ
    calc
      (∑ α : Fin 4, ∑ β : Fin 4, ∑ γ : Fin 4, ∑ δ : Fin 4, (epsilon4 μ ν ρ σ : Complex) * (epsilon4 α β γ δ : Complex) * M μ α * M ν β * M ρ γ * M σ δ)
      _ = ∑ α : Fin 4, ∑ β : Fin 4, ∑ γ : Fin 4, ∑ δ : Fin 4, (epsilon4 μ ν ρ σ : Complex) * ((epsilon4 α β γ δ : Complex) * M μ α * M ν β * M ρ γ * M σ δ) := by
        congr 1; ext α; congr 1; ext β; congr 1; ext γ; congr 1; ext δ; ring
      _ = (epsilon4 μ ν ρ σ : Complex) * ∑ α : Fin 4, ∑ β : Fin 4, ∑ γ : Fin 4, ∑ δ : Fin 4, (epsilon4 α β γ δ : Complex) * M μ α * M ν β * M ρ γ * M σ δ := by
        simp_rw [← Finset.mul_sum]
      _ = (epsilon4 μ ν ρ σ : Complex) * ((epsilon4 μ ν ρ σ : Complex) * M.det) := by rw [epsilon_det_inner M μ ν ρ σ]
      _ = ((epsilon4 μ ν ρ σ : Complex) * (epsilon4 μ ν ρ σ : Complex)) * M.det := by ring

  have h_contract : (∑ μ : Fin 4, ∑ ν : Fin 4, ∑ ρ : Fin 4, ∑ σ : Fin 4, (epsilon4 μ ν ρ σ : Complex) * (epsilon4 μ ν ρ σ : Complex)) = 24 := by
    simp only [
      sum_fin_4,
      e0000, e0001, e0002, e0003, e0010, e0011, e0012, e0013, e0020, e0021, e0022, e0023, e0030, e0031, e0032, e0033,
      e0100, e0101, e0102, e0103, e0110, e0111, e0112, e0113, e0120, e0121, e0122, e0123, e0130, e0131, e0132, e0133,
      e0200, e0201, e0202, e0203, e0210, e0211, e0212, e0213, e0220, e0221, e0222, e0223, e0230, e0231, e0232, e0233,
      e0300, e0301, e0302, e0303, e0310, e0311, e0312, e0313, e0320, e0321, e0322, e0323, e0330, e0331, e0332, e0333,
      e1000, e1001, e1002, e1003, e1010, e1011, e1012, e1013, e1020, e1021, e1022, e1023, e1030, e1031, e1032, e1033,
      e1100, e1101, e1102, e1103, e1110, e1111, e1112, e1113, e1120, e1121, e1122, e1123, e1130, e1131, e1132, e1133,
      e1200, e1201, e1202, e1203, e1210, e1211, e1212, e1213, e1220, e1221, e1222, e1223, e1230, e1231, e1232, e1233,
      e1300, e1301, e1302, e1303, e1310, e1311, e1312, e1313, e1320, e1321, e1322, e1323, e1330, e1331, e1332, e1333,
      e2000, e2001, e2002, e2003, e2010, e2011, e2012, e2013, e2020, e2021, e2022, e2023, e2030, e2031, e2032, e2033,
      e2100, e2101, e2102, e2103, e2110, e2111, e2112, e2113, e2120, e2121, e2122, e2123, e2130, e2131, e2132, e2133,
      e2200, e2201, e2202, e2203, e2210, e2211, e2212, e2213, e2220, e2221, e2222, e2223, e2230, e2231, e2232, e2233,
      e2300, e2301, e2302, e2303, e2310, e2311, e2312, e2313, e2320, e2321, e2322, e2323, e2330, e2331, e2332, e2333,
      e3000, e3001, e3002, e3003, e3010, e3011, e3012, e3013, e3020, e3021, e3022, e3023, e3030, e3031, e3032, e3033,
      e3100, e3101, e3102, e3103, e3110, e3111, e3112, e3113, e3120, e3121, e3122, e3123, e3130, e3131, e3132, e3133,
      e3200, e3201, e3202, e3203, e3210, e3211, e3212, e3213, e3220, e3221, e3222, e3223, e3230, e3231, e3232, e3233,
      e3300, e3301, e3302, e3303, e3310, e3311, e3312, e3313, e3320, e3321, e3322, e3323, e3330, e3331, e3332, e3333,
      zero_mul, mul_zero, zero_add, add_zero, sub_zero, zero_sub, neg_zero
    ]
    norm_num

  calc
    M.det = (1 / 24 : Complex) * (24 * M.det) := by ring
    _ = (1 / 24 : Complex) * ((∑ μ : Fin 4, ∑ ν : Fin 4, ∑ ρ : Fin 4, ∑ σ : Fin 4, (epsilon4 μ ν ρ σ : Complex) * (epsilon4 μ ν ρ σ : Complex)) * M.det) := by rw [← h_contract]
    _ = (1 / 24 : Complex) * ∑ μ : Fin 4, ∑ ν : Fin 4, ∑ ρ : Fin 4, ∑ σ : Fin 4, (epsilon4 μ ν ρ σ : Complex) * (epsilon4 μ ν ρ σ : Complex) * M.det := by simp_rw [Finset.sum_mul]
    _ = (1 / 24 : Complex) * ∑ μ : Fin 4, ∑ ν : Fin 4, ∑ ρ : Fin 4, ∑ σ : Fin 4, ∑ α : Fin 4, ∑ β : Fin 4, ∑ γ : Fin 4, ∑ δ : Fin 4, (epsilon4 μ ν ρ σ : Complex) * (epsilon4 α β γ δ : Complex) * M μ α * M ν β * M ρ γ * M σ δ := by simp_rw [← h_inner]

end Litlib.Math.EpsilonDeterminant
