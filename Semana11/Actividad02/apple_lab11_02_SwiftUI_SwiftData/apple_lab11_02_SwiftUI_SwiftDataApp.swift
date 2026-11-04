import SwiftUI
import SwiftData

// MARK: - Entrada y entorno (paso 5)
@main
struct AlumnosApp: App {
    var body: some Scene {
        WindowGroup { ContentView() }
            .modelContainer(ModelContainerProvider.shared.container)
    }
}

