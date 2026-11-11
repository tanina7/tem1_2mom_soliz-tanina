USE superstore_soliz_tanina;

WITH rangos AS (
    SELECT category, sub_category, sales, profit, discount,
           CASE
               WHEN discount = 0 THEN 'Sin descuento'
               WHEN discount > 0 AND discount <= 0.20 THEN 'Bajo'
               WHEN discount > 0.20 AND discount <= 0.50 THEN 'Medio'
               WHEN discount > 0.50 AND discount <= 1 THEN 'Alto'
               ELSE 'Sin dato o fuera de rango'
           END AS rango
    FROM ventas
),
resumen AS (
    SELECT rango, 'Global' AS nivel, CAST(NULL AS STRING) AS category, CAST(NULL AS STRING) AS sub_category,
           COUNT(*) AS registros, SUM(sales) AS importe_ventas, SUM(profit) AS ganancia,
           COUNT(profit) AS registros_con_ganancia_informada,
           COUNT(CASE WHEN profit < 0 THEN 1 END) AS registros_con_perdida,
           COUNT(CASE WHEN profit <= 0 THEN 1 END) AS registros_no_rentables,
           AVG(discount) AS descuento_promedio
    FROM rangos
    GROUP BY rango
    UNION ALL
    SELECT rango, 'Categoria' AS nivel, category, CAST(NULL AS STRING) AS sub_category,
           COUNT(*) AS registros, SUM(sales) AS importe_ventas, SUM(profit) AS ganancia,
           COUNT(profit) AS registros_con_ganancia_informada,
           COUNT(CASE WHEN profit < 0 THEN 1 END) AS registros_con_perdida,
           COUNT(CASE WHEN profit <= 0 THEN 1 END) AS registros_no_rentables,
           AVG(discount) AS descuento_promedio
    FROM rangos
    GROUP BY rango, category
    UNION ALL
    SELECT rango, 'Subcategoria' AS nivel, category, sub_category,
           COUNT(*) AS registros, SUM(sales) AS importe_ventas, SUM(profit) AS ganancia,
           COUNT(profit) AS registros_con_ganancia_informada,
           COUNT(CASE WHEN profit < 0 THEN 1 END) AS registros_con_perdida,
           COUNT(CASE WHEN profit <= 0 THEN 1 END) AS registros_no_rentables,
           AVG(discount) AS descuento_promedio
    FROM rangos
    GROUP BY rango, category, sub_category
),
porcentajes AS (
    SELECT *,
           CASE WHEN importe_ventas <> 0 THEN 100.0 * ganancia / importe_ventas END AS margen_pct,
           CASE WHEN registros_con_ganancia_informada > 0
                THEN 100.0 * registros_no_rentables / registros_con_ganancia_informada END AS no_rentables_pct
    FROM resumen
)
SELECT rango, nivel, category, sub_category, registros, registros_con_ganancia_informada,
       importe_ventas, ganancia, ROUND(margen_pct, 2) AS margen_pct,
       registros_con_perdida, registros_no_rentables, ROUND(no_rentables_pct, 2) AS no_rentables_pct,
       ROUND(100.0 * descuento_promedio, 2) AS descuento_promedio_pct,
       CASE WHEN no_rentables_pct IS NOT NULL THEN
           DENSE_RANK() OVER (PARTITION BY rango, nivel ORDER BY no_rentables_pct DESC)
       END AS puesto_por_no_rentabilidad
FROM porcentajes
ORDER BY nivel, rango, puesto_por_no_rentabilidad, category, sub_category;
