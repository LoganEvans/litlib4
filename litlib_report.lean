-- FILENAME: litlib_report.lean

import Litlib.Core.CLI

def main (args : List String) : IO UInt32 := do
  -- Defaulting to tracking the `Litlib` namespace root for this executable
  Litlib.Core.CLI.runCli `Litlib args
