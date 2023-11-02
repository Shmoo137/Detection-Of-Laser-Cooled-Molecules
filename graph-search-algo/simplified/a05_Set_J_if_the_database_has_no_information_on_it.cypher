//a05 Set J (if the database has no information on it)
match (s1)
set s1.J=0
return count(s1)