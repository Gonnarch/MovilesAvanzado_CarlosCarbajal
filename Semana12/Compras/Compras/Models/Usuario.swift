import Foundation
import SwiftData

/// Roles posibles de la app. Se guarda el rawValue (String) en Usuario.rol.
enum Rol: String, CaseIterable, Identifiable {
    case comprador = "Comprador"
    case supervisor = "Supervisor"

    var id: String { rawValue }
}

@Model
final class Usuario {
    var nombre: String      // Nombre completo
    var usuario: String     // Se guarda en minúsculas para que sea único sin distinguir mayúsculas
    var clave: String       // Texto plano: SOLO por ser práctica (la próxima clase se usará hash)
    var rol: String         // "Comprador" o "Supervisor"

    // Un usuario registra muchas compras. .deny: no se puede borrar si tiene compras.
    @Relationship(deleteRule: .deny, inverse: \Compra.comprador)
    var compras: [Compra] = []

    init(nombre: String, usuario: String, clave: String, rol: String) {
        self.nombre = nombre
        self.usuario = usuario
        self.clave = clave
        self.rol = rol
    }

    var esSupervisor: Bool { rol == Rol.supervisor.rawValue }

    /// Iniciales para el avatar ("María Torres" -> "MT")
    var iniciales: String {
        let partes = nombre.split(separator: " ").prefix(2)
        let letras = partes.compactMap { $0.first }.map { String($0) }.joined()
        return letras.isEmpty ? "?" : letras.uppercased()
    }
}
