# Análisis de optimización en Hive

La tabla analítica usa ORC y deja las conversiones de tipos en la carga. El [script de optimización](../sql/09_optimizacion.hql) recoge estadísticas y genera dos planes para una agregación por región con un filtro equivalente sobre ventas positivas. El plan del CSV aplica la conversión al leer los datos.

1. Ejecuta el script después de cargar las tablas. Guarda los dos planes completos.
2. Revisa el lector de cada tabla, la proyección de columnas, el filtro, las etapas de agregación y las estimaciones de filas si están disponibles.
3. Si comparas tiempos, ejecuta ambas consultas sin `EXPLAIN` bajo las mismas condiciones y comprueba que los importes coinciden. Registra repeticiones y tiempos observados.
4. Describe qué diferencias muestra el plan en tu instalación y qué optimización tendría sentido con más datos. El volumen de este CSV puede limitar el impacto medible.

**Evidencias, diferencias observadas y conclusión.** Pendientes de ejecución.
