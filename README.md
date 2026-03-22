# Projeto Análise de Crédito "BANCO X".

Análise de inadimplência de 30 mil clientes utilizando MySQL e Power BI

🏦 Gestão de Risco de Crédito: SQL + Power BI

Este repositório contém um projeto completo de análise de dados, onde utilizei uma base de 30.000 clientes para identificar padrões de comportamento financeiro e perfis de inadimplência.

📂 Estrutura do Projeto

UCI_Credit_Card.csv: Base de dados bruta utilizada como fonte.

scripts_analise_risco.sql: Scripts de criação de tabelas e Views otimizadas no MySQL.

analise_riscos_BI.pbix: Dashboard interativo com os indicadores de risco.

Demonstração do Dashboard:
![analise_risco_de_credito-ezgif com-video-to-gif-converter](https://github.com/user-attachments/assets/b87bfd6c-ed97-4f81-8a71-3656e163f831)

💡 Os insights abaixo foram extraídos a partir das interações demonstradas acima, focando nos principais indicadores de risco.

📊 Principais Insights do Dashboard

🔎 Panorama Geral  
A taxa média de inadimplência da carteira foi de 22,12%, indicando um nível de risco relevante que pode impactar diretamente a rentabilidade da operação. O indicador reforça a necessidade de monitoramento contínuo e revisão das políticas de concessão de crédito.

🎓 Escolaridade  
Clientes com menor nível de escolaridade apresentam maior propensão à inadimplência, com destaque para o grupo de Ensino Médio (25,16%). Em contrapartida, clientes com Pós-Graduação demonstram menor risco, sugerindo que o nível educacional é um fator relevante na análise de crédito e pode ser incorporado como variável de decisão.

👥 Gênero  
O público masculino apresenta maior taxa de inadimplência (26,20%) em comparação ao feminino, indicando um padrão de risco distinto entre os grupos. Esse comportamento pode ser explorado para ajustes em modelos de score e estratégias de concessão de crédito.

📅 Faixa Etária  
A inadimplência se mantém relativamente estável ao longo das faixas etárias, porém apresenta aumento significativo em clientes acima de 60 anos. Esse comportamento sugere a necessidade de políticas mais conservadoras para esse grupo, considerando possíveis limitações de renda e maior risco financeiro.

📌 Recomendações Estratégicas  
- Revisar políticas de concessão de crédito para perfis com maior risco identificado  
- Ajustar limites e condições de crédito com base em variáveis como escolaridade e idade  
- Incorporar variáveis demográficas em modelos de score de crédito  
- Desenvolver estratégias preventivas para redução da inadimplência em grupos críticos  
