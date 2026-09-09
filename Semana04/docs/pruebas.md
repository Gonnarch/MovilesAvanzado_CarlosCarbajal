# Plan de pruebas y evidencias

## Comprobaciones estáticas realizadas

- Conteos: 27, 27, 28 y 27 registros por línea; 109 en total.
- Sin nombres duplicados dentro de una misma línea.
- Los 14 extremos de los siete pares de transbordo existen y enlazan líneas distintas.
- El XML del Playground es válido y configura la plataforma macOS.
- Las semanas anteriores se conservan; los cambios se limitan a Semana04.

Estas revisiones no sustituyen la compilación del código Swift.

## Pruebas de ejecución pendientes en Mac

Ejecutar `swift MetroLima.playground/Contents.swift --pruebas` desde Semana04.
Verifica el catálogo, normalización,
búsqueda parcial, consultas inexistentes y simetría de los transbordos.
Además, abrir el Playground en Xcode y comprobar que muestra ejemplos sin pedir
entrada. En Terminal, ejecutar `swift MetroLima.playground/Contents.swift --menu`
para probar manualmente:

| Caso | Entrada | Resultado esperado |
| --- | --- | --- |
| P01 | Opción 1 | Cuatro líneas y sus conteos. |
| P02 | Opción 2 → Línea 2 | 27 estaciones en orden. |
| P03 | Opción 2 → 5 | Mensaje de línea inválida. |
| P04 | Opción 3 → GRAU | Miguel Grau, anterior 28 de Julio y siguiente El Ángel. |
| P05 | Opción 3 → Villa El Salvador | Sin anterior; siguiente Parque Industrial. |
| P06 | Opción 3 → bayovar | Anterior Santa Rosa; sin siguiente. |
| P07 | Opción 4 → Santa | Cinco registros coincidentes identificados por línea. |
| P08 | Opción 3 → Mercado Santa Anita | Dos resultados; escoger explícitamente uno. |
| P09 | Opción 6 → 28 de Julio → 1 | Transbordo a línea 2. |
| P10 | Opción 6 → Grau | Sin transbordos registrados. |
| P11 | Opción 6 → Rivera Navarrete | Conexión a Conde de San Isidro de línea 4. |
| P12 | Opción 5 | Siete pares, sin duplicar su sentido inverso. |
| P13 | Opción 3 → zzzz | Sin resultados. |
| P14 | Opción 3 o 4 → espacios | Solicitud de nombre no vacío. |
| P15 | Selección de resultado → 999 o texto | Mensaje de selección inválida, vuelve al menú. |
| P16 | Selección de resultado → 0 | Cancela la selección. |
| P17 | Menú → 99 o entrada vacía | Opción inválida, continúa el programa. |
| P18 | Menú → 0 | Termina correctamente. |
| P19 | Fin de entrada, también durante consulta | Termina sin repetición infinita. |

## Evidencias por capturar

Después de ejecutar realmente, guardar capturas en `docs/` del Playground en Xcode
y del menú, consulta de transbordo y resultado de `--pruebas` en Terminal.
No hay capturas de ejecución aún. No se han inventado resultados de compilación.
