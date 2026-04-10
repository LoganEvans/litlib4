-- FILENAME: lakefile.lean

import Lake
open Lake DSL

package "litlib4" where
  moreLeanArgs := #["-DwarningAsError=true"]

require mathlib from git
  "https://github.com/leanprover-community/mathlib4.git"

@[default_target]
lean_lib «Litlib» where
  -- This tells Lake to recursively search the Litlib/ directory and 
  -- compile every .lean file it finds. No root index file required!
  globs := #[.andSubmodules `Litlib]

lean_exe "litlib_report" where
  root := `litlib_report
