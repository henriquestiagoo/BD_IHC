
--CREATE SCHEMA aula4_rentacar;

/*
DROP TABLE aula4_rentacar.Cliente;
DROP TABLE aula4_rentacar.Aluguer;
DROP TABLE aula4_rentacar.Balcao;
DROP TABLE aula4_rentacar.Tipo_Veiculo;
DROP TABLE aula4_rentacar.Veiculo;
DROP TABLE aula4_rentacar.Ligeiro;
DROP TABLE aula4_rentacar.Pesado;
DROP TABLE aula4_rentacar.Similaridade;
*/

CREATE TABLE aula4_rentacar.Cliente(
	nome				VARCHAR(30)		NOT NULL,
	endereco			VARCHAR(30)		NOT NULL,
	num_carta			INT				NOT NULL	UNIQUE,
	nif					INT							PRIMARY KEY); 

CREATE TABLE aula4_rentacar.Aluguer(
	numero				INT							PRIMARY KEY,
	duracao				INT				NOT NULL,
	data				DATE			NOT NULL,
	nif_cliente			INT				NOT NULL,
	numero_balcao		INT,
	matricula_veiculo	CHAR(8)); 

CREATE TABLE aula4_rentacar.Balcao(
	numero				INT							PRIMARY KEY,
	nome				VARCHAR			NOT NULL,
	endereco			VARCHAR			NOT NULL);

CREATE TABLE aula4_rentacar.Tipo_Veiculo(
	codigo				INT							PRIMARY KEY,
	arcondicionado		BIT				NOT NULL,
	designacao			VARCHAR(30)					UNIQUE);

CREATE TABLE aula4_rentacar.Ligeiro(
	codigo				INT				PRIMARY KEY,
	portas				INT				NOT NULL,
	combustivel			VARCHAR(30)		NOT NULL,
	numlugares			INT				NOT NULL); 


CREATE TABLE aula4_rentacar.Veiculo(
	matricula			CHAR(8)			PRIMARY KEY,
	ano					INT				NOT NULL,
	marca				VARCHAR(15)		NOT NULL,
	codigo_tipoVeiculo  INT);

CREATE TABLE aula4_rentacar.Pesado(
	codigo				INT				PRIMARY KEY,
	peso				INT				NOT NULL,
	passageiros			INT				NOT NULL			CHECK(passageiros<=5));

CREATE TABLE aula4_rentacar.Similaridade(
	codigo_tipoVeiculo	INT				NOT NULL,
	codigo_tipoVeiculo2	INT				NOT NULL,
	PRIMARY KEY (codigo_tipoVeiculo,codigo_tipoVeiculo2));

--Chaves Estrangeiras

--Aluguer
ALTER TABLE aula4_rentacar.Aluguer ADD CONSTRAINT ALNIFFK FOREIGN KEY(nif_cliente)
	REFERENCES aula4_rentacar.Cliente(nif) ON UPDATE CASCADE;
ALTER TABLE aula4_rentacar.Aluguer ADD CONSTRAINT ALBCFK FOREIGN KEY(numero_balcao)
	REFERENCES aula4_rentacar.Balcao(numero) ON UPDATE CASCADE;
ALTER TABLE aula4_rentacar.Aluguer ADD CONSTRAINT ALMTFK FOREIGN KEY(matricula_veiculo)
	REFERENCES aula4_rentacar.Veiculo(matricula) ON UPDATE CASCADE;

--Veiculo
ALTER TABLE aula4_rentacar.Veiculo ADD CONSTRAINT VECVFK FOREIGN KEY(codigo_tipoVeiculo)
	REFERENCES aula4_rentacar.Tipo_Veiculo(codigo) ON UPDATE CASCADE;

--Ligeiro
ALTER TABLE aula4_rentacar.Ligeiro ADD CONSTRAINT LICDFK FOREIGN KEY(codigo)
	REFERENCES aula4_rentacar.Tipo_Veiculo(codigo) ON UPDATE CASCADE;

--Pesado
ALTER TABLE aula4_rentacar.Pesado ADD CONSTRAINT PECDFK FOREIGN KEY(codigo)
	REFERENCES aula4_rentacar.Tipo_Veiculo(codigo) ON UPDATE CASCADE;

--Similaridade
ALTER TABLE aula4_rentacar.Similaridade ADD CONSTRAINT SMCDFK FOREIGN KEY(codigo_tipoVeiculo)
	REFERENCES aula4_rentacar.Tipo_Veiculo(codigo) ON UPDATE CASCADE;
ALTER TABLE aula4_rentacar.Similaridade ADD CONSTRAINT SMCD2FK FOREIGN KEY(codigo_tipoVeiculo2)
	REFERENCES aula4_rentacar.Tipo_Veiculo(codigo) ON UPDATE NO ACTION;
