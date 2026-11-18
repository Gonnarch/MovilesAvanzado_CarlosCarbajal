import SwiftUI
import SwiftData

@main // Punto de entrada de la app Compras (Grupo B)
struct ComprasApp: App {
    // Sesión compartida por toda la app (@Observable)
    @State private var sesion = Sesion()

    var body: some Scene {
        WindowGroup {
            RootView()
                .environment(sesion)
        }
        // Contenedor persistente para toda la app (archivo ComprasData.sqlite)
        .modelContainer(ModelContainerProvider.shared.container)
    }
}
