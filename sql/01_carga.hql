USE superstore_soliz_tanina;

-- csv_path debe existir en el sistema de archivos de HiveServer2.
LOAD DATA LOCAL INPATH '${hivevar:csv_path}' OVERWRITE INTO TABLE ventas_csv;

-- Normaliza M/d/yyyy a yyyy-MM-dd antes de convertir la fecha.
WITH fechas_iso AS (
    SELECT *,
           CASE WHEN TRIM(order_date) RLIKE '^[0-9]{1,2}/[0-9]{1,2}/[0-9]{4}$'
                THEN CONCAT(SPLIT(TRIM(order_date), '/')[2], '-',
                            LPAD(SPLIT(TRIM(order_date), '/')[0], 2, '0'), '-',
                            LPAD(SPLIT(TRIM(order_date), '/')[1], 2, '0'))
           END AS pedido_iso,
           CASE WHEN TRIM(ship_date) RLIKE '^[0-9]{1,2}/[0-9]{1,2}/[0-9]{4}$'
                THEN CONCAT(SPLIT(TRIM(ship_date), '/')[2], '-',
                            LPAD(SPLIT(TRIM(ship_date), '/')[0], 2, '0'), '-',
                            LPAD(SPLIT(TRIM(ship_date), '/')[1], 2, '0'))
           END AS envio_iso
    FROM ventas_csv
)
INSERT OVERWRITE TABLE ventas
SELECT
    CAST(TRIM(row_id) AS INT),
    CASE WHEN TRIM(order_id) <> '' THEN TRIM(order_id) END,
    CASE WHEN CAST(CAST(pedido_iso AS DATE) AS STRING) = pedido_iso THEN CAST(pedido_iso AS DATE) END,
    CASE WHEN CAST(CAST(envio_iso AS DATE) AS STRING) = envio_iso THEN CAST(envio_iso AS DATE) END,
    CASE WHEN TRIM(ship_mode) <> '' THEN TRIM(ship_mode) END,
    CASE WHEN TRIM(customer_id) <> '' THEN TRIM(customer_id) END,
    CASE WHEN TRIM(customer_name) <> '' THEN TRIM(customer_name) END,
    CASE WHEN TRIM(segment) <> '' THEN TRIM(segment) END,
    CASE WHEN TRIM(country) <> '' THEN TRIM(country) END,
    CASE WHEN TRIM(city) <> '' THEN TRIM(city) END,
    CASE WHEN TRIM(state) <> '' THEN TRIM(state) END,
    CASE WHEN TRIM(postal_code) <> '' THEN TRIM(postal_code) END,
    CASE WHEN TRIM(region) <> '' THEN TRIM(region) END,
    CASE WHEN TRIM(product_id) <> '' THEN TRIM(product_id) END,
    CASE WHEN TRIM(category) <> '' THEN TRIM(category) END,
    CASE WHEN TRIM(sub_category) <> '' THEN TRIM(sub_category) END,
    CASE WHEN TRIM(product_name) <> '' THEN TRIM(product_name) END,
    CAST(TRIM(sales) AS DECIMAL(18,4)),
    CAST(TRIM(quantity) AS INT),
    CAST(TRIM(discount) AS DECIMAL(9,4)),
    CAST(TRIM(profit) AS DECIMAL(18,4))
FROM fechas_iso;

DESCRIBE ventas;
SELECT 'CSV' AS origen, COUNT(*) AS filas FROM ventas_csv
UNION ALL
SELECT 'ORC' AS origen, COUNT(*) AS filas FROM ventas;
SELECT row_id, order_id, order_date, ship_date, sales, quantity, discount, profit
FROM ventas ORDER BY row_id LIMIT 10;
