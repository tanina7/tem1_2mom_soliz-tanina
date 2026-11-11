USE superstore_soliz_tanina;

WITH anual AS (
    SELECT region, YEAR(order_date) AS anio, SUM(sales) AS ventas_anuales,
           SUM(profit) AS ganancia_anual
    FROM ventas
    WHERE order_date IS NOT NULL AND region IS NOT NULL
    GROUP BY region, YEAR(order_date)
),
comparacion AS (
    SELECT *,
           LAG(anio) OVER (PARTITION BY region ORDER BY anio) AS anio_previo,
           LAG(ventas_anuales) OVER (PARTITION BY region ORDER BY anio) AS ventas_previas,
           LAG(ganancia_anual) OVER (PARTITION BY region ORDER BY anio) AS ganancia_previa
    FROM anual
),
totales AS (
    SELECT region, SUM(ganancia_anual) AS ganancia_total
    FROM anual
    GROUP BY region
),
ranking AS (
    SELECT *,
           DENSE_RANK() OVER (ORDER BY ganancia_total DESC) AS mejor_posicion,
           DENSE_RANK() OVER (ORDER BY ganancia_total ASC) AS peor_posicion
    FROM totales
)
SELECT c.region, c.anio, c.ventas_anuales, c.ganancia_anual,
       CASE WHEN c.ventas_anuales <> 0 THEN ROUND(100.0 * c.ganancia_anual / c.ventas_anuales, 2) END AS margen_pct,
       CASE WHEN c.anio_previo = c.anio - 1 AND c.ventas_previas <> 0
            THEN ROUND(100.0 * (c.ventas_anuales - c.ventas_previas) / ABS(c.ventas_previas), 2) END AS variacion_ventas_pct,
       CASE WHEN c.anio_previo = c.anio - 1 AND c.ganancia_previa <> 0
            THEN ROUND(100.0 * (c.ganancia_anual - c.ganancia_previa) / ABS(c.ganancia_previa), 2) END AS variacion_ganancia_pct,
       r.ganancia_total, r.mejor_posicion = 1 AS mejor_region,
       r.peor_posicion = 1 AS peor_region
FROM comparacion c
JOIN ranking r ON c.region = r.region
ORDER BY c.region, c.anio;
