
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
	-- FALTA FOREIGN KEY HOTEL (ALTER TABLE)
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
	CHECK (tipoQuarto IN ('single', 'double', 'twin', 'mini-suite', 'suite')),
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
	CHECK (tipoPensao IN ('SA', 'APA', 'PC')),
	CHECK (DataFim > DataInicio));
	
CREATE TABLE gestaoHotel.Depende(
	idTemporada					INT		NOT NULL,
	idReserva					INT		NOT NULL,
	PRIMARY KEY(idTemporada, idReserva),
	FOREIGN KEY(idTemporada)	REFERENCES gestaoHotel.Temporada(idTemporada),
	FOREIGN KEY(idReserva)	REFERENCES gestaoHotel.Reserva(idReserva));
	
CREATE TABLE gestaoHotel.Cama(
	tipo					VARCHAR(10)	PRIMARY KEY,
	preco					MONEY		NOT NULL,
	CHECK (tipo IN ('single', 'double', 'twin', 'queen', 'king')));
	
CREATE TABLE gestaoHotel.Requere(
	idRequerimento			INT			PRIMARY KEY,
	tipo					VARCHAR(10)	NOT NULL,
	idReserva				INT 		NOT NULL,
	FOREIGN KEY(tipo)		REFERENCES gestaoHotel.Cama(tipo),
	FOREIGN KEY(idReserva)	REFERENCES gestaoHotel.Reserva(idReserva),
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
	idServico				INT			PRIMARY KEY,
	idProduto				INT			NOT NULL,
	hora					TIME,
	FOREIGN KEY(idServico)	REFERENCES gestaoHotel.Servico(idServico));

CREATE TABLE gestaoHotel.Estacionamento(
	idServico				INT			PRIMARY KEY,
	lugar					VARCHAR(4),
	FOREIGN KEY(idServico)	REFERENCES gestaoHotel.Servico(idServico));

CREATE TABLE gestaoHotel.Video(
	idServico				INT			PRIMARY KEY,
	idFilme					INT			NOT NULL,
	hora					TIME,
	FOREIGN KEY(idServico)	REFERENCES gestaoHotel.Servico(idServico));

CREATE TABLE gestaoHotel.ServicoExterno(
	idServico				INT			PRIMARY KEY,
	tipoServicoExt			VARCHAR(20)	NOT NULL,
	descricao				VARCHAR(50),
	FOREIGN KEY(idServico)	REFERENCES gestaoHotel.Servico(idServico),
	CHECK (tipoServicoExt IN ('aluguer', 'excursao', 'babySitting', 'espetaculo')));

CREATE TABLE gestaoHotel.RestauranteBar(
	idServico				INT			PRIMARY KEY,
	tipo					VARCHAR(20)	NOT NULL,
	descricao				VARCHAR(50),
	FOREIGN KEY(idServico)	REFERENCES gestaoHotel.Servico(idServico),
	CHECK (tipo IN ('bar','restaurante')));

-- Funcionario
ALTER TABLE	gestaoHotel.Funcionario ADD CONSTRAINT HOFKIH FOREIGN KEY(hotel) REFERENCES gestaoHotel.Hotel(idHotel) 
	ON UPDATE CASCADE;


/*
INSERT INTO gestaoHotel.Temporada VALUES (1000,'2016-12-23','2016-12-26','Natal', 120,130,140,150,160)
INSERT INTO gestaoHotel.Temporada VALUES (1001,'2016-12-31','2017-1-2','Passagem de ano', 130,140,150,160,170)
INSERT INTO gestaoHotel.Temporada VALUES (1002,'2016-4-1','2016-4-4','Conferencia Medicos', 120,120,120,130,130)
INSERT INTO gestaoHotel.Temporada VALUES (1003,'2016-5-4','2016-5-16','Fim de semana', 140,150,160,160,200)
INSERT INTO gestaoHotel.Temporada VALUES (1004,'2016-2-1','2016-3-3','promoção', 100,100,110,120,140)

INSERT INTO gestaoHotel.Pensao VALUES ('SA','Apenas Alojamento')
INSERT INTO gestaoHotel.Pensao VALUES ('APA','Alojamento e pequeno-almoço')
INSERT INTO gestaoHotel.Pensao VALUES ('PC','Pensão completa,alojamento, pequeno-alm, refeições')

INSERT INTO gestaoHotel.Pessoa VALUES (50,'rothixz@gmail.com','Antonio','mota','1995-12-25','rua da pega, nº 91, Aveiro','M','915464875','3256-536')
INSERT INTO gestaoHotel.Pessoa VALUES (2, 'slong1@wikipedia.org', 'Stephen', 'Long', '5/30/2006', '41173 Northview Park', 'M', 147849065, 8747489)
INSERT INTO gestaoHotel.Pessoa VALUES (3, 'ksimpson2@multiply.com', 'Kevin', 'Simpson', '5/12/2006', '256 Steensland Crossing', 'M', 433420895, 9469764)
INSERT INTO gestaoHotel.Pessoa VALUES (4, 'rwillis3@cloudflare.com', 'Russell', 'Willis', '12/29/2013', '8637 Lindbergh Pass', 'M', 243810063, 5478245);
INSERT INTO gestaoHotel.Pessoa VALUES (5, 'vcole4@comcast.net', 'Victor', 'Cole', '3/27/2016', '1956 Dennis Park', 'M', 204452314, 2815917);
INSERT INTO gestaoHotel.Pessoa VALUES (6, 'wwells5@mashable.com', 'Wanda', 'Wells', '7/25/2012', '712 Roxbury Park', 'F', 178724722, 5674831);
INSERT INTO gestaoHotel.Pessoa VALUES  (7, 'rgray6@pen.io', 'Russell', 'Gray', '6/1/2010', '5 Graceland Center', 'M', 899116553, 3040464);
INSERT INTO gestaoHotel.Pessoa VALUES (8, 'jwest7@so-net.ne.jp', 'Jack', 'West', '3/11/1996', '3574 Dawn Street', 'M', 378648914, 3510887);
INSERT INTO gestaoHotel.Pessoa VALUES (9, 'bmcdonald8@spotify.com', 'Beverly', 'Mcdonald', '4/6/2008', '8353 Oak Circle', 'F', 311186278, 5254647);
INSERT INTO gestaoHotel.Pessoa VALUES (10, 'pyoung9@scientificamerican.com', 'Peter', 'Young', '4/16/2006', '398 Judy Court', 'M', 613894051, 7030710);
INSERT INTO gestaoHotel.Pessoa VALUES  (11, 'dortiza@cocolog-nifty.com', 'Dennis', 'Ortiz', '6/6/2002', '47 Ruskin Avenue', 'M', 528700016, 9262445);
INSERT INTO gestaoHotel.Pessoa VALUES (12, 'tsimpsonb@oaic.gov.au', 'Thomas', 'Simpson', '7/10/2015', '0858 Dottie Court', 'M', 856580528, 8138615);
INSERT INTO gestaoHotel.Pessoa VALUES (13, 'abellc@vinaora.com', 'Amanda', 'Bell', '8/8/2014', '52 Sauthoff Way', 'F', 833406374, 2436151);
INSERT INTO gestaoHotel.Pessoa VALUES (14, 'kpetersond@rambler.ru', 'Kelly', 'Peterson', '9/5/2005', '60650 John Wall Center', 'F', 451249176, 8909109);
INSERT INTO gestaoHotel.Pessoa VALUES (15, 'jburtone@yelp.com', 'Jacqueline', 'Burton', '3/3/2016', '375 Crest Line Lane', 'F', 439884607, 3130072);
INSERT INTO gestaoHotel.Pessoa VALUES (16, 'vgrantf@paginegialle.it', 'Victor', 'Grant', '8/21/2003', '8 Pankratz Junction', 'M', 978499632, 3064730);
INSERT INTO gestaoHotel.Pessoa VALUES (17, 'mdunng@flickr.com', 'Matthew', 'Dunn', '3/15/1998', '3644 Mitchell Way', 'M', 557103316, 6140222);
INSERT INTO gestaoHotel.Pessoa VALUES (18, 'pclarkh@usa.gov', 'Pamela', 'Clark', '6/15/2001', '7 Summit Avenue', 'F', 779217664, 5323709);
INSERT INTO gestaoHotel.Pessoa VALUES (19, 'dmurphyi@paypal.com', 'Donna', 'Murphy', '10/12/2004', '8 Pleasure Hill', 'F', 171862442, 4203892);
INSERT INTO gestaoHotel.Pessoa VALUES (20, 'ngilbertj@mysql.com', 'Norma', 'Gilbert', '4/21/2005', '92 Washington Avenue', 'F', 884872180, 8760786);
INSERT INTO gestaoHotel.Pessoa VALUES (21, 'jmarshallk@mysql.com', 'Jason', 'Marshall', '6/8/2014', '3 Cottonwood Lane', 'M', 982712224, 2687541);
INSERT INTO gestaoHotel.Pessoa VALUES (22, 'lmitchelll@weibo.com', 'Louis', 'Mitchell', '11/12/2006', '3599 Eliot Lane', 'M', 790785686, 3072629);
INSERT INTO gestaoHotel.Pessoa VALUES  (23, 'pcastillom@cnet.com', 'Patrick', 'Castillo', '4/24/2008', '1 Aberg Way', 'M', 151950315, 1358575);
INSERT INTO gestaoHotel.Pessoa VALUES (24, 'ddayn@independent.co.uk', 'Diane', 'Day', '10/8/1999', '1240 Summerview Park', 'F', 533466906, 3781097);
INSERT INTO gestaoHotel.Pessoa VALUES (25, 'rreyeso@eventbrite.com', 'Roy', 'Reyes', '5/24/2001', '250 Onsgard Alley', 'M', 200881357, 7505696);
INSERT INTO gestaoHotel.Pessoa VALUES (26, 'kcarterp@utexas.edu', 'Kelly', 'Carter', '8/5/2009', '1 Boyd Trail', 'F', 858541491, 4381955);
INSERT INTO gestaoHotel.Pessoa VALUES (27, 'jrobertsq@abc.net.au', 'Jean', 'Roberts', '9/8/2008', '1299 Crowley Road', 'F', 809829702, 4654236);
INSERT INTO gestaoHotel.Pessoa VALUES (28, 'amarshallr@howstuffworks.com', 'Andrea', 'Marshall', '3/26/2002', '3 Donald Center', 'F', 684138993, 3296363);
INSERT INTO gestaoHotel.Pessoa VALUES (29, 'rowenss@tmall.com', 'Ronald', 'Owens', '3/28/1999', '80 Daystar Point', 'M', 331790940, 9357902);
INSERT INTO gestaoHotel.Pessoa VALUES (30, 'lbarnest@virginia.edu', 'Lillian', 'Barnes', '6/16/2008', '62616 Fuller Way', 'F', 552647064, 9974269);
INSERT INTO gestaoHotel.Pessoa VALUES  (31, 'gallenu@storify.com', 'George', 'Allen', '9/8/2008', '87017 High Crossing Park', 'M', 385450182, 7826268);
INSERT INTO gestaoHotel.Pessoa VALUES (32, 'rcampbellv@tumblr.com', 'Ruth', 'Campbell', '3/21/2010', '91720 Steensland Center', 'F', 932603439, 5859390);
INSERT INTO gestaoHotel.Pessoa VALUES (33, 'cromerow@sphinn.com', 'Carlos', 'Romero', '2/12/2015', '59 West Place', 'M', 967067493, 3702187);
INSERT INTO gestaoHotel.Pessoa VALUES  (34, 'rlynchx@sohu.com', 'Raymond', 'Lynch', '8/14/2010', '016 Superior Drive', 'M', 578739742, 7040347);
INSERT INTO gestaoHotel.Pessoa VALUES (35, 'jgonzalesy@parallels.com', 'Jerry', 'Gonzales', '9/28/2004', '7142 Katie Center', 'M', 351662412, 6362678);
INSERT INTO gestaoHotel.Pessoa VALUES (36, 'jfisherz@cmu.edu', 'Joyce', 'Fisher', '11/18/1998', '89 Oak Valley Alley', 'F', 757830749, 3276291);
INSERT INTO gestaoHotel.Pessoa VALUES (37, 'dvasquez10@webnode.com', 'Donald', 'Vasquez', '6/21/1995', '4537 Porter Alley', 'M', 628099467, 4397901);
INSERT INTO gestaoHotel.Pessoa VALUES (38, 'mvasquez11@cdc.gov', 'Marilyn', 'Vasquez', '1/11/2005', '47 Clemons Alley', 'F', 572473809, 1621082);

INSERT INTO gestaoHotel.Cliente VALUES (2)
INSERT INTO gestaoHotel.Cliente VALUES (3)
INSERT INTO gestaoHotel.Cliente VALUES (5)
INSERT INTO gestaoHotel.Cliente VALUES (20)
INSERT INTO gestaoHotel.Cliente VALUES (7)
INSERT INTO gestaoHotel.Cliente VALUES (9)
INSERT INTO gestaoHotel.Cliente VALUES (25)
INSERT INTO gestaoHotel.Cliente VALUES (30)
INSERT INTO gestaoHotel.Cliente VALUES (31)
INSERT INTO gestaoHotel.Cliente VALUES (32)
INSERT INTO gestaoHotel.Cliente VALUES (33)
INSERT INTO gestaoHotel.Cliente VALUES (34)
INSERT INTO gestaoHotel.Cliente VALUES (35)
INSERT INTO gestaoHotel.Cliente VALUES (36)

INSERT INTO gestaoHotel.Funcionario VALUES (4,900,2)
INSERT INTO gestaoHotel.Funcionario VALUES (10,1200,2)
INSERT INTO gestaoHotel.Funcionario VALUES (11,1200,2)
INSERT INTO gestaoHotel.Funcionario VALUES (12,1000,2)
INSERT INTO gestaoHotel.Funcionario VALUES (13,900,1)
INSERT INTO gestaoHotel.Funcionario VALUES (14,1000,2)
INSERT INTO gestaoHotel.Funcionario VALUES (15,800,3)
INSERT INTO gestaoHotel.Funcionario VALUES (16,1200,2)
INSERT INTO gestaoHotel.Funcionario VALUES (17,650,2)
INSERT INTO gestaoHotel.Funcionario VALUES (18,1000,2)
INSERT INTO gestaoHotel.Funcionario VALUES (19,1100,3)
INSERT INTO gestaoHotel.Funcionario VALUES (21,1200,2)
INSERT INTO gestaoHotel.Funcionario VALUES (22,10000,2)
INSERT INTO gestaoHotel.Funcionario VALUES (23,10000,2)
INSERT INTO gestaoHotel.Funcionario VALUES (24,10000,2)
INSERT INTO gestaoHotel.Funcionario VALUES (26,6000,3)
INSERT INTO gestaoHotel.Funcionario VALUES (30,4000,1)

INSERT INTO gestaoHotel.Gerente VALUES (21)
INSERT INTO gestaoHotel.Gerente VALUES (22)
INSERT INTO gestaoHotel.Gerente VALUES (23)
INSERT INTO gestaoHotel.Gerente VALUES (24)

INSERT INTO gestaoHotel.Hotel VALUES (1, 'George', 4, '7 Transport Pass', 2453826800, 21);
INSERT INTO gestaoHotel.Hotel VALUES (2, 'Hicks', 4, '18 Grayhawk Court', 5832508764, 22);
INSERT INTO gestaoHotel.Hotel VALUES  (3, 'Myers', 2, '1 Hoard Avenue', 1627258224, 23);
INSERT INTO gestaoHotel.Hotel VALUES (4, 'Jordan', 4, '0801 Eagle Crest Pass', 1888728770, 24);

INSERT INTO gestaoHotel.Recepcionista VALUES (10,null)
INSERT INTO gestaoHotel.Recepcionista VALUES (11,10)
INSERT INTO gestaoHotel.Recepcionista VALUES (12,10)
INSERT INTO gestaoHotel.Recepcionista VALUES (13,12)
INSERT INTO gestaoHotel.Recepcionista VALUES (14,11)

INSERT INTO gestaoHotel.Recepcionista VALUES (15,null)
INSERT INTO gestaoHotel.Recepcionista VALUES (16,15)
INSERT INTO gestaoHotel.Recepcionista VALUES (17,null)
INSERT INTO gestaoHotel.Recepcionista VALUES (18,null)
INSERT INTO gestaoHotel.Recepcionista VALUES (19,18)

INSERT INTO gestaoHotel.TipoQuarto VALUES ('single','quarto single',1)
INSERT INTO gestaoHotel.TipoQuarto VALUES ('double','quarto duplo',2)
INSERT INTO gestaoHotel.TipoQuarto VALUES ('twin','quarto twin',3)
INSERT INTO gestaoHotel.TipoQuarto VALUES ('mini-suite','Suite menor',2)
INSERT INTO gestaoHotel.TipoQuarto VALUES ('suite','Suite',3)

INSERT INTO gestaoHotel.Quarto VALUES (101, 0, 1, 16101,'single', 4);
INSERT INTO gestaoHotel.Quarto VALUES (102, 1, 0, 16102, 'double', 4);
INSERT INTO gestaoHotel.Quarto VALUES (103, 0, 1, 16103,'twin', 1);
INSERT INTO gestaoHotel.Quarto VALUES (104, 0, 0, 16104,'mini-suite', 3);
INSERT INTO gestaoHotel.Quarto VALUES(105, 1, 0, 16105, 'suite' ,3)
INSERT INTO gestaoHotel.Quarto VALUES(106, 1, 1, 16106, 'twin', 4);
INSERT INTO gestaoHotel.Quarto VALUES(107, 1, 1, 16107,  'double',3);
INSERT INTO gestaoHotel.Quarto VALUES(108, 0, 1, 16108,'single',  2);
INSERT INTO gestaoHotel.Quarto VALUES(109, 0, 0, 16109,'single',  1);
INSERT INTO gestaoHotel.Quarto VALUES(110, 1, 0, 16110, 'suite' , 3);
INSERT INTO gestaoHotel.Quarto VALUES(111, 0, 1, 16111, 'single', 2);
INSERT INTO gestaoHotel.Quarto VALUES(112, 1, 1, 16112, 'single', 4);
INSERT INTO gestaoHotel.Quarto VALUES(113, 1, 1, 16113, 'suite' , 1);
INSERT INTO gestaoHotel.Quarto VALUES (114, 1, 0, 16114,'single',  1);
INSERT INTO gestaoHotel.Quarto VALUES(115, 0, 0, 16115,'double', 2);
INSERT INTO gestaoHotel.Quarto VALUES (116, 1, 0, 16116, 'mini-suite', 1);
INSERT INTO gestaoHotel.Quarto VALUES(117, 1, 1, 16117, 'double',2);
INSERT INTO gestaoHotel.Quarto VALUES(118, 1, 1, 16118, 'double',4);
INSERT INTO gestaoHotel.Quarto VALUES (119, 1, 0, 16119,'double', 3);
INSERT INTO gestaoHotel.Quarto VALUES(120, 1, 1, 16120, 'double',3);
INSERT INTO gestaoHotel.Quarto VALUES(201, 1, 0, 16201, 'double',4);
INSERT INTO gestaoHotel.Quarto VALUES(202, 0, 1, 16202,'double', 3);
INSERT INTO gestaoHotel.Quarto VALUES(203, 0, 1, 16203,'double', 3);
INSERT INTO gestaoHotel.Quarto VALUES(204, 1, 1, 16204,'twin',  3);
INSERT INTO gestaoHotel.Quarto VALUES(205, 0, 0, 16205, 'twin', 2);
INSERT INTO gestaoHotel.Quarto VALUES(206, 0, 0, 16206, 'twin', 4);
INSERT INTO gestaoHotel.Quarto VALUES (207, 1, 1, 16207,'twin',  3);
INSERT INTO gestaoHotel.Quarto VALUES(208, 0, 0, 16208,'twin',  3);
INSERT INTO gestaoHotel.Quarto VALUES(209, 0, 0, 16209,  'mini-suite', 1);
INSERT INTO gestaoHotel.Quarto VALUES (210, 1, 0, 16210,'twin',  3);
INSERT INTO gestaoHotel.Quarto VALUES(211, 0, 0, 16211, 'suite' , 4);
INSERT INTO gestaoHotel.Quarto VALUES(212, 1, 1, 16212,'twin',  2);
INSERT INTO gestaoHotel.Quarto VALUES(213, 1, 0, 16213, 'suite' ,4);

INSERT INTO gestaoHotel.Pagamento VALUES (1, 'mastercard', '2015-05-02', '287975.60', 12);
INSERT INTO gestaoHotel.Pagamento VALUES(2, 'jcb', '2015-11-30', '814147.61', 11);
INSERT INTO gestaoHotel.Pagamento VALUES(3, 'jcb', '2015-11-13', '104264.08', 13);
INSERT INTO gestaoHotel.Pagamento VALUES(4, 'jcb', '2016-03-11', '137609.03', 10);
INSERT INTO gestaoHotel.Pagamento VALUES(5, 'visa-electron', '2015-05-19', '267388.61', 12);
INSERT INTO gestaoHotel.Pagamento VALUES(6, 'jcb', '2015-12-28', '613803.49', 14);
INSERT INTO gestaoHotel.Pagamento VALUES(7, 'diners-club-us-ca', '2015-04-25', '344966.06', 12);
INSERT INTO gestaoHotel.Pagamento VALUES(8, 'china-unionpay', '2015-11-04', '672816.24', 13);
INSERT INTO gestaoHotel.Pagamento VALUES(9, 'americanexpress', '2015-10-31', '481962.67', 12);
INSERT INTO gestaoHotel.Pagamento VALUES(10, 'mastercard', '2015-12-16', '327407.48', 12);
INSERT INTO gestaoHotel.Pagamento VALUES(11, 'switch', '2015-12-18', '796376.51', 11);
INSERT INTO gestaoHotel.Pagamento VALUES(12, 'diners-club-enroute', '2015-10-08', '917181.99', 12);
INSERT INTO gestaoHotel.Pagamento VALUES(13, 'jcb', '2015-07-06', '8548.13', 10);
INSERT INTO gestaoHotel.Pagamento VALUES(14, 'bankcard', '2015-06-11', '256062.96', 12);
INSERT INTO gestaoHotel.Pagamento VALUES(15, 'jcb', '2015-05-23', '743117.68', 11);

INSERT INTO gestaoHotel.Reserva VALUES (1, 4, 'SA', '2015-9-20', '2015-10-22', 7, 118, 14, 35);
INSERT INTO gestaoHotel.Reserva VALUES (2, 1, 'APA', '2015-10-23', '2016-11-02', 8, 104, 13, 33);
INSERT INTO gestaoHotel.Reserva VALUES (3, 3, 'APA', '2016-02-16', '2016-08-05', 5, 101, 13, 36);
INSERT INTO gestaoHotel.Reserva VALUES (4, 3, 'APA', '2015-08-13', '2016-01-27', 10, 108, 13, 30);
INSERT INTO gestaoHotel.Reserva VALUES (5, 2, 'APA', '2016-01-21', '2016-07-21', 15, 107, 10, 33);
INSERT INTO gestaoHotel.Reserva VALUES (6, 3, 'APA', '2015-12-01', '2016-03-05', 1, 113, 10, 34);
INSERT INTO gestaoHotel.Reserva VALUES (7, 5, 'APA', '2015-12-15', '2015-12-25', 5, 101, 12, 34);
INSERT INTO gestaoHotel.Reserva VALUES (8, 1, 'APA', '2016-01-25', '2016-02-12', 4, 110, 13, 31);	
INSERT INTO gestaoHotel.Reserva VALUES (9, 5, 'APA', '2015-07-07', '2016-04-06', 13, 119, 13, 33);
INSERT INTO gestaoHotel.Reserva VALUES (10, 5, 'SA', '2015-11-26', '2015-12-02', 15, 105, 14, 30);
INSERT INTO gestaoHotel.Reserva VALUES (11, 2, 'SA', '2015-07-11', '2015-09-11', 6, 101, 12, 33);
INSERT INTO gestaoHotel.Reserva VALUES (12, 5, 'SA', '2015-10-15', '2015-11-06', 9, 118, 10, 35);
INSERT INTO gestaoHotel.Reserva VALUES  (13, 2, 'SA', '2015-12-19', '2016-05-19', 2, 120, 11, 30);
INSERT INTO gestaoHotel.Reserva VALUES (14, 3, 'SA', '2015-05-01', '2015-08-05', 13, 116, 10, 34);
INSERT INTO gestaoHotel.Reserva VALUES (15, 4, 'SA', '2015-05-27', '2015-09-03', 13, 115, 10, 35);
INSERT INTO gestaoHotel.Reserva VALUES  (16, 4, 'SA', '2016-02-21', '2016-12-13', 12, 112, 10, 36);
INSERT INTO gestaoHotel.Reserva VALUES (17, 5, 'SA', '2016-01-19', '2016-07-10', 5, 116, 11, 34);
INSERT INTO gestaoHotel.Reserva VALUES (18, 1, 'SA', '2015-08-21', '2016-03-02', 14, 110, 14, 34);
INSERT INTO gestaoHotel.Reserva VALUES (19, 5, 'SA', '2015-1-14', '2015-08-16', 1, 101, 13, 36);
INSERT INTO gestaoHotel.Reserva VALUES (20, 1, 'SA', '2015-10-2', '2015-10-07', 11, 107, 12, 33);	
INSERT INTO gestaoHotel.Reserva VALUES (21, 4, 'SA', '2016-03-02', '2016-03-17', 9, 119, 14, 35);
INSERT INTO gestaoHotel.Reserva VALUES (22, 4, 'SA', '2015-04-25', '2015-12-14', 6, 120, 14, 36);
INSERT INTO gestaoHotel.Reserva VALUES  (23, 5, 'SA', '2015-05-08', '2015-07-14', 11, 115, 13, 32);	
INSERT INTO gestaoHotel.Reserva VALUES (24, 3, 'SA', '2015-12-19', '2016-03-12', 12, 105, 13, 34);
INSERT INTO gestaoHotel.Reserva VALUES (25, 4, 'SA', '2015-10-07', '2015-11-21', 15, 109, 11, 36);
INSERT INTO gestaoHotel.Reserva VALUES (26, 1, 'SA', '2015-10-13', '2015-10-22', 11, 112, 14, 30);
INSERT INTO gestaoHotel.Reserva VALUES (27, 3, 'SA', '2016-03-12', '2016-10-15', 12, 112, 10, 33);
INSERT INTO gestaoHotel.Reserva VALUES (28, 5, 'SA', '2015-12-09', '2015-12-27', 4, 118, 13, 30);
INSERT INTO gestaoHotel.Reserva VALUES (29, 2, 'PC', '2015-07-15', '2015-09-01', 6, 107, 10, 35);
INSERT INTO gestaoHotel.Reserva VALUES (30, 5, 'PC', '2015-06-03', '2015-07-22', 3, 112, 14, 30);
INSERT INTO gestaoHotel.Reserva VALUES (31, 5, 'PC', '2015-04-19', '2015-07-28', 2, 107, 10, 31);
INSERT INTO gestaoHotel.Reserva VALUES (32, 5, 'PC', '2016-03-28', '2016-08-22', 1, 115, 13, 30);
INSERT INTO gestaoHotel.Reserva VALUES (33, 4, 'PC', '2015-10-05', '2015-12-03', 2, 111, 13, 34);
INSERT INTO gestaoHotel.Reserva VALUES  (34, 4, 'PC', '2015-12-04', '2015-12-16', 11, 108, 14, 32);
INSERT INTO gestaoHotel.Reserva VALUES  (35, 3, 'PC', '2016-02-15', '2016-04-20', null, 116, 13, 34);
INSERT INTO gestaoHotel.Reserva VALUES (36, 5, 'PC', '2015-12-15', '2016-01-14', null, 114, 13, 35);
INSERT INTO gestaoHotel.Reserva VALUES  (37, 1, 'PC', '2015-12-28', '2016-02-24', null, 110, 13, 31);
INSERT INTO gestaoHotel.Reserva VALUES  (38, 5, 'PC', '2015-08-05', '2016-01-24', null, 117, 12, 31);
INSERT INTO gestaoHotel.Reserva VALUES (39, 3, 'PC', '2015-05-26', '2016-01-03', null, 117, 10, 33);

INSERT INTO gestaoHotel.Depende VALUES(1001,7)
INSERT INTO gestaoHotel.Depende VALUES(1002,21)
INSERT INTO gestaoHotel.Depende VALUES(1001,22)
INSERT INTO gestaoHotel.Depende VALUES(1004,27)
INSERT INTO gestaoHotel.Depende VALUES(1002,37)
INSERT INTO gestaoHotel.Depende VALUES(1003,23)
INSERT INTO gestaoHotel.Depende VALUES(1004,16)
INSERT INTO gestaoHotel.Depende VALUES(1001,6)
INSERT INTO gestaoHotel.Depende VALUES(1000,25)
INSERT INTO gestaoHotel.Depende VALUES(1004,21)

INSERT INTO gestaoHotel.Cama VALUES ('single',20)
INSERT INTO gestaoHotel.Cama VALUES ('double',25)
INSERT INTO gestaoHotel.Cama VALUES ('twin',50)
INSERT INTO gestaoHotel.Cama VALUES ('queen',70)
INSERT INTO gestaoHotel.Cama VALUES ('king',100)


INSERT INTO gestaoHotel.Requere VALUES (1,'single',1)
INSERT INTO gestaoHotel.Requere VALUES (2,'single',2)
INSERT INTO gestaoHotel.Requere VALUES (3,'single',3)
INSERT INTO gestaoHotel.Requere VALUES (4,'single',4)
INSERT INTO gestaoHotel.Requere VALUES (5,'single',5)
INSERT INTO gestaoHotel.Requere VALUES (6,'single',6)
INSERT INTO gestaoHotel.Requere VALUES (7,'single',7)
INSERT INTO gestaoHotel.Requere VALUES (8,'single',8)
INSERT INTO gestaoHotel.Requere VALUES (9,'single',9)
INSERT INTO gestaoHotel.Requere VALUES (10,'single',10)
INSERT INTO gestaoHotel.Requere VALUES (11,'single',11)
INSERT INTO gestaoHotel.Requere VALUES (12,'single',11)
INSERT INTO gestaoHotel.Requere VALUES (13,'double',12)
INSERT INTO gestaoHotel.Requere VALUES (14,'double',13)
INSERT INTO gestaoHotel.Requere VALUES (15,'double',14)
INSERT INTO gestaoHotel.Requere VALUES (16,'double',15)
INSERT INTO gestaoHotel.Requere VALUES (17,'double',16)
INSERT INTO gestaoHotel.Requere VALUES (18,'double',17)
INSERT INTO gestaoHotel.Requere VALUES (19,'double',18)
INSERT INTO gestaoHotel.Requere VALUES (20,'double',19)
INSERT INTO gestaoHotel.Requere VALUES (21,'double',20)
INSERT INTO gestaoHotel.Requere VALUES (22,'double',21)
INSERT INTO gestaoHotel.Requere VALUES (23,'double',22)
INSERT INTO gestaoHotel.Requere VALUES (24,'twin',23)
INSERT INTO gestaoHotel.Requere VALUES (25,'twin',24)
INSERT INTO gestaoHotel.Requere VALUES (26,'twin',25)
INSERT INTO gestaoHotel.Requere VALUES (27,'twin',26)
INSERT INTO gestaoHotel.Requere VALUES (28,'twin',27)
INSERT INTO gestaoHotel.Requere VALUES (29,'queen',28)
INSERT INTO gestaoHotel.Requere VALUES (30,'queen',29)
INSERT INTO gestaoHotel.Requere VALUES (31,'queen',30)
INSERT INTO gestaoHotel.Requere VALUES (32,'queen',31)
INSERT INTO gestaoHotel.Requere VALUES (33,'queen',32)
INSERT INTO gestaoHotel.Requere VALUES (34,'queen',33)
INSERT INTO gestaoHotel.Requere VALUES (35,'queen',34)
INSERT INTO gestaoHotel.Requere VALUES (36,'king',35)
INSERT INTO gestaoHotel.Requere VALUES (37,'king',36)
INSERT INTO gestaoHotel.Requere VALUES (38,'king',37)
INSERT INTO gestaoHotel.Requere VALUES (39,'king',38)
INSERT INTO gestaoHotel.Requere VALUES (40,'king',39)

INSERT INTO gestaoHotel.Servico VALUES (1,86,'2015-06-14',4,21)
INSERT INTO gestaoHotel.Servico VALUES(2,78,'2015-10-20',3,21)
INSERT INTO gestaoHotel.Servico VALUES(3,55,'2016-03-02',18,21)
INSERT INTO gestaoHotel.Servico VALUES(4,84,'2016-01-30',22,14)
INSERT INTO gestaoHotel.Servico VALUES(5,89,'2016-03-07',28,19)
INSERT INTO gestaoHotel.Servico VALUES(6,33,'2016-01-27',28,13)
INSERT INTO gestaoHotel.Servico VALUES(7,50,'2015-11-23',17,14)
INSERT INTO gestaoHotel.Servico VALUES(8,51,'2015-10-25',21,18)
INSERT INTO gestaoHotel.Servico VALUES(9,43,'2015-10-29',15,15)
INSERT INTO gestaoHotel.Servico VALUES(10,63,'2015-09-28',24,13)
INSERT INTO gestaoHotel.Servico VALUES(11,12,'2015-07-18',38,19)
INSERT INTO gestaoHotel.Servico VALUES(12,89,'2016-02-28',10,13)
INSERT INTO gestaoHotel.Servico VALUES(13,19,'2015-12-18',33,21)
INSERT INTO gestaoHotel.Servico VALUES(14,22,'2016-02-11',8,19)
INSERT INTO gestaoHotel.Servico VALUES(15,84,'2015-08-12',24,19)
INSERT INTO gestaoHotel.Servico VALUES(16,57,'2016-01-18',31,10)
INSERT INTO gestaoHotel.Servico VALUES(17,68,'2015-12-19',3,23)
INSERT INTO gestaoHotel.Servico VALUES(18,4,'2015-12-02',21,13)
INSERT INTO gestaoHotel.Servico VALUES(19,49,'2015-07-05',28,22)
INSERT INTO gestaoHotel.Servico VALUES(20,70,'2015-10-12',35,17)

INSERT INTO gestaoHotel.RoomService VALUES (1,2,'13:06')
INSERT INTO gestaoHotel.RoomService VALUES(2,4,'11:43')
INSERT INTO gestaoHotel.RoomService VALUES(3,5,'2:54')
INSERT INTO gestaoHotel.RoomService VALUES(4,8,'10:52')

INSERT INTO gestaoHotel.Estacionamento VALUES (9,'b-13')
INSERT INTO gestaoHotel.Estacionamento VALUES (5,'r-16')
INSERT INTO gestaoHotel.Estacionamento VALUES (7,'a-21')
INSERT INTO gestaoHotel.Estacionamento VALUES (10, 'l-1')

INSERT INTO gestaoHotel.Video VALUES(1,3,'11:43')
INSERT INTO gestaoHotel.Video VALUES(3,4,'11:43')
INSERT INTO gestaoHotel.Video VALUES(6,1,'1:43')
INSERT INTO gestaoHotel.Video VALUES(8,10,'12:22')
INSERT INTO gestaoHotel.Video VALUES(11,10,'4:22')
INSERT INTO gestaoHotel.Video VALUES(12,10,'22:22')
INSERT INTO gestaoHotel.Video VALUES(13,10,'00:22')

INSERT INTO gestaoHotel.ServicoExterno VALUES(15,'aluguer','aluguer de carro')
INSERT INTO gestaoHotel.ServicoExterno VALUES(16,'excursao','excursao a monte velho')
INSERT INTO gestaoHotel.ServicoExterno VALUES(17, 'babySitting', 'babySitting a 2 crianças')


INSERT INTO gestaoHotel.RestauranteBar VALUES(18,'bar','copo de wiskey')
INSERT INTO gestaoHotel.RestauranteBar VALUES(19,'bar','fino')
INSERT INTO gestaoHotel.RestauranteBar VALUES(20,'restaurante','refeição de 2')
INSERT INTO gestaoHotel.RestauranteBar VALUES(14,'restaurante','refeiçao de 3')
*/