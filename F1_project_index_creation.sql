CREATE INDEX idx_constructorRef ON constructors (constructorRef);
CREATE INDEX idx_name ON constructors("name");

CREATE INDEX idx_driverref ON drivers(driverRef);
CREATE INDEX idx_forename_surname ON drivers(forename, surname);
CREATE INDEX idx_dob ON drivers(dob);

CREATE INDEX idx_time ON laptimes("time");
CREATE INDEX idx_time_pitstop ON pitstops("time");

