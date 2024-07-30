// 08b1 Label candidates for S1s and S2s in double-S1 schemes - needs to be run for all potential num_decays
with 4 as num_decays, 800 as initial_energy, 250 as min_laser_nm, 5500 as max_laser_nm, 1e-8 as br_cutoff, 20 as max_J

//// Finding reachable starting stable states (depending on T_init) and connected excited states
match (s0:EnergyWiseStartingState)<-[r1:DECAY]-(s1:ReachableExcitedState) where r1.energy_diff > min_laser_nm and r1.energy_diff < max_laser_nm and s1.J < max_J
with s1, apoc.coll.max([4, s0.energy*0.62485285866738]) as initial_temp, s0.id as starting_id, num_decays as num_decays, min_laser_nm as min_laser_nm, max_laser_nm as max_laser_nm, br_cutoff as br_cutoff, max_J as max_J

//// Finding largest decay channels up to "num_decays" of each starting excited state and calculating parameters of the resulting cooling schemes
match (s1:ReachableExcitedState)-[r2:DECAY]->(s2:ReachableState) where r2.energy_diff > min_laser_nm and r2.energy_diff < max_laser_nm and s2.J < max_J and r2.branching_ratio > br_cutoff

with s1, collect(r2.branching_ratio) as br_list, num_decays as num_decays, initial_temp as initial_temp, starting_id as starting_id, min_laser_nm as min_laser_nm, max_laser_nm as max_laser_nm, br_cutoff as br_cutoff, max_J as max_J
with s1, apoc.coll.min(apoc.coll.reverse(apoc.coll.sort(br_list))[0..num_decays]) as minimal_considered_BR_per_scheme, initial_temp as initial_temp, starting_id as starting_id, min_laser_nm as min_laser_nm, max_laser_nm as max_laser_nm, br_cutoff as br_cutoff, max_J as max_J

match (s1:ReachableExcitedState)-[r2:DECAY]->(s2:ReachableState) where r2.energy_diff > min_laser_nm and r2.energy_diff < max_laser_nm and s2.J < max_J and r2.branching_ratio > br_cutoff and r2.branching_ratio >= minimal_considered_BR_per_scheme

with s1.id as id, count(DISTINCT r2) as num_decays, sum(DISTINCT r2.branching_ratio) as closure, s1.tau as lifetime, sum(DISTINCT 1/ (r2.energy_diff*r2.energy_diff*r2.energy_diff)) as sum_inv_lambdas_3, sum(DISTINCT r2.branching_ratio / r2.energy_diff) as sum_of_BR_lambda_ratios, initial_temp as initial_temp, starting_id as starting_id, min(DISTINCT s2.tau/r2.branching_ratio) as min_tau_br_ratio, collect(round(r2.energy_diff,2)) as lambda_list, collect(s2.id) as s2_id_list

with id as id, num_decays as num_decays, closure as closure, initial_temp as initial_temp, starting_id as starting_id, min_tau_br_ratio as min_tau_br_ratio, log(0.1)/log(closure) as n10, lifetime * (num_decays + 1) + 0.04160402474381969 * sum_inv_lambdas_3 as inv_R_s, sqrt(initial_temp * 24) * closure * 0.39579544150466855 / sum_of_BR_lambda_ratios as n_cool, lambda_list as lambda_list, s2_id_list as s2_id_list

where sqrt(4)/sqrt(initial_temp)*n_cool*inv_R_s < min_tau_br_ratio and sqrt(4)/sqrt(initial_temp)*n_cool/n10 < 2

with apoc.coll.toSet(apoc.coll.flatten(collect(DISTINCT id))) as s1_ids, apoc.coll.toSet(apoc.coll.flatten(collect(DISTINCT s2_id_list))) as s2_ids

unwind s1_ids as s1_id
match (s) where s.id = s1_id and not s:doubleS1Candidates
set s:doubleS1Candidates

with s2_ids, count(DISTINCT s) as num_S1_candidates

unwind s2_ids as s2_id
match (s) where s.id = s2_id and not s:doubleS2Candidates
set s:doubleS2Candidates

return num_S1_candidates, count(DISTINCT s) as num_S2_candidates