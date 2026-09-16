# Actividad Propuesta 02 — Cliente Natural y Cliente Jurídico

## 1. Descripción del caso

Esta actividad trabaja el concepto de herencia en Programación Orientada a Objetos.

Existe una clase general llamada `Cliente` y, a partir de ella, se crean dos tipos de clientes:

- `ClienteNatural`.
- `ClienteJuridico`.

El programa permite que el usuario elija qué tipo de cliente desea registrar e ingrese sus propios datos.

La imagen del laboratorio muestra la estructura de clases y un ejemplo de salida. Es una referencia visual, no significa que esos nombres, códigos o montos deban quedar escritos de forma fija en el programa.

---

## 2. Objetivo

Desarrollar un programa en Swift que permita registrar clientes naturales o jurídicos utilizando clases, herencia y sobrescritura de métodos.

---

## 3. Estructura de herencia

La relación utilizada es:

`Cliente`

↳ `ClienteNatural`

↳ `ClienteJuridico`

Esto significa que las dos clases hijas reutilizan los datos y métodos definidos en la clase base `Cliente`.

---

## 4. Datos comunes de cualquier cliente

La clase base `Cliente` almacena los datos que comparten ambos tipos de cliente:

- Código.
- Dirección.
- Fecha de registro.
- Número de cuenta.
- Monto mínimo de apertura.

También contiene el método:

- `mostrarDatos()`: imprime los datos generales del cliente.

---

## 5. Cliente Natural

La clase `ClienteNatural` hereda de `Cliente`.

Además de los datos generales, contiene:

- Nombre completo.
- DNI.

Esta clase sobrescribe el método `mostrarDatos()` utilizando `override`.

Cuando se ejecuta ese método:

1. Muestra el nombre completo.
2. Muestra el DNI.
3. Utiliza `super.mostrarDatos()` para mostrar también los datos heredados de la clase `Cliente`.

---

## 6. Cliente Jurídico

La clase `ClienteJuridico` también hereda de `Cliente`.

Además de los datos generales, contiene:

- Razón social.
- RUC.
- Representante legal.

Esta clase también sobrescribe `mostrarDatos()`.

Cuando se ejecuta ese método:

1. Muestra la razón social.
2. Muestra el RUC.
3. Muestra el representante legal.
4. Utiliza `super.mostrarDatos()` para mostrar los datos comunes heredados de `Cliente`.

---

## 7. Datos que ingresa el usuario

Al comenzar, el programa muestra dos opciones:

1. Cliente Natural.
2. Cliente Jurídico.

Después solicita los datos comunes:

- Código.
- Dirección.
- Fecha de registro.
- Número de cuenta.
- Monto mínimo de apertura.

Si el usuario elige Cliente Natural, también debe ingresar:

- Nombre completo.
- DNI.

Si elige Cliente Jurídico, debe ingresar:

- Razón social.
- RUC.
- Representante legal.

---

## 8. Funciones de entrada

El programa utiliza funciones auxiliares para recibir los datos del usuario.

### `leerTexto(_:)`

Muestra un mensaje y recibe un texto mediante `readLine()`.

### `leerDouble(_:)`

Solicita un valor numérico para el monto mínimo de apertura.

Si el usuario ingresa un dato inválido o un número negativo, vuelve a solicitarlo.

---

## 9. Flujo del programa

El funcionamiento es el siguiente:

1. Se muestra el menú de tipos de cliente.
2. El usuario selecciona la opción 1 o 2.
3. Si escribe una opción inválida, el programa vuelve a solicitarla.
4. Se ingresan los datos generales del cliente.
5. Dependiendo de la opción seleccionada, se solicitan los datos específicos.
6. Se crea un objeto `ClienteNatural` o `ClienteJuridico`.
7. Se ejecuta `mostrarDatos()`.
8. El programa muestra toda la información del cliente registrado.

---

## 10. Conceptos de POO utilizados

### Clase base

`Cliente` contiene los atributos y comportamientos comunes.

### Herencia

`ClienteNatural` y `ClienteJuridico` reutilizan lo definido en `Cliente`.

### `super.init(...)`

Los constructores de las clases hijas llaman al constructor de la clase padre para inicializar los datos generales.

### Sobrescritura con `override`

Cada tipo de cliente modifica el comportamiento de `mostrarDatos()` para incluir sus datos específicos.

### `super.mostrarDatos()`

Permite ejecutar el método de la clase padre y evitar repetir el código que muestra los datos generales.

---

## 11. Resultado esperado

El resultado depende de los datos ingresados por el usuario.

Por ejemplo, si se registra un Cliente Natural, la consola mostrará primero sus datos personales y luego sus datos generales.

Si se registra un Cliente Jurídico, mostrará la información de la empresa y después los datos generales del cliente.

Los valores mostrados en la imagen del laboratorio son únicamente un ejemplo de presentación.

---

## 12. Requerimientos funcionales

- RF01: Permitir seleccionar entre Cliente Natural y Cliente Jurídico.
- RF02: Solicitar los datos generales del cliente.
- RF03: Solicitar nombre completo y DNI cuando se registre un Cliente Natural.
- RF04: Solicitar razón social, RUC y representante legal cuando se registre un Cliente Jurídico.
- RF05: Crear el objeto correspondiente al tipo seleccionado.
- RF06: Mostrar los datos específicos del tipo de cliente.
- RF07: Mostrar también los datos heredados de la clase `Cliente`.
- RF08: Validar que la opción elegida sea 1 o 2.
- RF09: Validar que el monto mínimo de apertura sea un valor numérico válido y no negativo.

---

## 13. Requerimientos no funcionales

- RNF01: La solución debe desarrollarse en Swift.
- RNF02: Debe utilizar Programación Orientada a Objetos.
- RNF03: Debe aplicar clases, herencia y sobrescritura de métodos.
- RNF04: El código debe ser sencillo y entendible para un estudiante de Semana 4.
- RNF05: La salida en consola debe ser clara y ordenada.
- RNF06: Los datos de los clientes deben ser ingresados por el usuario y no quedar fijos en el código.

---

## 14. Cómo probar la actividad

La actividad utiliza `readLine()` para recibir los datos.

Al ejecutarla:

1. Selecciona `1` para Cliente Natural o `2` para Cliente Jurídico.
2. Ingresa los datos solicitados.
3. Revisa la información mostrada al final.

Si el Playground de Xcode no permite una interacción cómoda con `readLine()`, se puede ejecutar `Contents.swift` desde Terminal con Swift para probar todo el flujo interactivo.
