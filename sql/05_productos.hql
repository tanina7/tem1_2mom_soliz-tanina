USE superstore_soliz_tanina;

WITH productos AS (
    SELECT product_id, category, MIN(product_name) AS producto,
           SUM(sales) AS importe_ventas, SUM(quantity) AS unidades,
           SUM(profit) AS ganancia
    FROM ventas
    WHERE product_id IS NOT NULL AND category IS NOT NULL
    GROUP BY product_id, category
),
margenes AS (
    SELECT *,
           CASE WHEN importe_ventas > 0 THEN 100.0 * ganancia / importe_ventas END AS margen_pct
    FROM productos
),
ranking AS (
    SELECT *,
           RANK() OVER (PARTITION BY category ORDER BY ganancia DESC) AS posicion_categoria,
           DENSE_RANK() OVER (ORDER BY unidades DESC) AS puesto_por_unidades,
           CASE WHEN margen_pct IS NOT NULL
                THEN DENSE_RANK() OVER (ORDER BY CASE WHEN margen_pct IS NULL THEN 1 ELSE 0 END, margen_pct)
           END AS puesto_menor_margen,
           ROW_NUMBER() OVER (PARTITION BY category ORDER BY ganancia DESC, product_id) AS fila_ganancia,
           ROW_NUMBER() OVER (ORDER BY unidades DESC, product_id, category) AS fila_volumen,
           ROW_NUMBER() OVER (
               ORDER BY CASE WHEN margen_pct IS NULL THEN 1 ELSE 0 END, margen_pct, product_id, category
           ) AS fila_margen,
           SUM(ganancia) OVER (
               PARTITION BY category ORDER BY ganancia DESC, product_id
               ROWS BETWEEN UNBOUNDED PRECEDING AND CURRENT ROW
           ) AS ganancia_acumulada_categoria
    FROM margenes
)
SELECT category, product_id, producto, importe_ventas, unidades, ganancia,
       ROUND(margen_pct, 2) AS margen_pct, posicion_categoria, puesto_por_unidades,
       puesto_menor_margen, ganancia_acumulada_categoria,
       fila_ganancia <= 5 AS top_5_ganancia_categoria,
       fila_volumen <= 5 AND unidades IS NOT NULL AS top_5_volumen,
       fila_margen <= 5 AND margen_pct IS NOT NULL AS top_5_menor_margen
FROM ranking
ORDER BY category, posicion_categoria, product_id;
