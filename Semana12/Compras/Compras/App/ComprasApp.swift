import SwiftUI
import SwiftData

@main // Punto de entrada de la app Compras (Grupo B)
struct ComprasApp: App {
    var body: some Scene {
        WindowGroup {
            Text("Compras")
        }
        // Contenedor persistente para toda la app (archivo ComprasData.sqlite)
        .modelContainer(ModelContainerProvider.shared.container)
    }
}
