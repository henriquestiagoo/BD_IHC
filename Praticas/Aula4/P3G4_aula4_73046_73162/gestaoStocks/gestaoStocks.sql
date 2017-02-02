IF (NOT EXISTS (SELECT * FROM sys.schemas WHERE name = 'aula4_gestaoStocks')) 
BEGIN
    EXEC ('CREATE SCHEMA aula4_gestaoStocks')
END

DROP TABLE aula4_gestaoStocks.Produto;
DROP TABLE aula4_gestaoStocks.Tipo_fornecedor;
DROP TABLE aula4_gestaoStocks.Fornecedor;
DROP TABLE aula4_gestaoStocks.Encomenda;
DROP TABLE aula4_gestaoStocks.Sujeito;


CREATE TABLE aula4_gestaoStocks.Produto(
	codigo			INT			PRIMARY KEY,
	nome			VARCHAR(50)	NOT NULL,
	taxa_iva		INT			NOT NULL,
	preco			INT			NOT NULL);

CREATE TABLE aula4_gestaoStocks.Tipo_fornecedor(
	codigo			INT			PRIMARY KEY,
	designacao		VARCHAR(50)	NOT NULL);

CREATE TABLE aula4_gestaoStocks.Fornecedor(
	NIF						INT			PRIMARY KEY,
	codigo_tipoFornecedor	INT			NOT NULL,
	condPagamento			VARCHAR(50)	NOT NULL,
	nr_fax					INT			NOT NULL,
	nome					VARCHAR(50)	NOT NULL,
	endereco				VARCHAR(50)	NOT NULL,
	FOREIGN KEY(codigo_tipoFornecedor)  	REFERENCES aula4_gestaoStocks.Tipo_fornecedor(codigo));

CREATE TABLE aula4_gestaoStocks.Encomenda(
	nr				INT			PRIMARY KEY,
	data			VARCHAR(50)	NOT NULL,
	NIF_fornecedor	INT			NOT NULL,
	FOREIGN KEY(NIF_fornecedor)  REFERENCES aula4_gestaoStocks.Fornecedor(NIF));

CREATE TABLE aula4_gestaoStocks.Sujeito(
	nr_encomenda	INT			NOT NULL,
	codigo_produto	INT			NOT NULL,
	unidades		INT,
	PRIMARY KEY(nr_encomenda,codigo_produto),
	FOREIGN KEY(nr_encomenda)	REFERENCES aula4_gestaoStocks.Encomenda(nr),
	FOREIGN KEY(codigo_produto) REFERENCES aula4_gestaoStocks.Produto(codigo));
