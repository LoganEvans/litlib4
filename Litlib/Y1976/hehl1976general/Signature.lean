-- FILENAME: Litlib/Y1976/hehl1976general/Signature.lean

import Litlib.Core
import Mathlib.Analysis.Calculus.Deriv.Basic

namespace Litlib.Y1976.hehl1976general

Litlib.paper "hehl1976general"
  type "article"
  title "General relativity with spin and torsion: Foundations and prospects"
  authors ["Hehl, F. W.", "von der Heyde, P.", "Kerlick, G. D.", "Nester, J. M."]
  journal "Rev. Mod. Phys."
  year "1976"

Litlib.equation "hehl1976general" eq "2.15" page "397" kind "definition"
class Eq2_15
  (Gamma : (Fin 4 → ℝ) → Fin 4 → Fin 4 → Fin 4 → ℝ)
  (x : ℝ → Fin 4 → ℝ)
  (hx : ∀ k, Differentiable ℝ (fun s => x s k))
  (hx' : ∀ k, Differentiable ℝ (fun s => deriv (fun s'' => x s'' k) s))
  : Prop where
  autoparallel : ∀ (s : ℝ) (k : Fin 4),
    deriv (fun s' => deriv (fun s'' => x s'' k) s') s +
    ∑ i : Fin 4, ∑ j : Fin 4,
      Gamma (x s) k i j * deriv (fun s' => x s' i) s * deriv (fun s' => x s' j) s = 0

Litlib.equation "hehl1976general" eq "2.16" page "398" kind "definition"
class Eq2_16
  (christoffel : (Fin 4 → ℝ) → Fin 4 → Fin 4 → Fin 4 → ℝ)
  (x : ℝ → Fin 4 → ℝ)
  (hx : ∀ k, Differentiable ℝ (fun s => x s k))
  (hx' : ∀ k, Differentiable ℝ (fun s => deriv (fun s'' => x s'' k) s))
  : Prop where
  extremal : ∀ (s : ℝ) (k : Fin 4),
    deriv (fun s' => deriv (fun s'' => x s'' k) s') s +
    ∑ i : Fin 4, ∑ j : Fin 4,
      christoffel (x s) k i j * deriv (fun s' => x s' i) s * deriv (fun s' => x s' j) s = 0

end Litlib.Y1976.hehl1976general
