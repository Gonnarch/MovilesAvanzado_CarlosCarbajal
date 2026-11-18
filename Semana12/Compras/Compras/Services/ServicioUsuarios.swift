import Foundation
import SwiftData

/// Login y registro de usuarios con SwiftData.
@MainActor
enum ServicioUsuarios {

    /// Mensaje genérico: no dice si falló el usuario o la clave
    static let mensajeLoginInvalido = "Usuario o clave incorrectos"

    /// El usuario se guarda sin espacios a los lados y en minúsculas,
    /// así "MTorres" y "mtorres" son el mismo usuario.
    static func normalizar(_ usuario: String) -> String {
        usuario.trimmingCharacters(in: .whitespacesAndNewlines).lowercased()
    }

    // MARK: - Login

    /// Devuelve el usuario si usuario y clave coinciden; nil en otro caso.
    static func login(usuario: String, clave: String, en contexto: ModelContext) -> Usuario? {
        // #Predicate no acepta llamadas a funciones: guardamos el texto en un let antes
        let buscado = normalizar(usuario)
        let claveIngresada = clave
        let descriptor = FetchDescriptor<Usuario>(
            predicate: #Predicate { $0.usuario == buscado && $0.clave == claveIngresada }
        )
        return (try? contexto.fetch(descriptor))?.first
    }
}
