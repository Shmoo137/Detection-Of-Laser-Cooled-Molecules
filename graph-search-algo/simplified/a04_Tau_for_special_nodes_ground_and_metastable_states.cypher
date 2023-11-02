//a04 Tau for special nodes - ground and metastable states
match (s1) where not (s1)-[:DECAY]->()
set s1.tau=1000
return count(s1)