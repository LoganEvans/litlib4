-- FILENAME: lakefile.lean

import Lake
open Lake DSL

package "litlib4" where
  -- We rely on standard Lean 4 compiler diagnostics here.
  -- The litlib_run bash script handles filtering the `sorry` traces.

require mathlib from git
  "https://github.com/leanprover-community/mathlib4.git" @ "v4.29.1"

@[default_target]
lean_lib «Litlib» where
  roots := #[]
  globs := #[.submodules `Litlib]

@[default_target]
lean_exe "litlib_report" where
  root := `litlib_report
