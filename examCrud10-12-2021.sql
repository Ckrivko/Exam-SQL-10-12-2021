--02. Insert
insert into Passengers(FullName, Email)(select concat(p.FirstName, ' ', p.LastName)as FullName,
concat(concat(p.FirstName, p.LastName),'@gmail.com') as Email
from Pilots as p
where p.Id between 5 and 15)

go

--03. Update

Update  Aircraft 
set Condition='A'
WHERE (Condition='C' or Condition='B')
and (FlightHours is null or FlightHours <=100)
and [Year] >=2013
go

--04. Delete

Delete Passengers 
where len(FullName)<=10