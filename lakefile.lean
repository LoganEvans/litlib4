-- FILENAME: lakefile.lean

import Lake
open Lake DSL

package "litlib4" where
  -- Settings for litlib4
  -- Strict compilation to ensure signatures are mathematically sound
  moreLeanArgs := #["-DwarningAsError=true"]

require mathlib from git
  "https://github.com/leanprover-community/mathlib4.git"

@[default_target]
lean_lib «Litlib» where
  -- Core library containing all literature axioms and proofs

lean_exe "litlib_report" where
  root := `litlib_report
