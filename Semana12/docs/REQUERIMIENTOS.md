# Requerimientos funcionales y no funcionales — App Compras (Grupo B)

## Funcionales (RF)

| ID | Requerimiento | Implementación / verificación |
| --- | --- | --- |
| RF-01 | Registrar cuenta con nombre completo, usuario, clave, confirmación y rol | `RegistroView` (B2) + `ServicioUsuarios.validar` |
| RF-02 | Rechazar usuario repetido sin distinguir mayúsculas | `FetchDescriptor` + `#Predicate` + `fetchCount`; caso 1 |
| RF-03 | Exigir clave de mínimo 6 caracteres igual a su confirmación | `ServicioUsuarios.validar`; caso 11 |
| RF-04 | Entrar directo a la app al registrarse | `sesion.iniciar(nuevo)` |
| RF-05 | Iniciar sesión con mensaje genérico "Usuario o clave incorrectos" | `LoginView` (B1); caso 2 |
| RF-06 | Recordar al usuario conectado mientras la app está abierta | `Sesion` `@Observable` en `.environment` |
| RF-07 | Mostrar nombre y rol y cerrar sesión desde el menú del avatar | `AvatarMenu`; `sesion.cerrar()` vuelve al login |
| RF-08 | Mostrar pestañas según el rol | `MainTabView`: Comprador 4 pestañas, Supervisor 5 |
| RF-09 | Listar y buscar productos con costo promedio y stock en color | `ProductosView` (B3): verde > 10, ámbar 6–10, rojo ≤ 5 |
| RF-10 | Mostrar el valor del inventario (stock × costo promedio) | Cabecera de B3 y tarjeta de B9 |
| RF-11 | Crear, editar y borrar productos solo como supervisor | Botón + y `.onDelete` condicionados al rol |
| RF-12 | Impedir borrar productos, proveedores o usuarios con compras | `.deny` en el modelo + alerta previa; caso 10 |
| RF-13 | Listar proveedores con insignia "Por pagar"/"Al día" y total comprado | `ProveedoresView` (B4), valores calculados de `proveedor.compras` |
| RF-14 | Registrar compra con proveedor, producto, cantidad, costo y forma de pago | `NuevaCompraView` (B5) |
| RF-15 | Calcular IGV 18 % sobre el subtotal y total = subtotal + IGV | `ReglasCompra`; caso 3 |
| RF-16 | Dejar Aprobada al instante si el total < S/ 5,000; Pendiente si ≥ S/ 5,000 | `ReglasCompra.requiereAprobacion`; casos 3 y 5 |
| RF-17 | Avisar en pantalla cuando el total llega a S/ 5,000 y cambiar el botón | "Enviar a aprobación" / "Registrar compra" |
| RF-18 | Recalcular costo promedio ponderado y stock solo al aprobar | `ServicioCompras.aplicarEfectos`; casos 3 y 6 |
| RF-19 | Contado queda pagada; crédito vence a los 30 días | `ServicioCompras.registrar`; casos 3 y 4 |
| RF-20 | Guardar quién registró cada compra | Relación `Compra.comprador` |
| RF-21 | El comprador ve solo sus compras con filtro Todas / Pendientes / Rechazadas | `MisComprasView` (B6); caso 9 |
| RF-22 | Aprobar con vista previa del stock y costo promedio antes/después | `AprobarView` (B7); caso 6 |
| RF-23 | Rechazar exigiendo motivo; el comprador ve el motivo | `RechazoView`; caso 7 |
| RF-24 | Cuentas por pagar con Pendientes / Vencidas / Pagadas usando `#Predicate` | `PorPagarView` (B8) |
| RF-25 | Marcar VENCIDA la compra a crédito no pagada con fecha pasada | `Compra.estaVencida`; caso 8 |
| RF-26 | Pagar deslizando, solo supervisor | `.swipeActions` + `ServicioCompras.pagar`; casos 8 y 9 |
| RF-27 | Buscar por proveedor en Mis compras y Por pagar | `.searchable` |
| RF-28 | Resumen con inventario, crédito fiscal, por pagar, por aprobar y total por proveedor en barras | `ResumenView` (B9) con Swift Charts |
| RF-29 | Ícono propio y nombre "Compras" en la pantalla de inicio | `AppIcon` 1024 px + `CFBundleDisplayName` |

## No funcionales (RNF)

| ID | Requerimiento | Alcance |
| --- | --- | --- |
| RNF-01 | SwiftUI + SwiftData, iOS 17 o superior | Target `Compras`; sin dependencias externas |
| RNF-02 | Persistencia local en SQLite | `ComprasData.sqlite` en Application Support; la ruta se imprime en consola |
| RNF-03 | Separar reglas de negocio de las vistas | `ReglasCompra` (puro) y `ServicioCompras` / `ServicioUsuarios` |
| RNF-04 | Montos con dos decimales y separador de miles | `Moneda.formato` → "S/ 1,416.00" |
| RNF-05 | Mensajes de error claros con alertas | Borrado bloqueado, formulario incompleto, permisos |
| RNF-06 | Clave en texto plano solo por ser práctica | Documentado; se reemplazará por hash en la próxima clase |
| RNF-07 | Trazabilidad con ramas main, manual, ia-asistida y un commit por pantalla | Historial de Git |
| RNF-08 | Consultas a la IA documentadas | `PROMPTS.md` con Contexto, Tarea, Restricciones, Formato y uso |
| RNF-09 | Reglas comprobables fuera del simulador | `docs/verificar_reglas.py` reproduce los casos numéricos |
| RNF-10 | Organización del repositorio por semana | Todo dentro de `Semana12/` |
