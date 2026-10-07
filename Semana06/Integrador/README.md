# Caso integrador — Tienda de electrodomésticos

**Estudiante:** Carlos Daniel Carbajal Durand

**Rama:** `integrador`. **Proyecto y esquema:** `Integrador`.

## Ejecutar

1. Abre `Integrador.xcodeproj` en Xcode.
2. Selecciona el esquema **Integrador** y un simulador iPhone.
3. Presiona **⌘R**.

Este proyecto es independiente: contiene únicamente la tienda del caso integrador. El registro, la calculadora de venta a plazos y los ejercicios anteriores no forman parte de esta app.

## Pantallas y navegación

| Origen | Destino | Tipo | Identifier | Objetos |
| --- | --- | --- | --- | --- |
| Catálogo | Detalle | Show | `verDetalle` | Producto y carrito |
| Catálogo | Carrito | Show | `verCarrito` | Carrito |
| Carrito | Datos del cliente | Show | `irDatosCliente` | Carrito |
| Datos del cliente | Boleta | Present Modally | `verBoleta` | Carrito, cliente y boleta |

Las cinco pantallas están declaradas en `Integrador/Base.lproj/Integrador.storyboard`, con Navigation Controller, Auto Layout y outlets. Los cinco botones de producto usan la misma acción `productoTapped(_:)` y un solo segue `verDetalle`; sus tags coinciden con las posiciones del array.

El carrito es una única instancia de `CarritoModel`, creada en Catálogo y compartida por `prepare(for:sender:)`. El contador se actualiza en `viewWillAppear` al regresar.

## Productos

| Tag | Producto | Precio | Stock inicial |
| ---: | --- | ---: | ---: |
| 0 | Refrigeradora | S/ 2000.00 | 5 |
| 1 | Licuadora | S/ 250.00 | 10 |
| 2 | Laptop | S/ 3500.00 | 3 |
| 3 | Cocina | S/ 1200.00 | 4 |
| 4 | Microondas | S/ 450.00 | 6 |

## Modelos, cálculos y validaciones

`Producto`, `ItemCarrito` y `CarritoModel` completan los TODO A1–A5. `ClienteModel` conserva las propiedades e inicializadores del Ejercicio 2, ahora incluidos en este proyecto independiente. `BoletaModel` guarda las líneas y los importes antes de vaciar el carrito.

Los cálculos viven en el modelo:

```text
subtotal = suma(precio × cantidad)
descuento = subtotal × porcentaje
base imponible = subtotal - descuento
IGV = base imponible × 0.18
total = base imponible + IGV
```

| Subtotal | Descuento | Categoría usando switch Int(subtotal) |
| --- | ---: | --- |
| Menor a 500 | 0 % | Regular |
| Desde 500 y menor a 2000 | 5 % | Frecuente |
| Desde 2000 y menor a 5000 | 10 % | VIP |
| Desde 5000 | 15 % | Premium |

La cantidad nueva se valida junto con las unidades del mismo producto que ya están en el carrito. No se crean líneas duplicadas. Los tres campos del cliente son obligatorios y el DNI debe tener exactamente ocho dígitos. Los errores se muestran con `UIAlertController`.

Al confirmar la compra, se revalida el stock de todas las líneas, se guarda la boleta, se descuenta el stock y se vacía el mismo carrito. La boleta conserva su contenido y se cierra con `dismiss`. Cerrar también regresa al catálogo, como permite el reto opcional 1.

Los datos son de memoria; al reiniciar la app se recuperan los stocks iniciales.

## Cinco escenarios de verificación

| # | Qué probar | Resultado esperado |
| ---: | --- | --- |
| 1 | Refrigeradora x1 + Licuadora x2 | Subtotal 2500.00; descuento 250.00 (10 %); IGV 405.00; total 2655.00; VIP |
| 2 | Laptop x1 + Licuadora x1 | Subtotal 3750.00; descuento 375.00 (10 %); IGV 607.50; total 3982.50; VIP |
| 3 | Laptop x4 | Alerta de stock insuficiente; carrito sin cambios |
| 4 | Licuadora x1 en dos visitas distintas a Detalle | Una sola línea Licuadora x2 |
| 5 | Confirmar escenario 1 con Ana Pérez, DNI 12345678; cerrar boleta | Stock Refrigeradora 4; Licuadora 8; carrito vacío |

Reinicia la app entre escenarios independientes; el escenario 5 continúa desde el 1. Comprueba también campos vacíos, DNI con siete/nueve dígitos o letras, y stock acumulado. Guarda capturas reales del simulador para la entrega.

## Prueba final: quinto producto

Microondas se agregó después de implementar los cuatro productos originales. Se necesitó **un bloque de cambio en Storyboard** (nuevo botón, título, tag 4 y misma acción) y **un cambio en código** (una entrada en el array). El número cuenta bloques editados, no clics ni líneas de XML. No se agregó un nuevo segue ni se modificaron los otros controladores o modelos. La respuesta también figura como comentario en `CatalogoViewController.swift`.

## PREDICT

**1. ¿El carrito es el mismo al abrir otro producto?** Sí. Es una clase creada una sola vez en Catálogo. Cada destino recibe la misma referencia y sus cambios son visibles al regresar.

**2. ¿Qué ocurriría si CarritoModel fuera struct?** Asignarlo a un destino copiaría el valor. Agregar líneas en Detalle no actualizaría automáticamente el array del Catálogo y el contador conservaría su valor anterior. Si ItemCarrito sigue siendo class, las líneas existentes pueden compartir referencias internas: copiar el array no es copiar profundamente todos sus objetos.

## Commits progresivos

1. Crear proyecto independiente y cinco pantallas en Storyboard.
2. Completar modelos, descuentos, IGV, categoría y stock.
3. Navegar al detalle y compartir carrito con sender y tag.
4. Mostrar líneas, totales y categoría del carrito.
5. Validar cliente, confirmar compra y presentar boleta modal.
6. Agregar Microondas con el mismo segue de detalle.
7. Documentar README, RF/RNF y escenarios de verificación.

Los siete commits se prepararon localmente en la rama `integrador`. La publicación a GitHub sigue pendiente de autorización explícita. El ZIP permite abrir el proyecto; no incluye el historial Git.

## RF/RNF y estado de verificación

Consulta [docs/requerimientos.md](docs/requerimientos.md).

Se verificaron estáticamente el XML, los cinco tags, las conexiones de outlets y acciones, el único carrito, el único target y las referencias del proyecto. La compilación y la interacción real todavía deben probarse en Xcode; este entorno no dispone de Xcode ni simulador iOS. Los montos de la tabla son los resultados esperados del PDF.

La guía exige «Sin IA» y diseño manual en Storyboard. Esta preparación tiene asistencia de IA, incluido el XML, por lo que no acredita esas condiciones de trabajo manual. Los controladores no crean la interfaz en tiempo de ejecución.
