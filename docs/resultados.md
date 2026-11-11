# Resultados e interpretación

Para cada pregunta, enlaza la salida y sus capturas, escribe los valores observados y redacta tu interpretación y conclusión. Las estrategias son el punto de partida para explicar las consultas.

## 1. Diseño e implementación del modelo de datos

**Enunciado.** Construir el modelo de almacenamiento en Hive, documentar sus campos y demostrar la carga.

**Estrategia.** Lee el CSV con una tabla de texto y materializa una tabla ORC tipada. Compara ambos conteos y revisa la conversión de fechas y números. [Modelo](../sql/01_modelo.hql), [carga](../sql/01_carga.hql), [diccionario](diccionario.md).

**Evidencia, resultado, interpretación y conclusión.** Pendientes de ejecución. Registra conteo, formato observado y ejemplos de filas convertidas.

## 2. Auditoría de calidad e integridad de datos

**Enunciado.** Resumir duplicados, pedidos y clientes únicos, nulos y anomalías en fechas, ventas y descuentos.

**Estrategia.** Cuenta por separado los IDs duplicados y las filas adicionales asociadas. Distingue fechas sin dato de fechas informadas que no se pudieron convertir. Conserva la fuente para inspección. Para tratar incidencias, revisa primero si las filas con el mismo ID son copias exactas, identifica las fechas que requieren corrección y verifica si las ventas no positivas corresponden a ajustes. Separa los descuentos fuera del rango al interpretar los resultados. [Consulta](../sql/02_calidad.hql).

**Evidencia, resultado, interpretación y conclusión.** Pendientes de ejecución. Registra qué campos tuvieron nulos, qué reglas detectaron incidencias y qué tratamiento aplicarías a cada una.

## 3. Análisis de evolución comercial por región

**Enunciado.** Comparar ventas, ganancias, margen y variación anual por región, e identificar el mejor y peor desempeño.

**Estrategia.** Agrega por región y año y compara con el año calendario anterior mediante `LAG()`. El margen es ganancia dividida entre ventas. El mejor y peor desempeño se definen por ganancia acumulada en todo el período. Para la variación, divide el cambio por el valor absoluto de la base para conservar la dirección incluso cuando la base es negativa. Una base cero o ausente deja la variación sin valor. [Consulta](../sql/03_regiones.hql).

**Evidencia, resultado, interpretación y conclusión.** Pendientes de ejecución. Señala las regiones extremas y una variación anual relevante.

## 4. Segmentación avanzada de clientes mediante RFM

**Enunciado.** Medir recencia, frecuencia e importe por cliente, asignar puntajes e identificar perfiles.

**Estrategia.** Usa como referencia la última fecha del dataset. Divide cada métrica en cinco grupos con `NTILE(5)`, con 5 para las compras más recientes, frecuentes o de mayor importe. Desempata por ID de cliente, por lo que dos clientes con la misma métrica pueden quedar en quintiles vecinos. Alto valor requiere R, F y M de al menos 4. Riesgo requiere R de hasta 2 y F de al menos 3, para detectar clientes con historial de compras que llevan tiempo sin comprar. Recurrente requiere F de al menos 4 entre quienes todavía no se clasificaron. [Consulta](../sql/04_rfm.hql).

**Evidencia, resultado, interpretación y conclusión.** Pendientes de ejecución. Anota el tamaño de cada segmento y muestra ejemplos que permitan verificar las reglas.

## 5. Ranking de productos según rentabilidad

**Enunciado.** Identificar los cinco productos con mayor ganancia por categoría, mayor volumen y menor rentabilidad. Calcular margen y posición por categoría.

**Estrategia.** Agrupa por ID de producto y categoría. Define volumen como unidades vendidas y rentabilidad como ganancia dividida entre importe de ventas. `RANK()` y `DENSE_RANK()` exponen los empates, y `ROW_NUMBER()` con desempate por ID fija cinco filas por listado cuando hay suficientes datos. La ganancia acumulada se calcula dentro de cada categoría. [Consulta](../sql/05_productos.hql).

**Evidencia, resultado, interpretación y conclusión.** Pendientes de ejecución. Extrae las filas marcadas en las tres columnas `top_5` y comenta las diferencias entre unidades, margen y ganancia absoluta.

## 6. Análisis del impacto de los descuentos

**Enunciado.** Comparar ventas, ganancias y pérdidas por rango de descuento, categoría y subcategoría.

**Estrategia.** Aplica los cortes de 0%, 20% y 50%. Una pérdida tiene ganancia negativa. Una fila no rentable tiene ganancia menor o igual a cero y el denominador del porcentaje incluye las filas con ganancia informada. Compara la tasa y el número de registros para interpretar grupos con distinto tamaño. [Consulta](../sql/06_descuentos.hql).

**Evidencia, resultado, interpretación y conclusión.** Pendientes de ejecución. Compara el tramo alto con los demás y menciona las categorías y subcategorías más afectadas. Sustenta la asociación observada con los porcentajes de salida.

## 7. Análisis de tendencias temporales

**Enunciado.** Construir la serie mensual, comparar con el mes anterior y el mismo mes del año anterior, calcular un promedio móvil e identificar los meses extremos.

**Estrategia.** Agrega ventas y ganancias por mes. Comprueba que el registro anterior de `LAG()` corresponde al mes calendario anterior y cruza con el mismo mes del año previo. Calcula el promedio móvil cuando hay tres meses consecutivos. Define el volumen mensual como importe de ventas. [Consulta](../sql/07_tendencias.hql).

**Evidencia, resultado, interpretación y conclusión.** Pendientes de ejecución. Anota los tres meses de cada extremo y comenta cómo se comportan frente al año anterior y al promedio móvil.

## 8. Análisis Pareto de ventas y rentabilidad

**Enunciado.** Determinar cuántos productos alcanzan el 80% acumulado de ventas y cuántos alcanzan el 80% de ganancias.

**Estrategia.** Ordena por aporte en cada métrica y toma el primer punto que alcanza o supera el umbral sin redondear el cálculo. La ganancia es neta e incluye productos con pérdidas, que reducen el total y pueden hacer que el porcentaje acumulado supere 100% antes de descender. Si el total de una métrica es menor o igual a cero, su corte queda sin valor. [Consulta](../sql/08_pareto.hql).

**Evidencia, resultado, interpretación y conclusión.** Pendientes de ejecución. Registra los dos conteos y porcentajes de productos, identifica el producto de corte y explica si la contribución se concentra en productos distintos.

## Conclusiones generales

Pendientes de ejecución. Resume los principales hallazgos de calidad, ventas y rentabilidad, y explica qué decisiones podrían apoyar los resultados.

## Uso de herramientas externas

Completa la declaración según las indicaciones del docente. Si el uso de IA está permitido, indica qué partes recibieron asistencia y qué verificaste personalmente.
