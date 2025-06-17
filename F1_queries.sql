--1. Analyzing Drivers' Failure to Complete Races
SELECT distinct d.driverRef, d.driverid, COUNT(*) AS failed_races
FROM results r
JOIN drivers d ON r.driverid = d.driverid
JOIN status s on r.statusId = s.StatusId
WHERE s.status NOT IN ('Finished', 'Completed')
GROUP BY d.driverRef, d.driverid
order by failed_races desc;

--2. Evaluating the Impact of Circuit Characteristics on Race Outcomes:
SELECT c.name AS circuit_name, d.driverRef, AVG(r.position) AS average_position
FROM results r
JOIN drivers d ON r.driverId = d.driverId
JOIN races ra ON r.raceId = ra.raceId
JOIN circuits c ON ra.circuitId = c.circuitId
GROUP BY c.name, d.driverRef
ORDER BY c.name, average_position;

--3. Studying the Effects of Pit Stop Strategies on Race Results:
SELECT d.driverRef, ra.year, AVG(p.duration) AS average_pitstop_duration, AVG(r.position) AS 
average_race_position
FROM pitstops p
JOIN results r ON p.raceId = r.raceId AND p.driverId = r.driverId
JOIN drivers d ON p.driverId = d.driverId
JOIN races ra ON p.raceId = ra.raceId
GROUP BY d.driverRef, ra.year
ORDER BY d.driverRef, ra.year;

--4. Uncovering Trends and Patterns Behind Drivers' Failure to Complete Races:
SELECT dr.driverRef, COUNT(*) AS failure_count
FROM results re
JOIN drivers dr ON re.driverId = dr.driverId
JOIN status st ON re.statusId = st.statusId
WHERE st.status NOT IN ('Finished', 'Completed')
GROUP BY dr.driverRef;


-- 5.Driver Performance Analysis Across Different Circuits: This analysis could reveal how 
-- drivers perform on different types of circuits (e.g., street vs. race tracks)
SELECT dr.driverRef, ci.name AS circuit_name, Round(AVG(re.position)) AS average_position
FROM results re
JOIN drivers dr ON re.driverId = dr.driverId
JOIN races ra ON re.raceId = ra.raceId
JOIN circuits ci ON ra.circuitId = ci.circuitId
GROUP BY dr.driverRef, ci.name
ORDER BY average_position

--6. Impact of Pit Stops on Race Outcomes: Investigate how the number and duration of pit 
-- 	stops affect a driver's final position in a race.
SELECT re.raceId, dr.driverRef, COUNT(ps.stop) AS pit_stop_count, AVG(ps.duration) AS 
avg_pit_stop_duration, AVG(re.position) AS avg_race_position
FROM pitstops ps
JOIN results re ON ps.raceId = re.raceId AND ps.driverId = re.driverId
JOIN drivers dr ON re.driverId = dr.driverId
GROUP BY re.raceId, dr.driverRef


--7. Seasonal Performance Trends of Drivers: Analyze how drivers' performances vary across 
-- different seasons.
SELECT dr.driverRef, ra.year, AVG(re.position) AS average_season_position
FROM results re
JOIN drivers dr ON re.driverId = dr.driverId
JOIN races ra ON re.raceId = ra.raceId
GROUP BY dr.driverRef, ra.year;

--8.Constructor Team Performance Analysis: Assess the overall performance of constructor 
-- teams over various seasons.
SELECT co.constructorRef, ra.year, SUM(cs.points) AS total_points
FROM constructor_standings cs
JOIN constructors co ON cs.constructorId = co.constructorId
JOIN races ra ON cs.raceId = ra.raceId
GROUP BY co.constructorRef, ra.year

--9.Analysis of Lap Times Across Different Races: Examine trends in lap times for drivers across 
-- different races to gauge consistency and improvement.
SELECT dr.driverRef, ra.name AS race_name, AVG(lt.time) AS avg_lap_time
FROM laptimes lt
JOIN drivers dr ON lt.driverId = dr.driverId
JOIN races ra ON lt.raceId = ra.raceId
GROUP BY dr.driverRef, ra.name;

--10. Driver Standings and Win Analysis Over Years: Look into how drivers' standings and win 
-- rates have evolved over the years.
SELECT dr.driverRef, r.year, AVG(ds.position) AS average_position, SUM(ds.wins) AS 
total_wins
FROM driver_standings ds
JOIN drivers dr ON ds.driverId = dr.driverId
JOIN races r ON ds.raceid = r.raceid
GROUP BY dr.driverRef, r.year;

--11. Total Wins of the drivers
SELECT drivers.forename AS first_name, drivers.surname AS last_name, 
drivers.dob AS birth_date, COUNT(*) AS Total_Wins
FROM results
JOIN drivers ON results.driverId = drivers.driverId
JOIN races ON results.raceId = races.raceId
WHERE results.positionOrder = 1
GROUP BY drivers.driverId
ORDER BY COUNT(*) DESC;

--12. Comparing Constructor Performances Over Seasons: query improvement
;with sns as (
	Select Distinct "year"
	from races
	Order by "year"
)
SELECT c.constructorRef, s.year, SUM(cs.points) AS total_points, c.name
FROM constructor_standings cs
JOIN constructors c ON cs.constructorId = c.constructorId
JOIN races r on cs.raceid = r.raceid
JOIN sns s on r.year = s.year
GROUP BY c.constructorRef, s.year, c.name
ORDER BY total_points desc, s.year


