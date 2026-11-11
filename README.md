# Análisis de ventas de Sample Superstore en Apache Hive

Proyecto individual para modelar, cargar y auditar el CSV de Superstore y analizar ventas, ganancias, clientes, productos, descuentos y tendencias.

## Requisitos

- Una instancia funcional de Apache Hive con acceso mediante Beeline o el cliente usado en clase. Los ejemplos usan HiveServer2 y un entorno Linux para ejecutar Beeline.
- El archivo CSV de [Superstore Dataset en Kaggle](https://www.kaggle.com/datasets/vivek468/superstore-dataset-final). Descárgalo y descomprímelo. Si guardas una copia en el repositorio local, usa la carpeta `data/`, excluida de Git.
- Permisos de creación de tablas y lectura del CSV en el servidor.

## Ejecución

1. Revisa el CSV antes de cargarlo. Anota el encabezado, separador, codificación y formato de fechas en el [diccionario](docs/diccionario.md). Los scripts esperan las 21 columnas en el orden indicado y fechas mes/día/año. Si el archivo usa otra codificación, prepara una copia UTF-8 y conserva el original.
2. Pon el CSV en una ruta legible por **HiveServer2**. Si HiveServer2 corre en Docker, copia o monta el archivo dentro de ese contenedor. La ruta que pasas a `csv_path` es la ruta del servidor o contenedor.
3. Ejecuta desde una copia del repositorio accesible al cliente Beeline. Ajusta la URL JDBC, el usuario y la ruta del CSV a tu entorno. Si el servidor pide autenticación adicional, usa el mecanismo de tu instalación.

```bash
beeline -u 'jdbc:hive2://localhost:10000/default' -n hive -f sql/01_modelo.hql
beeline -u 'jdbc:hive2://localhost:10000/default' -n hive --hivevar csv_path=/tmp/SampleSuperstore.csv -f sql/01_carga.hql
beeline -u 'jdbc:hive2://localhost:10000/default' -n hive -f sql/02_calidad.hql
```

4. Comprueba que las tablas CSV y ORC tienen el mismo conteo y revisa las filas de muestra. La carga usa `OVERWRITE` en las dos tablas del proyecto para reemplazar una carga anterior.
5. Ejecuta los scripts restantes, uno por uno, con el mismo comando de Beeline y su ruta correspondiente. Para guardar una salida amplia de análisis, añade `--outputformat=csv2 --showHeader=true` y redirige la salida estándar a un archivo bajo `evidencias/`. Comprueba que Beeline terminó sin errores antes de usar la salida como evidencia.

| Pregunta | Script |
|---|---|
| 1. Modelo y carga | [DDL](sql/01_modelo.hql) y [DML](sql/01_carga.hql) |
| 2. Calidad | [Auditoría](sql/02_calidad.hql) |
| 3. Regiones | [Evolución comercial](sql/03_regiones.hql) |
| 4. Clientes | [RFM](sql/04_rfm.hql) |
| 5. Productos | [Ranking](sql/05_productos.hql) |
| 6. Descuentos | [Rangos y rentabilidad](sql/06_descuentos.hql) |
| 7. Tendencias | [Serie mensual](sql/07_tendencias.hql) |
| 8. Pareto | [Ventas y ganancia neta](sql/08_pareto.hql) |

Documenta los resultados en [respuestas](docs/resultados.md) y registra la comparación de planes en [optimización](docs/optimizacion.md). La [guía de evidencias](evidencias/README.md) indica cuándo capturar la ejecución y cómo repartir los commits.

El enunciado entregado enumera ocho preguntas y menciona doce en la sección de GitHub. Confirma el alcance con el docente.

## Referencias

- [CSV SerDe de Apache Hive](https://hive.apache.org/docs/latest/user/csv-serde/)
- [Carga de datos en Apache Hive](https://hive.apache.org/docs/latest/language/languagemanual-dml/)
- [Funciones de ventana en Apache Hive](https://hive.apache.org/docs/latest/language/languagemanual-windowingandanalytics/)
