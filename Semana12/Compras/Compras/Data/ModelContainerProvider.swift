import Foundation
import SwiftData

@MainActor // Se usa desde la UI (hilo principal)
final class ModelContainerProvider {

    // Singleton: un único contenedor para toda la app
    static let shared = ModelContainerProvider()

    let container: ModelContainer

    private init() {
        // Esquema: las cuatro clases que se guardan
        let schema = Schema([Usuario.self, Proveedor.self, Producto.self, Compra.self])

        do {
            let carpeta = FileManager.default
                .urls(for: .applicationSupportDirectory, in: .userDomainMask)
                .first!
            // Application Support no siempre existe en el simulador: la creamos
            try FileManager.default.createDirectory(at: carpeta, withIntermediateDirectories: true)

            let config = ModelConfiguration(
                "ComprasData",
                schema: schema,
                url: carpeta.appendingPathComponent("ComprasData.sqlite")
            )
            print("Base de datos SQLite en: \(config.url.path)")

            container = try ModelContainer(for: schema, configurations: [config])
        } catch {
            fatalError("Error al inicializar ModelContainer: \(error)")
        }
    }
}
