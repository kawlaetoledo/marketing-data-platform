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

