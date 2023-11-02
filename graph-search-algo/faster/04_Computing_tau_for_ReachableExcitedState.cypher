// 04 Computing tau for ReachableExcitedState
CALL apoc.periodic.iterate(
  "match (s1:ReachableExcitedState)-[r:DECAY]->(:ReachableState) return s1, sum(r.Einstein_coeff) as DECAYS_SUM",
  "set s1.tau = 1/DECAYS_SUM",
  {batchSize:10000, parallel:false})