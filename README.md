# Automated detection of laser cooling schemes for ultracold molecules
Repository for developing the code to automatically detect molecules that can be laser cooled.

## 1. The graph search algorithm for identification of viable laser cooling schemes
The folder `graph-search-algo` contains two versions of the same algorithm. The `simplified` version can be used for smaller molecules with number of states and transitions of the order of 100 000 and 10 mln, respectively. It is explained in detail in the tutorial described in the Appendix B of the research paper. Additionally, we provide the `faster` version of the algorithm, which can be used also for larger molecules. In particular, studying CO$_2$ required the improved version. 

The only difference between the versions is that the faster algorithm:
- splits certain steps into smaller steps that can be parallelized without overflowing the RAM memory by putting constraints on how many nodes and relationships are analyzed at the same time,
- to do that, we need to add labeling to the nodes. The labeling follows the nomenclature set in the research paper.

Moreover, the folder `graph-search-algo` contains `TIPS.md` file with suggestions how to quickly enter Neo4j and Cypher world and start using the graph search.

## 2. Lists of all identified laser cooling schemes
The folder `laser-cooling-schemes` contains data on all identified laser cooling schemes, in particular:
- the list of ExoMol id's of states participating in the scheme: S1_id, S0_id, s2_id_list, 
- the initial temperature in K: T_init,
- the number of needed lasers: num_decays,
- $R^{-1}$ in $\mu \mathrm{s}$: inv_R_us
- number of photon scatterings required to laser cool a molecule starting from the intial temperature of the gas: n_cool
- cooling time in ms: t_cool_ms
- the ratio of the number of photon scatterings needed for cooling and the number of photon scatterings after which only 10\% of the molecules stay in the cooling cycle. The smaller, the better: n_cool/n10,
- closure (sum of branching ratios in a scheme),
- t_cool and n_cool/n10 assuming 4 K as the initial temperature: t_cool_4K and n_cool_n10_ratio_4K,
- list of laser wavelengths required for the cooling scheme in nm: lambda_list_nm,
- list of branching ratios for each transition: BR_list.

Files are organized by a molecule and additionally by the maximum number of lasers, $G=$ num_decays, allowed during the search. Note that results obtained for some maximal $G$ may contain schemes with lower required $G$, so the number of identified laser cooling schemes is not equal to the sum of schemes listed in each result file (is smaller). Each file with laser cooling schemes is accompanied by the list of states taking part in all detected schemes, ordered by id, where we list all quantum numbers available in ExoMol.

- Folder `C2` contains 388 detected laser cooling schemes with laser wavelengths set during the search to be between 250 and 5500 nm. The data used for this search are in [ExoMol](https://www.exomol.com/data/molecules/C2/12C2/8states/).

- Folder `CO2` contains 18 detected laser cooling schemes engaging 42 states in total with laser wavelengths set during the search to be between 250 and 12 000 nm. The data used for this search are in [ExoMol](https://www.exomol.com/data/molecules/CO2/12C-16O2/UCL-4000/).