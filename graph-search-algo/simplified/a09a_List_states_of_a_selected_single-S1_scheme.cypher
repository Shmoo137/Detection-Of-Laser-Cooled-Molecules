//a09a List states of a selected single-S1 scheme
with 11 as num_decays, 29 as excited_state_id
match (s1)-[r2]->(s2) where s1.id = excited_state_id

with s1, collect(r2.branching_ratio) as list, num_decays as num_decays, excited_state_id as excited_state_id
with s1, apoc.coll.min(apoc.coll.reverse(apoc.coll.sort(list))[0..num_decays]) as minimal_considered_BR_per_scheme, num_decays as num_decays, excited_state_id as excited_state_id

match (s1)-[r2]->(s2) where s1.id = excited_state_id and r2.branching_ratio >= minimal_considered_BR_per_scheme

with apoc.coll.sort(apoc.coll.toSet(apoc.coll.flatten(collect(s1.id) + collect(DISTINCT s2.id)))) as all_ids

unwind all_ids as id

match (s) where s.id = id

return s.id, s{.*}