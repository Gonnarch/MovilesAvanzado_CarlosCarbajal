# Requerimientos — Cálculo de CTS

Autor: Carlos Carbajal. Curso: Móviles Avanzado. Semana 10.

## Objetivo y alcance

Desarrollar una aplicación SwiftUI y un archivo Excel editable para calcular
la Compensación por Tiempo de Servicios. El Excel corresponde al régimen general
privado; la aplicación conserva opciones adicionales con alcance explícito.
Al modificar los datos se actualizarán los resultados.
Talana se utiliza como referencia de organización de los campos.

La entrega de CTS comprende tres elementos: `Proyecto/CTSPeru.xcodeproj` con
sus fuentes en `Proyecto/CTSPeru`, `CTS_Automatica.xlsx` y este documento.
Abre el proyecto en Xcode 15 o posterior con un simulador iOS 17 o posterior.
Las referencias a celdas de la tabla corresponden al Excel; la aplicación usa
campos equivalentes en sus secciones.
Se supone que la jornada, el derecho al beneficio y la clasificación de los
conceptos remunerativos han sido verificados previamente.

## Requerimientos funcionales

| ID | Requerimiento | Criterio de aceptación |
| --- | --- | --- |
| RF01 | Seleccionar período de depósito. | Mayo del año elegido comprende noviembre del año anterior a abril; noviembre comprende mayo a octubre. |
| RF02 | Calcular tiempo desde el ingreso. | En modo Fechas, considera el ingreso dentro del semestre, incluye ambos extremos y convierte cada mes completo a 30 días equivalentes. |
| RF03 | Permitir tiempo validado manualmente. | En modo Manual admite meses enteros de 0 a 6 y días de 0 a 29, con total de 1 a 180 días equivalentes. Tres meses y diez días equivalen a 100. |
| RF04 | Descontar días no computables. | Resta las ausencias ingresadas del tiempo equivalente. Rechaza negativos, fracciones y ausencias superiores al período. |
| RF05 | Registrar sueldo, asignación familiar y fijos. | Suma los tres conceptos mensuales en la remuneración computable. Cero es válido cuando un concepto no corresponde; un dato requerido vacío solicita completarlo. |
| RF06 | Estimar gratificación automáticamente. | En modo Estimada calcula (sueldo + asignación familiar histórica + fijos históricos) × meses completos / 6. Sueldo 3000, sin adicionales y tres meses produce 1500. |
| RF07 | Usar la gratificación realmente percibida. | En modo Percibida utiliza B20 y no modifica ese importe al cambiar el sueldo. Se registra sin bonificación extraordinaria. |
| RF08 | Mantener independientes los períodos. | Los meses de gratificación se ingresan en B21; no se infieren de los meses/días CTS. Un error en el tiempo CTS no borra una gratificación válida. |
| RF09 | Separar asignación familiar actual e histórica. | B17 se usa en CTS y B22 en la gratificación estimada; no se calcula la asignación como porcentaje del sueldo. |
| RF10 | Evaluar un complemento variable mensual. | Registra un mismo concepto en seis casillas. Lo incluye si tiene importe positivo en tres meses o más; divide su suma entre los meses equivalentes del período liquidado. En un semestre completo, divide entre seis. |
| RF11 | Calcular y mostrar la CTS. | Base = sueldo + asignación familiar + fijos + promedio variable + gratificación / 6. CTS = base × días netos / 360, redondeada a dos decimales. Con sueldo 3000, gratificación 3000, seis meses y cero faltas, obtiene 1750. |
| RF12 | Mostrar el desglose numérico. | Presenta gratificación usada, su sexta parte, meses con variable, promedio variable, base computable y días antes/después de faltas. |
| RF13 | Validar fechas y datos. | Rechaza ingreso posterior al semestre y valores inválidos. Ingreso día 31 o febrero parcial exige tiempo manual validado; falta de mes mínimo en modo Fechas indica acumulación. |
| RF14 | Recalcular al editar. | Cambiar sueldo de 3000 a 4000, en modo Estimada con seis meses y sin adicionales, cambia la gratificación a 4000 y la CTS a 2333.33. |

| RF15 | Entregar un proyecto SwiftUI completo. | Incluye archivo .xcodeproj, esquema compartido, punto de entrada App, vista CTS y utilidades. Se abre sin añadir paquetes externos. |
| RF16 | Conservar las opciones adicionales de la aplicación. | Permite gratificación histórica validada, ausencias de gratificación, cese, principal variable, conceptos semestrales/anuales y selección de régimen. CAS, 276, construcción y otros requieren revisión y no muestran un importe inventado. |

## Requerimientos no funcionales

- Utilizar un archivo `.xlsx` de una hoja, sin macros, base de datos ni conexión a internet.
- Implementar la aplicación en SwiftUI para iOS 17+, con cálculos separados de la presentación y actualización al editar.
- Mantener el proyecto completo dentro de `Proyecto`, sin copias sueltas duplicadas.
- La compilación y ejecución de SwiftUI en Xcode siguen pendientes; la revisión estructural no se presenta como ejecución.
- Mantener etiquetas en español, celdas editables amarillas y fórmulas visibles.
- Almacenar importes y fechas como valores numéricos; mostrar moneda con dos decimales.
- Redondear la gratificación estimada y la CTS final al céntimo, conservando precisión intermedia en la base.
- Mostrar mensajes específicos cuando falten datos, sin sustituir una entrada inválida por cero.
- Mantener la documentación RF/RNF en Markdown, con la estructura del documento de Metro de Lima.
- Verificar cambios de sueldo, tiempo, asignación, fijos, variables y entradas inválidas. Se ejecutaron 34 escenarios del Excel con el motor de hojas disponible; no se afirma recálculo probado en Excel de escritorio.

## Fuera del alcance

No se entregan versiones anteriores del Excel, código suelto duplicado ni
anexos adicionales de CTS. El Excel no calcula regímenes especiales ni principal
variable por comisión/destajo; la aplicación dispone de funciones adicionales,
pero tampoco ofrece cobertura universal. Se excluyen múltiples complementos
mezclados sin clasificación, arrastres e intereses por mora. No se determina por
sí solo el derecho a asignación familiar ni se clasifican licencias o ausencias médicas.

La gratificación estimada del Excel supone sueldo constante y meses calendario
completos sin ausencias descontables. La aplicación permite registrar por separado
días no computables para su estimación o su cálculo histórico. Si hubo cambios de sueldo, variables o descuentos
en su semestre, se debe usar el importe realmente percibido. Un corte futuro
representa una proyección. No se afirma cobertura universal de casos laborales.

## Fuentes

- [Calculadora de Talana](https://web.talana.com/es-pe/calculo-de-cts): referencia de estructura de campos, no validación universal de las reglas.
- [TUO y Reglamento de CTS](https://diariooficial.elperuano.pe/Normas/obtenerDocumento?idNorma=37): DS 001-97-TR, artículo 21; DS 004-97-TR, artículo 6 para promedio en períodos incompletos.
- [Guía de asignación familiar del MTPE](https://cdn.www.gob.pe/uploads/document/file/2899623/guia_asignacion_familiar.pdf).
- [MTPE: gratificaciones y meses calendario completos](https://www.gob.pe/institucion/mtpe/noticias/567385-navidad-2021-gratificacion-se-debe-de-pagar-en-la-quincena-de-diciembre).

Consulta normativa con corte al 27/10/2026. Adecuación de la entrega: 28/10/2026.
