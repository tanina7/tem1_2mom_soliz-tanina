USE superstore_soliz_tanina;

WITH referencia AS (
    SELECT MAX(order_date) AS fecha_maxima FROM ventas
),
clientes AS (
    SELECT customer_id, MAX(order_date) AS ultima_compra,
           COUNT(DISTINCT order_id) AS frecuencia, SUM(sales) AS importe
    FROM ventas
    WHERE customer_id IS NOT NULL AND order_id IS NOT NULL AND order_date IS NOT NULL
    GROUP BY customer_id
    HAVING SUM(sales) IS NOT NULL
),
metricas AS (
    SELECT c.*, r.fecha_maxima,
           DATEDIFF(r.fecha_maxima, c.ultima_compra) AS dias_desde_compra
    FROM clientes c
    CROSS JOIN referencia r
),
puntos AS (
    SELECT *,
           6 - NTILE(5) OVER (ORDER BY dias_desde_compra ASC, customer_id) AS r,
           6 - NTILE(5) OVER (ORDER BY frecuencia DESC, customer_id) AS f,
           6 - NTILE(5) OVER (ORDER BY importe DESC, customer_id) AS m
    FROM metricas
),
segmentos AS (
    SELECT *,
           CASE
               WHEN r >= 4 AND f >= 4 AND m >= 4 THEN 'Alto valor'
               WHEN r <= 2 AND f >= 3 THEN 'Riesgo de abandono'
               WHEN f >= 4 THEN 'Recurrente'
               ELSE 'Otros'
           END AS segmento_rfm
    FROM puntos
)
SELECT customer_id, fecha_maxima, ultima_compra, dias_desde_compra, frecuencia, importe,
       r, f, m, CONCAT(CAST(r AS STRING), CAST(f AS STRING), CAST(m AS STRING)) AS codigo_rfm,
       segmento_rfm, COUNT(*) OVER (PARTITION BY segmento_rfm) AS clientes_del_segmento
FROM segmentos
ORDER BY segmento_rfm, importe DESC, customer_id;
