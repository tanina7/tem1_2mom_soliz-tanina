USE superstore_soliz_tanina;

WITH mensual AS (
    SELECT YEAR(order_date) AS anio, MONTH(order_date) AS mes,
           YEAR(order_date) * 12 + MONTH(order_date) AS indice_mes,
           SUM(sales) AS ventas_mes, SUM(profit) AS ganancia_mes
    FROM ventas
    WHERE order_date IS NOT NULL
    GROUP BY YEAR(order_date), MONTH(order_date)
),
ventanas AS (
    SELECT *,
           LAG(ventas_mes) OVER (ORDER BY indice_mes) AS ventas_mes_previo,
           LAG(ganancia_mes) OVER (ORDER BY indice_mes) AS ganancia_mes_previo,
           COUNT(*) OVER (
               ORDER BY indice_mes RANGE BETWEEN 1 PRECEDING AND CURRENT ROW
           ) AS meses_en_ventana_2,
           COUNT(*) OVER (
               ORDER BY indice_mes RANGE BETWEEN 2 PRECEDING AND CURRENT ROW
           ) AS meses_en_ventana_3,
           AVG(CAST(ventas_mes AS DOUBLE)) OVER (
               ORDER BY indice_mes RANGE BETWEEN 2 PRECEDING AND CURRENT ROW
           ) AS media_ventas,
           AVG(CAST(ganancia_mes AS DOUBLE)) OVER (
               ORDER BY indice_mes RANGE BETWEEN 2 PRECEDING AND CURRENT ROW
           ) AS media_ganancia
    FROM mensual
),
ranking AS (
    SELECT *,
           ROW_NUMBER() OVER (ORDER BY ventas_mes DESC, indice_mes) AS fila_mayor_venta,
           ROW_NUMBER() OVER (
               ORDER BY CASE WHEN ventas_mes IS NULL THEN 1 ELSE 0 END, ventas_mes, indice_mes
           ) AS fila_menor_venta
    FROM ventanas
)
SELECT v.anio, v.mes, v.ventas_mes, v.ganancia_mes,
       CASE WHEN v.meses_en_ventana_2 = 2 AND v.ventas_mes_previo <> 0
            THEN ROUND(100.0 * (v.ventas_mes - v.ventas_mes_previo) / ABS(v.ventas_mes_previo), 2)
       END AS variacion_mensual_ventas_pct,
       CASE WHEN v.meses_en_ventana_2 = 2 AND v.ganancia_mes_previo <> 0
            THEN ROUND(100.0 * (v.ganancia_mes - v.ganancia_mes_previo) / ABS(v.ganancia_mes_previo), 2)
       END AS variacion_mensual_ganancia_pct,
       p.ventas_mes AS ventas_mismo_mes_anio_anterior, p.ganancia_mes AS ganancia_mismo_mes_anio_anterior,
       CASE WHEN p.ventas_mes <> 0 THEN ROUND(100.0 * (v.ventas_mes - p.ventas_mes) / ABS(p.ventas_mes), 2)
       END AS variacion_anual_ventas_pct,
       CASE WHEN p.ganancia_mes <> 0 THEN ROUND(100.0 * (v.ganancia_mes - p.ganancia_mes) / ABS(p.ganancia_mes), 2)
       END AS variacion_anual_ganancia_pct,
       CASE WHEN v.meses_en_ventana_3 = 3
            THEN CAST(ROUND(v.media_ventas, 2) AS DECIMAL(18,2)) END AS media_ventas_3_meses,
       CASE WHEN v.meses_en_ventana_3 = 3
            THEN CAST(ROUND(v.media_ganancia, 2) AS DECIMAL(18,2)) END AS media_ganancia_3_meses,
       v.fila_mayor_venta <= 3 AND v.ventas_mes IS NOT NULL AS top_3_mayor_venta,
       v.fila_menor_venta <= 3 AND v.ventas_mes IS NOT NULL AS top_3_menor_venta
FROM ranking v
LEFT JOIN mensual p ON v.indice_mes = p.indice_mes + 12
ORDER BY v.indice_mes;
