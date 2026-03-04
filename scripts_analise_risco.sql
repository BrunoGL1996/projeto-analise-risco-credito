-- 1. Cria e seleciona o banco de dados
CREATE DATABASE IF NOT EXISTS analise_credito;
USE analise_credito;

-- 2. Limpa tabelas antigas para evitar conflito
DROP TABLE IF EXISTS tb_clientes_risco;
DROP TABLE IF EXISTS tb_clientes_financeiro;
DROP TABLE IF EXISTS tb_clientes_perfil;

-- 3. Cria a tabela de Perfil (Dados Demográficos)
CREATE TABLE tb_clientes_perfil (
    ID INT PRIMARY KEY,
    genero VARCHAR(20),
    escolaridade VARCHAR(50),
    estado_civil VARCHAR(20),
    idade INT
);

-- 4. Cria a tabela Financeira (Faturas e Limites)
CREATE TABLE tb_clientes_financeiro (
    ID INT,
    limite_credito DECIMAL(15,2),
    fatura_setembro DECIMAL(15,2),
    pagamento_setembro DECIMAL(15,2),
    PRIMARY KEY (ID),
    FOREIGN KEY (ID) REFERENCES tb_clientes_perfil(ID)
);

-- 5. Cria a tabela de Risco (Status de Inadimplência)
CREATE TABLE tb_clientes_risco (
    ID INT,
    inadimplente_proximo_mes VARCHAR(5),
    PRIMARY KEY (ID),
    FOREIGN KEY (ID) REFERENCES tb_clientes_perfil(ID)
);