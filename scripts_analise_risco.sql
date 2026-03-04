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

INSERT INTO tb_clientes_perfil (ID, genero, escolaridade, estado_civil, idade)
SELECT 
    ID, 
    CASE WHEN SEX = 1 THEN 'Masculino' ELSE 'Feminino' END,
    CASE 
        WHEN EDUCATION = 1 THEN 'Pós-Graduação'
        WHEN EDUCATION = 2 THEN 'Universidade'
        WHEN EDUCATION = 3 THEN 'Ensino Médio'
        ELSE 'Outros' 
    END,
    CASE WHEN MARRIAGE = 1 THEN 'Casado' WHEN MARRIAGE = 2 THEN 'Solteiro' ELSE 'Outros' END,
    AGE
FROM `UCI_Credit_Card`;

-- Inserindo na tabela Financeira
INSERT INTO tb_clientes_financeiro (ID, limite_credito, fatura_setembro, pagamento_setembro)
SELECT ID, LIMIT_BAL, BILL_AMT1, PAY_AMT1
FROM `UCI_Credit_Card`;

-- Inserindo na tabela de Risco
INSERT INTO tb_clientes_risco (ID, inadimplente_proximo_mes)
SELECT ID, CASE WHEN `default.payment.next.month` = 1 THEN 'Sim' ELSE 'Não' END
FROM `UCI_Credit_Card`;

USE analise_credito;

-- Penei pra caramba aqui pra transformar os números (1,2,3) em nomes que fazem sentido.
-- Tive que conferir a documentação do dataset original umas 10 vezes pq tava dando erro de lógica.
INSERT INTO tb_clientes_perfil (ID, genero, escolaridade, estado_civil, idade)
SELECT 
    ID, 
    CASE WHEN SEX = 1 THEN 'Masculino' ELSE 'Feminino' END,
    CASE 
        WHEN EDUCATION = 1 THEN 'Pos-Graduacao'
        WHEN EDUCATION = 2 THEN 'Universidade'
        WHEN EDUCATION = 3 THEN 'Ensino Medio'
        ELSE 'Outros' -- Usei Outros pra não perder os dados que vinham com 0 ou 4
    END,
    CASE WHEN MARRIAGE = 1 THEN 'Casado' WHEN MARRIAGE = 2 THEN 'Solteiro' ELSE 'Outros' END,
    AGE
FROM `UCI_Credit_Card`;

-- 2. Alimentando a tabela Financeira
INSERT INTO tb_clientes_financeiro (ID, limite_credito, fatura_setembro, pagamento_setembro)
SELECT ID, LIMIT_BAL, BILL_AMT1, PAY_AMT1
FROM `UCI_Credit_Card`;

-- 3. Alimentando a tabela de Risco
INSERT INTO tb_clientes_risco (ID, inadimplente_proximo_mes)
SELECT ID, CASE WHEN `default.payment.next.month` = 1 THEN 'Sim' ELSE 'Não' END
FROM `UCI_Credit_Card`;

-- ESSA QUERY ME DEU MUITO TRABALHO!! 
-- O MySQL tava retornando 0 na taxa porque ele ignorava as casas decimais.
-- Quase joguei o PC na janela até descobrir que tinha que multiplicar por 100.0 (com o ponto!) 
-- pra forçar o cálculo decimal.
SELECT 
    p.escolaridade,
    COUNT(*) AS total_clientes,
    ROUND(
    -- Usei o CASE aqui pra converter "Sim" em 1, senão o SQL não somava nem a pau
        SUM(CASE WHEN r.inadimplente_proximo_mes = 'Sim' THEN 1 ELSE 0 END) * 100.0 / COUNT(*), 
        2
    ) AS taxa_inadimplencia_perc
FROM tb_clientes_perfil p
JOIN tb_clientes_risco r ON p.ID = r.ID
GROUP BY p.escolaridade
ORDER BY taxa_inadimplencia_perc DESC;

SELECT 
    CASE 
        WHEN p.idade < 30 THEN '20-29 anos'
        WHEN p.idade BETWEEN 30 AND 45 THEN '30-45 anos'
        WHEN p.idade BETWEEN 46 AND 60 THEN '46-60 anos'
        ELSE 'Acima de 60'
    END AS faixa_etaria,
    COUNT(*) AS total_clientes,
    ROUND(
        SUM(CASE WHEN r.inadimplente_proximo_mes = 'Sim' THEN 1 ELSE 0 END) * 100.0 / COUNT(*), 
        2
    ) AS taxa_inadimplencia_perc
FROM tb_clientes_perfil p
JOIN tb_clientes_risco r ON p.ID = r.ID
GROUP BY faixa_etaria
ORDER BY faixa_etaria;

/* Finalmente consegui criar essa View. 
   O objetivo aqui foi unir as 3 tabelas (que eu mesmo separei pra ficar organizado)
   em uma só pra não passar raiva na hora de montar os gráficos no Power BI.
   Tive que usar JOIN porque os dados tavam espalhados. */

CREATE OR REPLACE VIEW vw_analise_risco_final AS
SELECT 
    p.ID,
    p.genero,
    p.escolaridade,
    p.idade,
    f.limite_credito,
    f.fatura_setembro,
    -- Criei essa 'flag' numérica pq o Power BI entende melhor 0 e 1 do que 'Sim' e 'Não'
    CASE WHEN r.inadimplente_proximo_mes = 'Sim' THEN 1 ELSE 0 END AS flag_inadimplente
FROM tb_clientes_perfil p
JOIN tb_clientes_financeiro f ON p.ID = f.ID
JOIN tb_clientes_risco r ON p.ID = r.ID;
