-- FILENAME: Tests/CLI/Match/TestGlob.lean

import Litlib.Core.CLI.Engine
open Litlib.Core.CLI

#guard matchesAnyGlob [] "CGK.Axioms.Ontology" == false
#guard matchesAnyGlob ["all"] "CGK.Axioms.Ontology" == true
#guard matchesAnyGlob ["CGK.*"] "CGK.Axioms.Ontology" == true
#guard matchesAnyGlob ["Mathlib.*"] "CGK.Axioms.Ontology" == false
