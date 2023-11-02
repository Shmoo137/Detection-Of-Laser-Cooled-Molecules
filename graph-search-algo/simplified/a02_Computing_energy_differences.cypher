//a02 Computing energy differences
match (s1)-[r:DECAY]->(s2)
set r.energy_diff = 10000000/(s1.energy-s2.energy)
return count(r)