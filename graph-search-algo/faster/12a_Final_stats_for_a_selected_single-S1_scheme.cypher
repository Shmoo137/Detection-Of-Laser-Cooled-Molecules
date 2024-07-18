// 12a Final stats for a selected single-S1 scheme
with 6 as num_decays, "1673" as excited_state_id, "1" as starting_id
match (s0:EnergyWiseStartingState) where s0.id = starting_id
with s0.energy*1.4387863+3 as initial_temp, starting_id as starting_id, excited_state_id as excited_state_id, num_decays as num_decays

match (s1:ReachableExcitedState)-[r2:DECAY]->(s2:ReachableState) where s1.id = excited_state_id

with s1, collect(r2.branching_ratio) as list, num_decays as num_decays, excited_state_id as excited_state_id, initial_temp as initial_temp, starting_id as starting_id
with s1, apoc.coll.min(apoc.coll.reverse(apoc.coll.sort(list))[0..num_decays]) as minimal_considered_BR_per_scheme, num_decays as num_decays, excited_state_id as excited_state_id, initial_temp as initial_temp, starting_id as starting_id

match (s1:ReachableExcitedState)-[r2:DECAY]->(s2:ReachableState) where s1.id = excited_state_id and r2.branching_ratio >= minimal_considered_BR_per_scheme

with s1.id as id, count(DISTINCT r2) as num_decays, sum(DISTINCT r2.branching_ratio) as closure, 1/s1.tau as excited_linewidth, sum(DISTINCT 1/ (r2.energy_diff*r2.energy_diff*r2.energy_diff)) as sum_inv_lambdas_3, sum(DISTINCT r2.branching_ratio / r2.energy_diff) as freqs_BRs, initial_temp as initial_temp, starting_id as starting_id, min(DISTINCT s2.tau/r2.branching_ratio) as min_tau_br_ratio

with id as id, num_decays as num_decays, closure as closure, excited_linewidth as excited_linewidth, sum_inv_lambdas_3 as sum_inv_lambdas_3, freqs_BRs as freqs_BRs, initial_temp as initial_temp, starting_id as starting_id, excited_linewidth/(num_decays + 1 + 0.04160402480353238 * excited_linewidth * sum_inv_lambdas_3) as R_Hz, log(0.1)/log(closure) as n10, sqrt(initial_temp) * 1.938993742307538 / (freqs_BRs/closure) as n_cool, min_tau_br_ratio as min_tau_br_ratio

// where sqrt(3)/sqrt(initial_temp)*n_cool/R_Hz < min_tau_br_ratio and sqrt(3)/sqrt(initial_temp)*n_cool/n10 < 1
return id, starting_id, initial_temp, num_decays, n10 as n10, n10/R_Hz as t10_s, n_cool as n_cool, n_cool/R_Hz as t_cool_s, n_cool/n10, closure, sqrt(3)/sqrt(initial_temp)*n_cool/R_Hz as t_cool_s_3K, (sqrt(3)/sqrt(initial_temp))*n_cool/n10 as n_cool_n10_ratio_3K, min_tau_br_ratio as min_tau_br_ratio