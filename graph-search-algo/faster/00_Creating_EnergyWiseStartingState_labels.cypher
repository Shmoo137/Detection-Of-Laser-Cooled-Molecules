//00 Creating EnergyWiseStartingState labels
match (s0) where s0.energy < 800
set s0:EnergyWiseStartingState
return count(s0)