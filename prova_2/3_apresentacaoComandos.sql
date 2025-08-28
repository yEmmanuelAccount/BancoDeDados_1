/* 
    Apresentação dos comandos SQL

    NÃO RODE ESSE ARQUIVO!
    Esse arquivo é apenas para apresentar os comandos SQL que foram vistos em aula.

*/

/* ===== APRENDENDO A CRIAR TABELAS ===== */

/* Exemplo 01
    > Crie uma tabela para cada esquema de relação a seguir:
    Empregado (Matricula PK, Nome, Salario, Supervisor)
    Projeto (Codigo PK, Nome, DataInicio)
    TrabalhaProjeto (Empregado PK, CodProjeto PK, NumHoras, DataAlocacao)
*/

CREATE TABLE empregado (
    Matricula VARCHAR(10) PRIMARY KEY,
    Nome VARCHAR(100),
    Salario NUMERIC (10,2),
    Supervisor VARCHAR(10),

    FOREIGN KEY (Supervisor) REFERENCES empregado(Matricula),
    CHECK (Salario > 1500),
    UNIQUE (Nome, Salario) -- a combinação de Nome e Salario deve ser única
);

CREATE TABLE projeto (
    Codigo INT PRIMARY KEY,
    Nome VARCHAR(50) UNIQUE NOT NULL,
    DataInicio DATE
);

CREATE TABLE TrabalhaProjeto (
    Empregado VARCHAR(10),
    CodProjeto INT,
    NumHoras INT,
    DataAlocacao DATE,

    PRIMARY KEY (Empregado, CodProjeto),
    FOREIGN KEY (Empregado) REFERENCES empregado(Matricula),
    FOREIGN KEY (CodProjeto) REFERENCES projeto(Codigo)
);

/* ===== Nomeando Restrições de Integridade ===== */
    -- constraint[nome_da_restrição]

/* ===== Alterando a estrutura de uma tabela já existente ===== */

    -- adicionar uma nova coluna
    ALTER TABLE empregado ADD COLUMN [nome_da_coluna] [tipo_da_coluna] [restrições];

    -- remover uma coluna
    ALTER TABLE empregado DROP COLUMN [nome_da_coluna] [RESTRICT|CASCADE];

    -- alterar coluna
    ALTER TABLE empregado ALTER COLUMN [nome_da_coluna] [restrições];

    -- adicionar uma restrição
    ALTER TABLE empregado ADD CONSTRAINT [nome_da_restrição] [tipo_da_restrição];

/* Exemplo 02
    Crie as tabelas referentes aos dois esquemas de relação a seguir:
    - Empregado (Matricula PK, Nome, Salario, Supervisor, CodDepartamento)
    - Departamento (Codigo PK, Nome, Gerente FK)
*/

CREATE TABLE Departamento (
    Codigo INT PRIMARY KEY,
    Nome VARCHAR(50) UNIQUE NOT NULL,
    Gerente VARCHAR(10),

    FOREIGN KEY (Gerente) REFERENCES empregado(Matricula)
);

CREATE TABLE Empregado (
    Matricula VARCHAR(10) PRIMARY KEY,
    Nome VARCHAR(100),
    Salario NUMERIC (10,2),
    Supervisor VARCHAR(10),
    CodDepartamento INT,

    FOREIGN KEY (Supervisor) REFERENCES empregado(Matricula),
    FOREIGN KEY (CodDepartamento) REFERENCES Departamento(Codigo),
    CHECK (Salario > 1500),
    UNIQUE (Nome, Salario)
);

/* ===== Inserção de dados ===== */
    INSERT INTO [nome_da_tabela] ([coluna1], [coluna2], ...) VALUES (valor1, valor2, ...);
    INSERT INTO [nome_da_tabela] VALUES (valor1, valor2, ...); -- inserir valores para todas as colunas

/* ===== Consulta de dados ===== */
    SELECT [coluna1], [coluna2], ... FROM [nome_da_tabela];
    SELECT * FROM [nome_da_tabela]; -- selecionar todas as colunas

