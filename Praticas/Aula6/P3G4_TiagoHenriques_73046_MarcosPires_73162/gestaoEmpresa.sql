
IF (NOT EXISTS (SELECT * FROM sys.schemas WHERE name = 'aula6_empresa')) 
BEGIN
    EXEC ('CREATE SCHEMA aula6_empresa;')
END
/*
DROP TABLE aula6_empresa.employee
DROP TABLE aula6_empresa.department
DROP TABLE aula6_empresa.dept_locations
DROP TABLE aula6_empresa.project
DROP TABLE aula6_empresa.works_on
DROP TABLE aula6_empresa.dependent
DROP SCHEMA aula6_empresa;

*/
CREATE TABLE aula6_empresa.employee(
	Fname		VARCHAR(50)	NOT NULL,
Minit		VARCHAR(2) 		NOT NULL,
Lname		VARCHAR(50)	NOT NULL,
	Ssn		INT 			PRIMARY KEY,
	Bdate		DATE			NOT NULL,
	Address	VARCHAR(100)	NOT NULL,
Sex		VARCHAR(20)	NOT NULL,
Salary		INT			NOT NULL,
Super_ssn	INT ,
Dno		INT			NOT NULL,
FOREIGN KEY(Super_ssn) REFERENCES aula6_empresa.employee(Ssn));



CREATE TABLE aula6_empresa.department(
	Dname			VARCHAR(50)	NOT NULL,
	Dnumber		INT 			PRIMARY KEY,
	Mgr_ssn		INT,
	Mgr_start_date	DATE,
FOREIGN KEY(Mgr_ssn) REFERENCES aula6_empresa.employee(Ssn));

CREATE TABLE aula6_empresa.dept_locations(
	Dnumber	INT			NOT NULL,
	Dlocation	VARCHAR(100)	NOT NULL,
	PRIMARY KEY(Dnumber,Dlocation),
FOREIGN KEY(Dnumber) REFERENCES aula6_empresa.department(Dnumber));

CREATE TABLE aula6_empresa.project(
	Pname			VARCHAR(50)	NOT NULL,
	Pnumber		INT 			PRIMARY KEY,
	Plocation		VARCHAR(100)	NOT NULL,
	Dnum			INT 			NOT NULL,
	FOREIGN KEY(Dnum) REFERENCES aula6_empresa.department(Dnumber));

CREATE TABLE aula6_empresa.works_on(
	Essn		INT 			NOT NULL,
	Pno			INT 			NOT NULL,
	Hours		INT				NOT NULL,
	PRIMARY KEY		(Essn,Pno),
	FOREIGN KEY(Essn) REFERENCES aula6_empresa.employee(Ssn),
	FOREIGN KEY(Pno) REFERENCES aula6_empresa.project(Pnumber));

CREATE TABLE aula6_empresa.dependent(
	Essn			INT 			NOT NULL,
	Dependent_name	VARCHAR(50)	NOT NULL,
	Sex			VARCHAR(20)	NOT NULL,
	Bdate			DATE			NOT NULL,
Relationship		VARCHAR(100)	NOT NULL,
FOREIGN KEY(Essn)	 REFERENCES aula6_empresa.employee(Ssn));


ALTER TABLE aula6_empresa.employee ADD CONSTRAINT dep  FOREIGN KEY (Dno) REFERENCES aula6_empresa.department(Dnumber) ON UPDATE CASCADE;

/*
INSERT INTO aula6_empresa.works_on VALUES (183623612,1,20.0)
INSERT INTO aula6_empresa.works_on VALUES (183623612,3,10.0)
INSERT INTO aula6_empresa.works_on VALUES (21312332 ,1,20.0)
INSERT INTO aula6_empresa.works_on VALUES (321233765,1,25.0)
INSERT INTO aula6_empresa.works_on VALUES (342343434,1,20.0)
INSERT INTO aula6_empresa.works_on VALUES (342343434,4,25.0)
INSERT INTO aula6_empresa.works_on VALUES (41124234 ,2,20.0)
INSERT INTO aula6_empresa.works_on VALUES (41124234 ,3,30.0)

INSERT INTO aula6_empresa.project VALUES ('Aveiro Digital',1,'Aveiro',3)
INSERT INTO aula6_empresa.project VALUES ('BD Open Day',2,'Espinho',2)
INSERT INTO aula6_empresa.project VALUES ('Dicoogle',3,'Aveiro',3)
INSERT INTO aula6_empresa.project VALUES ('GOPACS',4,'Aveiro',3)

INSERT INTO aula6_empresa.dept_locations VALUES (2,'Aveiro')
INSERT INTO aula6_empresa.dept_locations VALUES (3,'Coimbra')

INSERT INTO aula6_empresa.dependent VALUES (21312332 ,'Joana Costa','F','2008-04-01', 'Filho')
INSERT INTO aula6_empresa.dependent VALUES (21312332 ,'Maria Costa','F','1990-10-05', 'Neto')
INSERT INTO aula6_empresa.dependent VALUES (21312332 ,'Rui Costa','M','2000-08-04','Neto')
INSERT INTO aula6_empresa.dependent VALUES (321233765,'Filho Lindo','M','2001-02-22','Filho')
INSERT INTO aula6_empresa.dependent VALUES (342343434,'Rosa Lima','F','2006-03-11','Filho')
INSERT INTO aula6_empresa.dependent VALUES (41124234 ,'Ana Sousa','F','2007-04-13','Neto')
INSERT INTO aula6_empresa.dependent VALUES (41124234 ,'Gaspar Pinto','M','2006-02-08','Sobrinho')

INSERT INTO aula6_empresa.department VALUES ('Investigacao',1,21312332 ,'2010-08-02')
INSERT INTO aula6_empresa.department VALUES ('Comercial',2,321233765,'2013-05-16')
INSERT INTO aula6_empresa.department VALUES ('Logistica',3,41124234 ,'2013-05-16')
INSERT INTO aula6_empresa.department VALUES ('Recursos Humanos',4,12652121,'2014-04-02')
INSERT INTO aula6_empresa.department VALUES ('Desporto',5,NULL,NULL)

INSERT INTO aula6_empresa.employee VALUES ('Paula','A','Sousa',183623612,'2001-08-11','Rua da FRENTE','F',1450.00,NULL,3)
INSERT INTO aula6_empresa.employee VALUES ('Carlos','D','Gomes',21312332 ,'2000-01-01','Rua XPTO','M',1200.00,NULL,1)
INSERT INTO aula6_empresa.employee VALUES ('Juliana','A','Amaral',321233765,'1980-08-11','Rua BZZZZ','F',1350.00,NULL,3)
INSERT INTO aula6_empresa.employee VALUES ('Maria','I','Pereira',342343434,'2001-05-01','Rua JANOTA','F',1250.00,21312332,2)
INSERT INTO aula6_empresa.employee VALUES ('Joao','G','Costa',41124234 ,'2001-01-01','Rua YGZ','M',1300.00,21312332,2)
INSERT INTO aula6_empresa.employee VALUES ('Ana','L','Silva',12652121 ,'1990-03-03','Rua ZIG ZAG','F',1400.00,21312332,2)
*/