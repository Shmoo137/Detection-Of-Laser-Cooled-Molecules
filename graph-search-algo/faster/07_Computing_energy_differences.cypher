// 07 Computing energy differences
CALL apoc.periodic.iterate(
  "match (s1:ReachableExcitedState)-[r:DECAY]->(s2:ReachableState) return s1, r, s2",
  "set r.energy_diff = 10000000/(s1.energy-s2.energy)",
  {batchSize:1000, parallel:false})