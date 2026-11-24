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

-- Desafio 3: média móvel de 7 dias de conversões por campanha
SELECT date::date AS date, campaign, conversions,
       ROUND(AVG(conversions) OVER (
         PARTITION BY campaign
         ORDER BY date
         ROWS BETWEEN 6 PRECEDING AND CURRENT ROW
       ), 2) AS media_movel_7d
FROM raw.ads_performance
ORDER BY campaign, date;

-- Desafio 4: Variação de gasto semana contra semana (só semanas completas)
WITH semanal AS (
  SELECT DATE_TRUNC('week', date)::date AS semana,
         SUM(spend) AS spend
  FROM raw.ads_performance
  GROUP BY 1
  HAVING COUNT(DISTINCT date) = 7
)
SELECT semana,
       ROUND(spend::numeric, 2) AS spend,
       ROUND(LAG(spend) OVER (ORDER BY semana)::numeric, 2) AS spend_semana_anterior,
       ROUND(((spend - LAG(spend) OVER (ORDER BY semana))
              / LAG(spend) OVER (ORDER BY semana) * 100)::numeric, 1) AS variacao_pct
FROM semanal
ORDER BY semana;

-- Desafio 5: Detectar e remover duplicatas com ROW_NUMBER()
-- Detectar
WITH numerado AS (
  SELECT *,
         ROW_NUMBER() OVER (
           PARTITION BY date, platform, campaign
           ORDER BY date
         ) AS rn
  FROM raw.ads_performance
)
SELECT date::date, platform, campaign, rn
FROM numerado
WHERE rn > 1;

-- Remover
DELETE FROM raw.ads_performance
WHERE ctid IN (
  SELECT ctid
  FROM (
    SELECT ctid,
           ROW_NUMBER() OVER (
             PARTITION BY date, platform, campaign
             ORDER BY date
           ) AS rn
    FROM raw.ads_performance
  ) t
  WHERE rn > 1
);

