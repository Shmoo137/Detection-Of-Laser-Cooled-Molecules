//a00 Id to int (optional)
match(s)
set s.id=ToInteger(s.id)
return count(s)