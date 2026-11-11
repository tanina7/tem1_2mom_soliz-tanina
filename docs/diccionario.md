# Diccionario de datos

Cada registro representa una línea de pedido. Un mismo pedido puede tener varias líneas. La tabla `ventas_csv` conserva los campos de origen como texto y la tabla `ventas` contiene los tipos analíticos. Las restricciones de la tabla son criterios de auditoría.

| Columna CSV | Campo Hive | Tipo en ventas | Descripción | Restricción o formato esperado |
|---|---|---|---|---|
| Row ID | `row_id` | `INT` | Identificador de fila | Único y no nulo según la clave esperada |
| Order ID | `order_id` | `STRING` | Identificador de pedido | Puede repetirse entre líneas |
| Order Date | `order_date` | `DATE` | Fecha del pedido | Fecha válida |
| Ship Date | `ship_date` | `DATE` | Fecha de envío | Igual o posterior a la fecha de pedido |
| Ship Mode | `ship_mode` | `STRING` | Modalidad de envío | — |
| Customer ID | `customer_id` | `STRING` | Identificador del cliente | Puede repetirse entre pedidos |
| Customer Name | `customer_name` | `STRING` | Nombre del cliente | — |
| Segment | `segment` | `STRING` | Segmento comercial de origen | — |
| Country | `country` | `STRING` | País | — |
| City | `city` | `STRING` | Ciudad | — |
| State | `state` | `STRING` | Estado | — |
| Postal Code | `postal_code` | `STRING` | Código postal | Texto para conservar ceros iniciales |
| Region | `region` | `STRING` | Región comercial | — |
| Product ID | `product_id` | `STRING` | Identificador de producto | Puede repetirse entre líneas |
| Category | `category` | `STRING` | Categoría de producto | — |
| Sub-Category | `sub_category` | `STRING` | Subcategoría de producto | — |
| Product Name | `product_name` | `STRING` | Nombre del producto | — |
| Sales | `sales` | `DECIMAL(18,4)` | Importe de ventas de la línea | Mayor que cero según el criterio de auditoría |
| Quantity | `quantity` | `INT` | Unidades vendidas | — |
| Discount | `discount` | `DECIMAL(9,4)` | Descuento expresado como fracción | Entre 0 y 1 inclusive |
| Profit | `profit` | `DECIMAL(18,4)` | Ganancia de la línea | Un valor negativo indica pérdida |

## Verificación del archivo descargado

Registra el nombre original, la codificación, el separador, el encabezado, el formato de las fechas y cualquier inconsistencia que observes antes de cargar el archivo. El script espera las columnas en el orden de esta tabla y fechas de origen en formato mes/día/año.
