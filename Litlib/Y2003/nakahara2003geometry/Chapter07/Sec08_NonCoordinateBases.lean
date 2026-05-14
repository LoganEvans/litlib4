-- FILENAME: Litlib/Y2003/nakahara2003geometry/Chapter07/Sec08_NonCoordinateBases.lean

import Litlib.Core
import Mathlib.Algebra.Group.Basic
import Mathlib.Algebra.BigOperators.Group.Finset.Basic
import Mathlib.Data.Fintype.Basic

open BigOperators

namespace Litlib.Y2003.nakahara2003geometry

Litlib.equation "nakahara2003geometry"
  eq "7.146a"
  page "42"
  kind "equation"
class CartanFirstStructureEquation 
    (Form Index : Type _) [AddCommGroup Form] [Nonempty Form] [Fintype Index]
    (exteriorDeriv : Form → Form)
    (wedge : Form → Form → Form)
    (theta T : Index → Form)
    (omega : Index → Index → Form) where
  cartanFirstStructureEq
    (alpha : Index) :
    T alpha = exteriorDeriv (theta alpha) + ∑ beta, wedge (omega alpha beta) (theta beta)

Litlib.equation "nakahara2003geometry"
  eq "7.146b"
  page "42"
  kind "equation"
class CartanSecondStructureEquation 
    (Form Index : Type _) [AddCommGroup Form] [Nonempty Form] [Fintype Index]
    (exteriorDeriv : Form → Form)
    (wedge : Form → Form → Form)
    (omega R : Index → Index → Form) where
  cartanSecondStructureEq
    (alpha beta : Index) :
    R alpha beta = exteriorDeriv (omega alpha beta) + ∑ gamma, wedge (omega alpha gamma) (omega gamma beta)

Litlib.equation "nakahara2003geometry"
  eq "7.147b"
  page "42"
  kind "equation"
class BianchiIdentity 
    (Form Index : Type _) [AddCommGroup Form] [Nonempty Form] [Fintype Index]
    (exteriorDeriv : Form → Form)
    (wedge : Form → Form → Form)
    (omega R : Index → Index → Form) where
  bianchiIdentity
    (alpha beta : Index) :
    exteriorDeriv (R alpha beta) + 
      (∑ gamma, wedge (omega alpha gamma) (R gamma beta)) - 
      (∑ gamma, wedge (R alpha gamma) (omega gamma beta)) = 0

end Litlib.Y2003.nakahara2003geometry
