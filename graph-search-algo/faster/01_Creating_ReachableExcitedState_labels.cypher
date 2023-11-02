// 01 Creating ReachableExcitedState labels
match (s0:EnergyWiseStartingState)<-[]-(s1) where 10000000/(s1.energy-s0.energy) > 250 and 10000000/(s1.energy-s0.energy) < 12000
set s1:ReachableExcitedState
return count(s1)