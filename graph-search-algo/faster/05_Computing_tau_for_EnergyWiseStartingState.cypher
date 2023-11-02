// 05 Computing tau for EnergyWiseStartingState
CALL apoc.periodic.iterate(
  "match (s0:EnergyWiseStartingState)-[r:DECAY]->() where not s0:GroundOrMetastable return s0, sum(r.Einstein_coeff) as DECAYS_SUM",
  "set s0.tau = 1/DECAYS_SUM",
  {batchSize:1000, parallel:false})