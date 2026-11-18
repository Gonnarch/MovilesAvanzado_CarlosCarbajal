import SwiftUI
import SwiftData

/// Pantalla inicial: si hay usuario en la sesión muestra las pestañas; si no, el login.
struct RootView: View {
    @Environment(Sesion.self) private var sesion
    @Environment(\.modelContext) private var modelContext

    var body: some View {
        Group {
            if let usuario = sesion.usuario {
                MainTabView(usuario: usuario)
                    .id(usuario.persistentModelID) // Al cambiar de usuario se reinician las pestañas
            } else {
                LoginView()
            }
        }
        .task {
            DatosSemilla.cargarSiVacio(en: modelContext)
        }
    }
}
