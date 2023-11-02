//10 Visualize a scheme
with 6 as num_decays, "1832" as excited_state_id
match (s1:ReachableExcitedState)-[r2:DECAY]->(s2:ReachableState) where s1.id = excited_state_id

with s1, collect(r2.branching_ratio) as list, num_decays as num_decays, excited_state_id as excited_state_id
with s1, apoc.coll.min(apoc.coll.reverse(apoc.coll.sort(list))[0..num_decays]) as minimal_considered_BR_per_scheme, num_decays as num_decays, excited_state_id as excited_state_id

match p = (s1:ReachableExcitedState)-[r2:DECAY]->(s2:ReachableState) where s1.id = excited_state_id and r2.branching_ratio >= minimal_considered_BR_per_scheme
return p