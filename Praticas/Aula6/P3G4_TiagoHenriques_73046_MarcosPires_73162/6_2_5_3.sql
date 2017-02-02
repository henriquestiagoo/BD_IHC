
use p3g4;

-- 5.3 a)
-- Lista de pacientes que nunca tiveram uma prescrição; 
SELECT nome, nr_utente, data_nasc, endereco
FROM (aula4_prescricaoMed.Paciente LEFT OUTER JOIN aula4_prescricaoMed.Prescricao 
ON Paciente.nr_utente=Prescricao.utente_nr)
WHERE Prescricao.nr_unico IS NULL;

-- 5.3-b)
-- Número de prescrições por especialidade médica; 
SELECT especialidade, SUM(totalPresc) AS numPresc
FROM (aula4_prescricaoMed.Medico JOIN (SELECT medico_id, COUNT(nr_unico) AS totalPresc 
FROM aula4_prescricaoMed.Prescricao GROUP BY medico_id) AS T ON nr_id=T.medico_id) 
GROUP BY especialidade;

-- 5.3 c)
-- Número de prescrições processadas por farmácia;  
SELECT farmacia, COUNT(prescricao.nr_unico) AS totalPresc 
FROM aula4_prescricaoMed.Prescricao 
WHERE prescricao.farmacia IS NOT NULL 
GROUP BY farmacia;

-- 5.3-d)
-- Para a farmacêutica com registo número 906, lista dos seus fármacos nunca prescritos;
SELECT nome_comercial, Farmaco.nr_reg_nac_farmaceutica, formula 
FROM aula4_prescricaoMed.Farmaco LEFT OUTER JOIN aula4_prescricaoMed.Contem ON nome_comercial=nomeFarmaco
WHERE nr_unico_prescricao IS NULL AND Farmaco.nr_reg_nac_farmaceutica = 906;

-- 5.3 e)
-- Para cada farmácia, o número de fármacos de cada farmacêutica vendidos;
SELECT T.farmacia, Contem.nr_reg_nac_farmaceutica, COUNT(Contem.nr_reg_nac_farmaceutica) AS num_farmacos_vendidos 
FROM (aula4_prescricaoMed.Contem JOIN (SELECT Prescricao.nr_unico, Prescricao.farmacia FROM aula4_prescricaoMed.Prescricao WHERE Prescricao.farmacia IS NOT NULL) AS T 
ON Contem.nr_unico_prescricao=T.nr_unico) 
GROUP BY T.farmacia,Contem.nr_reg_nac_farmaceutica
ORDER BY T.farmacia;

-- 5.3 f)
SELECT Paciente.nr_utente, Paciente.nome, Paciente.data_nasc, Paciente.endereco
FROM (aula4_prescricaoMed.Paciente JOIN (SELECT Prescricao.utente_nr, COUNT(DISTINCT Prescricao.medico_id) AS  numMedicos
	FROM aula4_prescricaoMed.Prescricao 
GROUP BY Prescricao.utente_nr 
HAVING COUNT(Prescricao.medico_id) > 1) AS T
ON Paciente.nr_utente=T.utente_nr);



