/* ===== Prodecimentos Armazenados =====
    - Declarando variáveis locais
        DECLARE [nome_variavel] [TIPO] [restrições];

        DECLARE quantidade INTEGER;
        DECLARE valor NUMERIC(10, 2) DEFAULT 200;
        DECLARE soma := 0;
        DELCARE PI CONSTANT NUMERIC(3,2) := 3.14;
        DECLARE divisao NUMERIC(10,2) := (5/2);

    - Copiando Tipo
        - sintaxe: DECLARE [nome_variavel] [Tabela.Coluna%TYPE];

        DECLARE quantidade Vendas.Quantidade%TYPE;
        DECLARE soma Vendas.SubTotal%TYPE := 0;

    - Tipo Linha
        - sintaxe: DECLARE [nome_variavel] [Tabela%ROWTYPE];

        DECLARE emp Empregado%ROWTYPE;

    - Atribuindo Valores a Variáveis
        SET [nome_variavel] = [expressão];
        SET [nome_variavel] := valor;
        SELECT [coluna] INTO [nome_variaveis] [nome_colunas] FROM [tabela] WHERE [condição]; -- só funciona se a consulta retornar exatamente uma linha

        SET quantidade = 10;
        SET soma := soma + quantidade;

        SELECT INTO salarioAtual
        FROM Empregado
        WHERE Matricula = '1111-1';

        SELECT INTO totalEmpregados, mediaSalarial COUNT(*), AVG(Salario)
        FROM Empregado;

   - Sintaxe básica para criação:
        CREATE PROCEDURE nome_procedimento (parametros)
        BEGIN
        -- corpo do procedimento
        END;
   - Para executar um procedimento armazenado, utiliza-se o comando CALL:
     CALL nome_procedimento(parametros);
   - É importante gerenciar permissões para garantir a segurança dos procedimentos armazenados.
*/

/*
    As tabelas utilizadas ainda são as mesmas, criadas o arquivo 1 e povoadas no arquivo 2.
*/

-- Exemplo 01: crie um procedimento armazenado para recuperar o número do próximo departamento a ser criado. Ex: se o último departamento criado foi o de código 2, o procedimento deve retornar 3.
CREATE FUNCTION proximoDepartamento() RETURNS INTEGER
AS $$
    DECLARE
        maior INTEGER;
    BEGIN
        SELECT INTO maiorDepartamento MAX(CodDepartamento)
        FROM Departamento;
        RETURN maior + 1;
    END;
$$ LANGUAGE plpgsql;

SELECT proximoDepartamento(); -- para testar

-- Exemplo 02: crie um procedimento armazenado para recuperar a quantidade de projetos em que um determinado empregado trabalha.
CREATE FUNCTION numeroProjetos(matricula VARCHAR) RETURNS INTEGER
AS $$
    DECLARE
        totalProjetos INTEGER;
    BEGIN
        SELECT INTO totalProjetos COUNT(*)
        FROM TrabalhaProjeto
        WHERE Empregado = matricula;
        RETURN totalProjetos;
    END;
$$ LANGUAGE plpgsql;

SELECT Matricula, Nome, numeroProjetos(Matricula) AS Projetos
FROM TrabalhaProjeto;

-- Exemplo 03: crie um procedimento armazenado para criar um novo departamento a partir do nome e da matrícula do supervisor.
CREATE PROCEDURE criarDepartamento(nomeDep VARCHAR, matriculaSup VARCHAR)
AS $$
    DECLARE
        codDep INTEGER;
    BEGIN
        codDep := proximoDepartamento();
        INSERT INTO Departamento VALUES (
            codDep, nomeDep, matriculaSup
        );
    END;
$$ LANGUAGE plpgsql;

CALL criarDepartamento('Marketing', '3333-3'); -- para testar
SELECT * FROM Departamento; -- para testar

/* ===== Estruturas de Controle ===== */

/* Estrutura condicional IF
    IF [condição] THEN [comandos]
        ELSE [comandos]
        ELSEIF [comandos]
    END IF;
*/

-- Exemplo 04: crie um subprograma que classifique um empregado de acordo sua faixa salarial, de forma que: x <= 1000 = 'Salário Baixo', 1000 < x <= 4000 = 'Salário Médio', x > 4000 = 'Salário Alto'.
CREATE FUNCTION classificarSalario(matEmpregado VARCHAR) RETURNS VARCHAR
AS $$
    DECLARE
        salarioAtual INTEGER(2);
    BEGIN
        SELECT INTO salarioAtual Salario
        FROM Empregado
        WHERE Matricula = matEmpregado;

        IF salarioAtual <= 1000 THEN
            RETURN 'Salário Baixo';
        ELSIF salarioAtual <= 4000 THEN
            RETURN 'Salário Médio';
        ELSE
            RETURN 'Salário Alto';
        END IF;
    END;
$$ LANGUAGE plpgsql;

/* Estrutura Condicional FOR
    FOR [variável] IN (
        SELECT ...
        FROM ...
        WHERE ...
    ) LOOP
        -- comandos
    END LOOP;
*/

-- Exemplo 05: crie um subprograma que calcule a quantidade de horas que um determinado empregado trabalhou em um projeto da empresa.
CREATE FUNCTION calcularHoras(matEmpregado VARCHAR) RETURNS INTEGER
AS $$
    DECLARE
        totalHoras INTEGER := 0;
        numHoras INTEGER;
    BEGIN
        FOR numHoras IN (
            SELECT NumHoras
            FROM TrabalhaProjeto
            WHERE Empregado = matEmpregado
        ) LOOP
            totalHoras := totalHoras + numHoras;
        END LOOP;
        RETURN totalHoras;
    END;
$$ LANGUAGE plpgsql;

/* ===== CURSOR =====
    - Um cursor é um mecanismo que permite percorrer linha a linha o resultado de uma consulta SQL.
    - Sintaxe básica para declaração:
        DECLARE 
            c1 REFCURSOR; -- livre
            c2 CURSOR FOR [consulta_sql]; -- amarrado e limitado
            c3 SCROLL CURSOR FOR [consulta_sql]; -- amarrado e flexível

    - Abrir o cursor:
        OPEN c1 FOR [consulta_sql]; -- para cursor livre
        OPEN c2; -- para cursor amarrado
        OPEN c3; -- para cursor flexível

    - Movimentação FETCH:
        FETCH [nome_cursor] INTO [variáveis];

    - Fechar o cursor:
        CLOSE [nome_cursor];
*/

-- Exemplo 06: calcule a quantidade de horas que um determinado empregado trabalhou em um projeto da empresa, utilizando cursor.
CREATE FUNCTION totalHoras(matEmpregado VARCHAR) RETURNS INTEGER
AS $$
    DECLARE
        total INTEGER := 0;
        numHoras INTEGER;
        c1 REFCURSOR;
        horas INTEGER;
    BEGIN
        OPEN c1 FOR (
            SELECT NumHoras
            FROM TrabalhaProjeto
            WHERE Empregado = matEmpregado
        );
        FETCH c1 INTO horas;
        WHILE FOUND (
            LOOP
                FETCH c1 INTO numHoras;
                EXIT WHEN NOT FOUND;
                total := total + numHoras;
            END LOOP
        );
        CLOSE c1;
        RETURN total;
    END;
$$ LANGUAGE plpgsql;