
CREATE DATABASE f1_project;

Create or replace Function get_age(dob DATE)
returns INTERVAL
LANGUAGE plpgsql IMMUTABLE
AS $$
BEGIN
	return age(dob);
END
$$;

CREATE OR REPLACE FUNCTION compute_millisecond(duration DOUBLE PRECISION)
RETURNS INT
LANGUAGE plpgsql IMMUTABLE
AS $$
BEGIN 
	return duration * 1000;
END
$$;

DROP TABLE IF EXISTS public.DRIVERS CASCADE;
CREATE TABLE public.DRIVERS(
	driverid SERIAL PRIMARY KEY,
	driverRef VARCHAR(20) NOT NULL DEFAULT 'default',
	"number" INT,
	code VARCHAR(3),
	forename VARCHAR(100),
	surname VARCHAR(100),
	dob DATE NOT NULL DEFAULT '1900-01-01'::DATE,
	age INTERVAL GENERATED ALWAYS AS (get_age(dob)) STORED,
	nationality VARCHAR(20),
	url TEXT
);


DROP TABLE IF EXISTS public.CONSTRUCTORS CASCADE;
CREATE TABLE public.CONSTRUCTORS(
	constructorId SERIAL PRIMARY KEY,
	constructorRef VARCHAR(20) NOT NULL DEFAULT 'default',
	"name" VARCHAR(30),
	nationality VARCHAR(20),
	url TEXT
);

DROP TABLE IF EXISTS public.CIRCUITS CASCADE;
CREATE TABLE public.CIRCUITS(
	circuitId SERIAL PRIMARY KEY,
	circuitRef VARCHAR(20) NOT NULL DEFAULT 'default',
	"name" VARCHAR(50),
	"location" VARCHAR(30),
	country VARCHAR (20),
	lat DOUBLE PRECISION,
	lng DOUBLE PRECISION,
	url TEXT
);

DROP TABLE IF EXISTS public.STATUS CASCADE;
CREATE TABLE public.STATUS(
	statusId SERIAL PRIMARY KEY,
	status VARCHAR(30)
);

DROP TABLE IF EXISTS public.RACES CASCADE;
CREATE TABLE public.RACES(
	raceId SERIAL PRIMARY KEY,
	"year" INT,
	round INT,
	circuitId INT REFERENCES public.CIRCUITS(circuitId) NOT NULL,
	"name" VARCHAR(40),
	"date" DATE NOT NULL DEFAULT '1900-01-01'::DATE,
	"time" TIME,
	url TEXT
);

DROP TABLE IF EXISTS public.PITSTOPS CASCADE;
CREATE TABLE public.PITSTOPS(
	raceId INT REFERENCES public.RACES(raceId) NOT NULL,
	driverId INT REFERENCES public.DRIVERS(driverId) NOT NULL,
	stop INT,
	lap INT NOT NULL,
	"time" TIME,
	duration DOUBLE PRECISION,
	milliseconds INT GENERATED ALWAYS AS (compute_millisecond(duration)) STORED, -- can be derived column
	PRIMARY KEY(raceId, driverId, lap)
);

DROP TABLE IF EXISTS public.LAPTIMES CASCADE;
CREATE TABLE public.LAPTIMES(
	raceId INT REFERENCES public.RACES(raceId) NOT NULL,
	driverId INT REFERENCES public.DRIVERS(driverId) NOT NULL,
	lap INT NOT NULL,
	"position" INT,
	"time" TIME,
	PRIMARY KEY(raceId, driverId, lap)
);

DROP TABLE IF EXISTS public.RESULTS CASCADE;
CREATE TABLE public.RESULTS(
	resultId SERIAL PRIMARY KEY,
	raceId INT REFERENCES public.RACES(raceId) NOT NULL,
	driverId INT REFERENCES public.DRIVERS(driverId) NOT NULL,
	constructorId INT REFERENCES public.CONSTRUCTORS(constructorId) NOT NULL,
	"number" INT,
	grid INT,
	"position" INT,
	positionOrder INT,
	points FLOAT,
	laps INT,
	"time" INTERVAL,
	fastestLap INT,
	"rank" INT,
	fastestLapTime TIME,
	fastestLapSpeed DOUBLE PRECISION,
	statusId INT REFERENCES public.STATUS(statusId) NOT NULL
);																														

DROP TABLE IF EXISTS public.DRIVER_STANDINGS CASCADE;
CREATE TABLE public.DRIVER_STANDINGS(
	driverStandingsId SERIAL PRIMARY KEY,
	raceId INT REFERENCES public.RACES(raceId) NOT NULL,
	driverId INT REFERENCES public.DRIVERS(driverId) NOT NULL,
	points FLOAT,
	"position" INT,
	wins INT
);
 

DROP TABLE IF EXISTS public.CONSTRUCTOR_STANDINGS CASCADE;
CREATE TABLE public.CONSTRUCTOR_STANDINGS(
	constructorStandingsId SERIAL PRIMARY KEY,
	raceId INT REFERENCES public.RACES(raceId) NOT NULL, -- FK
	constructorId INT REFERENCES public.CONSTRUCTORS(constructorId) NOT NULL, -- FK
	points FLOAT,
	"position" INT,
	wins INT
);



-- Seeding data through csv file

-- Seeding data into public.drivers table
COPY public.drivers
FROM 'D:/Docs/Masters/CIS_556/data/drivers.csv'
DELIMITER ','
CSV HEADER;

-- Seeding data into public.CONSTRUCTORS table
COPY public.CONSTRUCTORS
FROM 'D:/Docs/Masters/CIS_556/data/constructors.csv'
DELIMITER ','
CSV HEADER;

-- Seeding data into public.CIRCUITS table
COPY public.CIRCUITS(circuitId, circuitRef, "name", "location", country, lat, lng, url)
FROM 'D:/Docs/Masters/CIS_556/data/circuits.csv'
DELIMITER ','
CSV HEADER;

-- Seeding data into public.STATUS table
COPY public.STATUS
FROM 'D:/Docs/Masters/CIS_556/data/status.csv'
DELIMITER ','
CSV HEADER;

-- Seeding data into public.RACES table
COPY public.RACES(raceId, "year", round, circuitId, "name", "date", "time", url)
FROM 'D:/Docs/Masters/CIS_556/data/races.csv'
DELIMITER ','
CSV HEADER;

-- Seeding data into public.PITSTOPS table
COPY public.PITSTOPS(raceid, driverid, stop, lap, "time", duration)
FROM 'D:/Docs/Masters/CIS_556/data/pit_stops.csv'
DELIMITER ','
CSV HEADER;

-- Seeding data into public.LAPTIMES table
COPY public.LAPTIMES
FROM 'D:/Docs/Masters/CIS_556/data/lap_times.csv'
DELIMITER ','
CSV HEADER;

-- Seeding data into public.RESULTS table
COPY public.RESULTS
FROM 'D:/Docs/Masters/CIS_556/data/results.csv'
DELIMITER ','
CSV HEADER;

-- Seeding data into public.DRIVER_STANDINGS table
COPY public.DRIVER_STANDINGS
FROM 'D:/Docs/Masters/CIS_556/data/driver_standings.csv'
DELIMITER ','
CSV HEADER;

-- Seeding data into public.CONSTRUCTOR_STANDINGS table
COPY public.CONSTRUCTOR_STANDINGS
FROM 'D:/Docs/Masters/CIS_556/data/constructor_standings.csv'
DELIMITER ','
CSV HEADER;
