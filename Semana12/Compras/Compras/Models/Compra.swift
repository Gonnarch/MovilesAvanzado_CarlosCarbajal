import Foundation
import SwiftData

/// Estados posibles de una compra. Se guarda el rawValue en Compra.estado.
enum EstadoCompra: String, CaseIterable {
    case pendiente = "Pendiente"
    case aprobada = "Aprobada"
    case rechazada = "Rechazada"
}

@Model
final class Compra {
    var fecha: Date
    var cantidad: Int
    var costoUnitario: Double
    var igv: Double             // Crédito fiscal: 18 % del subtotal
    var total: Double           // subtotal + igv
    var alCredito: Bool         // false = contado
    var vence: Date             // fecha + 30 días si es a crédito
    var estado: String          // Pendiente, Aprobada o Rechazada
    var pagada: Bool
    var motivoRechazo: String?

    // Lado "uno" de las relaciones (el lado "muchos" declara el inverse)
    var comprador: Usuario?
    var proveedor: Proveedor?
    var producto: Producto?

    init(fecha: Date = .now,
         cantidad: Int,
         costoUnitario: Double,
         igv: Double,
         total: Double,
         alCredito: Bool,
         vence: Date,
         estado: String,
         pagada: Bool,
         motivoRechazo: String? = nil) {
        self.fecha = fecha
        self.cantidad = cantidad
        self.costoUnitario = costoUnitario
        self.igv = igv
        self.total = total
        self.alCredito = alCredito
        self.vence = vence
        self.estado = estado
        self.pagada = pagada
        self.motivoRechazo = motivoRechazo
    }

    // MARK: - Valores calculados (no se guardan)

    var subtotal: Double { Double(cantidad) * costoUnitario }

    var estadoCompra: EstadoCompra { EstadoCompra(rawValue: estado) ?? .pendiente }

    /// Cuenta por pagar: aprobada, al crédito y todavía no pagada
    var esPorPagar: Bool {
        alCredito && !pagada && estado == EstadoCompra.aprobada.rawValue
    }

    /// Por pagar y con la fecha de vencimiento ya pasada
    var estaVencida: Bool { esPorPagar && vence < .now }
}
