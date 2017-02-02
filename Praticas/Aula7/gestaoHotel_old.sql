
use p3g4;

-- DROP SCHEMA gestaoHotel;
-- CREATE SCHEMA gestaoHotel;


CREATE TABLE gestaoHotel.Temporada (
	idTemporada 		INT 			PRIMARY KEY,
	dataComeco			DATE			NOT NULL,
	dataTermino			DATE			NOT NULL,
	razao				VARCHAR(30),
	precoSimples		MONEY			NOT NULL,
	precoDouble			MONEY			NOT NULL,
	precoTwin			MONEY			NOT NULL,
	precoMiniSuite		MONEY			NOT NULL,
	precoSuite			MONEY			NOT NULL,
	CHECK(dataTermino>dataComeco));


CREATE TABLE gestaoHotel.Pensao(
	tipo			VARCHAR(3)			PRIMARY KEY,
	descricao		VARCHAR(50),
	CHECK (tipo IN ('SA', 'APA', 'PC')));

CREATE TABLE gestaoHotel.Pessoa(
	idPessoa		INT					PRIMARY KEY,
	email			VARCHAR(50)			UNIQUE	NOT NULL,
	Pnome			VARCHAR(15)			NOT NULL,
	Unome			VARCHAR(30)			NOT NULL,
	dataNasc		DATE,
	endereco		VARCHAR(50),
	sexo			CHAR(1),
	nrTelefone		CHAR(9),
	codigoPostal	VARCHAR(10));

CREATE TABLE gestaoHotel.Cliente(
	id					INT 				PRIMARY KEY,
	FOREIGN KEY (id)	REFERENCES gestaoHotel.Pessoa(idPessoa));

CREATE TABLE gestaoHotel.Funcionario(
	id					INT 			PRIMARY KEY,
	salario				INT 			NOT NULL,
	hotel				INT 			NOT NULL,
	FOREIGN KEY (id)	REFERENCES gestaoHotel.Pessoa(idPessoa));

CREATE TABLE gestaoHotel.Gerente (
	nrFuncionario				INT 			PRIMARY KEY,
	FOREIGN KEY(nrFuncionario)	REFERENCES gestaoHotel.Funcionario(id));

			
CREATE TABLE gestaoHotel.Hotel (
	idHotel					INT			PRIMARY KEY,
	nome					VARCHAR(30)	NOT NULL,
	classificacao			INT			NOT NULL,
	localizacao				VARCHAR(50)	NOT NULL,
	codigoPostal			VARCHAR(10),
	gerente					INT			NOT NULL,
	FOREIGN KEY(gerente)	REFERENCES gestaoHotel.Gerente(nrFuncionario));

CREATE TABLE gestaoHotel.Recepcionista (
	nrFuncionario				INT 			PRIMARY KEY,
	supervisor					INT,
	FOREIGN KEY (supervisor)	REFERENCES gestaoHotel.Recepcionista (nrFuncionario),
	FOREIGN KEY(nrFuncionario)	REFERENCES gestaoHotel.Funcionario (id));

CREATE TABLE gestaoHotel.Empregado(
	nrFuncionario				INT 			PRIMARY KEY,
	supervisor					INT,
	FOREIGN KEY(supervisor)		REFERENCES gestaoHotel.Empregado(nrFuncionario),
	FOREIGN KEY(nrFuncionario)	REFERENCES gestaoHotel.Funcionario (id));

CREATE TABLE gestaoHotel.TipoQuarto(
	tipo				VARCHAR(10)		PRIMARY KEY,
	descricao			VARCHAR(50),
	numCamasExtraDisp	INT				NOT NULL,
	CHECK (tipo IN ('single', 'double', 'twin', 'mini-suite', 'suite')));

CREATE TABLE gestaoHotel.Quarto(
	idQuarto			INT			PRIMARY KEY,
	fumador				BINARY(1)	NOT NULL,
	estado				BINARY(1)	NOT NULL,
	telefone			INT 		NOT NULL,
	tipoQuarto			VARCHAR(10)	NOT NULL,
	hotel				INT			NOT NULL,
	FOREIGN KEY(hotel)	REFERENCES gestaoHotel.Hotel(idHotel),
	FOREIGN KEY(tipoQuarto)	REFERENCES gestaoHotel.TipoQuarto(tipo),
	CHECK (fumador IN (0,1)),
	CHECK (estado IN (0,1)));


CREATE TABLE gestaoHotel.Pagamento (
	idPagamento					INT			PRIMARY KEY,
	metodo						VARCHAR(20),
	dataPagamento				DATE		NOT NULL,
	custoTotal					MONEY 		NOT NULL,
	recepcionista				INT			NOT NULL,
	FOREIGN KEY(recepcionista)	REFERENCES gestaoHotel.Recepcionista(nrFuncionario));

CREATE TABLE gestaoHotel.Reserva (
	idReserva					INT 		PRIMARY KEY,
	numPessoas					INT			NOT NULL,
	tipoPensao					VARCHAR(3)	DEFAULT 'SA',
	dataInicio					DATE		NOT NULL,
	dataFim 					DATE 		NOT NULL,
	pagamento					INT,
	quarto						INT 		NOT NULL,
	recepcionista				INT			NOT NULL,
	cliente						INT 		NOT NULL,
	FOREIGN KEY(tipoPensao)		REFERENCES gestaoHotel.Pensao(tipo),
	FOREIGN KEY(pagamento)		REFERENCES gestaoHotel.Pagamento(idPagamento),
	FOREIGN KEY(quarto)			REFERENCES gestaoHotel.Quarto(idQuarto),
	FOREIGN KEY(recepcionista)	REFERENCES gestaoHotel.Recepcionista(nrFuncionario),
	FOREIGN KEY(cliente)		REFERENCES gestaoHotel.Cliente(id),
	CHECK (DataFim > DataInicio));

CREATE TABLE gestaoHotel.Depende(
	idTemporada					INT		NOT NULL,
	idReserva					INT		NOT NULL,
	PRIMARY KEY(idTemporada, idReserva),
	FOREIGN KEY(idTemporada)	REFERENCES gestaoHotel.Temporada(idTemporada),
	FOREIGN KEY(idTemporada)	REFERENCES gestaoHotel.Reserva(idReserva));

CREATE TABLE gestaoHotel.Cama(
	tipo					VARCHAR(10)	PRIMARY KEY,
	preco					MONEY		NOT NULL,
	reserva					INT 		NOT NULL,
	FOREIGN KEY(reserva)	REFERENCES gestaoHotel.Reserva(idReserva),
	CHECK (tipo IN ('single', 'double', 'twin', 'queen', 'king')));


CREATE TABLE gestaoHotel.Servico(
	idServico					INT			PRIMARY KEY,
	custo						MONEY		NOT NULL,
	data						DATE		NOT NULL,
	reserva						INT			NOT NULL,
	funcionario					INT			NOT NULL,
	FOREIGN KEY(reserva)		REFERENCES gestaoHotel.Reserva(idReserva),
	FOREIGN KEY(funcionario)	REFERENCES gestaoHotel.Funcionario(id));

CREATE TABLE gestaoHotel.RoomService(
	idServico				INT			NOT NULL,
	idProduto				INT			NOT NULL,
	hora					TIME,
	FOREIGN KEY(idServico)	REFERENCES gestaoHotel.Servico(idServico));

CREATE TABLE gestaoHotel.Estacionamento(
	idServico				INT			NOT NULL,
	lugar					VARCHAR(4),
	FOREIGN KEY(idServico)	REFERENCES gestaoHotel.Servico(idServico));

CREATE TABLE gestaoHotel.Video(
	idServico				INT			NOT NULL,
	idFilme					INT			NOT NULL,
	hora					TIME,
	FOREIGN KEY(idServico)	REFERENCES gestaoHotel.Servico(idServico));

CREATE TABLE gestaoHotel.ServicoExterno(
	idServico				INT			NOT NULL,
	tipoServicoExt			VARCHAR(20)	NOT NULL,
	descricao				VARCHAR(50),
	FOREIGN KEY(idServico)	REFERENCES gestaoHotel.Servico(idServico),
	CHECK (tipoServicoExt IN ('aluguer', 'excursao', 'babySitting', 'espetaculo')));

CREATE TABLE gestaoHotel.RestauranteBar(
	idServico				INT			NOT NULL,
	tipo					VARCHAR(20)	NOT NULL,
	descricao				VARCHAR(50),
	FOREIGN KEY(idServico)	REFERENCES gestaoHotel.Servico(idServico),
	CHECK (tipo IN ('bar','restaurante')));

-- Funcionario
ALTER TABLE	gestaoHotel.Funcionario ADD CONSTRAINT HOFKIH FOREIGN KEY(hotel) REFERENCES gestaoHotel.Hotel(idHotel) 
	ON UPDATE CASCADE;


