//a03 Computing tau
match (s1)-[r:DECAY]->()
with s1, sum(r.Einstein_coeff) as DECAYS_SUM
set s1.tau = 1/DECAYS_SUM
return count(s1)