--CREATE SCHEMA aula4_prescricaoMed;
use p3g4;

IF (NOT EXISTS (SELECT * FROM sys.schemas WHERE name = 'aula4_prescricaoMed')) 
BEGIN
    EXEC ('CREATE SCHEMA aula4_prescricaoMed')
END
/*
DROP TABLE aula4_prescricaoMed.Contem;
DROP TABLE aula4_prescricaoMed.Farmaco;
DROP TABLE aula4_prescricaoMed.Farmaceutica;
DROP  TABLE aula4_prescricaoMed.Prescricao;
DROP TABLE aula4_prescricaoMed.Farmacia;
DROP  TABLE aula4_prescricaoMed.Paciente;
DROP TABLE aula4_prescricaoMed.Medico;
DROP SCHEMA aula4_prescricaoMed;
*/
--/*
CREATE TABLE aula4_prescricaoMed.Medico(
	nr_id			INT			PRIMARY KEY,
	nome			VARCHAR(50)	NOT NULL,
	especialidade	VARCHAR(50));

CREATE TABLE aula4_prescricaoMed.Paciente(
	nr_utente		INT			PRIMARY KEY,
	nome			VARCHAR(50)	NOT NULL,
	data_nasc		DATE		NOT NULL,
	endereco		VARCHAR(50)	NOT NULL);

CREATE TABLE aula4_prescricaoMed.Farmacia(
	nome			VARCHAR(50)	PRIMARY KEY,
	endereco		VARCHAR(50)	NOT NULL,
	telefone		INT			NOT NULL);

CREATE TABLE aula4_prescricaoMed.Prescricao(
	nr_unico			INT			PRIMARY KEY,
	utente_nr			INT			NOT NULL,
	medico_id			INT			NOT NULL,
	farmacia			VARCHAR(50),
	data_processamento	DATE,
	FOREIGN KEY(medico_id)  REFERENCES aula4_prescricaoMed.Medico(nr_id),
	FOREIGN KEY(utente_nr)  REFERENCES aula4_prescricaoMed.Paciente(nr_utente),
	FOREIGN KEY(farmacia)  REFERENCES aula4_prescricaoMed.Farmacia(nome));

CREATE TABLE aula4_prescricaoMed.Farmaceutica(
	nr_reg_nac		INT			PRIMARY KEY,
	nome			VARCHAR(50)	NOT NULL,
	endereco		VARCHAR(50));

CREATE TABLE aula4_prescricaoMed.Farmaco(
	nr_reg_nac_farmaceutica		INT				NOT NULL,
	nome_comercial				VARCHAR(50)		NOT NULL,
	formula						VARCHAR(100),
	PRIMARY KEY (nr_reg_nac_farmaceutica,nome_comercial),
	FOREIGN KEY(nr_reg_nac_farmaceutica)  REFERENCES aula4_prescricaoMed.Farmaceutica(nr_reg_nac));

CREATE TABLE aula4_prescricaoMed.Contem(
	nr_reg_nac_farmaceutica	INT				NOT NULL,
	nomeFarmaco				VARCHAR(50)	NOT NULL,
	nr_unico_prescricao		INT				NOT NULL,
	PRIMARY KEY (nr_reg_nac_farmaceutica,nomeFarmaco,nr_unico_prescricao),
	FOREIGN KEY(nr_unico_prescricao)  REFERENCES aula4_prescricaoMed.Prescricao(nr_unico),
	FOREIGN KEY(nr_reg_nac_farmaceutica,nomeFarmaco)  REFERENCES aula4_prescricaoMed.Farmaco(nr_reg_nac_farmaceutica,nome_comercial));

-- INSERTS
-- MEDICOS
INSERT INTO aula4_prescricaoMed.Medico VALUES (101,'Joao Pires Lima', 'Cardiologia')
INSERT INTO aula4_prescricaoMed.Medico VALUES (102,'Manuel Jose Rosa', 'Cardiologia')
INSERT INTO aula4_prescricaoMed.Medico VALUES (103,'Rui Luis Caraca', 'Pneumologia')
INSERT INTO aula4_prescricaoMed.Medico VALUES (104,'Sofia Sousa Silva', 'Radiologia')
INSERT INTO aula4_prescricaoMed.Medico VALUES (105,'Ana Barbosa', 'Neurologia')
-- PACIENTES
INSERT INTO aula4_prescricaoMed.Paciente VALUES (1,'Renato Manuel Cavaco',Convert(date, '19800103'),'Rua Nova do Pilar 35')
INSERT INTO aula4_prescricaoMed.Paciente VALUES (2,'Paula Vasco Silva', Convert(date, '19721030'),'Rua Direita 43')
INSERT INTO aula4_prescricaoMed.Paciente VALUES (3,'Ines Couto Souto', Convert(date, '19850512'),'Rua de Cima 144')
INSERT INTO aula4_prescricaoMed.Paciente VALUES (4,'Rui Moreira Porto', Convert(date, '19701212'),'Rua Zig Zag 235')
INSERT INTO aula4_prescricaoMed.Paciente VALUES (5,'Manuel Zeferico Polaco', Convert(date, '19900605'),'Rua da Baira Rio 1135')
-- FARMACIA
INSERT INTO aula4_prescricaoMed.Farmacia (nome, telefone, endereco) VALUES ('Farmacia BelaVista',221234567,'Avenida Principal 973')
INSERT INTO aula4_prescricaoMed.Farmacia (nome, telefone, endereco) VALUES ('Farmacia Central',234370500,'Avenida da Liberdade 33')
INSERT INTO aula4_prescricaoMed.Farmacia (nome, telefone, endereco) VALUES ('Farmacia Peixoto',234375111,'Largo da Vila 523')
INSERT INTO aula4_prescricaoMed.Farmacia (nome, telefone, endereco) VALUES ('Farmacia Vitalis',229876543,'Rua Visconde Salgado 263')
-- FARMACEUTICA
INSERT INTO aula4_prescricaoMed.Farmaceutica (nr_reg_nac, nome, endereco) VALUES (905, 'Roche','Estrada Nacional 249')
INSERT INTO aula4_prescricaoMed.Farmaceutica (nr_reg_nac, nome, endereco) VALUES (15432, 'Bayer','Rua da Quinta do Pinheiro 5')
INSERT INTO aula4_prescricaoMed.Farmaceutica (nr_reg_nac, nome, endereco) VALUES (907, 'Pfizer','Empreendimento Lagoas Park - Edificio 7')
INSERT INTO aula4_prescricaoMed.Farmaceutica (nr_reg_nac, nome, endereco) VALUES (908, 'Merck', 'Alameda Fernão Lopes 12')
-- FARMACO
INSERT INTO aula4_prescricaoMed.Farmaco VALUES (905,'Boa Saude em 3 Dias', 'XZT9')
INSERT INTO aula4_prescricaoMed.Farmaco VALUES (15432,'Voltaren Spray', 'PLTZ32')
INSERT INTO aula4_prescricaoMed.Farmaco VALUES (15432,'Xelopironi 350', 'FRR-34')
INSERT INTO aula4_prescricaoMed.Farmaco VALUES (15432,'Gucolan 1000', 'VFR-750')
INSERT INTO aula4_prescricaoMed.Farmaco VALUES (907,'GEROaero Rapid', 'DDFS-XEN9')
INSERT INTO aula4_prescricaoMed.Farmaco VALUES (908,'Aspirina 1000', 'BIOZZ02')
-- PRESCRICAO
INSERT INTO aula4_prescricaoMed.Prescricao VALUES (10001, 1, 105,'Farmacia Central', Convert(date, '20150303'))
INSERT INTO aula4_prescricaoMed.Prescricao VALUES (10002,1,105,NULL,NULL)
INSERT INTO aula4_prescricaoMed.Prescricao VALUES (10003,3,102,'Farmacia Central', Convert(date, '20150117'))
INSERT INTO aula4_prescricaoMed.Prescricao VALUES (10004,3,101,'Farmacia BelaVista', Convert(date, '20150209'))
INSERT INTO aula4_prescricaoMed.Prescricao VALUES (10005,3,102,'Farmacia Central', Convert(date, '20150117'))
INSERT INTO aula4_prescricaoMed.Prescricao VALUES (10006,4,102,'Farmacia Vitalis', Convert(date, '20150222'))
INSERT INTO aula4_prescricaoMed.Prescricao VALUES (10007,5,103,NULL,NULL)
INSERT INTO aula4_prescricaoMed.Prescricao VALUES (10008,1,103,'Farmacia Central', Convert(date, '2015-01-02'))
INSERT INTO aula4_prescricaoMed.Prescricao VALUES (10009,3,102,'Farmacia Peixoto', Convert(date, '20150202'))
-- CONTEM
INSERT INTO aula4_prescricaoMed.Contem (nr_unico_prescricao, nr_reg_nac_farmaceutica, nomeFarmaco) VALUES (10001,905,'Boa Saude em 3 Dias')
INSERT INTO aula4_prescricaoMed.Contem (nr_unico_prescricao, nr_reg_nac_farmaceutica, nomeFarmaco) VALUES (10002,907,'GEROaero Rapid')
INSERT INTO aula4_prescricaoMed.Contem (nr_unico_prescricao, nr_reg_nac_farmaceutica, nomeFarmaco) VALUES (10003,906,'Voltaren Spray')
INSERT INTO aula4_prescricaoMed.Contem (nr_unico_prescricao, nr_reg_nac_farmaceutica, nomeFarmaco) VALUES (10003,906,'Xelopironi 350')
INSERT INTO aula4_prescricaoMed.Contem (nr_unico_prescricao, nr_reg_nac_farmaceutica, nomeFarmaco) VALUES (10003,908,'Aspirina 1000')
INSERT INTO aula4_prescricaoMed.Contem (nr_unico_prescricao, nr_reg_nac_farmaceutica, nomeFarmaco) VALUES (10004,905,'Boa Saude em 3 Dias')
INSERT INTO aula4_prescricaoMed.Contem (nr_unico_prescricao, nr_reg_nac_farmaceutica, nomeFarmaco) VALUES (10004,908,'Aspirina 1000')
INSERT INTO aula4_prescricaoMed.Contem (nr_unico_prescricao, nr_reg_nac_farmaceutica, nomeFarmaco) VALUES (10005,906,'Voltaren Spray')
INSERT INTO aula4_prescricaoMed.Contem (nr_unico_prescricao, nr_reg_nac_farmaceutica, nomeFarmaco) VALUES (10006,905,'Boa Saude em 3 Dias')
INSERT INTO aula4_prescricaoMed.Contem (nr_unico_prescricao, nr_reg_nac_farmaceutica, nomeFarmaco) VALUES (10006,906,'Voltaren Spray')
INSERT INTO aula4_prescricaoMed.Contem (nr_unico_prescricao, nr_reg_nac_farmaceutica, nomeFarmaco) VALUES (10006,906,'Xelopironi 350')
INSERT INTO aula4_prescricaoMed.Contem (nr_unico_prescricao, nr_reg_nac_farmaceutica, nomeFarmaco) VALUES (10006,908,'Aspirina 1000')
INSERT INTO aula4_prescricaoMed.Contem (nr_unico_prescricao, nr_reg_nac_farmaceutica, nomeFarmaco) VALUES (10007,906,'Voltaren Spray')
INSERT INTO aula4_prescricaoMed.Contem (nr_unico_prescricao, nr_reg_nac_farmaceutica, nomeFarmaco) VALUES (10008,905,'Boa Saude em 3 Dias')
INSERT INTO aula4_prescricaoMed.Contem (nr_unico_prescricao, nr_reg_nac_farmaceutica, nomeFarmaco) VALUES (10008,908,'Aspirina 1000')
INSERT INTO aula4_prescricaoMed.Contem (nr_unico_prescricao, nr_reg_nac_farmaceutica, nomeFarmaco) VALUES (10009,905,'Boa Saude em 3 Dias')
INSERT INTO aula4_prescricaoMed.Contem (nr_unico_prescricao, nr_reg_nac_farmaceutica, nomeFarmaco) VALUES (10009,906,'Voltaren Spray')
INSERT INTO aula4_prescricaoMed.Contem (nr_unico_prescricao, nr_reg_nac_farmaceutica, nomeFarmaco) VALUES (10009,908,'Aspirina 1000')
