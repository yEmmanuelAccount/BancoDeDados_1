/* Exercícios sobre a linguagem SQL 

>  Seja o esquema lógico relacional: 
    - Setor (CodSetor, Nome, Supervisor)
    - Médico (CRM, Nome, Especialidade)
    - SetorMedico (CodSetor, CRM)
    - Paciente (CodPaciente, Nome, DataNascimento)
    - Atendimento (CodAtendimento, Data, Valor, Operadora, AtendAnterior, CRM,  CodPaciente)
     -TelefoneMedico (Telefone, CRM)

*/

-- > Realize as seguintes operações usando a linguagem SQL para:

-- 1. Criar as tabelas referentes a estes esquemas de relação. 
CREATE TABLE Medico(
    CRM VARCHAR(10),
    Nome VARCHAR(50),
    Especialidade VARCHAR(15),
    PRIMARY KEY (CRM)
)
;
CREATE TABLE Setor(
    CodSetor Int,
    Nome VARCHAR(30),
    Supervisor VARCHAR(10),
    PRIMARY KEY (CodSetor),
    FOREIGN KEY (Supervisor) REFERENCES Medico(CRM)       
)
;

CREATE TABLE SetorMedico(
    CodSetor INT,
    CRM Varchar(10),
    PRIMARY KEY (CodSetor, CRM),
    FOREIGN KEY (CodSetor) REFERENCES Setor(CodSetor),
    FOREIGN KEY (CRM) REFERENCES Medico(CRM) 	
)
;
CREATE TABLE Paciente(
    CodPaciente INT,
    Nome VARCHAR(50),
    DataNascimento varchar(10),
    PRIMARY KEY (CodPaciente)
)
;
CREATE TABLE Atendimento(
    CodAtendimento INT,
    Data varchar(10),
    Valor NUMERIC,
    Tipo VARCHAR(10),
    AtendAnterior INT,
    CRM VARCHAR(10),
    CodPaciente INT,
    PRIMARY KEY (CodAtendimento),
    FOREIGN KEY (AtendAnterior) REFERENCES Atendimento(CodAtendimento)  	
)
;
CREATE TABLE TelefoneMedico (
    Telefone VARCHAR(15),
    CRM VARCHAR(10),
    PRIMARY KEY (Telefone, CRM),  
    FOREIGN KEY (CRM) REFERENCES Medico(CRM)
)
;

-- 2. Inserir pelo menos três tuplas em cada tabela. 

INSERT INTO Medico VALUES ('1111-1','João', 'Neurologista');
INSERT INTO Medico VALUES ('1111-2','Sérgio', 'Pediatra');
INSERT INTO Medico VALUES ('1111-3','Carlos', 'Neurologista');
INSERT INTO Medico VALUES ('1111-4','Ana', 'Pediatra');
INSERT INTO Medico VALUES ('1111-5','Paulo', 'Urologia');
INSERT INTO Medico VALUES ('1111-6','Saulo', 'Urologia');



INSERT INTO Setor VALUES (1,'Neurologia', '1111-1');
INSERT INTO Setor VALUES (2,'Pediatria', '1111-2');
INSERT INTO Setor VALUES (3,'Urologia', '1111-6');


INSERT INTO SetorMedico VALUES (1, '1111-1');
INSERT INTO SetorMedico VALUES (1, '1111-3');
INSERT INTO SetorMedico VALUES (2, '1111-2');
INSERT INTO SetorMedico VALUES (2, '1111-4');
INSERT INTO SetorMedico VALUES (2, '1111-3');
INSERT INTO SetorMedico VALUES (3, '1111-5');
INSERT INTO SetorMedico VALUES (3, '1111-6');

INSERT INTO Paciente VALUES (1, 'Luiza', '12/04/1985');
INSERT INTO Paciente VALUES (2, 'Maria', '13/05/1985');
INSERT INTO Paciente VALUES (3, 'Joana', '12/08/2002');
INSERT INTO Paciente VALUES (4, 'Maurício', '12/11/2003');
INSERT INTO Paciente VALUES (5, 'Raquel', '12/12/1995');

INSERT INTO Atendimento VALUES (1, '10/05/2017', 50, 'Unimed', NULL, '1111-1',1);
INSERT INTO Atendimento VALUES (2, '15/05/2017', 0, 'Unimed', 1, '1111-1',1);
INSERT INTO Atendimento VALUES (3, '11/05/2017', 80, 'Particular',NULL, '1111-3',2);
INSERT INTO Atendimento VALUES (4, '20/05/2017', 50, 'Unimed', Null,'1111-1',3);
INSERT INTO Atendimento VALUES (5, '20/05/2017', 80, 'Particular',NULL, '1111-2',4);
INSERT INTO Atendimento VALUES (6, '20/05/2017', 0, 'Particular', 5,'1111-2',4);
INSERT INTO Atendimento VALUES (7, '20/05/2017', 80, 'Particular',NULL, '1111-4',4);
INSERT INTO Atendimento VALUES (8, '31/05/2017', 50, 'Unimed',NULL, '1111-4',3);
INSERT INTO Atendimento VALUES (9, '31/05/2017', 50, 'Unimed',NULL, '1111-2',3);
INSERT INTO Atendimento VALUES (10, '11/05/2017', 80, 'Particular',NULL, '1111-3',2);

INSERT INTO TelefoneMedico VALUES ('1111-1111','1111-1');
INSERT INTO TelefoneMedico VALUES ('1111-1123','1111-1');
INSERT INTO TelefoneMedico VALUES ('9999-1111','1111-1');
INSERT INTO TelefoneMedico VALUES ('1112-1112','1111-2');
INSERT INTO TelefoneMedico VALUES ('1113-1113','1111-3');
INSERT INTO TelefoneMedico VALUES ('1114-1114','1111-4');
INSERT INTO TelefoneMedico VALUES ('9999-1114','1111-4');
INSERT INTO TelefoneMedico VALUES ('9999-2235','1111-5');
INSERT INTO TelefoneMedico VALUES ('9999-1345','1111-6');
INSERT INTO TelefoneMedico VALUES ('9999-7654','1111-6');

-- 3. Recuperar o código da paciente Maria.
SELECT CodPaciente
FROM Paciente
WHERE Nome = 'Maria';

-- 4. Recuperar o CRM e a Especialidade do médico João.
SELECT CRM, Especialidade
FROM Medico
WHERE Nome = 'João';

-- 5. Recuperar o valor de cada atendimento caso a clinica reajustasse o preço  dos mesmos em 15 %.
SELECT CodAtendimento, Valor, Valor * 1.15 AS NovoValor
FROM Atendimento;

-- 6. Recuperar o nome do médico que supervisiona o setor de pediatria.
SELECT M.Nome
FROM Setor S INNER JOIN Medico M 
    ON S.Supervisor = M.CRM
WHERE S.Nome = 'Pediatria';

-- 7. Recuperar o nome de todos os setores onde o médico Carlos trabalha.
SELECT S.Nome
FROM SetorMedico SM NATURAL INNER JOIN Setor S
    INNER JOIN Medico M ON SM.CRM = M.CRM
WHERE M.Nome = 'Carlos';

-- 8. Recuperar todos os telefones do médico João.
SELECT TM.Telefone
FROM TelefoneMedico TM INNER JOIN Medico M
    ON TM.CRM = M.CRM
WHERE M.Nome = 'João';

-- 9. Recuperar a data, o nome de cada médico e o nome do paciente de cada  atendimento realizado na clínica ordenado primeiramente pelo nome do  médico e depois pelo nome do paciente, ambos em ordem ascendente.
SELECT A.Data, M.Nome AS NomeMedico, P.Nome AS NomePaciente
FROM Atendimento A NATURAL INNER JOIN Medico M
    INNER JOIN Paciente P ON A.CodPaciente = P.CodPaciente
ORDER BY M.Nome, P.Nome;

-- 10. Recuperar a data e o nome de cada paciente dos atendimentos realizados  pelo médico Sérgio que não sejam retorno.
SELECT A.Data, P.Nome AS NomePaciente
FROM Atendimento A NATURAL INNER JOIN Medico M
    INNER JOIN Paciente P ON A.CodPaciente = P.CodPaciente
WHERE M.Nome = 'Sérgio' AND A.AtendAnterior IS NULL;

-- 11. Recuperar o nome dos pacientes que fizeram algum retorno com o médico  João.
SELECT P.Nome
FROM Atendimento A NATURAL INNER JOIN Medico M
    INNER JOIN Paciente P ON A.CodPaciente = P.CodPaciente
WHERE M.Nome = 'João' AND A.AtendAnterior IS NOT NULL;

-- 12. Recuperar o nome de todos os pacientes (sem repetição) que já se  consultaram com o médico Ana.
SELECT DISTINCT P.Nome
FROM Atendimento A NATURAL INNER JOIN Medico M
    INNER JOIN Paciente P ON A.CodPaciente = P.CodPaciente
WHERE M.Nome = 'Ana';

-- 13. Recuperar o nome de todos os pacientes que se consultaram com o médico  João e com a médica Ana.
SELECT P.Nome 
FROM Paciente P
WHERE P.CodPaciente IN (
    SELECT A.Nome
    FROM Atendimento A NATURAL INNER JOIN Medico M
    WHERE M.Nome = 'João'
        INTERSECT
    SELECT A.CodPaciente,
    FROM Atendimento A NATURAL INNER JOIN Medico M
    WHERE M.Nome = 'Ana'
    );

-- 14. Recuperar o nome de todos os pacientes cujo nome começa com a letra M.
SELECT P.Nome
FROM Paciente P
WHERE P.Nome LIKE 'M%';

-- 15. Recuperar a quantidade de atendimentos realizados por cada médico.
SELECT M.Crm, M.Nome, COUNT(A.CodAtendimento) AS QuantidadeAtendimentos
FROM Atendimento A NATURAL INNER JOIN Medico M
WHERE A.AtendAnterior IS NULL; -- para excluir os retornos da contagem
GROUP BY M.Crm, M.Nome
ORDER BY QuantidadeAtendimentos DESC, M.Nome;

-- 16. Recuperar o nome dos médicos que já realizaram mais de 2 atendimento.
SELECT M.Crm, M.Nome, COUNT(A.CodAtendimento) AS QuantidadeAtendimentos
FROM Atendimento A NATURAL INNER JOIN Medico M
GROUP BY M.Crm, M.Nome
HAVING COUNT(A.CodAtendimento) > 2

-- 17. Recuperar o valor médio das consultas que não são retorno e foram realizadas por algum médico alocado no setor 1.
SELECT AVG(A.Valor) AS ValorMedio
FROM Atendimento A 
WHERE AtedAnterior IS NULL AND Crm in (
    SELECT Crm 
    FROM SetorMedico
    WHERE CodSetor = 1
    );

-- 18. Recuperar o nome dos médicos que nunca realizaram atendimento pela  operadora Unimed.
SELECT Crm, Nome
FROM Medico 
WHERE Crm NOT IN (
    SELECT Crm
    FROM Atendimento 
    WHERE Tipo = 'Unimed'
    );

 -- 19. Recuperar a quantidade de atendimentos particulares realizados por cada  médico da clínica, excluindo os retornos.
SELECT M.Crm, M.Nome, COUNT(*) AS AtendimentosParticulares
FROM Atendimento A NATURAL INNER JOIN Medico M
WHERE A.Tipo = 'Particular' AND A.AtendAnterior IS NULL
GROUP BY M.Crm, M.Nome
ORDER BY AtendimentosParticulares DESC, M.Nome;

 -- 20. Recuperar a quantidade de atendimentos e o valor total apurado em cada  dia, ordenado pela data em ordem decrescente.
 SELECT Data, SUM(Valor) AS Total 
 FROM Atendimento
 GROUP BY Data
 ORDER BY Data DESC;

-- 21. Recuperar os nomes dos médicos que possuem mais de dois telefones.
SELECT M.Crm, M.Nome, COUNT(*) AS QuantidadeTelefones
FROM TelefoneMedico TM NATURAL INNER JOIN Medico M
GROUP BY M.Crm, M.Nome
HAVING COUNT(*) > 2
ORDER BY QuantidadeTelefones DESC, M.Nome;

-- 22. Recuperar os nomes dos setores que têm menos de 3 médicos alocados.
SELECT S.Nome, COUNT(*) AS QuantidadeMedicos
FROM SetorMedico SM NATURAL RIGHT INNER JOIN Setor S
GROUP BY S.CodSetor, S.Nome
HAVING COUNT(*) < 3
ORDER BY QuantidadeMedicos DESC;

-- 23. Criar uma visão contendo o crm, nome de cada médico com a respectiva quantidade de atendimentos realizados por cada médico.
CREATE VIEW VisaoMedico
AS
    SELECT M.Crm, M.Nome, COUNT(A.CodAtendimento) AS QuantidadeAtendimentos
    FROM Atendimento A NATURAL INNER JOIN Medico M
    WHERE A.AtendAnterior IS NULL
    GROUP BY M.Crm, M.Nome
    ORDER BY QuantidadeAtendimentos DESC, M.Nome;

-- 24. Recuperar o CRM e o Nome de todos os médicos da clínica ordenados em  ordem decrescente pela quantidade de atendimentos realizados.
SELECT Crm, Nome
FROM VisaoMedico
ORDER BY QuantidadeAtendimentos DESC, Crm;

-- 25. Criar uma visão contendo, para cada setor, o seu código, o nome, o nome  do supervisor e a quantidade de médicos alocados.
CREATE VIEW VisaoSetor 
AS
    SELECT S.CodSetor, S.Nome AS NomeSetor, M.Nome AS NomeSupervisor, COUNT(SM.CRM) AS QuantidadeMedicos
    FROM SetorMedico SM NATURAL RIGHT OUTER INNER JOIN Setor S
        INNER JOIN Medico M ON S.Supervisor = M.CRM
    GROUP BY S.CodSetor, S.Nome, M.Nome
    ORDER BY S.CodSetor;

SELECT * FROM VisaoSetor;

-- 26. Recuperar o código, o nome e o nome do supervisor de cada setor que tem  mais de um médico alocado. 
SELECT CodSetor, NomeSetor, NomeSupervisor
FROM VisaoSetor
WHERE QuantidadeMedicos > 1
ORDER BY CodSetor;

-- 27. Criar uma visão contendo, para cada atendimento realizado na clínica, a  data do atendimento, o crm do médico, o nome do médico, o código do  paciente, o nome do paciente e o tipo do atendimento.
CREATE VIEW VisaoAtendimento
AS
    SELECT A.Data, M.CRM, M.Nome AS Medico, P.CodPaciente, P.Nome AS Paciente, A.Tipo
    FROM Atendimento A NATURAL INNER JOIN Medico M
        INNER JOIN Paciente P ON A.CodPaciente = P.CodPaciente
    ORDER BY A.Data, M.Crm;

SELECT * FROM VisaoAtendimento;

-- 28. Recuperar o código do paciente, o nome do paciente e o tipo da consulta  para cada atendimento realizado para o médico com CRM 1111-1.
SELECT CodPaciente, Paciente, Tipo
FROM VisaoAtendimento
WHERE CRM = '1111-1'

-- 29. Atualizar a operadora dos atendimentos feitos pela operadora Unimed para  Unimed Vida.
UPDATE Atendimento
SET Tipo = 'Unimed Vida'
WHERE Tipo = 'Unimed';

-- 30. Atualizar o supervisor do setor de Neurologia para o médico com CRM  1111-3.
UPDATE Setor
SET Supervisor = '1111-3'
WHERE Nome = 'Neurologia';

-- 31. Excluir todos os atendimentos realizados pelo médico com CRM 1111-1.
DELETE FROM Atendimento
WHERE CRM = '1111-1';

-- 32. Excluir os telefones de todos os médicos da clinica.
DELETE FROM TelefoneMedico;

-- 33. Criar um índice para o atributo nome da tabela Médico.
CREATE INDEX idx_nome_medico
ON Medico(Nome);