import Foundation
import SwiftData

@Model
final class Proveedor {
    var nombre: String
    var ruc: String         // 11 dígitos

    // Un proveedor tiene muchas compras. .deny: no se puede borrar si tiene compras.
    @Relationship(deleteRule: .deny, inverse: \Compra.proveedor)
    var compras: [Compra] = []

    init(nombre: String, ruc: String) {
        self.nombre = nombre
        self.ruc = ruc
    }

    // MARK: - Valores calculados (no se guardan)

    /// Total comprado: solo compras aprobadas (las pendientes o rechazadas no cuentan)
    var totalComprado: Double {
        compras.filter { $0.estado == EstadoCompra.aprobada.rawValue }
            .reduce(0) { $0 + $1.total }
    }

    /// Lo que se le debe: compras aprobadas a crédito y no pagadas
    var porPagar: Double {
        compras.filter { $0.esPorPagar }.reduce(0) { $0 + $1.total }
    }

    var estaAlDia: Bool { porPagar == 0 }
}
