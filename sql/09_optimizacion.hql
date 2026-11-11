USE superstore_soliz_tanina;

ANALYZE TABLE ventas COMPUTE STATISTICS;
ANALYZE TABLE ventas COMPUTE STATISTICS FOR COLUMNS;

EXPLAIN
SELECT region, SUM(sales) AS importe_ventas
FROM ventas
WHERE sales > 0
GROUP BY region;

EXPLAIN
SELECT region, SUM(CAST(TRIM(sales) AS DECIMAL(18,4))) AS importe_ventas
FROM ventas_csv
WHERE CAST(TRIM(sales) AS DECIMAL(18,4)) > 0
GROUP BY region;
