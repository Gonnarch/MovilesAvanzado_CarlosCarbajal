# Requerimientos — Metro de Lima y Callao

Autor: Carlos Carbajal. Curso: Móviles Avanzado. Semana 04.

## Objetivo y alcance

Desarrollar en Swift un Playground editable y ejecutable desde Xcode para
consultar las cuatro líneas representadas en el mapa proporcionado.
Se supone que todas sus estaciones están operativas. No representa el servicio
real ni confirma la aprobación de proyectos futuros.

En Xcode se ejecutan ejemplos escritos en el código. El menú interactivo se ejecuta
desde Terminal con `swift MetroLima.playground/Contents.swift --menu`.

## Requerimientos funcionales

| ID | Requerimiento | Criterio de aceptación |
| --- | --- | --- |
| RF01 | Mostrar un menú repetitivo. | Regresa al menú después de cada consulta. |
| RF02 | Listar líneas. | Muestra las líneas 1 a 4, extremos y cantidad de estaciones. |
| RF03 | Consultar una línea. | Acepta `2` o `Línea 2` y lista estaciones en orden. |
| RF04 | Consultar una estación. | Muestra nombre, línea, posición, anterior y siguiente. |
| RF05 | Filtrar por nombre parcial. | `Santa` devuelve las coincidencias identificadas por línea. |
| RF06 | Consultar transbordos. | Informa estación y línea de destino, o ausencia de conexión. |
| RF07 | Listar conexiones. | Muestra todos los pares de transbordo de la simulación. |
| RF08 | Normalizar entradas. | Ignora mayúsculas, tildes y espacios exteriores. |
| RF09 | Resolver coincidencias múltiples. | Permite escoger un resultado sin seleccionar arbitrariamente. |
| RF10 | Validar entradas. | Informa opciones inválidas, vacíos y consultas sin resultados. |
| RF11 | Salir. | Termina con opción 0 o fin de entrada sin bucles infinitos. |
| RF12 | Ejecutar ejemplos en Playground. | Muestra consultas sin depender de readLine al ejecutar en Xcode. |

## Requerimientos no funcionales

- Usar diccionarios y arreglos en memoria, sin base de datos ni internet.
- Interfaz y comentarios en español, funciones pequeñas y nombres descriptivos.
- Playground de plataforma macOS con Foundation y un archivo Contents.swift.
- Mantener todo dentro de Semana04 y realizar seis commits progresivos.

## Fuera del alcance

Cálculo de rutas óptimas, GPS, distancias, tiempos, tarifas, cuentas de usuario
y estaciones ajenas al mapa. No se inventarán distritos o datos no representados.

## Fuente

[Mapa de referencia](https://commons.wikimedia.org/wiki/File:Lima_Metro_Map.svg),
versión del 1 de junio de 2025, Antonio Escobar y colaboradores.
Los nombres y el orden se transcriben como datos; el mapa no se redistribuye.
Las correspondencias interpretadas para la simulación se documentarán por separado.
