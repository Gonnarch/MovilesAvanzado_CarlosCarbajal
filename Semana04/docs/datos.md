# Datos y decisiones de la simulación

Fuente: [Lima Metro Map.svg](https://commons.wikimedia.org/wiki/File:Lima_Metro_Map.svg),
versión del 1 de junio de 2025. Se revisó visualmente el SVG, no solo su descripción.
Se mantienen los nombres proyectados del mapa; no se mezclan versiones posteriores.

| Línea | Inicio del arreglo | Final del arreglo | Registros |
| --- | --- | --- | --- |
| 1 | Villa El Salvador | Bayóvar | 27 |
| 2 | Puerto del Callao | Municipalidad de Ate | 27 |
| 3 | El Álamo | Pedro Miotta | 28 |
| 4 | Gambetta | Mercado Santa Anita | 27 |

Hay 109 registros estación-línea, no 109 ubicaciones físicas distintas.
Una estación de intercambio tiene un registro por cada línea.

## Diferencias respecto del servicio real

- La línea 1 incluye **28 de Julio**, representada como futura estación en el mapa.
  Por eso el catálogo académico tiene 27 registros, no las 26 estaciones del servicio original.
- La línea 2 incluye sus 27 estaciones y la línea 4 ambos tramos representados.
- La línea 4 de este mapa tiene 27 puntos; no se fuerza el total de otras propuestas.
- Se mantienen nombres como Los Cabitos y Alejandro Velazco tal como aparecen en el plano.
- La Cultura se usa como nombre del punto de intercambio de la línea 4 que aparece
  junto a la estación homónima de la línea 1.
- No se agregan líneas 5 a 9, distritos, tarifas, horarios ni distancias.

Los IDs L1-1, L2-1, etc. son identificadores internos, no códigos oficiales.
Anterior y siguiente siempre se refieren al orden del arreglo indicado arriba.

## Transbordos académicos

El mapa es esquemático y no contiene una leyenda específica de pasajes peatonales.
Para la aplicación se adoptan explícitamente estos siete pares en sus puntos de
encuentro. Son supuestos de la simulación, no verificación de infraestructura real.

| Origen | Destino |
| --- | --- |
| L1 — 28 de Julio | L2 — 28 de Julio |
| L1 — Los Cabitos | L3 — Los Cabitos |
| L1 — La Cultura | L4 — La Cultura |
| L2 — Carmen de la Legua | L4 — Carmen de la Legua |
| L2 — Estación Central | L3 — Estación Central |
| L2 — Mercado Santa Anita | L4 — Mercado Santa Anita |
| L3 — Rivera Navarrete | L4 — Conde de San Isidro |

Las conexiones son bidireccionales. Se mantienen separados los nombres distintos
del intercambio Rivera Navarrete / Conde de San Isidro. No se asigna un transbordo
a Miguel Grau ni al cruce próximo a Atocongo, donde los puntos no coinciden.
