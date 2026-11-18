# Casos de prueba · cómo ejecutarlos en el simulador

Antes de empezar: borra la app del simulador si ya la habías instalado (mantén pulsado el ícono ▸
Eliminar app). Al abrirla por primera vez se cargan 3 proveedores y 4 productos de ejemplo, entre ellos
**Monitor 24 pulgadas** con stock 40 y costo promedio S/ 110.00.

Los números de los casos 3 a 6 también se comprueban sin simulador:

```bash
python3 Semana12/docs/verificar_reglas.py
```

| N.º | Pasos | Resultado esperado | ✔ |
| --- | --- | --- | --- |
| 1 | Crear cuenta: Mónica Torres · `mtorres` · clave `123456` · Comprador. Cerrar sesión. Crear cuenta otra vez con `MTORRES` | La primera entra a la app; la segunda muestra "Ese usuario ya existe" y no deja registrarse | ☐ |
| 2 | En el login: `mtorres` / `999999` | "Usuario o clave incorrectos"; no entra | ☐ |
| 3 | Como comprador: Compra ▸ Monitor 24 pulgadas · 10 · 120.00 · Crédito 30 días ▸ Registrar compra | Subtotal 1,200.00 · IGV 216.00 · total 1,416.00 · Aprobada · en Productos: stock 50 y costo prom. 112.00 · vence en 30 días | ☐ |
| 4 | Reinstalar (stock 40) y repetir el caso 3 al Contado | Queda pagada; no aparece en Por pagar ▸ Pendientes | ☐ |
| 5 | Reinstalar. Compra de 50 a 120.00 | Aviso de S/ 5,000; botón "Enviar a aprobación"; queda Pendiente; stock sigue en 40; Por pagar no cambia | ☐ |
| 6 | Crear cuenta Supervisor (`jleon`), pestaña Aprobar ▸ la compra del caso 5 ▸ Aprobar | Vista previa 40 → 90 y 110.00 → 115.56; tras aprobar: stock 90, costo prom. 115.56; si era a crédito aparece en Por pagar | ☐ |
| 7 | Comprador registra otra compra ≥ 5,000. Supervisor ▸ Rechazar sin motivo; luego con motivo | Sin motivo el botón está desactivado; con motivo queda Rechazada; el comprador la ve en Mis compras ▸ Rechazadas con el motivo; el stock no cambia | ☐ |
| 8 | Supervisor ▸ Por pagar ▸ menú Pruebas ▸ "Crear compra vencida (caso 8)". Ir a Vencidas y deslizar Pagar | Aparece con etiqueta VENCIDA; al pagar pasa a Pagadas y baja el total por pagar | ☐ |
| 9 | Comprador ▸ Mis compras; deslizar una fila | Solo ve sus compras; no hay opción Pagar (tampoco tiene la pestaña Por pagar) | ☐ |
| 10 | Supervisor ▸ Proveedores ▸ deslizar para borrar un proveedor con compras | Alerta "No se puede borrar"; el proveedor sigue | ☐ |
| 11 | Crear cuenta con clave `1234`, o con confirmación distinta | Mensaje de error; no se crea el usuario | ☐ |

## Persistencia

Detener la app (■) y ejecutarla de nuevo: usuarios, proveedores, productos y compras siguen ahí.
En la consola de Xcode aparece `Base de datos SQLite en: …/ComprasData.sqlite`.
