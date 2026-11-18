import SwiftUI
import SwiftData

/// Pantalla inicial: si hay usuario en la sesión muestra las pestañas; si no, el login.
struct RootView: View {
    @Environment(Sesion.self) private var sesion
    @Environment(\.modelContext) private var modelContext

    var body: some View {
        Group {
            if let usuario = sesion.usuario {
                Text("Hola, \(usuario.nombre) (\(usuario.rol))")
            } else {
                Text("Login")
            }
        }
        .task {
            DatosSemilla.cargarSiVacio(en: modelContext)
        }
    }
}
