-- FILENAME: litlib_report.lean

import Litlib.Core
import Litlib.Cli.Runner
import Lean

open Lean

/-!
# Litlib4 Report CLI
Executable for tracking, extracting, and reporting on litlib4 metadata.
This file acts as the default `litlib_report` binary, analyzing the `Litlib` module itself.

Downstream packages (like CGD) should create their own `Main.lean` and call:
`Litlib.Cli.Runner.runCli \`DownstreamName args`
-/

def main (args : List String) : IO UInt32 := do
  Litlib.Cli.Runner.runCli `Litlib args
