# Semana 13 · Consumir API desde una aplicación (SwiftUI)

Consumo de la API REST [JSONPlaceholder `/users`](https://jsonplaceholder.typicode.com/users) desde iOS con
arquitectura MVVM (Models / View / ViewModels).

Autor: Carlos Daniel Carbajal Durand · Tecsup C24 – Sección A · Programación en Móviles Avanzado

## Actividades

| Actividad | Proyecto | Qué hace |
| --- | --- | --- |
| 01 | `Semana13_API` | GET de usuarios con `URLSession.dataTask`, lista y filtro de búsqueda (`searchText`, `filteredUsers`) |
| 02 | `Semana13_MetodosAPI` | POST (crear), PUT (editar) y DELETE (eliminar) con `UserFormView`, `.swipeActions` y `.sheet` |
| 03 | `Semana13_MetodosAPI` | Mismo proyecto migrado a `async/await` con `URLSession.shared.data(from:)` / `data(for:)` y `Task` |

La versión de la Actividad 02 (con `dataTask`) queda en el historial de commits; el proyecto actual tiene la de la Actividad 03.

## Cómo abrir

1. Abrir `Semana13_API/Semana13_API.xcodeproj` o `Semana13_MetodosAPI/Semana13_MetodosAPI.xcodeproj` en Xcode.
2. Elegir un simulador de iPhone con iOS 17 o superior y ejecutar (▶).

## Estructura

```
Semana13/
├── Semana13_API/Semana13_API/
│   ├── Models/      User (id, name)
│   ├── View/        ContentView (tarjeta resumen, buscador, lista)
│   └── ViewModels/  UserViewModel (fetchUsers, filtro)
├── Semana13_MetodosAPI/Semana13_MetodosAPI/
│   ├── Models/      User (id, name, email)
│   ├── View/        ContentView, UserFormView
│   └── ViewModels/  UserViewModel (GET, POST, PUT, DELETE)
└── docs/            Lab13_API_CarlosCarbajal.docx, capturas/
```

## Notas

- JSONPlaceholder simula POST/PUT/DELETE: responde bien pero no guarda, así que la lista se actualiza en local.
- POST siempre devuelve `id: 11`; se asigna un id local único para que la `List` no repita ids.
- Se agregó `.onChange(of: editingUser?.id)` antes del `.sheet(isPresented:)`: sin eso, al tocar **Editar**
  SwiftUI abría el formulario como "Nuevo Usuario".
