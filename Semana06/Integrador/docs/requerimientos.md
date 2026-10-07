# Requerimientos funcionales y no funcionales — Tienda Tecsup

## Funcionales (RF)

| ID | Requerimiento | Implementación / verificación |
| --- | --- | --- |
| RF-01 | Mostrar cuatro productos fijos con sus precios y stock | Array `productos` de Catálogo; tabla del README |
| RF-02 | Abrir Detalle usando una sola acción y un solo segue | `productoTapped`, sender, tags 0–4, `verDetalle` |
| RF-03 | Seleccionar una cantidad positiva | UIStepper; modelo rechaza valores no positivos |
| RF-04 | Rechazar compras que excedan el stock acumulado | `CarritoModel.agregar`; escenario 3 |
| RF-05 | Agrupar cantidades del mismo producto en una línea | Identidad de `Producto`; escenario 4 |
| RF-06 | Compartir un único carrito entre todas las pantallas | Creación en Catálogo y `prepare(for:sender:)` |
| RF-07 | Actualizar el contador al volver al catálogo | `viewWillAppear`; cuenta unidades, no líneas |
| RF-08 | Mostrar líneas, subtotal, descuento, IGV y total | Modelo + outlets del Carrito; escenarios 1 y 2 |
| RF-09 | Aplicar 0 %, 5 %, 10 % o 15 % según subtotal | `porcentajeDescuento`; revisión de límites de los tramos |
| RF-10 | Calcular IGV de 18 % sobre el monto descontado | `baseImponible`, `igv`, `total` en el modelo |
| RF-11 | Clasificar cliente Regular/Frecuente/VIP/Premium | `switch Int(subtotal())` |
| RF-12 | Solicitar apellidos, nombres y DNI obligatorios | `DatosClienteViewController` y `ValidacionCliente` |
| RF-13 | Validar DNI de exactamente ocho dígitos | Alerta para longitud incorrecta o caracteres no numéricos |
| RF-14 | Presentar boleta modal con cliente, líneas y montos | `verBoleta`, `BoletaModel`, `BoletaViewController` |
| RF-15 | Descontar stock y vaciar carrito al confirmar | `confirmarCompra`; escenario 5 |
| RF-16 | Agregar Microondas S/ 450 y stock 6 | Tag 4; mismo segue y modelo |
| RF-17 | Mostrar cada error mediante UIAlertController | Stock, datos del cliente y carrito vacío |
| RF-18 | Cerrar boleta y regresar al Catálogo | `dismiss` + `popToRootViewController`; reto opcional 1 |

## No funcionales (RNF)

| ID | Requerimiento | Alcance |
| --- | --- | --- |
| RNF-01 | Usar UIKit y cinco pantallas en Storyboard | Target `Integrador`; navegación Show y modal |
| RNF-02 | Separar cálculo y presentación | Importes y categoría viven en `CarritoModel` |
| RNF-03 | Evitar confirmaciones parciales o repetidas | Revalidación conjunta y bloqueo del botón |
| RNF-04 | Mostrar importes con dos decimales | `Moneda.formato`, locale POSIX |
| RNF-05 | Adaptar la interfaz a la pantalla | Auto Layout, Safe Area y UIScrollView en cada escena |
| RNF-06 | Ejecutar sin servicios o dependencias externos | Productos y stock en memoria |
| RNF-07 | Mantener trazabilidad con commits progresivos | Rama `integrador`; más de seis checkpoints |
| RNF-08 | Documentar pruebas reproducibles | Escenarios y pasos de comprobación en README |
| RNF-09 | Conservar la organización del repositorio | `Semana06/Integrador`; proyecto y target independientes |
| RNF-10 | Evitar pérdida de la boleta tras vaciar el carrito | Snapshot de líneas, subtotal, descuento, IGV y total |

## Condiciones académicas del enunciado

«Sin IA», diseño manual y trabajo individual en clase son condiciones del proceso, no prestaciones de la app. Esta preparación asistida por IA no puede acreditar su cumplimiento. La validación de interacción real y las capturas del simulador deben distinguirse de las verificaciones estáticas. La compilación y la interacción en Xcode están pendientes.
