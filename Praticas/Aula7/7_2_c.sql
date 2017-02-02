
use p3g4;

-- c) Enumere um conjunto de consultas necessárias para o seu sistema de informação e implemente-as em SQL.

-- Quantos Hotéis existem nesta cadeia?
SELECT COUNT(DISTINCT idHotel) AS nr_hoteis 
FROM gestaoHotel.Hotel;

-- Emails de todas as pessoas
SELECT email FROM gestaoHotel.Pessoa

-- Reservas que consumiram no restaurante ou bar
SELECT * FROM gestaoHotel.Reserva JOIN (gestaoHotel.Servico JOIN gestaoHotel.RestauranteBar ON Servico.idServico=RestauranteBar.idServico ) 
	ON reserva=idReserva

-- Em que Hotel está alojado Raymond Lynch na data de inicio 2015-12-15?
SELECT Pnome+ ' '+Unome AS Cliente, idPessoa, idReserva, dataInicio, dataFim, idHotel, Hotel.nome
FROM ((gestaoHotel.Pessoa JOIN (gestaoHotel.Cliente JOIN gestaoHotel.Reserva ON id=cliente)
	ON id=idPessoa) JOIN (gestaoHotel.Quarto JOIN gestaoHotel.Hotel ON hotel=idHotel) ON quarto=idQuarto)
WHERE Pnome='Raymond' AND Unome='Lynch' AND dataInicio=(convert(date,'20151215'));

-- Numero de Clientes por Hotel
SELECT idHotel, Hotel.nome, COUNT(idHotel) AS nr_clientes
FROM (gestaoHotel.Hotel JOIN (gestaoHotel.Quarto JOIN gestaoHotel.Reserva ON idQuarto=quarto) ON idHotel=hotel)
GROUP BY idHotel, Hotel.nome;

-- Quais são os nomes do gerentes dos Hoteis desta cadeia?
SELECT idHotel, Hotel.nome, Hotel.localizacao, Pnome+' '+Unome AS nome_Gerente, idPessoa 
FROM gestaoHotel.Pessoa JOIN gestaoHotel.Hotel ON idPessoa=gerente
ORDER BY idHotel, Hotel.nome, Hotel.localizacao;

-- Quantas Reservas tem cada cliente?
SELECT id, Pnome, Unome, COUNT(idReserva) AS reservas 
FROM (gestaoHotel.Pessoa JOIN (gestaoHotel.Cliente JOIN gestaoHotel.Reserva ON id=cliente) ON idPessoa=id)
GROUP BY id, Pnome, Unome;

-- Quais os precos de cada tipo de quarto nas diferentes datas de acordo com a Temporada?
SELECT * FROM gestaoHotel.Temporada;

-- Qual foi o valor do Servico mais caro requerido por um cliente e qual o nome desse Cliente?
SELECT idPessoa, Pnome, Unome, idServico, custo, data 
FROM ((gestaoHotel.Pessoa JOIN gestaoHotel.Cliente ON idPessoa=id) JOIN (gestaoHotel.Servico JOIN gestaoHotel.Reserva ON reserva=idReserva)
	ON idPessoa=cliente)
GROUP BY idPessoa, Pnome, Unome, idServico, custo, data
HAVING custo=(SELECT MAX(custo) FROM gestaoHotel.Servico);

-- Quantos servicos foram atendidos por cada funcionario?
SELECT id, Pnome, Unome, COUNT(funcionario) AS nr_servicos
FROM (gestaoHotel.Pessoa JOIN (gestaoHotel.Funcionario JOIN gestaoHotel.Servico ON id=funcionario) ON idPessoa=id)
GROUP BY id, Pnome, Unome;

-- Quais sao os funcionarios que nunca atenderam servicos?
SELECT id, Pnome, Unome
FROM (gestaoHotel.Pessoa JOIN (gestaoHotel.Funcionario LEFT OUTER JOIN gestaoHotel.Servico ON id=funcionario) ON idPessoa=id)
WHERE funcionario is NULL
GROUP BY id, Pnome, Unome;

-- Nome dos Recepcionistas que não tem supervisores
SELECT idPessoa, Pnome, Unome
FROM (gestaoHotel.Pessoa JOIN (gestaoHotel.Recepcionista AS R RIGHT JOIN gestaoHotel.Recepcionista AS R2 ON 
	R.nrFuncionario=R2.supervisor) ON idPessoa=R2.nrFuncionario)
WHERE R2.supervisor is NULL;

-- Nome dos Empregados que não tem supervisores
SELECT idPessoa, Pnome, Unome
FROM (gestaoHotel.Pessoa JOIN (gestaoHotel.Empregado AS E RIGHT JOIN gestaoHotel.Empregado AS E2 ON 
	E.nrFuncionario=E2.supervisor) ON idPessoa=E2.nrFuncionario)
WHERE E2.supervisor is NULL;


