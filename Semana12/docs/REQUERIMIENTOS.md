# Requerimientos — App Compras (Grupo B)

Autor: Carlos Carbajal Durand. Curso: Programación en Móviles Avanzado. Semana 12.

## Objetivo y alcance

Desarrollar en SwiftUI + SwiftData una app para iPhone con la que una distribuidora registra sus
proveedores, el costo de sus productos y las compras al contado o a crédito. La app tiene login,
registro y dos roles: Comprador y Supervisor. Cada rol ve sus propias pestañas.

Se ejecuta desde Xcode en el simulador (iOS 17 o superior). Los datos se guardan en el teléfono.
La primera vez se cargan 3 proveedores y 4 productos de ejemplo.

## Requerimientos funcionales

| ID | Requerimiento | Criterio de aceptación |
| --- | --- | --- |
| RF01 | Crear cuenta. | Pide nombre, usuario, clave, confirmación y rol; al terminar entra directo a la app. |
| RF02 | Usuario único. | `MTORRES` se rechaza si ya existe `mtorres`; el aviso aparece mientras se escribe. |
| RF03 | Validar el registro. | Nombre y usuario obligatorios, usuario sin espacios, clave de 6 o más e igual a su confirmación. |
| RF04 | Iniciar sesión. | Con datos correctos entra; si no, muestra "Usuario o clave incorrectos" sin decir cuál falló. |
| RF05 | Recordar la sesión. | El usuario sigue conectado mientras la app está abierta. |
| RF06 | Pestañas por rol. | Comprador: Productos, Proveedores, Compra y Mis compras. Supervisor: Resumen, Aprobar, Por pagar, Productos y Proveedores. |
| RF07 | Menú de cuenta. | El avatar muestra nombre, usuario y rol, y tiene Cerrar sesión. |
| RF08 | Cerrar sesión. | Vuelve al login; otro usuario puede entrar con sus propias pestañas. |
| RF09 | Listar productos. | Muestra nombre, categoría, costo promedio, stock y valor de cada producto. |
| RF10 | Stock en color. | Verde más de 10, ámbar de 6 a 10, rojo 5 o menos. |
| RF11 | Valor del inventario. | Muestra la suma de stock × costo promedio de todos los productos. |
| RF12 | Buscar productos. | Filtra por nombre o categoría; avisa si no hay resultados. |
| RF13 | Administrar productos. | Solo el supervisor crea (nombre, categoría, stock inicial y costo) y edita nombre y categoría. |
| RF14 | Listar proveedores. | Muestra nombre, RUC, insignia "Por pagar S/ x" o "Al día" y total comprado. |
| RF15 | Buscar proveedores. | Filtra por nombre o RUC. |
| RF16 | Administrar proveedores. | Solo el supervisor crea y edita; el RUC debe tener 11 dígitos. |
| RF17 | Impedir borrados con compras. | Un producto o proveedor con compras no se borra y se muestra "No se puede borrar". |
| RF18 | Registrar compra. | Pide proveedor, producto, cantidad, costo unitario y forma de pago; la compra queda a nombre del comprador. |
| RF19 | Calcular IGV. | 10 × 120.00 muestra subtotal 1,200.00, IGV 216.00 y total 1,416.00. |
| RF20 | Aprobar al instante. | Si el total es menor a S/ 5,000 queda Aprobada y se actualizan stock y costo promedio. |
| RF21 | Pedir aprobación. | Desde S/ 5,000 avisa, el botón dice "Enviar a aprobación" y la compra queda Pendiente sin cambiar el stock. |
| RF22 | Calcular costo promedio. | Stock 40 a 110.00 + 10 a 120.00 da stock 50 y costo 112.00. |
| RF23 | Contado o crédito. | Al contado queda pagada; a crédito vence a los 30 días y queda por pagar. |
| RF24 | Ver mis compras. | El comprador ve solo las suyas, filtradas en Todas, Pendientes o Rechazadas. |
| RF25 | Ver el motivo del rechazo. | La compra rechazada muestra "Motivo: …" al comprador. |
| RF26 | Buscar por proveedor. | Mis compras y Por pagar filtran por nombre del proveedor. |
| RF27 | Listar compras por aprobar. | El supervisor ve las pendientes con quién las pidió, cantidad e importe total. |
| RF28 | Vista previa al aprobar. | Muestra stock y costo promedio antes y después: 40 → 90 y 110.00 → 115.56. |
| RF29 | Aprobar compra. | Se aplican el stock y el costo promedio; si es a crédito pasa a Por pagar. |
| RF30 | Rechazar compra. | Sin motivo el botón está desactivado; con motivo queda Rechazada y no cambia el stock. |
| RF31 | Ver todas las compras. | El supervisor ve las compras de todos los compradores y quién registró cada una. |
| RF32 | Filtrar cuentas por pagar. | Pendientes, Vencidas y Pagadas, solo de compras a crédito aprobadas. |
| RF33 | Marcar vencidas. | Una compra a crédito no pagada con fecha pasada muestra la etiqueta VENCIDA. |
| RF34 | Pagar compra. | Solo el supervisor desliza Pagar; pasa a Pagadas y baja el total por pagar. |
| RF35 | Mostrar resumen. | Valor del inventario, crédito fiscal, por pagar, por aprobar y total comprado por proveedor en barras. |
| RF36 | Dato para el cierre de IGV. | El resumen muestra el crédito fiscal que se lleva al cierre con el Grupo A. |
| RF37 | Guardar los datos. | Al cerrar y volver a abrir la app, usuarios, productos, proveedores y compras siguen ahí. |
| RF38 | Ícono y nombre. | En la pantalla de inicio aparece el ícono propio con el nombre "Compras". |
| RF39 | Compra vencida de prueba. | Solo en Debug, Por pagar ▸ Pruebas crea una compra vencida para el caso 8. |

## Requerimientos no funcionales

- SwiftUI + SwiftData, iOS 17 o superior, sin librerías externas.
- Datos locales en SQLite (`ComprasData.sqlite`); la ruta se imprime en la consola de Xcode.
- Cuatro clases `@Model` (Usuario, Proveedor, Producto, Compra) con relaciones `.deny`.
- Reglas de negocio separadas de las vistas (`ReglasCompra`, `ServicioCompras`, `ServicioUsuarios`).
- Montos en soles con dos decimales y separador de miles: S/ 1,416.00.
- Interfaz y comentarios en español, funciones pequeñas y nombres descriptivos.
- Clave guardada en texto plano solo por ser práctica.
- Todo dentro de `Semana12`, con ramas main, manual e ia-asistida y un commit por pantalla.

## Fuera del alcance

Recuperar la clave, editar o borrar usuarios, pagos parciales, devoluciones, notas de crédito,
facturación electrónica, varias monedas, sincronización en la nube y el IGV de ventas (lo trabaja
el Grupo A).

## Fuente

Guía de laboratorio 11 — Core Data / SwiftData, trabajo de la semana, Grupo B · Caso Compras
(Tecsup, docente Juan León). Las reglas, pantallas y casos de prueba se toman de esa guía.
