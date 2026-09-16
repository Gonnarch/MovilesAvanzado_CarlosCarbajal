# Requerimientos — Actividad Propuesta 01

Autor: Carlos Carbajal. Curso: Móviles Avanzado. Semana 04.

## Objetivo y alcance

Desarrollar en Swift un Playground para registrar cursos libres de Tecsup y calcular el monto final que debe pagar un estudiante.

El usuario ingresa sus propios datos y registra los cursos que desea llevar. El programa calcula subtotal, IGV, descuentos y total final.

La imagen del laboratorio se usa solo como referencia visual. Los nombres, cursos, cantidades y precios no quedan fijos en el código.

## Requerimientos funcionales

| ID | Requerimiento | Criterio de aceptación |
| --- | --- | --- |
| RF01 | Registrar los datos del estudiante. | Solicita nombre y DNI. |
| RF02 | Identificar si pertenece a Tecsup. | Acepta la respuesta del usuario y la guarda como Sí o No. |
| RF03 | Registrar uno o varios cursos. | Permite indicar cuántos cursos diferentes se desean ingresar. |
| RF04 | Registrar los datos de cada curso. | Solicita nombre, cantidad y precio unitario. |
| RF05 | Calcular el subtotal de cada curso. | Multiplica cantidad por precio unitario. |
| RF06 | Calcular el subtotal general. | Suma los subtotales de todos los cursos registrados. |
| RF07 | Calcular el IGV. | Aplica 18 % al subtotal general. |
| RF08 | Calcular el total con IGV. | Suma subtotal más IGV. |
| RF09 | Aplicar descuento por cantidad. | Si el estudiante lleva 3 o más cursos en total, descuenta 10 % del total con IGV. |
| RF10 | Aplicar descuento especial Tecsup. | Si además es alumno Tecsup y lleva 3 o más cursos, descuenta S/ 400 adicionales. |
| RF11 | Evitar un total negativo. | Si el cálculo final es menor que cero, muestra S/ 0.00. |
| RF12 | Mostrar el resumen final. | Presenta estudiante, cursos, subtotal, IGV, descuentos y total final. |
| RF13 | Validar cantidades y montos. | Rechaza cantidades menores o iguales a cero y precios negativos. |

## Relación con el código

- `CursoLibre`: representa cada curso registrado por el usuario.
- `subtotal()`: calcula `cantidad × precioUnitario`.
- `Alumno`: almacena los datos del estudiante y sus cursos.
- `inscribir(curso:)`: agrega un curso al arreglo.
- `calcularPago()`: realiza todos los cálculos y muestra el resultado.
- `leerTexto(_:)`, `leerEntero(_:)` y `leerDouble(_:)`: reciben y validan los datos ingresados por el usuario.

## Requerimientos no funcionales

- Desarrollado en Swift con Foundation.
- Código y mensajes en español, con nombres descriptivos y lógica sencilla.
- Ejecutable como Playground de macOS; para interacción completa con `readLine()` puede ejecutarse desde Terminal.
- Los datos deben ser ingresados por el usuario y no estar escritos de forma fija.
- La salida en consola debe ser clara, ordenada y fácil de leer.
- Mantener la solución acorde con los temas trabajados hasta la Semana 4.

## Fuera del alcance

No incluye base de datos, interfaz gráfica, pagos reales, conexión a internet, autenticación de estudiantes ni verificación real de matrícula en Tecsup.

## Referencia del caso

La actividad corresponde al caso de cursos libres mostrado al final del Laboratorio 04. La imagen sirve como ejemplo de presentación; el programa debe funcionar con los datos que ingrese cada usuario.
