//10b Visualize a selected double-S2 scheme
with 8 as num_decays_per_subscheme, "172" as s1_id, "184" as s1prim_id, 250 as min_laser_nm, 5500 as max_laser_nm, 1e-8 as br_cutoff, 20 as max_J

match (s1prim:doubleS1Candidates)-[r12prim:DECAY]->(s2:doubleS2Candidates)<-[r12:DECAY]-(s1:doubleS1Candidates) where s1.id = s1_id and s1prim.id = s1prim_id and r12.energy_diff > min_laser_nm and r12.energy_diff < max_laser_nm and r12prim.energy_diff > min_laser_nm and r12prim.energy_diff < max_laser_nm

with s1.id as s1_id, s1prim.id as s1prim_id, collect(r12.branching_ratio) as br12_list, collect(r12prim.branching_ratio) as br12prim_list, num_decays_per_subscheme as num_decays_per_subscheme, min_laser_nm as min_laser_nm, max_laser_nm as max_laser_nm

with s1_id as s1_id, s1prim_id as s1prim_id, apoc.coll.min(reverse(apoc.coll.sort(br12_list))[0..num_decays_per_subscheme]) as minimal_considered_BR_per_scheme, apoc.coll.min(reverse(apoc.coll.sort(br12prim_list))[0..num_decays_per_subscheme]) as minimal_considered_BRprim_per_scheme, min_laser_nm as min_laser_nm, max_laser_nm as max_laser_nm

match p = (s1prim:doubleS1Candidates)-[r12prim:DECAY]->(s2:doubleS2Candidates)<-[r12:DECAY]-(s1:doubleS1Candidates) where s1.id = s1_id and s1prim.id = s1prim_id and r12.energy_diff > min_laser_nm and r12.energy_diff < max_laser_nm and r12.branching_ratio >= minimal_considered_BR_per_scheme and r12prim.energy_diff > min_laser_nm and r12prim.energy_diff < max_laser_nm and r12prim.branching_ratio >= minimal_considered_BRprim_per_scheme

return p