//11b Make a list of states participating in a double-S1 scheme
with 5 as num_decays_per_subscheme, 428 as s0_id, 734 as s1_id, 728 as s1prim_id, 250 as min_laser_nm, 10000 as max_laser_nm, 1e-7 as br_cutoff, 4 as max_J

match (s2:ReachableState)<-[r12prim:DECAY]-(s1prim:ReachableExcitedState)-[r10prim:DECAY]->(s0:EnergyWiseStartingState)<-[r10:DECAY]-(s1:ReachableExcitedState)-[r12:DECAY]->(s2:ReachableState) where s0.id = s0_id and s1.id = s1_id and s1prim.id = s1prim_id and r12.energy_diff > min_laser_nm and r12.energy_diff < max_laser_nm and r12.branching_ratio > br_cutoff and r12prim.energy_diff > min_laser_nm and r12prim.energy_diff < max_laser_nm and r12prim.branching_ratio > br_cutoff and s2.J < max_J

with s0, s1, r10, s1prim, r10prim, collect(r12.branching_ratio) as br12_list, collect(r12prim.branching_ratio) as br12prim_list, num_decays_per_subscheme as num_decays_per_subscheme,  min_laser_nm as min_laser_nm, max_laser_nm as max_laser_nm, br_cutoff as br_cutoff, max_J as max_J

with s0, s1, r10, s1prim, r10prim, apoc.coll.min(reverse(apoc.coll.sort(br12_list))[0..num_decays_per_subscheme-1]) as minimal_considered_BR_per_scheme, apoc.coll.min(reverse(apoc.coll.sort(br12prim_list))[0..num_decays_per_subscheme-1]) as minimal_considered_BRprim_per_scheme, min_laser_nm as min_laser_nm, max_laser_nm as max_laser_nm, br_cutoff as br_cutoff, max_J as max_J

match p = (s2:ReachableState)<-[r12prim:DECAY]-(s1prim:ReachableExcitedState)-[r10prim:DECAY]->(s0:EnergyWiseStartingState)<-[r10:DECAY]-(s1:ReachableExcitedState)-[r12:DECAY]->(s2:ReachableState) where r12.energy_diff > min_laser_nm and r12.energy_diff < max_laser_nm and r12.branching_ratio >= minimal_considered_BR_per_scheme and r12prim.energy_diff > min_laser_nm and r12prim.energy_diff < max_laser_nm and r12prim.branching_ratio >= minimal_considered_BRprim_per_scheme and s2.J < max_J

with apoc.coll.sort(apoc.coll.toSet(apoc.coll.flatten(collect(DISTINCT s0_id) + collect(DISTINCT s1_id) + collect(DISTINCT s1prim_id) + collect(DISTINCT s2_ids)))) as all_ids

unwind all_ids as id

match (s) where s.id = id

return s.id, s{.*}