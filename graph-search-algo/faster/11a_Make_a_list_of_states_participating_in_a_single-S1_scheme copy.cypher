//11a Make a list of states participating in a single-S1 scheme
with 6 as num_decays, "1832" as excited_state_id
match (s1:ReachableExcitedState)-[r2:DECAY]->(s2:ReachableState) where s1.id = excited_state_id

with s1, collect(r2.branching_ratio) as list, num_decays as num_decays, excited_state_id as excited_state_id
with s1, apoc.coll.min(apoc.coll.reverse(apoc.coll.sort(list))[0..num_decays]) as minimal_considered_BR_per_scheme, num_decays as num_decays, excited_state_id as excited_state_id

match (s1:ReachableExcitedState)-[r2:DECAY]->(s2:ReachableState) where s1.id = excited_state_id and r2.branching_ratio >= minimal_considered_BR_per_scheme

with apoc.coll.sort(apoc.coll.toSet(apoc.coll.flatten(collect(DISTINCT s1.id) + collect(DISTINCT s2.id)))) as all_ids

unwind all_ids as id

match (s) where s.id = id

return s.id, s{.*}