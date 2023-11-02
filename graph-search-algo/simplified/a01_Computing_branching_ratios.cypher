//a01 Computing branching ratios
match (s1)-[r:DECAY]->()
with s1, sum(r.Einstein_coeff) as DECAYS_SUM
match (s1)-[r1:DECAY]->(s2)
set r1.branching_ratio = r1.Einstein_coeff/DECAYS_SUM
return count(r1)