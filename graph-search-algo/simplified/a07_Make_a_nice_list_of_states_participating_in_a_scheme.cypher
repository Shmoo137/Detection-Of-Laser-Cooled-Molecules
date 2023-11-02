//a07 Make a nice list of states participating in a scheme
with 4 as num_decays, 800 as initial_energy, 250 as min_laser_nm, 5500 as max_laser_nm, 1e-8 as br_cutoff, 1e-6 as min_starting_tau, 20 as max_J

//// Finding reachable starting stable states (depending on T_init) and connected excited states
match (s0)<-[r1:DECAY]-(s1) where s0.energy < initial_energy and s0.tau > min_starting_tau and r1.energy_diff > min_laser_nm and r1.energy_diff < max_laser_nm and s0.J < max_J and s1.J < max_J
with s1, apoc.coll.max([4, s0.energy*0.62485285866738]) as initial_temp, s0.id as starting_id, num_decays as num_decays, min_laser_nm as min_laser_nm, max_laser_nm as max_laser_nm, br_cutoff as br_cutoff, min_starting_tau as min_starting_tau, max_J as max_J

//// Finding largest decay channels up to "num_decays" of each starting excited state and calculating parameters of the resulting cooling schemes
match (s1)-[r2:DECAY]->(s2) where r2.energy_diff > min_laser_nm and r2.energy_diff < max_laser_nm and r2.branching_ratio > br_cutoff and s1.J < max_J and s2.J < max_J

with s1, collect(r2.branching_ratio) as br_list, num_decays as num_decays, initial_temp as initial_temp, starting_id as starting_id, min_laser_nm as min_laser_nm, max_laser_nm as max_laser_nm, br_cutoff as br_cutoff, min_starting_tau as min_starting_tau, max_J as max_J
with s1, apoc.coll.min(apoc.coll.reverse(apoc.coll.sort(br_list))[0..num_decays]) as minimal_considered_BR_per_scheme, initial_temp as initial_temp, starting_id as starting_id, min_laser_nm as min_laser_nm, max_laser_nm as max_laser_nm, br_cutoff as br_cutoff, min_starting_tau as min_starting_tau, max_J as max_J

match (s1)-[r2:DECAY]->(s2) where r2.energy_diff > min_laser_nm and r2.energy_diff < max_laser_nm and s2.tau > min_starting_tau and r2.branching_ratio > br_cutoff and r2.branching_ratio >= minimal_considered_BR_per_scheme and s1.J < max_J and s2.J < max_J

with s1.id as id, count(DISTINCT r2) as num_decays, sum(DISTINCT r2.branching_ratio) as closure, s1.tau as lifetime, sum(DISTINCT 1/ (r2.energy_diff*r2.energy_diff*r2.energy_diff)) as sum_inv_lambdas_3, sum(DISTINCT r2.branching_ratio / r2.energy_diff) as sum_of_BR_lambda_ratios, initial_temp as initial_temp, starting_id as starting_id, min(DISTINCT s2.tau/r2.branching_ratio) as min_tau_br_ratio, collect(round(r2.energy_diff,2)) as lambda_list, collect(s2.id) as s2_id_list

with id as id, num_decays as num_decays, closure as closure, initial_temp as initial_temp, starting_id as starting_id, min_tau_br_ratio as min_tau_br_ratio, log(0.1)/log(closure) as n10, lifetime * (num_decays + 1) + 0.04160402474381969 * sum_inv_lambdas_3 as inv_R_s, sqrt(initial_temp * 24) * closure * 0.39579544150466855 / sum_of_BR_lambda_ratios as n_cool, lambda_list as lambda_list, s2_id_list as s2_id_list

where sqrt(4)/sqrt(initial_temp)*n_cool*inv_R_s < min_tau_br_ratio and sqrt(4)/sqrt(initial_temp)*n_cool/n10 < 1

with apoc.coll.sort(apoc.coll.toSet(apoc.coll.flatten(collect(DISTINCT id) + collect(DISTINCT s2_id_list)))) as all_ids

unwind all_ids as id

match (s) where s.id = id

return s.id, s{.*}