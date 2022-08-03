--05. Aircraft
SELECT Manufacturer, Model,FlightHours,Condition 
FROM Aircraft
ORDER BY FlightHours desc
go

--06. Pilots and Aircraft
select p.FirstName,p.LastName,a.Manufacturer,a.Model,a.FlightHours from Pilots as p
join PilotsAircraft as pa ON p.Id=pa.PilotId
join Aircraft as a ON a.Id=pa.AircraftId
where a.FlightHours is not null and a.FlightHours<=304
order by a.FlightHours desc,p.FirstName 
GO

--07. Top 20 Flight Destinations
select top(20) f.Id as DestinationId,
				f.[Start], 	
				p.FullName,
				a.AirportName,
				f.TicketPrice
from FlightDestinations as f
join Passengers as p on f.PassengerId=p.Id
join Airports as a on a.Id=f.AirportId
where datepart(day,f.[Start])%2=0
order by f.TicketPrice desc, a.AirportName
go

--08. Number of Flights for Each Aircraft
select * from(select a.Id,a.Manufacturer,
	a.FlightHours,
	count(*)as FlightDestinationsCount,
	Round(avg(f.TicketPrice),2) as AvgPrice
from Aircraft as a
join FlightDestinations as f on a.Id=f.AircraftId
group by f.AircraftId, a.Id,a.Manufacturer,a.FlightHours)as subQ
where subQ.FlightDestinationsCount>=2
order by subq.FlightDestinationsCount desc,subQ.Id
go

--09. Regular Passengers
SELECT * from(select p.FullName,COUNT(*)as CountOfAircraft,SUM(f.TicketPrice)as TotalPayed
from Passengers as p
join FlightDestinations as f ON p.Id=f.PassengerId
group by f.PassengerId,p.FullName)as subQ
where substring(subQ.FullName,2,1)='a'
and subQ.CountOfAircraft>=2
order by subQ.FullName
Go

--10. Full Info for Flight Destinations
select a.AirportName,
	f.Start,
	f.TicketPrice,
	p.FullName,
	ac.Manufacturer,
	ac.Model
from FlightDestinations as f
join Airports as a ON f.AirportId=a.Id
join Aircraft as ac ON f.AircraftId=ac.Id
join Passengers as p ON f.PassengerId=p.Id
where (datePart(HOUR,f.Start) between  6 and 20) and
f.TicketPrice>2500
order by ac.Model
GO

--11. Find all Destinations by Email Address
CREATE FUNCTION udf_FlightDestinationsByEmail(@email VARCHAR(30)) 
RETURNS INT
AS
BEGIN
return (SELECT count(p.Id) FROM Passengers AS p
JOIN FlightDestinations as f ON p.Id=f.PassengerId
where p.Email=@email)

--declare @result int=(select subQ.Count from (SELECT count(*)as [Count],p.Email FROM Passengers AS p
--JOIN FlightDestinations as f ON p.Id=f.PassengerId
--group by f.PassengerId,p.Email)as subQ
----where subQ.Email=@email)
--where subQ.Email=@email)

--		if(@result is null)
--		begin
--		set @result=0
--		return @result
--		end
		
--return @result
END
GO

--12. Full Info for Airports
create proc usp_SearchByAirportName(@airportName varchar(70))
as
begin
	select a.AirportName,
		p.FullName,
			case
				when f.TicketPrice<=400 then 'Low'
				when f.TicketPrice between 401 and 1500 then 'Medium'
				when f.TicketPrice >1500 then 'High'
				end as LevelOfTickerPrice ,
		ac.Manufacturer,
		ac.Condition,
		act.TypeName
		
	from  Airports as a
	join FlightDestinations as f ON f.AirportId=a.Id
	join Passengers as p ON p.Id=f.PassengerId
	join Aircraft as ac ON ac.Id= f.AircraftId
	join AircraftTypes as act ON ac.TypeId= act.Id
	where a.AirportName=@airportName
	order by ac.Manufacturer, p.FullName
end


