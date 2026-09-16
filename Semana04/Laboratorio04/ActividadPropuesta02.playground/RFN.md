# RFN — Actividad Propuesta 02: Cliente Natural y Cliente Jurídico

## Alcance

Esta actividad corresponde al segundo caso propuesto mostrado al final del Laboratorio 04. La imagen del PDF muestra la estructura de herencia `Cliente -> ClienteNatural / ClienteJuridico` y un ejemplo de salida. Los datos mostrados son solo referenciales; el usuario debe poder ingresar sus propios datos.

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
13. Los nombres, códigos, direcciones, cuentas y montos que aparecen en la imagen del laboratorio son ejemplos visuales y no deben quedar escritos de forma fija en el programa.

## Requerimientos no funcionales

1. La solución debe desarrollarse en Swift.
2. Debe aplicarse Programación Orientada a Objetos mediante clases, herencia y sobrescritura de métodos.
3. Debe ejecutarse como Playground de Xcode o desde Terminal si se utiliza entrada interactiva con `readLine()`.
4. El código debe mantenerse simple y entendible para un estudiante de Semana 4.
5. La salida en consola debe seguir una presentación parecida a la referencia visual del PDF, pero mostrando los datos reales ingresados por el usuario.

## Nota sobre la interacción

La imagen del caso propuesto 02 sirve como modelo de la jerarquía de clases y como ejemplo de presentación. No obliga a utilizar los mismos clientes de la imagen. El usuario debe elegir el tipo de cliente e ingresar sus propios datos para que el programa cree y muestre el objeto correspondiente.
