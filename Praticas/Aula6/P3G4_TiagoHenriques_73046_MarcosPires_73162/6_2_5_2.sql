
use p3g4;

-- 5.2-a)
-- Lista dos fornecedores que nunca tiveram encomendas;
SELECT nome, nif, nr_fax, endereco
FROM (aula4_gestaoStocks.Encomenda RIGHT OUTER JOIN aula4_gestaoStocks.Fornecedor ON NIF_fornecedor=nif)
WHERE NIF_fornecedor IS NULL;

-- 5.2 b)
-- Número médio de unidades encomendadas para cada produto;
SELECT DISTINCT nome, codigo, AVG(Sujeito.unidades) as Media_encomendas
FROM aula4_gestaoStocks.Produto JOIN aula4_gestaoStocks.Sujeito ON codigo=codigo_produto
GROUP BY nome, codigo;


-- 5.2 c)
-- Número médio de produtos por encomenda; (nota: não interessa o número de unidades);
SELECT AVG(CAST(T.num_enc_prod AS FLOAT)) as Media_prod_enc
FROM(SELECT COUNT(nr_encomenda) As num_enc_prod FROM aula4_gestaoStocks.Sujeito 
GROUP BY nr_encomenda) As T;

-- 5.2 d)
-- Lista de produtos (e quantidades) fornecidas por cada fornecedor;
SELECT T.nome, T.NIF, Produto.nome, SUM(T2.unidades) As qt_prod
FROM (((SELECT nome, NIF, nr_fax, nr
	  FROM (aula4_gestaoStocks.Fornecedor JOIN aula4_gestaoStocks.Encomenda ON NIF=NIF_Fornecedor)) As T
	JOIN (SELECT codigo_produto, Sujeito.unidades, nr_encomenda FROM aula4_gestaoStocks.Sujeito) As T2 ON T.nr=T2.nr_encomenda) JOIN aula4_gestaoStocks.Produto ON T2.codigo_produto=produto.codigo) 
GROUP BY T.nome, T.NIF, produto.nome 
ORDER BY T.nome;