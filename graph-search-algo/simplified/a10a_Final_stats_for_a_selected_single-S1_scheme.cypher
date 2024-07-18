//a10a Final stats for a selected single-S1 scheme
with 3 as num_decays, 7 as excited_state_id, 309 as starting_id, 250 as min_laser_nm, 5500 as max_laser_nm, 1e-7 as br_cutoff, 4 as max_J

//// Identify the starting state to compute initial temperature
match (s0) where s0.id = starting_id
with apoc.coll.max([4, s0.energy*0.62485285866738]) as initial_temp, starting_id as starting_id, num_decays as num_decays, min_laser_nm as min_laser_nm, max_laser_nm as max_laser_nm, br_cutoff as br_cutoff, max_J as max_J, excited_state_id as excited_state_id

//// Finding largest decay channels up to "num_decays" of each starting excited state and calculating parameters of the resulting cooling schemes
match (s1)-[r2:DECAY]->(s2) where s1.id = excited_state_id and r2.energy_diff > min_laser_nm and r2.energy_diff < max_laser_nm and r2.branching_ratio > br_cutoff and s2.J < max_J

with s1, collect(r2.branching_ratio) as br_list, num_decays as num_decays, initial_temp as initial_temp, starting_id as starting_id, min_laser_nm as min_laser_nm, max_laser_nm as max_laser_nm, br_cutoff as br_cutoff, max_J as max_J
with s1, apoc.coll.min(apoc.coll.reverse(apoc.coll.sort(br_list))[0..num_decays]) as minimal_considered_BR_per_scheme, initial_temp as initial_temp, starting_id as starting_id, min_laser_nm as min_laser_nm, max_laser_nm as max_laser_nm, br_cutoff as br_cutoff, max_J as max_J

match (s1)-[r2:DECAY]->(s2) where r2.energy_diff > min_laser_nm and r2.energy_diff < max_laser_nm and r2.branching_ratio > br_cutoff and r2.branching_ratio >= minimal_considered_BR_per_scheme and s2.J < max_J

with s1.id as id, count(DISTINCT r2) as num_decays, sum(DISTINCT r2.branching_ratio) as closure, s1.tau as lifetime, sum(DISTINCT 1/ (r2.energy_diff*r2.energy_diff*r2.energy_diff)) as sum_inv_lambdas_3, sum(DISTINCT r2.branching_ratio / r2.energy_diff) as sum_of_BR_lambda_ratios, initial_temp as initial_temp, starting_id as starting_id, min(DISTINCT s2.tau/r2.branching_ratio) as min_tau_br_ratio, collect(round(r2.energy_diff,2)) as lambda_list, collect(s2.id) as s2_id_list, collect(round(r2.branching_ratio,6)) as BR_list

with id as id, num_decays as num_decays, closure as closure, initial_temp as initial_temp, starting_id as starting_id, min_tau_br_ratio as min_tau_br_ratio, log(0.1)/log(closure) as n10, lifetime * (num_decays + 1) + 0.04160402474381969 * sum_inv_lambdas_3 as inv_R_s, sqrt(initial_temp * 24) * closure * 0.39579544150466855 / sum_of_BR_lambda_ratios as n_cool, lambda_list as lambda_list, BR_list as BR_list, s2_id_list as s2_id_list

//where sqrt(4)/sqrt(initial_temp)*n_cool*inv_R_s < min_tau_br_ratio and sqrt(4)/sqrt(initial_temp)*n_cool/n10 < 1
return id as S1_id, starting_id as S0_id, s2_id_list, round(initial_temp,1) as T_init, num_decays, round(inv_R_s*1000000,3) as inv_R_us, round(n_cool,0) as n_cool, round(n_cool*inv_R_s*1000) as t_cool_ms, n_cool/n10, round(closure,8) as closure, round(sqrt(4)/sqrt(initial_temp)*n_cool*inv_R_s*1000) as t_cool_ms_4K, (sqrt(4)/sqrt(initial_temp))*n_cool/n10 as n_cool_n10_ratio_4K, lambda_list as lambda_list_nm, BR_list as BR_list
order by t_cool_ms, num_decays, n_cool/n10