# Actividad Propuesta 01 — Cursos libres de Tecsup

## 1. Descripción del caso

La institución Tecsup ofrece cursos libres y un estudiante puede inscribirse en uno o varios cursos.

El programa permite que el usuario ingrese sus propios datos, registre los cursos que desea llevar y obtenga automáticamente el monto final que debe pagar.

La imagen mostrada en el laboratorio sirve como referencia de cómo debe verse el resultado, pero los nombres, precios y cantidades no están fijos en el código.

---

## 2. Objetivo

Desarrollar un programa en Swift que permita registrar cursos libres y calcular el pago final de un estudiante aplicando IGV y los descuentos indicados en el enunciado.

---

## 3. Datos que ingresa el usuario

El programa solicita los siguientes datos:

### Datos del estudiante

- Nombre del estudiante.
- DNI.
- Si pertenece o no a Tecsup.

### Datos de los cursos

Por cada curso se solicita:

- Nombre del curso.
- Cantidad.
- Precio unitario.

El usuario también indica cuántos cursos diferentes desea registrar.

---

## 4. Reglas del negocio

El programa aplica las siguientes reglas:

1. El subtotal de cada curso se obtiene multiplicando:

   `cantidad × precio unitario`

2. El subtotal general es la suma de todos los cursos registrados.

3. El IGV corresponde al 18 % del subtotal.

4. El total con IGV se calcula de la siguiente manera:

   `subtotal + IGV`

5. Si el estudiante lleva 3 o más cursos en total, recibe un descuento del 10 % sobre el total con IGV.

6. Si además es alumno de Tecsup y lleva 3 o más cursos, recibe un descuento adicional de S/ 400.00.

7. El total final se obtiene restando ambos descuentos al total con IGV.

8. Si el resultado final fuera menor que cero, el programa muestra S/ 0.00.

---

## 5. Estructura del código

### `struct CursoLibre`

Representa cada curso registrado por el usuario.

Contiene:

- `nombre`: nombre del curso.
- `cantidad`: cantidad registrada.
- `precioUnitario`: precio de una unidad del curso.

También contiene el método:

- `subtotal()`: multiplica la cantidad por el precio unitario y devuelve el importe correspondiente al curso.

### `class Alumno`

Representa al estudiante que realiza la inscripción.

Contiene:

- `nombre`.
- `dni`.
- `esAlumnoTecsup`.
- `cursos`: arreglo donde se almacenan los cursos inscritos.

Métodos principales:

- `inscribir(curso:)`: agrega un curso al arreglo.
- `calcularPago()`: recorre los cursos, calcula subtotal, IGV, descuentos y total final.

### Funciones de entrada

- `leerTexto(_:)`: permite ingresar datos de texto.
- `leerEntero(_:)`: solicita un número entero mayor que cero y repite la pregunta si el dato es inválido.
- `leerDouble(_:)`: solicita un monto numérico válido y evita valores negativos.

---

## 6. Flujo del programa

El funcionamiento es el siguiente:

1. Se muestra el título del registro.
2. El usuario ingresa nombre y DNI.
3. Indica si es alumno de Tecsup.
4. Indica cuántos cursos diferentes desea registrar.
5. Por cada curso ingresa nombre, cantidad y precio.
6. Cada curso se guarda dentro del arreglo del alumno.
7. El programa recorre todos los cursos registrados.
8. Calcula subtotal, IGV y total con IGV.
9. Evalúa si corresponde aplicar los descuentos.
10. Muestra una factura final ordenada en consola.

---

## 7. Información mostrada al final

El programa muestra:

- Nombre del estudiante.
- DNI.
- Si pertenece o no a Tecsup.
- Cursos registrados.
- Cantidad de cada curso.
- Importe de cada curso.
- Subtotal general.
- IGV del 18 %.
- Total con IGV.
- Descuento del 10 % por cantidad, cuando corresponde.
- Descuento adicional de S/ 400.00 para alumnos Tecsup, cuando corresponde.
- Total final a pagar.

---

## 8. Ejemplo de uso

Un usuario puede registrar, por ejemplo:

- Curso 1: Swift Avanzado.
- Curso 2: Desarrollo iOS.
- Curso 3: Base de Datos.

Los precios y cantidades pueden ser diferentes en cada ejecución. El programa no depende de los valores mostrados en la imagen del laboratorio.

---

## 9. Requerimientos funcionales

- RF01: Permitir ingresar los datos del estudiante.
- RF02: Permitir indicar si el estudiante pertenece a Tecsup.
- RF03: Permitir registrar uno o varios cursos.
- RF04: Permitir ingresar nombre, cantidad y precio de cada curso.
- RF05: Calcular el subtotal de cada curso.
- RF06: Calcular el subtotal general.
- RF07: Calcular el IGV del 18 %.
- RF08: Aplicar el descuento del 10 % cuando se registren 3 o más cursos en total.
- RF09: Aplicar el descuento adicional de S/ 400.00 cuando el estudiante sea de Tecsup y lleve 3 o más cursos.
- RF10: Mostrar el total final a pagar.
- RF11: Validar cantidades y montos ingresados.

---

## 10. Requerimientos no funcionales

- RNF01: El programa debe desarrollarse en Swift.
- RNF02: El código debe ser sencillo y entendible para un estudiante de Semana 4.
- RNF03: La salida en consola debe mostrarse de forma ordenada.
- RNF04: Los datos deben ser ingresados por el usuario y no quedar escritos de forma fija en el programa.
- RNF05: El programa debe evitar cantidades inválidas y montos negativos.

---

## 11. Cómo probar la actividad

La actividad utiliza `readLine()` para recibir información del usuario.

Al ejecutarla, solo se debe seguir lo que aparece en consola e ingresar los datos solicitados.

Si el Playground de Xcode no permite una interacción cómoda con `readLine()`, se puede ejecutar el archivo `Contents.swift` desde Terminal con Swift para probar todo el flujo interactivo.
