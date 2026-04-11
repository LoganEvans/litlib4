-- FILENAME: Litlib/Y1978/atiyah1978construction/Signature.lean

import Litlib.Core
import Mathlib.Data.Complex.Basic
import Mathlib.Algebra.Module.Basic

namespace Litlib.Y1978.atiyah1978construction

literature_axiom Page185Algebra
  bibtex_key "atiyah1978construction"
  doi "10.1016/0375-9601(78)90141-X"
  authors["Atiyah, M.F.", "Hitchin, N.J.", "Drinfeld, V.G.", "Manin, Yu.I."]
  status Standard
class Page185Algebra where
  /--
  The core linear algebra lemma on page 185:
  If B is a skew form, σ_V is an antilinear map with σ_V^2 = -1, and the induced 
  hermitian form H(u, v) = B(u, σ_V v) is positive definite, then for any subspace Uz, 
  if U_σz = σ_V(Uz), the intersection of the annihilator (Uz)^0 and U_σz is trivial.
  
  This algebraic result ensures that the "real" lines of P3(C) are never jumping lines,
  forming the topological foundation of the ADHM instanton construction.
  -/
  jumping_lines_trivial
    (V : Type*) [AddCommGroup V][Module ℂ V]
    (B : V → V → ℂ)
    (hB_lin1 : ∀ u1 u2 v : V, ∀ c : ℂ, B (c • u1 + u2) v = c * B u1 v + B u2 v)
    (hB_lin2 : ∀ u v1 v2 : V, ∀ c : ℂ, B u (c • v1 + v2) = c * B u v1 + B u v2)
    (hB_skew : ∀ v w : V, B v w = - B w v)
    (σ_V : V → V)
    (hσ_V_add : ∀ v1 v2 : V, σ_V (v1 + v2) = σ_V v1 + σ_V v2)
    (hσ_V_smul : ∀ c : ℂ, ∀ v : V, σ_V (c • v) = star c • σ_V v)
    (hσ_V_inv : ∀ v : V, σ_V (σ_V v) = -v)
    (hB_σ : ∀ v1 v2 : V, B (σ_V v1) (σ_V v2) = star (B v1 v2))
    (h_pos_def : ∀ v : V, v ≠ 0 → (B v (σ_V v)).re > 0 ∧ (B v (σ_V v)).im = 0)
    (Uz : Set V)
    (v : V)
    (hv_in_U_σz : ∃ u ∈ Uz, σ_V u = v)
    (hv_in_Uz_annihilator : ∀ u ∈ Uz, B u v = 0) :
    v = 0
