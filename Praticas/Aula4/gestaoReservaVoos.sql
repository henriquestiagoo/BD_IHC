IF (NOT EXISTS (SELECT * FROM sys.schemas WHERE name = 'aula4_reservaVoos')) 
BEGIN
    EXEC ('CREATE SCHEMA aula4_reservaVoos')
END

/*
DROP  TABLE aula4_reservaVoos.Cand_Land  ;
DROP  TABLE aula4_reservaVoos.Seat ;
DROP   TABLE aula4_reservaVoos.Leg_Instance;
DROP    TABLE aula4_reservaVoos.Airplane;
DROP TABLE aula4_reservaVoos.Fare  ;
DROP   TABLE aula4_reservaVoos.Airplane_Type ;
DROP TABLE aula4_reservaVoos.Flight_Leg ;
DROP TABLE aula4_reservaVoos.Flight  ;
DROP  TABLE aula4_reservaVoos.Airport ;
DROP   SCHEMA aula4_reservaVoos;
*/

CREATE TABLE aula4_reservaVoos.Airport(
	airport_code	INT			PRIMARY KEY,
	city			VARCHAR(50)	NOT NULL,
	state			VARCHAR(50)	NOT NULL,
	name			VARCHAR(50)	NOT NULL);

CREATE TABLE aula4_reservaVoos.Flight(
	number			INT			PRIMARY KEY,
	airline			VARCHAR(50)	NOT NULL,
	weekdays		VARCHAR(15)	NOT NULL	CHECK(weekdays IN('sunday','monday','tuesday','wednesday','thursday','friday','saturday')));

CREATE TABLE aula4_reservaVoos.Flight_Leg(
	leg_no				INT,
	flight_number		INT,
	airp_dep_code		INT,
	airp_arr_code		INT,
	sch_dep				DATETIME,
	sch_arr				DATETIME
	PRIMARY KEY(leg_no,flight_number));

CREATE TABLE aula4_reservaVoos.Airplane_Type(
	typeName			VARCHAR(50)	PRIMARY KEY,
	company				VARCHAR(50)	NOT NULL,
	max_seats			INT			NOT NULL);

CREATE TABLE aula4_reservaVoos.Fare(
	flight_number		INT,		
	code				INT,
	restrictions		VARCHAR(50)	NOT NULL,
	amount				MONEY		NOT NULL,
	PRIMARY KEY(code,flight_number));

CREATE TABLE aula4_reservaVoos.Airplane(
	airplane_id			INT		PRIMARY KEY,
	airplane_type		VARCHAR(50),
	total_no_of_seats	INT		NOT NULL);	

CREATE TABLE aula4_reservaVoos.Leg_Instance(
	flight_leg_no		INT	,
	date				DATE,
	flight_number		INT,
	airplane_id			INT,
	airp_code_dep		INT,
	airp_code_arr		INT,
	dep_time			DATETIME,
	arr_time			DATETIME,
	no_of_avail_seats	INT,
	PRIMARY KEY(flight_leg_no,date,flight_number));

CREATE TABLE aula4_reservaVoos.Seat(
	seat_no				INT,
	date				DATE,
	flight_leg_no		INT,
	flight_number		INT,
	customer_name		VARCHAR(50),
	cphone				INT,
	PRIMARY KEY(seat_no,date,flight_leg_no,flight_number));

CREATE TABLE aula4_reservaVoos.Cand_Land(		
	airport				INT,
	airplane_type		VARCHAR(50),
	PRIMARY KEY(airport,airplane_type));

--Chaves Estrangeiras

-- FLIGHT_LEG
ALTER TABLE aula4_reservaVoos.Flight_Leg ADD CONSTRAINT FLFNFK FOREIGN KEY (flight_number) REFERENCES aula4_reservaVoos.Flight(number) ON UPDATE CASCADE;
ALTER TABLE aula4_reservaVoos.Flight_Leg ADD CONSTRAINT FLAACFK FOREIGN KEY (airp_arr_code) REFERENCES aula4_reservaVoos.Airport(airport_code) ON UPDATE CASCADE;
ALTER TABLE aula4_reservaVoos.Flight_Leg ADD CONSTRAINT FLADPCFK FOREIGN KEY (airp_dep_code) REFERENCES aula4_reservaVoos.Airport(airport_code) ON UPDATE NO ACTION;

-- FARE
ALTER TABLE aula4_reservaVoos.Fare ADD CONSTRAINT FRFNFK FOREIGN KEY (flight_number) REFERENCES aula4_reservaVoos.Flight(number) ON UPDATE CASCADE;

-- AIRPLANE
ALTER TABLE aula4_reservaVoos.Airplane ADD CONSTRAINT APATFK FOREIGN KEY (airplane_type) REFERENCES aula4_reservaVoos.Airplane_Type(typeName) ON UPDATE CASCADE;

-- LEG INSTANCE
ALTER TABLE aula4_reservaVoos.Leg_Instance ADD CONSTRAINT LIFLFNFK FOREIGN KEY(flight_leg_no, flight_number) REFERENCES aula4_reservaVoos.Flight_Leg(leg_no, flight_number) ON UPDATE CASCADE;
ALTER TABLE aula4_reservaVoos.Leg_Instance ADD CONSTRAINT LIAIFK FOREIGN KEY (airplane_id) REFERENCES aula4_reservaVoos.Airplane(airplane_id) ON UPDATE NO ACTION;
ALTER TABLE aula4_reservaVoos.Leg_Instance ADD CONSTRAINT LIAACFK FOREIGN KEY (airp_code_arr) REFERENCES aula4_reservaVoos.Airport(airport_code) ON UPDATE NO ACTION;
ALTER TABLE aula4_reservaVoos.Leg_Instance ADD CONSTRAINT LIADCFK FOREIGN KEY (airp_code_dep) REFERENCES aula4_reservaVoos.Airport(airport_code) ON UPDATE NO ACTION;

-- Seat
ALTER TABLE aula4_reservaVoos.Seat ADD CONSTRAINT STDTFNFLFK FOREIGN KEY ( flight_leg_no,date, flight_number) REFERENCES aula4_reservaVoos.Leg_Instance( flight_leg_no,date, flight_number) ON UPDATE CASCADE;

-- Can Land
ALTER TABLE aula4_reservaVoos.Cand_Land ADD CONSTRAINT CLATFK FOREIGN KEY (airplane_type) REFERENCES aula4_reservaVoos.Airplane_Type(typeName) ON UPDATE CASCADE;
ALTER TABLE aula4_reservaVoos.Cand_Land ADD CONSTRAINT CLAPFK FOREIGN KEY (airport) REFERENCES aula4_reservaVoos.Airport(airport_code) ON UPDATE CASCADE;	
