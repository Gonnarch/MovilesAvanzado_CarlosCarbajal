# RFN — Actividades propuestas del Laboratorio 04

## Alcance

Este archivo describe los requerimientos de las dos actividades propuestas que aparecen al final del Laboratorio 04.

Las imágenes del PDF se toman como referencia de la estructura de las soluciones y de cómo debe verse la información en consola. Los valores mostrados en esas imágenes no deben quedar fijos en el código: el usuario debe poder ingresar sus propios datos.

---

# Actividad Propuesta 01 — Cursos libres de Tecsup

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

---

# Actividad Propuesta 02 — Cliente Natural y Cliente Jurídico

## Requerimientos funcionales

1. El sistema debe utilizar una clase base llamada `Cliente`.
2. La clase `Cliente` debe contener:
   - Código.
   - Dirección.
   - Fecha de registro.
   - Número de cuenta.
   - Monto mínimo de apertura.
3. La clase `Cliente` debe tener el método `mostrarDatos()`.
4. Debe existir una clase `ClienteNatural` que herede de `Cliente`.
5. `ClienteNatural` debe incluir:
   - Nombre completo.
   - DNI.
6. `ClienteNatural` debe sobrescribir `mostrarDatos()` para mostrar sus datos propios y los heredados.
7. Debe existir una clase `ClienteJuridico` que herede de `Cliente`.
8. `ClienteJuridico` debe incluir:
   - Razón social.
   - RUC.
   - Representante legal.
9. `ClienteJuridico` debe sobrescribir `mostrarDatos()` para mostrar sus datos propios y los heredados.
10. El sistema debe permitir al usuario elegir si desea registrar un cliente natural o un cliente jurídico.
11. El usuario debe ingresar todos los datos del cliente seleccionado.
12. El sistema debe mostrar al final la información completa del cliente creado.
13. Los nombres, códigos, direcciones, cuentas y montos que aparecen en la imagen del laboratorio son ejemplos visuales; no deben quedar escritos de forma fija en el programa.

## Requerimientos no funcionales

1. La solución debe desarrollarse en Swift.
2. Debe aplicarse Programación Orientada a Objetos mediante clases, herencia y sobrescritura de métodos.
3. Debe ejecutarse como Playground de Xcode o desde Terminal si se utiliza entrada interactiva con `readLine()`.
4. El código debe mantenerse simple y entendible para un estudiante de Semana 4.
5. La salida en consola debe seguir una presentación parecida a la referencia visual del PDF, pero mostrando los datos reales ingresados por el usuario.

---

# Nota sobre la interacción en Playground

Las dos actividades usan `readLine()` para que el usuario pueda ingresar sus propios datos. En un Playground normal de Xcode la entrada interactiva puede no comportarse igual que en Terminal. Si se desea probar toda la interacción, se puede ejecutar el archivo `Contents.swift` desde Terminal con Swift.

La imagen final del laboratorio sirve como ejemplo de cómo deberían organizarse los resultados, no como obligación de utilizar exactamente los mismos valores mostrados.
