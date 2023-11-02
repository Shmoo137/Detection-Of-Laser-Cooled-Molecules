// 06 Computing branching ratios for ReachableExcitedState
CALL apoc.periodic.iterate(
  "match (s1:ReachableExcitedState)-[r:DECAY]->(:ReachableState) return s1, sum(r.Einstein_coeff) as DECAYS_SUM",
  "match(s1:ReachableExcitedState)-[r1:DECAY]->(s2:ReachableState) return r1, DECAYS_SUM as DECAYS_SUM",
  "set r1.branching_ratio = r1.Einstein_coeff/DECAYS_SUM",
  {batchSize:5000, parallel:false})