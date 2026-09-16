# Requerimientos — Actividad Propuesta 02

Autor: Carlos Carbajal. Curso: Móviles Avanzado. Semana 04.

## Objetivo y alcance

Desarrollar en Swift un Playground para registrar clientes naturales o jurídicos aplicando Programación Orientada a Objetos.

El programa utiliza una clase base `Cliente` y dos clases hijas: `ClienteNatural` y `ClienteJuridico`. El usuario elige el tipo de cliente, ingresa sus propios datos y el sistema muestra la información completa del objeto creado.

La imagen del laboratorio se usa como referencia de la estructura de herencia y de la presentación. Los nombres, códigos, direcciones, cuentas y montos no quedan fijos en el código.

## Requerimientos funcionales

| ID | Requerimiento | Criterio de aceptación |
| --- | --- | --- |
| RF01 | Seleccionar el tipo de cliente. | Permite elegir entre Cliente Natural y Cliente Jurídico. |
| RF02 | Validar la opción seleccionada. | Solo acepta las opciones 1 o 2 y vuelve a solicitar el dato si es inválido. |
| RF03 | Registrar los datos comunes del cliente. | Solicita código, dirección, fecha de registro, número de cuenta y monto mínimo de apertura. |
| RF04 | Registrar un Cliente Natural. | Solicita nombre completo y DNI cuando se selecciona la opción 1. |
| RF05 | Registrar un Cliente Jurídico. | Solicita razón social, RUC y representante legal cuando se selecciona la opción 2. |
| RF06 | Crear el objeto correspondiente. | Instancia `ClienteNatural` o `ClienteJuridico` según la opción elegida. |
| RF07 | Aplicar herencia. | Las clases hijas reutilizan los atributos y métodos definidos en `Cliente`. |
| RF08 | Inicializar los datos heredados. | Los constructores de las clases hijas llaman a `super.init(...)`. |
| RF09 | Sobrescribir la presentación de datos. | Cada clase hija usa `override func mostrarDatos()` para mostrar sus datos específicos. |
| RF10 | Mostrar también los datos comunes. | Las clases hijas llaman a `super.mostrarDatos()`. |
| RF11 | Validar el monto de apertura. | Rechaza valores no numéricos o negativos. |
| RF12 | Mostrar el resultado final. | Presenta en consola todos los datos del cliente registrado. |

## Relación con el código

- `Cliente`: clase base con los datos comunes y el método `mostrarDatos()`.
- `ClienteNatural`: hereda de `Cliente` y agrega `nombreCompleto` y `dni`.
- `ClienteJuridico`: hereda de `Cliente` y agrega `razonSocial`, `ruc` y `representanteLegal`.
- `super.init(...)`: inicializa los atributos heredados desde la clase padre.
- `override mostrarDatos()`: permite que cada tipo de cliente muestre primero sus datos particulares.
- `super.mostrarDatos()`: reutiliza la impresión de los datos comunes.
- `leerTexto(_:)` y `leerDouble(_:)`: reciben y validan los datos ingresados por el usuario.

## Requerimientos no funcionales

- Desarrollado en Swift con Foundation.
- Aplicar clases, herencia y sobrescritura de métodos de forma clara.
- Código y mensajes en español, con nombres descriptivos y fáciles de entender.
- Ejecutable como Playground de macOS; para interacción completa con `readLine()` puede ejecutarse desde Terminal.
- Los datos de los clientes deben ser ingresados por el usuario y no estar escritos de forma fija.
- La salida en consola debe ser clara y ordenada.
- Mantener la solución acorde con los conceptos vistos en la Semana 4.

## Fuera del alcance

No incluye base de datos, interfaz gráfica, almacenamiento permanente, autenticación, operaciones bancarias reales, generación automática de cuentas ni conexión a servicios externos.

## Referencia del caso

La actividad corresponde al diagrama de `Cliente`, `ClienteNatural` y `ClienteJuridico` mostrado al final del Laboratorio 04. La imagen sirve como modelo de la jerarquía y como ejemplo visual; el programa debe funcionar con los datos que ingrese cada usuario.
