# PROMPTS.md · Semana 12 · Caso Compras (Grupo B)

Registro de las consultas a la IA hechas en la rama `ia-asistida`, después de tener el expediente
(`docs/EXPEDIENTE.md`) y la base manual (modelo, contenedor, sesión, login, registro y pestañas).

Formato de cada entrada: **Contexto · Tarea · Restricciones · Formato esperado · Qué hicimos con la respuesta**.

---

## 1. Reglas de negocio

- **Contexto:** App Compras en SwiftUI + SwiftData con las clases `Usuario`, `Proveedor`, `Producto` y
  `Compra` ya creadas (rama manual). Las reglas están en la sección 4 del expediente.
- **Tarea:** Escribir las reglas de IGV, aprobación, costo promedio ponderado, contado/crédito y pago.
- **Restricciones:** IGV 18 % sobre el subtotal; aprobación desde S/ 5,000; el costo promedio y el stock
  cambian solo al aprobar; rechazar exige motivo y no cambia nada; pagar solo el supervisor; montos a dos
  decimales; separar la parte pura (sin SwiftData) para poder probarla.
- **Formato esperado:** `ReglasCompra.swift` (enum con funciones estáticas) y `ServicioCompras.swift`
  (registrar, aprobar, rechazar, pagar) con errores `LocalizedError` en español.
- **Qué hicimos con la respuesta:** Aceptada con cambios. Se comprobó con `docs/verificar_reglas.py`
  (casos 3 a 6: 1,416.00 · 112.00 · 7,080.00 · 115.56). Se renombró la variable local `efecto` a
  `cambio` en `aplicarEfectos` porque tenía el mismo nombre que la función `efecto(de:)` y era confuso.
  Se decidió insertar la compra en el contexto **antes** de asignar sus relaciones.

## 2. B3 · Productos

- **Contexto:** Pestaña Productos para ambos roles; `Producto` con `stock` y `costoPromedio`.
- **Tarea:** Lista con búsqueda, stock en color, valor del inventario y CRUD solo para el supervisor.
- **Restricciones:** verde > 10, ámbar 6–10, rojo ≤ 5; `.onDelete` solo supervisor y bloqueado si el
  producto tiene compras (regla `.deny`) con una alerta; usar `@Query` y `.searchable`.
- **Formato esperado:** `ProductosView.swift` y `ProductoFormView.swift`.
- **Qué hicimos con la respuesta:** Aceptada con cambios. `.onDelete(perform:)` recibe `nil` para el
  comprador mediante una propiedad `accionBorrar` (más claro que el ternario dentro del modificador).
  Decidimos que stock y costo promedio solo se ingresan al crear el producto; luego cambian únicamente al
  aprobar compras, para no romper el costo promedio.

## 3. B4 · Proveedores

- **Contexto:** `Proveedor` con relación `compras`.
- **Tarea:** Lista con insignia "Por pagar" o "Al día" y total comprado, calculados desde las compras.
- **Restricciones:** Solo compras aprobadas cuentan para el total; por pagar = aprobadas a crédito no
  pagadas; RUC de 11 dígitos; borrado bloqueado si tiene compras.
- **Formato esperado:** `ProveedoresView.swift` y `ProveedorFormView.swift`.
- **Qué hicimos con la respuesta:** Aceptada. Los valores calculados se dejaron como propiedades de
  `Proveedor` (`totalComprado`, `porPagar`, `estaAlDia`) para reutilizarlos en el Resumen.

## 4. B5 · Compra

- **Contexto:** Comprador conectado (sesión) y reglas de la entrada 1.
- **Tarea:** Formulario con proveedor, producto, cantidad, costo unitario y Contado / Crédito 30 días;
  resumen en vivo; aviso desde S/ 5,000.
- **Restricciones:** El botón dice "Enviar a aprobación" si el total ≥ 5,000 y "Registrar compra" si es
  menor; la compra guarda al comprador de la sesión; mostrar el avatar.
- **Formato esperado:** `NuevaCompraView.swift`.
- **Qué hicimos con la respuesta:** Aceptada con un cambio: al elegir producto se sugiere su costo
  promedio como costo unitario (solo si el campo está en 0).

## 5. B6 · Mis compras

- **Contexto:** El comprador solo debe ver sus compras.
- **Tarea:** Lista con segmented Todas / Pendientes / Rechazadas y motivo de rechazo visible.
- **Restricciones:** Filtrar el arreglo de `@Query` por `comprador == usuario de la sesión` (pista de la
  guía); sin opción de pagar; búsqueda por proveedor.
- **Formato esperado:** `MisComprasView.swift`, `ListaComprasView.swift`, `CompraFila.swift`.
- **Qué hicimos con la respuesta:** Aceptada. Se reutilizó la lista en `TodasLasComprasView` para que el
  supervisor "vea todo" desde la pestaña Aprobar.

## 6. B7 · Aprobar

- **Contexto:** Compras `Pendiente` (≥ S/ 5,000).
- **Tarea:** Tarjetas con quién la solicitó, vista previa de stock y costo promedio antes/después,
  botones Rechazar y Aprobar.
- **Restricciones:** `@Query` con `#Predicate`; rechazar pide motivo obligatorio (botón desactivado si
  está vacío); aprobar aplica efectos.
- **Formato esperado:** `AprobarView.swift` con `TarjetaAprobacion` y `RechazoView`.
- **Qué hicimos con la respuesta:** Aceptada con cambio: se usa `ScrollView` + `LazyVStack` en lugar de
  `List`, porque en una fila de `List` los dos botones se activaban juntos.

## 7. B8 · Por pagar

- **Contexto:** Compras a crédito aprobadas.
- **Tarea:** Segmented Pendientes / Vencidas / Pagadas con `#Predicate`, etiqueta VENCIDA, total por
  pagar y deslizar Pagar.
- **Restricciones:** El filtro debe resolverse con `#Predicate` (Nivel +); guardar en `let` los valores
  que usa el predicado; Pagar solo supervisor.
- **Formato esperado:** `PorPagarView.swift` con una subvista que construye el `@Query` en su `init`.
- **Qué hicimos con la respuesta:** Aceptada con cambio: agregamos, solo en compilación DEBUG, un botón
  "Crear compra vencida (caso 8)" para poder probar el caso 8 sin cambiar la fecha del simulador.

## 8. B9 · Resumen

- **Contexto:** Supervisor; datos de productos y compras.
- **Tarea:** Valor del inventario, crédito fiscal, por pagar, por aprobar y total por proveedor en barras.
- **Restricciones:** Crédito fiscal = IGV de compras aprobadas; usar Swift Charts.
- **Formato esperado:** `ResumenView.swift`.
- **Qué hicimos con la respuesta:** Aceptada con cambio: los datos del gráfico se pasaron de una tupla a
  la estructura `TotalProveedor: Identifiable`, más simple de explicar. Se agregó el dato del crédito
  fiscal para el cierre conjunto de IGV.

## 9. Ícono

- **Contexto:** La app debe verse como "Compras" en la pantalla de inicio.
- **Tarea:** Ícono 1024 × 1024 px con un símbolo simple.
- **Restricciones:** PNG cuadrado, sin transparencia y sin esquinas redondeadas; buen contraste.
- **Formato esperado:** `AppIcon.png` en `Assets.xcassets/AppIcon.appiconset`.
- **Qué hicimos con la respuesta:** Aceptada tras una segunda versión (la primera tenía uniones
  dentadas en el mango del carrito).
