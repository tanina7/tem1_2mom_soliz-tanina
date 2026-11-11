USE superstore_soliz_tanina;

WITH resumen AS (
    SELECT COUNT(*) AS filas,
           COUNT(DISTINCT order_id) AS pedidos_unicos,
           COUNT(DISTINCT customer_id) AS clientes_unicos,
           COUNT(CASE WHEN order_date IS NULL OR ship_date IS NULL THEN 1 END) AS filas_con_fecha_faltante_o_invalida,
           COUNT(CASE WHEN ship_date < order_date THEN 1 END) AS envios_antes_del_pedido,
           COUNT(CASE WHEN sales <= 0 THEN 1 END) AS ventas_no_positivas,
           COUNT(CASE WHEN discount < 0 OR discount > 1 THEN 1 END) AS descuentos_fuera_de_rango,
           COUNT(CASE WHEN row_id IS NULL THEN 1 END) AS nulos_row_id,
           COUNT(CASE WHEN order_id IS NULL THEN 1 END) AS nulos_order_id,
           COUNT(CASE WHEN order_date IS NULL THEN 1 END) AS nulos_order_date,
           COUNT(CASE WHEN ship_date IS NULL THEN 1 END) AS nulos_ship_date,
           COUNT(CASE WHEN ship_mode IS NULL THEN 1 END) AS nulos_ship_mode,
           COUNT(CASE WHEN customer_id IS NULL THEN 1 END) AS nulos_customer_id,
           COUNT(CASE WHEN customer_name IS NULL THEN 1 END) AS nulos_customer_name,
           COUNT(CASE WHEN segment IS NULL THEN 1 END) AS nulos_segment,
           COUNT(CASE WHEN country IS NULL THEN 1 END) AS nulos_country,
           COUNT(CASE WHEN city IS NULL THEN 1 END) AS nulos_city,
           COUNT(CASE WHEN state IS NULL THEN 1 END) AS nulos_state,
           COUNT(CASE WHEN postal_code IS NULL THEN 1 END) AS nulos_postal_code,
           COUNT(CASE WHEN region IS NULL THEN 1 END) AS nulos_region,
           COUNT(CASE WHEN product_id IS NULL THEN 1 END) AS nulos_product_id,
           COUNT(CASE WHEN category IS NULL THEN 1 END) AS nulos_category,
           COUNT(CASE WHEN sub_category IS NULL THEN 1 END) AS nulos_sub_category,
           COUNT(CASE WHEN product_name IS NULL THEN 1 END) AS nulos_product_name,
           COUNT(CASE WHEN sales IS NULL THEN 1 END) AS nulos_sales,
           COUNT(CASE WHEN quantity IS NULL THEN 1 END) AS nulos_quantity,
           COUNT(CASE WHEN discount IS NULL THEN 1 END) AS nulos_discount,
           COUNT(CASE WHEN profit IS NULL THEN 1 END) AS nulos_profit
    FROM ventas
),
duplicados AS (
    SELECT row_id, COUNT(*) AS filas_por_id
    FROM ventas
    WHERE row_id IS NOT NULL
    GROUP BY row_id
    HAVING COUNT(*) > 1
),
conteo_duplicados AS (
    SELECT COUNT(*) AS ids_duplicados,
           COALESCE(SUM(filas_por_id - 1), 0) AS filas_duplicadas_adicionales
    FROM duplicados
),
fechas_origen AS (
    SELECT COUNT(CASE WHEN TRIM(order_date) <> '' THEN 1 END) AS pedidos_con_fecha_informada,
           COUNT(CASE WHEN TRIM(ship_date) <> '' THEN 1 END) AS envios_con_fecha_informada
    FROM ventas_csv
)
SELECT r.*, d.ids_duplicados, d.filas_duplicadas_adicionales,
       f.pedidos_con_fecha_informada - (r.filas - r.nulos_order_date) AS fechas_pedido_invalidas,
       f.envios_con_fecha_informada - (r.filas - r.nulos_ship_date) AS fechas_envio_invalidas
FROM resumen r
CROSS JOIN conteo_duplicados d
CROSS JOIN fechas_origen f;
