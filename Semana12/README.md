# Semana 12 · Trabajo de la semana · Grupo B · Caso Compras

App **Compras** en SwiftUI + SwiftData (iOS 17): una distribuidora registra proveedores, el costo de sus
productos y compras al contado o a crédito, con login, registro y dos roles (Comprador y Supervisor).

Autor: Carlos Carbajal Durand · Tecsup C24 · Programación en Móviles Avanzado (Lab 11)

## Cómo abrir

1. Abrir `Semana12/Compras/Compras.xcodeproj` en Xcode 15 o superior.
2. Elegir un simulador de iPhone con iOS 17 o superior y ejecutar (▶).
3. Crear una cuenta (Comprador o Supervisor). La primera vez se cargan proveedores y productos de ejemplo.

## Estructura

```
Semana12/
├── Compras/Compras.xcodeproj
├── Compras/Compras/
│   ├── App/        ComprasApp, Sesion (@Observable), RootView, MainTabView
│   ├── Models/     Usuario, Proveedor, Producto, Compra (@Model)
│   ├── Data/       ModelContainerProvider (ComprasData.sqlite), DatosSemilla
│   ├── Services/   ReglasCompra, ServicioCompras, ServicioUsuarios
│   ├── Util/       Formato (S/ 1,416.00), colores de stock, insignias
│   └── Views/      Auth (B1, B2) · Productos (B3) · Proveedores (B4)
│                   Compras (B5, B6) · Supervisor (B7, B8, B9) · Components (avatar)
├── docs/           EXPEDIENTE, REQUERIMIENTOS, CASOS_PRUEBA, verificar_reglas.py, capturas/
└── PROMPTS.md
```

## Pantallas

| Pant. | Rol | Vista |
| --- | --- | --- |
| B1 Login | Todos | `LoginView` |
| B2 Registro | Todos | `RegistroView` |
| B3 Productos | Ambos (CRUD solo supervisor) | `ProductosView` |
| B4 Proveedores | Ambos (CRUD solo supervisor) | `ProveedoresView` |
| B5 Compra | Comprador | `NuevaCompraView` |
| B6 Mis compras | Comprador | `MisComprasView` |
| B7 Aprobar | Supervisor | `AprobarView` |
| B8 Por pagar | Supervisor | `PorPagarView` |
| B9 Resumen | Supervisor | `ResumenView` |
| Cuenta | Ambos | Menú del avatar (`AvatarMenu`) |

## Niveles de entrega

| Nivel | Estado |
| --- | --- |
| Base | Login, registro, sesión y pestañas por rol; 4 clases con relaciones `.deny`; compra con IGV, contado/crédito y costo promedio; mis compras; aprobación y pago |
| Nivel + | Filtros Pendientes / Vencidas / Pagadas con `#Predicate` y búsqueda por proveedor |
| Reto | Resumen con inventario, crédito fiscal, por pagar, por aprobar y total por proveedor (Swift Charts) |

## Ramas

| Rama | Contenido |
| --- | --- |
| `main` | Expediente y entrega final (merge de `ia-asistida`) |
| `manual` | Proyecto, modelo, contenedor, sesión, login, registro y pestañas por rol |
| `ia-asistida` | Reglas de negocio, pantallas B3 a B9, ícono, PROMPTS.md y casos de prueba |

## Documentos

- [Expediente](docs/EXPEDIENTE.md) (completar la fecha del visto bueno)
- [Requerimientos funcionales y no funcionales](docs/REQUERIMIENTOS.md)
- [Casos de prueba](docs/CASOS_PRUEBA.md) · `python3 docs/verificar_reglas.py`
- [PROMPTS.md](PROMPTS.md)
- [Capturas](docs/capturas/README.md)

## Cierre conjunto de IGV

La pestaña Resumen muestra el **crédito fiscal** (IGV de compras aprobadas) que el Grupo B lleva al
cierre: IGV por pagar = IGV de ventas (Grupo A) − crédito fiscal de compras.
