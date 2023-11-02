//a08 Visualize a selected scheme
with 3 as num_decays, 7 as excited_state_id
match (s1)-[r2]->(s2) where s1.id = excited_state_id

with s1, collect(r2.branching_ratio) as list, num_decays as num_decays, excited_state_id as excited_state_id
with s1, apoc.coll.min(apoc.coll.reverse(apoc.coll.sort(list))[0..num_decays]) as minimal_considered_BR_per_scheme, num_decays as num_decays, excited_state_id as excited_state_id

match p = (s1)-[r2]->(s2) where s1.id = excited_state_id and r2.branching_ratio >= minimal_considered_BR_per_scheme
return p