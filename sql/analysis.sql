-- Desafio 1: Top 3 campanhas por ROAS
WITH por_campanha AS (
  SELECT campaign, SUM(revenue) / SUM(spend) AS roas
  FROM raw.ads_performance
  GROUP BY campaign
),
ranqueado AS (
  SELECT campaign, roas,
         RANK() OVER (ORDER BY roas DESC) AS posicao
  FROM por_campanha
)
SELECT campaign, ROUND(roas::numeric, 2) AS roas, posicao
FROM ranqueado
WHERE posicao <= 3;

-- Desafio 2: Gasto acumulado por plataforma
WITH diario AS (
  SELECT date, platform, SUM(spend) AS spend
  FROM raw.ads_performance
  GROUP BY date, platform
)
SELECT date::date AS date, platform,
       ROUND(spend::numeric, 2) AS spend,
       ROUND(SUM(spend) OVER (PARTITION BY platform ORDER BY date)::numeric, 2) AS spend_acumulado
FROM diario
ORDER BY platform, date;

