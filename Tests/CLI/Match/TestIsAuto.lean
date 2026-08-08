-- FILENAME: Tests/CLI/Match/TestIsAuto.lean

import Litlib.Core.CLI.CodeSummary
open Litlib.Core.CLI

-- Real theorems must pass
#guard isAuto `CGK.Axioms.Ontology == false
#guard isAuto `CGK.Foundations.kinematicBianchiIdentity == false

-- Boilerplate must be blocked
#guard isAuto `CGK.Axioms.Ontology.instDecidableEq == true
#guard isAuto `CGK.Axioms.instInhabitedSpacetime == true
#guard isAuto `CGK.Axioms.Ontology._aux_1 == true
#guard isAuto `CGK.Axioms.Ontology.eq_1 == true
#guard isAuto `CGK.Axioms.Ontology.mk == true
