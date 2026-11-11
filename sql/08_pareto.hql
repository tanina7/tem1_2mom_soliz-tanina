USE superstore_soliz_tanina;

WITH productos AS (
    SELECT product_id, MIN(product_name) AS producto,
           SUM(sales) AS importe_ventas, SUM(profit) AS ganancia
    FROM ventas
    WHERE product_id IS NOT NULL
    GROUP BY product_id
),
aportes AS (
    SELECT 'Ventas' AS metrica, product_id, producto, importe_ventas AS aporte
    FROM productos
    WHERE importe_ventas IS NOT NULL
    UNION ALL
    SELECT 'Ganancia neta' AS metrica, product_id, producto, ganancia AS aporte
    FROM productos
    WHERE ganancia IS NOT NULL
),
acumulados AS (
    SELECT *,
           ROW_NUMBER() OVER (PARTITION BY metrica ORDER BY aporte DESC, product_id) AS posicion,
           COUNT(*) OVER (PARTITION BY metrica) AS productos_con_dato,
           SUM(aporte) OVER (PARTITION BY metrica) AS aporte_total,
           SUM(aporte) OVER (
               PARTITION BY metrica ORDER BY aporte DESC, product_id
               ROWS BETWEEN UNBOUNDED PRECEDING AND CURRENT ROW
           ) AS aporte_acumulado
    FROM aportes
),
corte AS (
    SELECT *,
           MIN(CASE WHEN aporte_total > 0 AND aporte_acumulado >= 0.80 * aporte_total THEN posicion END)
               OVER (PARTITION BY metrica) AS productos_para_80_pct
    FROM acumulados
)
SELECT metrica, posicion, product_id, producto, aporte, aporte_total, aporte_acumulado,
       CASE WHEN aporte_total > 0 THEN ROUND(100.0 * aporte / aporte_total, 4) END AS participacion_pct,
       CASE WHEN aporte_total > 0 THEN ROUND(100.0 * aporte_acumulado / aporte_total, 4) END AS acumulado_pct,
       productos_para_80_pct, productos_con_dato,
       ROUND(100.0 * productos_para_80_pct / productos_con_dato, 2) AS pct_productos_para_80,
       posicion <= productos_para_80_pct AS pertenece_al_corte,
       posicion = productos_para_80_pct AS producto_que_alcanza_el_80
FROM corte
ORDER BY metrica, posicion;
