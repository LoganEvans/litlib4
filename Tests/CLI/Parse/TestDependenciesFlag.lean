-- FILENAME: @litlib4/Tests/CLI/Parse/TestDependenciesFlag.lean

import Litlib.Core.CLI
open Litlib.Core.CLI

-- 1. Default invocation: bare --dependencies defaults to dependencies.dot in dot format
#guard (parseArgs ["--dependencies"]).action == "dependencies"
#guard (parseArgs ["--dependencies"]).dependenciesOut == some "dependencies.dot"
#guard (parseArgs ["--dependencies"]).dependenciesFormat == "dot"

-- 2. Explicit .dot target file
#guard (parseArgs ["--dependencies=output/graph.dot"]).action == "dependencies"
#guard (parseArgs ["--dependencies=output/graph.dot"]).dependenciesOut == some "output/graph.dot"
#guard (parseArgs ["--dependencies=output/graph.dot"]).dependenciesFormat == "dot"

-- 3. Explicit .json target file
#guard (parseArgs ["--dependencies=deps.json"]).action == "dependencies"
#guard (parseArgs ["--dependencies=deps.json"]).dependenciesOut == some "deps.json"
#guard (parseArgs ["--dependencies=deps.json"]).dependenciesFormat == "json"

-- 4. Invalid extension handling: rejected with error
#guard (parseArgs ["--dependencies=invalid.xml"]).action == "error"
