# Automated detection of laser cooling schemes for ultracold molecules
Repository for developing the code to automatically detect molecules that can be laser cooled.

## Lists of all identified laser cooling schemes

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

- Folder `CN` contains 843 detected laser cooling schemes with laser wavelengths set during the search to be between 250 and 5500 nm. The data used for this search are in [ExoMol](https://www.exomol.com/data/molecules/CN/12C-14N/Trihybrid/).

- Folder `CO2` contains 18 detected laser cooling schemes engaging 42 states in total with laser wavelengths set during the search to be between 250 and 12 000 nm. The data used for this search are in [ExoMol](https://www.exomol.com/data/molecules/CO2/12C-16O2/UCL-4000/).

- Folder `OH+` contains 509 detected laser cooling schemes with laser wavelengths set during the search to be between 250 and 5500 nm. The data used for this search are in [ExoMol](https://www.exomol.com/data/molecules/OH_p/16O-1H_p/MoLLIST/).

- Folder `YO` contains 3262 detected laser cooling schemes with laser wavelengths set during the search to be between 250 and 5500 nm. The data used for this search are in [ExoMol](https://www.exomol.com/data/molecules/YO/89Y-16O/BRYTS/).