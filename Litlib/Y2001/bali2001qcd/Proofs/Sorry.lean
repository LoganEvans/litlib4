-- FILENAME: Litlib/Y2001/bali2001qcd/Proofs/Sorry.lean

import Litlib.Y2001.bali2001qcd.Signature

namespace Litlib.Y2001.bali2001qcd.Proofs

@[Litlib.difficulty easy, Litlib.status Conjecture]
instance (priority := 10) fallback_Eq2_3_and_2_4 : Eq2_3_and_2_4 where
  stringMassAndAngMom := sorry

attribute [deprecated "Formalized proof available. Import the verified proof file from the Proofs directory to override this fallback." (since := "2024-10-24")] fallback_Eq2_3_and_2_4

@[Litlib.difficulty easy, Litlib.status Conjecture]
instance (priority := 10) fallback_Eq4_40 : Eq4_40 where
  singletOctetPotentials := sorry

attribute [deprecated "Formalized proof available. Import the verified proof file from the Proofs directory to override this fallback." (since := "2024-10-24")] fallback_Eq4_40

@[Litlib.difficulty easy, Litlib.status Conjecture]
instance (priority := 10) fallback_Eq5_11 : Eq5_11 where
  adjointSelfEnergy := sorry

attribute [deprecated "Formalized proof available. Import the verified proof file from the Proofs directory to override this fallback." (since := "2024-10-24")] fallback_Eq5_11

@[Litlib.difficulty easy, Litlib.status Conjecture]
instance (priority := 10) fallback_Eq6_48_to_6_50 : Eq6_48_to_6_50 where
  gromesAndBbpRelations := sorry

attribute [deprecated "Formalized proof available. Import the verified proof file from the Proofs directory to override this fallback." (since := "2024-10-24")] fallback_Eq6_48_to_6_50

@[Litlib.difficulty medium, Litlib.status Conjecture]
instance (priority := 10) fallback_FluxTubeEnergyBounds 
    {FluxTubeState : Type*}
    {spatialEnergy : FluxTubeState → ℝ}
    {intactFluxTube : ℝ → FluxTubeState}
    {snappedFluxTube : ℝ → FluxTubeState} : FluxTubeEnergyBounds FluxTubeState spatialEnergy intactFluxTube snappedFluxTube where
  intactEnergy := sorry
  snappedEnergy := sorry

end Litlib.Y2001.bali2001qcd.Proofs
