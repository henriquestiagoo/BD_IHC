--CREATE SCHEMA aula4_prescricaoMed;

IF (NOT EXISTS (SELECT * FROM sys.schemas WHERE name = 'aula4_prescricaoMed')) 
BEGIN
    EXEC ('CREATE SCHEMA aula4_prescricaoMed')
END
/*
DROP TABLE aula4_prescricaoMed.Produzir;
DROP TABLE aula4_prescricaoMed.Contem;
DROP TABLE aula4_prescricaoMed.Vende;
DROP TABLE aula4_prescricaoMed.Farmaco;
DROP TABLE aula4_prescricaoMed.Farmaceutica;
DROP  TABLE aula4_prescricaoMed.Prescricao;
DROP TABLE aula4_prescricaoMed.Farmacia
DROP  TABLE aula4_prescricaoMed.Paciente;
DROP TABLE aula4_prescricaoMed.Medico;
DROP SCHEMA aula4_prescricaoMed;
*/
--/*
CREATE TABLE aula4_prescricaoMed.Medico(
	nr_id			INT			PRIMARY KEY,
	nome			VARCHAR(50)	NOT NULL,
	endereco		VARCHAR(50)	NOT NULL);

CREATE TABLE aula4_prescricaoMed.Paciente(
	nr_utente		INT			PRIMARY KEY,
	nome			VARCHAR(50)	NOT NULL,
	data_nasc		VARCHAR(50)	NOT NULL,
	endereco		VARCHAR(50)	NOT NULL);

CREATE TABLE aula4_prescricaoMed.Farmacia(
	telefone		INT			PRIMARY KEY,
	nome			VARCHAR(50)	NOT NULL,
	endereco		VARCHAR(50)	NOT NULL);

CREATE TABLE aula4_prescricaoMed.Prescricao(
	nr_unico			INT			PRIMARY KEY,
	medico_id			INT			NOT NULL,
	utente_nr			INT			NOT NULL,
	telefone_farmacia	INT			NOT NULL,
	data_processamento	VARCHAR(50)	NOT NULL,
	FOREIGN KEY(medico_id)  REFERENCES aula4_prescricaoMed.Medico(nr_id),
	FOREIGN KEY(utente_nr)  REFERENCES aula4_prescricaoMed.Paciente(nr_utente),
	FOREIGN KEY(telefone_farmacia)  REFERENCES aula4_prescricaoMed.Farmacia(telefone));

CREATE TABLE aula4_prescricaoMed.Farmaceutica(
	nr_reg_nac		INT			PRIMARY KEY,
	nome			VARCHAR(50)	NOT NULL,
	taxa_iva		INT			NOT NULL,
	endereco		VARCHAR(50)	NOT NULL);

CREATE TABLE aula4_prescricaoMed.Farmaco(
	formula						VARCHAR(100)	NOT NULL,
	nr_reg_nac_farmaceutica		INT				NOT NULL,
	nome_comercial				VARCHAR(50)		NOT NULL,
	PRIMARY KEY (nr_reg_nac_farmaceutica,formula),
	FOREIGN KEY(nr_reg_nac_farmaceutica)  REFERENCES aula4_prescricaoMed.Farmaceutica(nr_reg_nac));

CREATE TABLE aula4_prescricaoMed.Vende(
	tel_farmacia				INT			NOT NULL,
	nr_reg_nac_farmaceutica		INT			NOT NULL,	
	formula_farmaco				VARCHAR(100)	NOT NULL,
	PRIMARY KEY(tel_farmacia,nr_reg_nac_farmaceutica,formula_farmaco),
	FOREIGN KEY(tel_farmacia)  REFERENCES aula4_prescricaoMed.Farmacia(telefone),
	FOREIGN KEY(nr_reg_nac_farmaceutica,formula_farmaco)  REFERENCES aula4_prescricaoMed.Farmaco(nr_reg_nac_farmaceutica,formula));
	--FOREIGN KEY(formula_farmaco)  REFERENCES aula4_prescricaoMed.Farmaco(formula));

CREATE TABLE aula4_prescricaoMed.Contem(
	nr_unico_prescricao		INT				NOT NULL,
	nr_reg_nac_farmaceutica	INT				NOT NULL,
	formula_farmaco			VARCHAR(100)	NOT NULL,
	PRIMARY KEY (nr_unico_prescricao,nr_reg_nac_farmaceutica,formula_farmaco),
	FOREIGN KEY(nr_unico_prescricao)  REFERENCES aula4_prescricaoMed.Prescricao(nr_unico),
	FOREIGN KEY(nr_reg_nac_farmaceutica,formula_farmaco)  REFERENCES aula4_prescricaoMed.Farmaco(nr_reg_nac_farmaceutica,formula));
 
CREATE TABLE aula4_prescricaoMed.Produzir(
	formula_farmaco				VARCHAR(100)	NOT NULL,
	nr_reg_nac_farmaceutica		INT				NOT NULL,
	nr_reg_nac_farmaceutica2	INT				NOT NULL,
	PRIMARY KEY (nr_reg_nac_farmaceutica2,nr_reg_nac_farmaceutica,formula_farmaco),
	FOREIGN KEY(nr_reg_nac_farmaceutica,formula_farmaco)  REFERENCES aula4_prescricaoMed.Farmaco(nr_reg_nac_farmaceutica,formula),
	FOREIGN KEY(nr_reg_nac_farmaceutica2)  REFERENCES aula4_prescricaoMed.Farmaceutica(nr_reg_nac));
