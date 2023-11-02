// 03 Find ground and metastable states and set tau
CALL apoc.periodic.iterate(
  "match (s2:ReachableState) where not (s2)-[:DECAY]->() return s2",
  "set s2:GroundOrMetastable, s2.tau=1000",
  {batchSize:1000, parallel:false})