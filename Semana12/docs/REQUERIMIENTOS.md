# Requerimientos funcionales y no funcionales — App Compras (Grupo B)

Describe todo lo que hace la app. La columna **Origen** indica si el requerimiento lo pide la guía
del laboratorio (**Guía**) o si se agregó durante el desarrollo (**Agregado**).

## Funcionales (RF)

### 1. Registro e inicio de sesión (B1, B2)

| ID | Requerimiento | Pantalla / código | Origen |
| --- | --- | --- | --- |
| RF-01 | Crear cuenta con nombre completo, usuario, clave, confirmación de clave y rol | B2 `RegistroView` | Guía |
| RF-02 | El nombre completo es obligatorio | `ServicioUsuarios.validar` | Guía |
| RF-03 | El usuario es obligatorio, no admite espacios y se guarda en minúsculas | `ServicioUsuarios.normalizar` | Agregado |
| RF-04 | El usuario es único sin distinguir mayúsculas; mientras se escribe aparece el aviso "Ese usuario ya existe" y el botón Registrarme se desactiva | `existe()` con `#Predicate` + `fetchCount` | Guía |
| RF-05 | La clave tiene mínimo 6 caracteres y debe ser igual a su confirmación; ambos errores se avisan en vivo y al pulsar Registrarme | B2 | Guía |
| RF-06 | Elegir el rol Comprador o Supervisor | B2 | Guía |
| RF-07 | Al registrarse, la persona entra directo a la app | `sesion.iniciar` | Guía |
| RF-08 | Volver del registro al login con el botón atrás | B2 | Guía |
| RF-09 | Iniciar sesión con usuario y clave; el botón Ingresar se activa solo con ambos campos llenos | B1 `LoginView` | Guía |
| RF-10 | Si el usuario o la clave no coinciden, mostrar "Usuario o clave incorrectos" sin decir cuál falló; el mensaje se borra al editar | B1 | Guía |
| RF-11 | Ir de login a Crear cuenta | B1 | Guía |
| RF-12 | Evitar que iOS tape el registro con "¿Usar contraseña segura?" | `.textContentType(.oneTimeCode)` | Agregado |

### 2. Sesión, roles y cuenta

| ID | Requerimiento | Pantalla / código | Origen |
| --- | --- | --- | --- |
| RF-13 | Recordar al usuario conectado mientras la app está abierta | `Sesion` `@Observable` en `.environment` | Guía |
| RF-14 | Comprador ve Productos, Proveedores, Compra y Mis compras; Supervisor ve Resumen, Aprobar, Por pagar, Productos y Proveedores | `MainTabView` | Guía |
| RF-15 | Avatar con las iniciales en todas las pestañas (índigo supervisor, verde azulado comprador) | `AvatarMenu` | Guía |
| RF-16 | El menú del avatar muestra nombre, @usuario, rol y Cerrar sesión | Cuenta | Guía |
| RF-17 | Cerrar sesión vuelve al login; al entrar con otro usuario las pestañas se reinician | `sesion.cerrar()` | Guía |

### 3. Datos de ejemplo

| ID | Requerimiento | Pantalla / código | Origen |
| --- | --- | --- | --- |
| RF-18 | La primera vez que se abre la app se cargan 3 proveedores y 4 productos (incluido Monitor 24 pulgadas con stock 40 y costo 110.00) | `DatosSemilla` | Agregado |

### 4. Productos (B3)

| ID | Requerimiento | Pantalla / código | Origen |
| --- | --- | --- | --- |
| RF-19 | Listar productos por nombre con categoría, costo promedio, stock y valor de cada producto | `ProductosView` | Guía |
| RF-20 | Stock en color: verde más de 10, ámbar de 6 a 10, rojo 5 o menos | `NivelStock` | Guía |
| RF-21 | Mostrar el valor del inventario (Σ stock × costo promedio) y la cantidad de productos | B3 | Guía |
| RF-22 | Buscar por nombre o por categoría; si no hay resultados se indica | `.searchable` | Guía (búsqueda) / Agregado (por categoría) |
| RF-23 | Crear producto (solo supervisor, botón +) con nombre, categoría, stock inicial y costo promedio; nombre y categoría obligatorios | `ProductoFormView` | Guía |
| RF-24 | Editar producto (solo supervisor, tocando la fila): solo nombre y categoría; muestra stock, costo promedio y número de compras | `ProductoFormView` | Guía (editar) / Agregado (qué se edita) |
| RF-25 | Borrar deslizando (solo supervisor); si tiene compras se bloquea con la alerta "No se puede borrar" | `.onDelete` + `.deny` | Guía |
| RF-26 | El comprador solo consulta y busca: no ve +, no edita ni borra | B3 | Guía |

### 5. Proveedores (B4)

| ID | Requerimiento | Pantalla / código | Origen |
| --- | --- | --- | --- |
| RF-27 | Listar proveedores con nombre y RUC | `ProveedoresView` | Guía |
| RF-28 | Insignia "Por pagar S/ x" o "Al día" y total comprado, calculados desde sus compras (solo aprobadas) | `Proveedor.porPagar`, `totalComprado` | Guía |
| RF-29 | Buscar por nombre o por RUC | `.searchable` | Agregado |
| RF-30 | Crear y editar proveedor (solo supervisor) con razón social y RUC de 11 dígitos; al editar muestra compras, total comprado y por pagar | `ProveedorFormView` | Guía (crear/editar) / Agregado (RUC y datos) |
| RF-31 | Borrar deslizando (solo supervisor); si tiene compras se bloquea con alerta | `.onDelete` + `.deny` | Guía |
| RF-32 | El comprador solo consulta y busca | B4 | Guía |

### 6. Registrar compra (B5, comprador)

| ID | Requerimiento | Pantalla / código | Origen |
| --- | --- | --- | --- |
| RF-33 | Mostrar el avatar y el nombre del comprador de la sesión | `NuevaCompraView` | Guía |
| RF-34 | Elegir proveedor y producto; al elegir producto se ven su stock y costo promedio actuales | B5 | Guía |
| RF-35 | Ingresar la cantidad (con botones + / − o escribiendo) y el costo unitario; se sugiere el costo promedio del producto | B5 | Guía (cantidad) / Agregado (sugerencia) |
| RF-36 | Elegir Contado o Crédito 30 días; a crédito se muestra la fecha de vencimiento | B5 | Guía |
| RF-37 | Resumen en vivo: subtotal (cantidad × costo), IGV 18 % (crédito fiscal) y total | `ReglasCompra` | Guía |
| RF-38 | Si el total llega a S/ 5,000, aviso de que quedará Pendiente; el botón dice "Enviar a aprobación", si no "Registrar compra" | B5 | Guía |
| RF-39 | Validar que haya proveedor y producto, cantidad mayor a 0 y costo mayor a 0 | `ServicioCompras.registrar` | Guía |
| RF-40 | Total menor a S/ 5,000: Aprobada al instante, sube el stock y se recalcula el costo promedio ponderado | `ServicioCompras` | Guía |
| RF-41 | Total desde S/ 5,000: Pendiente, sin cambiar stock, costo promedio ni cuentas por pagar | `ServicioCompras` | Guía |
| RF-42 | Contado: queda pagada. Crédito: pendiente de pago y vence a los 30 días | `ServicioCompras` | Guía |
| RF-43 | Guardar quién registró la compra (relación con el usuario) | `Compra.comprador` | Guía |
| RF-44 | Al registrar, alerta con el resultado (estado, total, vencimiento, nuevo stock y costo) y limpiar el formulario | B5 | Agregado |

### 7. Mis compras (B6, comprador)

| ID | Requerimiento | Pantalla / código | Origen |
| --- | --- | --- | --- |
| RF-45 | Mostrar solo las compras del comprador de la sesión, de la más reciente a la más antigua | `MisComprasView` | Guía |
| RF-46 | Filtro Todas / Pendientes / Rechazadas con el número de compras | `ListaComprasView` | Guía |
| RF-47 | Cada fila muestra producto, proveedor, cantidad × costo, total, estado, Contado / Crédito con vencimiento / Pagada / VENCIDA y fecha | `CompraFila` | Guía |
| RF-48 | Las compras rechazadas muestran su motivo | `CompraFila` | Guía |
| RF-49 | Buscar por proveedor | `.searchable` | Guía |
| RF-50 | El comprador no tiene opción de pagar | B6 | Guía |

### 8. Aprobar (B7, supervisor)

| ID | Requerimiento | Pantalla / código | Origen |
| --- | --- | --- | --- |
| RF-51 | Listar las compras Pendientes (la más antigua primero) con su cantidad e importe total | `@Query` + `#Predicate` | Guía |
| RF-52 | Tarjeta con quién la solicitó, fecha, producto, proveedor, cantidad × costo, forma de pago, subtotal, IGV y total | `TarjetaAprobacion` | Guía |
| RF-53 | Vista previa del efecto: stock y costo promedio antes → después | `ServicioCompras.efecto` | Guía |
| RF-54 | Aprobar aplica el stock y el costo promedio; solo el supervisor y solo compras pendientes | `ServicioCompras.aprobar` | Guía |
| RF-55 | Rechazar abre una hoja con los datos y el motivo; el botón Rechazar está desactivado sin motivo | `RechazoView` | Guía |
| RF-56 | Al rechazar se guarda el motivo y no cambia stock, costo ni cuentas por pagar | `ServicioCompras.rechazar` | Guía |
| RF-57 | Ver todas las compras de todos los compradores, con filtros, búsqueda y quién la registró | `TodasLasComprasView` | Guía |
| RF-58 | Si no hay pendientes, mostrar "Nada por aprobar" | B7 | Agregado |

### 9. Por pagar (B8, supervisor)

| ID | Requerimiento | Pantalla / código | Origen |
| --- | --- | --- | --- |
| RF-59 | Mostrar el total por pagar, el número de compras pendientes y cuántas están vencidas | `PorPagarView` | Guía |
| RF-60 | Filtro Pendientes / Vencidas / Pagadas con `#Predicate`, solo compras a crédito aprobadas | `FiltroPago.predicado` | Guía |
| RF-61 | Ordenar por fecha de vencimiento; etiqueta VENCIDA si ya pasó la fecha y no está pagada; mostrar quién la registró y el subtotal del filtro | `ListaPorPagar` | Guía |
| RF-62 | Buscar por proveedor | `.searchable` | Guía |
| RF-63 | Pagar deslizando la fila: solo el supervisor y solo compras no pagadas; pasa a Pagadas y baja el total | `ServicioCompras.pagar` | Guía |
| RF-64 | Solo en Debug: menú Pruebas ▸ "Crear compra vencida (caso 8)" | `#if DEBUG` | Agregado |

### 10. Resumen (B9, supervisor)

| ID | Requerimiento | Pantalla / código | Origen |
| --- | --- | --- | --- |
| RF-65 | Saludo con avatar, nombre y rol | `ResumenView` | Guía |
| RF-66 | Valor del inventario y número de productos | B9 | Guía |
| RF-67 | Crédito fiscal (IGV de compras aprobadas) y número de compras aprobadas | B9 | Guía |
| RF-68 | Total por pagar y número de vencidas | B9 | Guía |
| RF-69 | Compras por aprobar: cantidad e importe | B9 | Guía |
| RF-70 | Gráfico de barras del total comprado por proveedor (aprobadas, de mayor a menor, con el monto) | Swift Charts | Guía |
| RF-71 | Dato del crédito fiscal para el cierre conjunto de IGV con el Grupo A | B9 | Agregado |

### 11. Generales

| ID | Requerimiento | Pantalla / código | Origen |
| --- | --- | --- | --- |
| RF-72 | No se puede borrar un usuario, proveedor o producto con compras (`.deny`) | Modelo | Guía |
| RF-73 | Aprobar, rechazar y pagar vuelven a comprobar que el usuario sea supervisor | `ServicioCompras` | Agregado |
| RF-74 | Los datos se guardan y siguen al cerrar y volver a abrir la app | `ComprasData.sqlite` | Guía |
| RF-75 | Montos en soles con dos decimales y separador de miles (S/ 1,416.00) | `Moneda` | Agregado |
| RF-76 | Ícono propio y el nombre "Compras" en la pantalla de inicio | `AppIcon`, Display Name | Guía |

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
