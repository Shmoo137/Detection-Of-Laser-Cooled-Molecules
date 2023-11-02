// 05 Computing tau for ReachableState
CALL apoc.periodic.iterate(
  "match (s2:ReachableState)-[r:DECAY]->() where not s2:GroundOrMetastable return s2, sum(r.Einstein_coeff) as DECAYS_SUM",
  "set s2.tau = 1/DECAYS_SUM",
  {batchSize:5000, parallel:false})