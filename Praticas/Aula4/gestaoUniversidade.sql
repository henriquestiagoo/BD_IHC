--CREATE SCHEMA aula4_gestaoUniversidade;

IF (NOT EXISTS (SELECT * FROM sys.schemas WHERE name = 'aula4_gestaoUniversidade')) 
BEGIN
    EXEC ('CREATE SCHEMA aula4_gestaoUniversidade')
END
/*
DROP TABLE aula4_gestaoUniversidade.Orienta;
DROP TABLE aula4_gestaoUniversidade.Participa;
DROP TABLE aula4_gestaoUniversidade.Estudante_graduado;
DROP TABLE aula4_gestaoUniversidade.Projeto;
DROP TABLE aula4_gestaoUniversidade.Departamento;
DROP TABLE aula4_gestaoUniversidade.Professor;
DROP TABLE aula4_gestaoUniversidade.Pessoa;
DROP SCHEMA aula4_gestaoUniversidade;
*/
CREATE TABLE aula4_gestaoUniversidade.Pessoa(
	nmec		INT 			PRIMARY KEY,
	nome		VARCHAR(50)		NOT NULL,
	data_nasc	VARCHAR(50)		NOT NULL);

CREATE TABLE aula4_gestaoUniversidade.Professor(
	nmec				INT 			PRIMARY KEY,
	cat_prof			VARCHAR(50)		NOT NULL,
	area_cientifica		VARCHAR(50)		NOT NULL,
	nome_departamento	VARCHAR(50)		NOT NULL
	FOREIGN KEY(nmec)	REFERENCES aula4_gestaoUniversidade.Pessoa(nmec));

CREATE TABLE aula4_gestaoUniversidade.Departamento(
	nome				VARCHAR(50)		PRIMARY KEY,
	localizacao			VARCHAR(50)		NOT NULL,
	nmec_prof			INT				NOT NULL,
	FOREIGN KEY(nmec_prof)  REFERENCES aula4_gestaoUniversidade.Professor(nmec));

CREATE TABLE aula4_gestaoUniversidade.Projeto(
	id					INT 			PRIMARY KEY,
	nmec_prof			INT				NOT NULL,
	data_inicio			VARCHAR(50)		NOT NULL,
	data_fim			VARCHAR(50)		NOT NULL,
	nome				VARCHAR(50)		NOT NULL,
	orcamento			INT				NOT NULL,
	ent_financeira		VARCHAR(50)		NOT NULL,
	FOREIGN KEY(nmec_prof)  REFERENCES aula4_gestaoUniversidade.Professor(nmec));

CREATE TABLE aula4_gestaoUniversidade.Estudante_graduado(
	nmec					INT			PRIMARY KEY,
	nome_dep				VARCHAR(50)	NOT NULL,
	percentagem_dedicacao	INT			NOT NULL,
	nmec_advisor			INT			NOT NULL,
	grau_formacao			VARCHAR(50)	NOT NULL,
	FOREIGN KEY(nmec)  REFERENCES aula4_gestaoUniversidade.Pessoa(nmec),
	FOREIGN KEY(nmec_advisor)  REFERENCES aula4_gestaoUniversidade.Estudante_graduado(nmec),
	FOREIGN KEY(nome_dep)  REFERENCES aula4_gestaoUniversidade.Departamento(nome));

CREATE TABLE aula4_gestaoUniversidade.Participa(
	nmec_estudante			INT			NOT NULL,
	projeto_id				INT			NOT NULL,
	nmec_prof				INT			NOT NULL,
	PRIMARY KEY (nmec_estudante,projeto_id,nmec_prof),
	FOREIGN KEY(nmec_estudante)  REFERENCES aula4_gestaoUniversidade.Estudante_graduado(nmec),
	FOREIGN KEY(projeto_id)  REFERENCES aula4_gestaoUniversidade.Projeto(id),
	FOREIGN KEY(nmec_prof)  REFERENCES aula4_gestaoUniversidade.Professor(nmec));

CREATE TABLE aula4_gestaoUniversidade.Orienta(
	nmec_prof				INT			NOT NULL,
	projeto_id				INT			NOT NULL,
	PRIMARY KEY(nmec_prof,projeto_id),
	FOREIGN KEY(nmec_prof)  REFERENCES aula4_gestaoUniversidade.Professor(nmec),
	FOREIGN KEY(projeto_id)  REFERENCES aula4_gestaoUniversidade.Projeto(id));

--Chave Estrangeiras
--Professor
ALTER TABLE aula4_gestaoUniversidade.Professor ADD CONSTRAINT PRGEUNI FOREIGN KEY(nome_departamento)  REFERENCES aula4_gestaoUniversidade.Departamento(nome) ON UPDATE CASCADE;
