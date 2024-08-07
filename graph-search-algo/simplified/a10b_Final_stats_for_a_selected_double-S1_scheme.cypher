//a10b Final stats for a selected two-S1 scheme
with 5 as num_decays_per_subscheme, 428 as s0_id, 722 as s1_id, 728 as s1prim_id, 250 as min_laser_nm, 5500 as max_laser_nm, 1e-7 as br_cutoff, 4 as max_J

match (s2)<-[r12prim:DECAY]-(s1prim)-[r10prim:DECAY]->(s0)<-[r10:DECAY]-(s1)-[r12:DECAY]->(s2) where s0.id = s0_id and s1.id = s1_id and s1prim.id = s1prim_id and r12.energy_diff > min_laser_nm and r12.energy_diff < max_laser_nm and r12.branching_ratio > br_cutoff and r12prim.energy_diff > min_laser_nm and r12prim.energy_diff < max_laser_nm and r12prim.branching_ratio > br_cutoff and s2.J < max_J

with s0, s1, r10, s1prim, r10prim, collect(r12.branching_ratio) as br12_list, collect(r12prim.branching_ratio) as br12prim_list, num_decays_per_subscheme as num_decays_per_subscheme,  min_laser_nm as min_laser_nm, max_laser_nm as max_laser_nm, br_cutoff as br_cutoff, max_J as max_J

with s0, s1, r10, s1prim, r10prim, apoc.coll.min(reverse(apoc.coll.sort(br12_list))[0..num_decays_per_subscheme-1]) as minimal_considered_BR_per_scheme, apoc.coll.min(reverse(apoc.coll.sort(br12prim_list))[0..num_decays_per_subscheme-1]) as minimal_considered_BRprim_per_scheme, min_laser_nm as min_laser_nm, max_laser_nm as max_laser_nm, br_cutoff as br_cutoff, max_J as max_J

match (s2)<-[r12prim:DECAY]-(s1prim)-[r10prim:DECAY]->(s0)<-[r10:DECAY]-(s1)-[r12:DECAY]->(s2) where r12.energy_diff > min_laser_nm and r12.energy_diff < max_laser_nm and r12.branching_ratio >= minimal_considered_BR_per_scheme and r12prim.energy_diff > min_laser_nm and r12prim.energy_diff < max_laser_nm and r12prim.branching_ratio >= minimal_considered_BRprim_per_scheme and s2.J < max_J

with collect(s2.id) as s2_ids, s0.id as s0_id, s1.id as s1_id, s1prim.id as s1prim_id,
apoc.coll.avg([s1.tau, s1prim.tau]) as avg_lifetime,
apoc.coll.min([min(DISTINCT s2.tau/r12.branching_ratio), collect(s0.tau/r10.branching_ratio), min(DISTINCT s2.tau/r12prim.branching_ratio), collect(s0.tau/r10prim.branching_ratio)]) as min_tau_br_ratio,
collect(r10.branching_ratio)[0] + collect(r12.branching_ratio) as BRs, collect(r10prim.branching_ratio)[0] + collect(r12prim.branching_ratio) as BRs_prim,
collect(r10.energy_diff)[0] + collect(r12.energy_diff) as lambdas, collect(r10prim.energy_diff)[0] + collect(r12prim.energy_diff) as lambdas_prim,
collect(round(r10.branching_ratio, 6))[0] + collect(round(r12.branching_ratio, 6)) + collect(round(r10prim.branching_ratio, 6))[0] + collect(round(r12prim.branching_ratio, 6)) as BRs_list,
collect(round(r10.energy_diff, 2))[0] + collect(round(r12.energy_diff, 2)) + collect(round(r10prim.energy_diff, 2))[0] + collect(round(r12prim.energy_diff, 2)) as lambdas_list,
apoc.coll.max([4, s0.energy*0.62485285866738]) as initial_temp

with s2_ids as s2_ids, s0_id as s0_id, s1_id as s1_id, s1prim_id as s1prim_id,
(apoc.coll.sum(BRs) + apoc.coll.sum(BRs_prim)) / 2 as closure,
reduce(acc = 0.0, i IN range(0, size(BRs) - 1) | (acc + BRs[i] / lambdas[i] / apoc.coll.sum(BRs) + BRs_prim[i] / lambdas_prim[i] / apoc.coll.sum(BRs_prim))) as sum_of_BR_lambda_ratios_w_closures,
reduce(acc = 0.0, i IN range(0, size(BRs) - 1) | (acc + (BRs[i] + BRs_prim[i]) / (BRs[i] * lambdas[i]*lambdas[i]*lambdas[i] + BRs_prim[i] * lambdas_prim[i]*lambdas_prim[i]*lambdas_prim[i]) )) as sum_BRs_over_lambdas_3_BRs,
min_tau_br_ratio as min_tau_br_ratio,
BRs_list as BRs_list, lambdas_list as lambdas_list,
avg_lifetime as avg_lifetime, initial_temp as initial_temp

with s2_ids as s2_ids, s0_id as s0_id, s1_id as s1_id, s1prim_id as s1prim_id,
log(0.1)/log(closure) as n10, closure as closure, 
avg_lifetime * (2 + size(s2_ids) + 1) / 2 + 0.04160402474381969 / 2 * sum_BRs_over_lambdas_3_BRs as inv_R_s, 
2 * sqrt(initial_temp * 24) * 0.39579544150466855 / sum_of_BR_lambda_ratios_w_closures as n_cool,
BRs_list as BRs_list, lambdas_list as lambdas_list,
initial_temp as initial_temp

//where sqrt(4)/sqrt(initial_temp)*n_cool*inv_R_s < min_tau_br_ratio and sqrt(4)/sqrt(initial_temp)*n_cool/n10 < 1
return s0_id, s1_id, s1prim_id, s2_ids, round(initial_temp,1) as T_init, (size(s2_ids) + 1) * 2 as num_decays, round(inv_R_s*1e6,3) as inv_R_us, round(n_cool) as n_cool, round(n_cool*inv_R_s*1e3,1) as t_cool_ms, round(n_cool/n10,3) as n_cool_n10_ratio, round(closure,8) as closure, round(sqrt(4)/sqrt(initial_temp)*n_cool*inv_R_s*1e3,1) as t_cool_ms_4K, (sqrt(4)/sqrt(initial_temp))*n_cool/n10 as n_cool_n10_ratio_4K, lambdas_list as lambda_list_nm, BRs_list as BR_list
order by t_cool_ms, num_decays, n_cool_n10_ratio