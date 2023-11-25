-- TAXA DE LEITOS SUS POR HOSPITAL

SELECT 
    leitos_2021_01.CNES,
    info_hospitais_2021_01.nome_estabelecimento,
    leitos_2021_01.leitos_sus,
    leitos_2021_01.leitos_existentes,
    (leitos_2021_01.leitos_sus * 100.0 / leitos_2021_01.leitos_existentes) AS Taxa_Leitos_SUS
FROM
    info_hospitais_2021_01
JOIN
    leitos_2021_01 ON info_hospitais_2021_01.CNES = leitos_2021_01.CNES;

-- MÉDIA DE LEITOS POR TIPO UNIDADE

SELECT 
    info_hospitais_2021_01.DS_Tipo_Unidade,
    AVG(leitos_2021_01.leitos_existentes) AS Media_Leitos_Existentes,
    AVG(leitos_2021_01.leitos_sus) AS Media_Leitos_SUS
FROM
    info_hospitais_2021_01
JOIN
    leitos_2021_01 ON info_hospitais_2021_01.CNES = leitos_2021_01.CNES
GROUP BY
    info_hospitais_2021_01.DS_Tipo_Unidade;
	
-- ANÁLISE DE GESTÃO POR UF

SELECT 
	info_hospitais_2021_01.tp_gestao,
	end_contato_hospitais_2021_01.uf,
	COUNT(*) AS numero_hospitais
FROM
    info_hospitais_2021_01
JOIN
    end_contato_hospitais_2021_01 ON info_hospitais_2021_01.CNES = end_contato_hospitais_2021_01.CNES
GROUP BY 
    end_contato_hospitais_2021_01.uf,
    info_hospitais_2021_01.tp_gestao
ORDER BY
    end_contato_hospitais_2021_01.uf ASC;
	
-- IDENTIFICAÇÃO DE HOSPITAIS SEM LEITOS DO SUS

SELECT 
    info_hospitais_2021_01.CNES,
    info_hospitais_2021_01.Nome_Estabelecimento
FROM
    info_hospitais_2021_01
LEFT JOIN
    leitos_2021_01 ON info_hospitais_2021_01.CNES = leitos_2021_01.CNES
WHERE
    leitos_2021_01.Leitos_SUS IS NULL OR leitos_2021_01.Leitos_SUS = 0;

-- TOTAL E PROPORÇÃO DE HOSPITAIS SEM LEITOS DO SUS

SELECT 
    COUNT(CASE WHEN leitos_2021_01.Leitos_SUS IS NULL OR leitos_2021_01.Leitos_SUS = 0 THEN 1 ELSE NULL END) AS Hospitais_Sem_Leitos_SUS,
    COUNT(*) AS Total_Hospitais,
    (COUNT(CASE WHEN leitos_2021_01.Leitos_SUS IS NULL OR leitos_2021_01.Leitos_SUS = 0 THEN 1 ELSE NULL END) * 100.0 / COUNT(*)) AS Proporcao_Hospitais_Sem_Leitos_SUS
FROM
    info_hospitais_2021_01
LEFT JOIN
    leitos_2021_01 ON info_hospitais_2021_01.CNES = leitos_2021_01.CNES;

-- CORRELAÇÃO ENTRE NÚMERO DE LEITOS E TIPO DE UNIDADE

SELECT 
    info_hospitais_2021_01.DS_Tipo_Unidade,
    AVG(leitos_2021_01.Leitos_Existentes) AS Media_Leitos_Existentes
FROM
    info_hospitais_2021_01
JOIN
    leitos_2021_01 ON info_hospitais_2021_01.CNES = leitos_2021_01.CNES
GROUP BY
    info_hospitais_2021_01.DS_Tipo_Unidade;
	
-- AVALIAÇÃO DA COBERTURA DE UTI POR REGIÃO

SELECT 
    end_contato_hospitais_2021_01.regiao,
    SUM(leitos_2021_01.UTI_Total_Exist) AS Total_UTI,
    SUM(leitos_2021_01.Leitos_Existentes) AS Total_Leitos
FROM
    end_contato_hospitais_2021_01
JOIN
    leitos_2021_01 ON end_contato_hospitais_2021_01.CNES = leitos_2021_01.CNES
GROUP BY
    end_contato_hospitais_2021_01.regiao;

-- COMPARAÇÃO DE NÚMERO DE LEITOS ENTRE HOSPITAIS PÚBLICOS E PRIVADOS

SELECT 
    CASE 
		WHEN info_hospitais_2021_01.desc_natureza_juridica = 'HOSPITAL_PUBLICO' THEN 'Público'
		WHEN info_hospitais_2021_01.desc_natureza_juridica = 'HOSPITAL_FILANTROPICO' THEN 'Filantrópico'
		ELSE 'Privado' END AS natureza_juridica,
    AVG(leitos_2021_01.Leitos_Existentes) AS Media_Leitos_Existentes
FROM
    info_hospitais_2021_01
JOIN
    leitos_2021_01 ON info_hospitais_2021_01.CNES = leitos_2021_01.CNES
GROUP BY
    info_hospitais_2021_01.desc_natureza_juridica;

-- ANÁLISE DE NATUREZA JURÍDICA POR UF

SELECT 
    end_contato_hospitais_2021_01.UF,
    info_hospitais_2021_01.Desc_Natureza_Juridica,
    COUNT(*) AS Numero_Hospitais
FROM
   end_contato_hospitais_2021_01
JOIN
   info_hospitais_2021_01 ON end_contato_hospitais_2021_01.CNES = info_hospitais_2021_01.CNES
GROUP BY
    end_contato_hospitais_2021_01.UF,
    info_hospitais_2021_01.Desc_Natureza_Juridica
ORDER BY
    end_contato_hospitais_2021_01.uf ASC;

-- VARIAÇÃO DOS LEITOS EM 2021

WITH VariaçãoLeitos AS (
    SELECT
        leitos_2021_01.CNES,
        leitos_2021_01.leitos_existentes  AS Leitos_Janeiro,
        leitos_2021_03.leitos_existentes  AS Leitos_Abril,
        leitos_2021_06.leitos_existentes  AS Leitos_Junho,
        leitos_2021_09.leitos_existentes  AS Leitos_Setembro,
        leitos_2021_12.leitos_existentes  AS Leitos_Dezembro
    FROM
        leitos_2021_01
    LEFT JOIN
        leitos_2021_03 ON leitos_2021_01.CNES = leitos_2021_03.CNES
    LEFT JOIN
        leitos_2021_06 ON leitos_2021_01.CNES = leitos_2021_06.CNES
    LEFT JOIN
        leitos_2021_09 ON leitos_2021_01.CNES = leitos_2021_09.CNES
    LEFT JOIN
        leitos_2021_12 ON leitos_2021_01.CNES = leitos_2021_12.CNES
)
SELECT
    CNES,
    Leitos_Janeiro,
    Leitos_Abril,
    Leitos_Junho,
    Leitos_Setembro,
    Leitos_Dezembro,
    Leitos_Abril - Leitos_Janeiro AS Variação_Abril,
    Leitos_Junho - Leitos_Abril AS Variação_Junho,
    Leitos_Setembro - Leitos_Junho AS Variação_Setembro,
    Leitos_Dezembro - Leitos_Setembro AS Variação_Dezembro
FROM
    VariaçãoLeitos;
	
-- SELECT *
-- FROM estabelecimentos_2021

-- SELECT *
-- FROM info_hospitais_2021_01

SELECT *
FROM leitos_2021_01