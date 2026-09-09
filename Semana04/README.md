# Semana 04 · Metro de Lima y Callao en Playground

Autor: Carlos Carbajal. Curso: Móviles Avanzado.

Sistema de consultas en **Swift Playground**, con diccionarios y arreglos.
Simula que todas las estaciones de las cuatro líneas del mapa están disponibles.
No representa el servicio real ni debe usarse para planificar viajes reales.

## Abrir en Xcode

1. Abre `Semana04/MetroLima.playground` con doble clic.
2. Ejecuta el Playground con el botón de reproducción. Abre la consola inferior
   para ver los mensajes impresos.
3. Verás ejemplos de líneas, estaciones, filtros y conexiones, sin solicitudes
   de entrada por teclado.

Puedes modificar las consultas de `ejecutarEjemplos()` al final del código:
cambiar `Grau` por `Bayóvar`, `Santa` por otro filtro o `lineas[2]` por `lineas[1]`.
No hace falta crear un proyecto, elegir un esquema ni abrir un simulador.

## Menú interactivo desde Terminal

Abre Terminal dentro de la carpeta `Semana04` y ejecuta:

```bash
swift MetroLima.playground/Contents.swift --menu
```

Escribe el número de una opción y pulsa Enter. Luego introduce la línea o estación.
Por ejemplo: opción `2` → `Línea 2`; opción `3` → `Grau`.
Para terminar, escribe `0` en el menú.

El argumento `--menu` habilita `readLine()` en Terminal. Sin ese argumento,
el archivo ejecuta ejemplos sin entrada interactiva, igual que en Xcode.

## Funciones y datos

- Listar líneas y sus estaciones en orden.
- Consultar estación, línea, posición, anterior y siguiente.
- Buscar por nombre parcial y resolver coincidencias múltiples.
- Consultar o listar transbordos de la simulación.
- Validar opciones, entradas vacías, tildes, mayúsculas y fin de entrada.

| Diccionario | Propósito |
| --- | --- |
| `lineas: [Int: [String]]` | Estaciones ordenadas de cada línea. |
| `estaciones: [String: Estacion]` | Datos por ID interno. |
| `conexiones: [String: [String]]` | Destinos de transbordo por ID. |

El catálogo contiene 109 registros estación-línea y siete pares de transbordo.
Una estación de intercambio tiene un registro por línea. Los nombres, conteos
y supuestos se explican en [datos.md](docs/datos.md).

## Archivos

| Archivo | Contenido |
| --- | --- |
| `MetroLima.playground/Contents.swift` | Datos, consultas, menú, ejemplos y pruebas. |
| `MetroLima.playground/contents.xcplayground` | Configuración del Playground macOS. |
| `docs/requerimientos.md` | Requerimientos funcionales y alcance. |
| `docs/datos.md` | Fuente y decisiones del catálogo. |
| `docs/pruebas.md` | Casos de prueba y estado de verificación. |

## Pruebas

Desde `Semana04`:

```bash
swift MetroLima.playground/Contents.swift --pruebas
```

Si todas pasan, imprime `OK`. También puedes escribir `ejecutarPruebas()` al
final del Playground y ejecutarlo en Xcode.

Se verificaron estáticamente el catálogo y la configuración XML. La compilación
y ejecución quedan pendientes en tu Mac: el entorno de elaboración no tiene
Swift ni Xcode. No se incluyen capturas simuladas de ejecución.

## Seis commits de Semana04

1. Crear Playground macOS y requerimientos.
2. Incorporar diccionarios de líneas y estaciones.
3. Implementar consultas de líneas y menú para Terminal.
4. Agregar búsqueda, filtros y detalles de estaciones.
5. Agregar transbordos bidireccionales.
6. Completar ejemplos, validaciones, pruebas e instrucciones.

## Fuente

[Mapa proporcionado](https://commons.wikimedia.org/wiki/File:Lima_Metro_Map.svg),
versión del 1 de junio de 2025, Antonio Escobar y colaboradores.
Se transcriben datos y no se redistribuye la imagen.
