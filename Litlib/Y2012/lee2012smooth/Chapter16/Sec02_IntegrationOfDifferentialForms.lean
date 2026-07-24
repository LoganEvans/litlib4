-- FILENAME: Litlib/Y2012/lee2012smooth/Chapter16/Sec02_IntegrationOfDifferentialForms.lean

import Mathlib
import Litlib.Core

set_option linter.unusedVariables false

namespace Litlib.Y2012.lee2012smooth

-- Hardcoded definitions outside the class prevent default override exploits.
noncomputable def example16_9_F (φ θ : ℝ) : Fin 3 → ℝ :=
  ![Real.sin φ * Real.cos θ, Real.sin φ * Real.sin θ, Real.cos φ]

noncomputable def example16_9_omega (p v1 v2 : Fin 3 → ℝ) : ℝ :=
  p 0 * (v1 1 * v2 2 - v1 2 * v2 1) +
  p 1 * (v1 2 * v2 0 - v1 0 * v2 2) +
  p 2 * (v1 0 * v2 1 - v1 1 * v2 0)

noncomputable def example16_9_dF_dφ (φ θ : ℝ) : Fin 3 → ℝ :=
  ![Real.cos φ * Real.cos θ, Real.cos φ * Real.sin θ, -Real.sin φ]

noncomputable def example16_9_dF_dθ (φ θ : ℝ) : Fin 3 → ℝ :=
  ![-Real.sin φ * Real.sin θ, Real.sin φ * Real.cos θ, 0]

Litlib.equation "lee2012smooth" eq "16.9" page "409" kind "example"
class Example_16_9
  where
  -- F^* ω = sin(φ) dφ ^ dθ
  pullbackEval : ∀ φ θ,
    example16_9_omega (example16_9_F φ θ) (example16_9_dF_dφ φ θ) (example16_9_dF_dθ φ θ) = Real.sin φ
    
  -- Integral formulation explicitly matching 4π
  integralVal :
    (∫ φ in (0)..(Real.pi), ∫ θ in (0)..(2 * Real.pi), Real.sin φ) = 4 * Real.pi

end Litlib.Y2012.lee2012smooth
