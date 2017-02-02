
IF (NOT EXISTS (SELECT * FROM sys.schemas WHERE name = 'aula4_gestaoConferencias')) 
BEGIN
    EXEC ('CREATE SCHEMA aula4_gestaoConferencias')
END

/*
DROP TABLE aula4_gestaoConferencias.Instituicao;
DROP TABLE aula4_gestaoConferencias.Escrito;
DROP TABLE aula4_gestaoConferencias.Nao_Estudante;
DROP TABLE aula4_gestaoConferencias.Estudante;
DROP  TABLE aula4_gestaoConferencias.Pessoa;
DROP TABLE aula4_gestaoConferencias.Artigo_Cientifico;
DROP SCHEMA aula4_gestaoConferencias;




*/
CREATE TABLE aula4_gestaoConferencias.Artigo_Cientifico(
	nr_registo	INT 			PRIMARY KEY,
	titulo		VARCHAR(50)	NOT NULL);

CREATE TABLE aula4_gestaoConferencias.Pessoa(
	email			VARCHAR(50)	PRIMARY KEY,
	nome			VARCHAR(50)	NOT NULL,
	nome_instituicao	VARCHAR(50)	NOT NULL);

CREATE TABLE aula4_gestaoConferencias.Estudante(
	email_pessoa		VARCHAR(50)	PRIMARY KEY,
	morada		VARCHAR(100)	NOT NULL,
	dataInscricao		DATE			NOT NULL,
	custoInscricao		MONEY		NOT NULL,
	comprovativo		INT			NOT NULL);

CREATE TABLE aula4_gestaoConferencias.Nao_Estudante(
	email_pessoa		VARCHAR(50)	PRIMARY KEY,
	morada		VARCHAR(100)	NOT NULL,
	dataInscricao		DATE			NOT NULL,
	custoInscricao		MONEY		NOT NULL,
	refTransBancaria	INT			NOT NULL);

CREATE TABLE aula4_gestaoConferencias.Instituicao(
	nome			VARCHAR(50)	PRIMARY KEY,
	endereco		VARCHAR(100)	NOT NULL);

CREATE TABLE aula4_gestaoConferencias.Escrito(
	nr_reg			INT,
	email_pessoa		VARCHAR(50),
PRIMARY KEY(nr_reg,email_pessoa));

--Chaves Estrangeiras

--Pessoa
ALTER TABLE aula4_gestaoConferencias.Pessoa ADD CONSTRAINT PENIFK FOREIGN KEY(nome_instituicao) REFERENCES aula4_gestaoConferencias.Instituicao(nome) ON UPDATE CASCADE;

--Estudante
ALTER TABLE aula4_gestaoConferencias.Estudante ADD CONSTRAINT ESEMFK FOREIGN KEY(email_pessoa) REFERENCES aula4_gestaoConferencias.Pessoa(email) ON UPDATE CASCADE;

--Nao_Estudante
ALTER TABLE aula4_gestaoConferencias.Nao_Estudante ADD CONSTRAINT NESEMFK FOREIGN KEY(email_pessoa) REFERENCES aula4_gestaoConferencias.Pessoa(email) ON UPDATE CASCADE;

--Escrito
ALTER TABLE aula4_gestaoConferencias.Escrito ADD CONSTRAINT ECNRFK FOREIGN KEY(nr_reg) REFERENCES aula4_gestaoConferencias.Artigo_Cientifico(nr_registo) ON UPDATE CASCADE;
ALTER TABLE aula4_gestaoConferencias.Escrito ADD CONSTRAINT ECEPFK FOREIGN KEY(email_pessoa) REFERENCES aula4_gestaoConferencias.Pessoa(email) ON UPDATE CASCADE;
