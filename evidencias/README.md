# Capturas y commits

Toma cada captura justo después de una ejecución correcta en Hive. Procura que se vea el nombre del script o la consulta y sus columnas de resultado. Si hay muchas filas, conserva la salida completa y usa la captura para mostrar el resumen o las filas relevantes. Guarda las evidencias con nombres como `p01_carga.png`, `p04_rfm.csv` y `optimizacion_explain.txt`.

| Momento | Cuándo tomar las capturas | Qué incluir en el commit |
|---|---|---|
| 1. Modelo e ingesta | Después de verificar el encabezado y ejecutar el DDL y la carga. Muestra `DESCRIBE ventas`, los conteos CSV y ORC y filas de muestra. | README, diccionario revisado, modelo, carga y evidencia de la pregunta 1. Mensaje sugerido `Crea el modelo y carga Superstore en Hive`. |
| 2. Calidad | Después de ejecutar la pregunta 2. Guarda la fila resumen completa, especialmente si la terminal corta columnas. | Auditoría, evidencia e interpretación. Mensaje `Audita la calidad del dataset`. |
| 3. Consultas comerciales | Tras ejecutar cada pregunta de la 3 a la 6. Muestra los totales regionales, segmentos RFM, filas de los rankings y resumen de descuentos. | Scripts, salidas y respuestas de las preguntas 3 a 6. Mensaje `Analiza regiones, clientes, productos y descuentos`. |
| 4. Tendencias y Pareto | Después de ejecutar las preguntas 7 y 8. Muestra la serie mensual y los puntos de corte para ventas y ganancias. | Scripts, salidas y respuestas de las preguntas 7 y 8. Mensaje `Analiza tendencias mensuales y concentración de productos`. |
| 5. Optimización y cierre | Tras ejecutar los dos `EXPLAIN`. Guarda ambos planes. | Análisis de optimización, evidencia y conclusiones generales. Mensaje `Documenta los planes de ejecución y las conclusiones`. |

En el primer commit puedes agregar también `.gitignore` y esta guía. Para que `docs/resultados.md` muestre el avance de tu redacción, incorpóralo al completar la primera respuesta y actualízalo en los siguientes hitos.

En cada hito usa `git status --short`, agrega solo los archivos de ese hito con `git add` y comprueba la selección con `git diff --cached --stat` antes de confirmar. Haz `git push -u origin main` después del primer commit y `git push` después de cada hito posterior si estás trabajando en `main`. Confirma que GitHub muestra los commits y las evidencias antes de entregar el enlace.
