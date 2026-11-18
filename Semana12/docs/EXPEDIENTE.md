# Expediente del trabajo · Semana 12 · Grupo B · Caso Compras

> Laboratorio 11 – Core Data / SwiftData · Trabajo de la semana
> Curso: Programación en Móviles Avanzado · Docente: Juan León · Tecsup C24

## 1. Integrantes y caso

| Campo | Valor |
| --- | --- |
| Integrante | Carlos Carbajal Durand (GitHub: Gonnarch) |
| Grupo | B |
| Caso | Compras de una distribuidora |
| Tecnología | SwiftUI + SwiftData (iOS 17) |
| Nombre de la app | **Compras** |
| Proyecto Xcode | `Semana12/Compras/Compras.xcodeproj` |

## 2. Modelo de datos

Cuatro clases `@Model`. Cada relación de uno a muchos se declara en el lado "muchos" con
`@Relationship(deleteRule: .deny, inverse:)`; el lado "uno" es una propiedad opcional en `Compra`.

| Clase | Propiedad | Tipo | Nota |
| --- | --- | --- | --- |
| Usuario | nombre | String | Nombre completo |
| | usuario | String | Único sin distinguir mayúsculas (se guarda en minúsculas) |
| | clave | String | Texto plano (solo práctica; mínimo 6) |
| | rol | String | `Comprador` o `Supervisor` |
| | compras | [Compra] | `.deny`, inverse `\Compra.comprador` |
| Proveedor | nombre | String | |
| | ruc | String | 11 dígitos |
| | compras | [Compra] | `.deny`, inverse `\Compra.proveedor` |
| Producto | nombre | String | |
| | categoria | String | |
| | stock | Int | Sube al aprobar una compra |
| | costoPromedio | Double | Ponderado, se recalcula al aprobar |
| | compras | [Compra] | `.deny`, inverse `\Compra.producto` |
| Compra | fecha | Date | |
| | cantidad | Int | > 0 |
| | costoUnitario | Double | > 0 |
| | igv | Double | 18 % del subtotal (crédito fiscal) |
| | total | Double | subtotal + IGV |
| | alCredito | Bool | false = contado |
| | vence | Date | fecha + 30 días si es a crédito; igual a la fecha si es contado |
| | estado | String | `Pendiente`, `Aprobada` o `Rechazada` |
| | pagada | Bool | true al contado; false a crédito hasta que se paga |
| | motivoRechazo | String? | Obligatorio al rechazar |
| | comprador | Usuario? | quién registró la compra |
| | proveedor | Proveedor? | |
| | producto | Producto? | |

```
 ┌───────────┐ 1      * ┌──────────────┐ *      1 ┌────────────┐
 │  Usuario  │──────────│    Compra    │──────────│  Proveedor │
 │ (.deny)   │comprador │              │proveedor │  (.deny)   │
 └───────────┘          │              │          └────────────┘
                        │              │ *      1 ┌────────────┐
                        │              │──────────│  Producto  │
                        └──────────────┘ producto │  (.deny)   │
                                                  └────────────┘
```

**Reglas de borrado:** las tres relaciones usan `.deny`: no se puede borrar un usuario, proveedor o
producto que tenga compras. Además de la regla del modelo, la app revisa `compras.isEmpty` antes de
borrar y muestra una alerta, para que el mensaje sea claro.

## 3. Roles y permisos

| Qué puede hacer | Comprador | Supervisor |
| --- | --- | --- |
| Pestañas | Productos, Proveedores, Compra, Mis compras | Resumen, Aprobar, Por pagar, Productos, Proveedores |
| Productos | Consultar y buscar | Crear, editar, borrar (si no tiene compras) |
| Proveedores | Consultar y buscar | Crear, editar, borrar (si no tiene compras) |
| Registrar compra | Sí (queda a su nombre) | No (no tiene la pestaña) |
| Ver compras | Solo las suyas | Todas |
| Aprobar / rechazar | No | Sí (rechazo con motivo obligatorio) |
| Pagar | No | Sí (deslizar Pagar) |
| Resumen | No lo ve | Sí |
| Cuenta | Menú del avatar con Cerrar sesión | Menú del avatar con Cerrar sesión |

## 4. Reglas de negocio con ejemplos resueltos a mano

**IGV (crédito fiscal).** subtotal = cantidad × costo unitario; IGV = 18 % × subtotal; total = subtotal + IGV.
- 10 × 120.00 = 1,200.00 → IGV 216.00 → total **1,416.00**.

**Aprobación.** total < 5,000 → `Aprobada` al instante. total ≥ 5,000 → `Pendiente`: no cambia stock,
costo promedio ni cuentas por pagar hasta que el supervisor la apruebe. Rechazar pide motivo y no cambia nada.
- 50 × 120.00 = 6,000.00 → IGV 1,080.00 → total **7,080.00** ≥ 5,000 → Pendiente.

**Costo promedio ponderado (al aprobar).**
nuevo = (stock × costo promedio + cantidad × costo unitario) / (stock + cantidad)
- Stock 40 a 110.00 + 10 a 120.00 → (4,400 + 1,200) / 50 = **112.00**, stock 50.
- Stock 40 a 110.00 + 50 a 120.00 → (4,400 + 6,000) / 90 = 115.555… → **115.56**, stock 90.

**Contado / crédito.** Contado: `pagada = true`. Crédito: `pagada = false`, `vence = fecha + 30 días`.
Una compra a crédito aprobada, no pagada y con `vence < hoy` se muestra como **VENCIDA**.
- Compra del 01/11 a crédito → vence el 01/12.

**Pagar (solo supervisor).** Marca `pagada = true`; sale de Pendientes y baja el total por pagar.

**Visibilidad.** El comprador solo ve las compras donde `comprador == usuario de la sesión`.

**Cierre de IGV conjunto (A y B).** IGV por pagar = IGV de ventas − crédito fiscal de compras.
Ejemplo del docente: 734.10 − 2,361.60 = −1,627.50 → saldo a favor S/ 1,627.50.

## 5. Pantallas

| Pant. | Vista SwiftUI | Propósito | Lee | Escribe |
| --- | --- | --- | --- | --- |
| B1 | `LoginView` | Ingresar con usuario y clave | Usuario (fetch) | Sesión |
| B2 | `RegistroView` | Crear cuenta y entrar directo | Usuario (fetchCount) | Usuario, Sesión |
| B3 | `ProductosView` | Lista, búsqueda, valor del inventario | Producto (@Query) | Producto (solo supervisor) |
| B4 | `ProveedoresView` | Lista con "Por pagar"/"Al día" y total comprado | Proveedor, Compra | Proveedor (solo supervisor) |
| B5 | `NuevaCompraView` | Registrar compra, contado o crédito | Proveedor, Producto | Compra (+ Producto si se aprueba sola) |
| B6 | `MisComprasView` | Compras propias: Todas / Pendientes / Rechazadas | Compra filtrada por comprador | — |
| B7 | `AprobarView` | Aprobar o rechazar compras grandes con vista previa | Compra Pendiente | Compra, Producto |
| B8 | `PorPagarView` | Pendientes / Vencidas / Pagadas con `#Predicate`, pagar | Compra a crédito | Compra.pagada |
| B9 | `ResumenView` | Inventario, crédito fiscal, por pagar, por aprobar, gráfico por proveedor | Producto, Compra | — |
| Cuenta | `AvatarMenu` | Nombre, rol y Cerrar sesión | Sesión | Sesión = nil |

## 6. Casos de prueba

| N.º | Caso | Resultado esperado |
| --- | --- | --- |
| 1 | Registrar "mtorres" como Comprador e intentar repetir el usuario (p. ej. "MTORRES") | Se crea el primero y entra; el repetido se rechaza |
| 2 | Login con clave incorrecta | "Usuario o clave incorrectos"; no entra |
| 3 | Producto stock 40, costo prom. 110.00. Compra de 10 a 120.00 al crédito | Subtotal 1,200.00 · IGV 216.00 · total 1,416.00 · Aprobada · stock 50 · costo prom. 112.00 · vence a 30 días |
| 4 | La misma compra al contado | Queda pagada y no aparece en Pendientes de pago |
| 5 | Compra de 50 a 120.00 (total 7,080.00) | Pendiente; stock sigue en 40; no suma a por pagar |
| 6 | El supervisor aprueba la compra del caso 5 | Stock 90 · costo prom. 115.56 · aparece en Por pagar (si es a crédito) |
| 7 | Rechazar otra compra grande sin motivo y luego con motivo | Sin motivo no se puede; con motivo queda Rechazada, el comprador ve el motivo y el stock no cambia |
| 8 | Compra a crédito con vencimiento pasado, luego Pagar | Aparece en Vencidas con VENCIDA; al pagar pasa a Pagadas y baja el total por pagar |
| 9 | Un comprador abre Mis compras e intenta pagar | Solo ve sus compras; no hay opción Pagar |
| 10 (propio) | Supervisor intenta borrar un proveedor con compras | Alerta "No se puede borrar"; el proveedor sigue |
| 11 (propio) | Registro con clave de 4 caracteres o con confirmación distinta | Mensaje de error; no se crea el usuario |

## 7. Plan de commits

| Rama | Commit | Entrega |
| --- | --- | --- |
| main | docs(semana12): expediente | Este documento |
| main | docs(semana12): requerimientos | RF y RNF |
| manual | feat(compras): proyecto | Proyecto Xcode SwiftUI + SwiftData |
| manual | feat(compras): modelo | 4 clases @Model y relaciones .deny |
| manual | feat(compras): contenedor | ModelContainerProvider y datos de prueba |
| manual | feat(compras): sesión | Sesion @Observable y vista raíz |
| manual | feat(compras): B1 | Login |
| manual | feat(compras): B2 | Registro |
| manual | feat(compras): pestañas | TabView por rol y menú del avatar |
| ia-asistida | feat(compras): reglas | IGV, aprobación, costo promedio, pago |
| ia-asistida | feat(compras): B3 … B9 | Un commit por pantalla |
| ia-asistida | feat(compras): ícono | AppIcon y Display Name "Compras" |
| ia-asistida | docs: PROMPTS.md y pruebas | Registro de consultas y verificación |
| main | merge | Entrega final |

## 8. Plan de uso de IA

| A mano (rama manual) | Con IA (rama ia-asistida) |
| --- | --- |
| Modelo de datos y relaciones | Servicio de reglas de compra |
| Contenedor y sesión | Pantallas B3 a B9 |
| Login, registro y pestañas por rol | Gráfico del resumen e ícono |

**Verificación:** cada respuesta de la IA se compara con los ejemplos numéricos de la sección 4
(script `docs/verificar_reglas.py`) y con los nueve casos de prueba en el simulador. Todo se anota en
`PROMPTS.md`.

## 9. Visto bueno

| Campo | Valor |
| --- | --- |
| Fecha de presentación | ____ / ____ / 2026 |
| Visto bueno del docente | ______________________ |
