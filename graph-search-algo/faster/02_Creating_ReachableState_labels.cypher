//02 Creating ReachableState labels
CALL apoc.periodic.iterate(
  "match (s1:ReachableExcitedState)-[r:DECAY]->(s2) where not s2:ReachableState return s2",
  "set s2:ReachableState",
  {batchSize:10000, parallel:false})