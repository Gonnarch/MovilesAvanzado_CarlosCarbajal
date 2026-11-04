import SwiftUI
import SwiftData

// MARK: - Contenedor persistente (paso 4)
@MainActor
final class ModelContainerProvider {
    static let shared = ModelContainerProvider()
    let container: ModelContainer
    private init() {
        let schema = Schema([Alumno.self, Curso.self])
        do {
            let directorio = try FileManager.default.url(
                for: .applicationSupportDirectory, in: .userDomainMask,
                appropriateFor: nil, create: true)
            let config = ModelConfiguration("AlumnosData", schema: schema,
                url: directorio.appendingPathComponent("AlumnosData.sqlite"))
            container = try ModelContainer(for: schema, configurations: [config])
            print("Base de datos SQLite en: \(config.url.path)")
        } catch { fatalError("Error al inicializar ModelContainer: \(error)") }
    }
}

