# RFN — Actividad Propuesta 01: Cursos libres de Tecsup

## Alcance

Esta actividad corresponde al primer caso propuesto mostrado al final del Laboratorio 04. La imagen del PDF se toma como referencia de cómo debe organizarse la información en consola, pero los datos de la imagen no deben quedar fijos en el código. El usuario debe poder ingresar sus propios datos.

## Requerimientos funcionales

1. El sistema debe permitir ingresar el nombre y DNI del estudiante.
2. El sistema debe preguntar si el estudiante pertenece a Tecsup.
3. El usuario debe poder registrar uno o más cursos libres.
4. Para cada curso se debe ingresar:
   - Nombre del curso.
   - Cantidad.
   - Precio unitario.
5. El sistema debe calcular el subtotal de cada curso multiplicando cantidad por precio unitario.
6. El sistema debe calcular el subtotal general de todos los cursos.
7. El sistema debe calcular el IGV del 18%.
8. El sistema debe calcular el total con IGV.
9. Si el estudiante compra 3 o más cursos, debe recibir un descuento del 10% sobre el total con IGV.
10. Si además es alumno de Tecsup y compra 3 o más cursos, debe recibir un descuento adicional de S/ 400.
11. El sistema debe mostrar en consola:
    - Datos del estudiante.
    - Cursos registrados.
    - Subtotal.
    - IGV.
    - Total con IGV.
    - Descuento por cantidad.
    - Descuento especial por ser alumno de Tecsup.
    - Total final a pagar.
12. Si el total final resultara negativo, debe mostrarse como S/ 0.00.
13. Los datos usados en la imagen del laboratorio son solo un ejemplo; el programa debe funcionar con cualquier dato válido ingresado por el usuario.

## Requerimientos no funcionales

1. La solución debe desarrollarse en Swift.
2. Debe ejecutarse como Playground de Xcode o desde Terminal si se necesita utilizar `readLine()`.
3. Debe utilizar estructuras y clases sencillas, acordes con los temas vistos hasta la Semana 4.
4. La salida debe ser clara, ordenada y fácil de leer.
5. Se deben validar cantidades y precios para evitar valores inválidos.

## Nota sobre la interacción

La imagen del caso propuesto 01 es una referencia visual del resultado. No significa que el programa deba usar exactamente los mismos nombres, cursos o precios. El objetivo es que el usuario ingrese sus propios datos y que el sistema calcule el resultado aplicando las reglas del enunciado.
