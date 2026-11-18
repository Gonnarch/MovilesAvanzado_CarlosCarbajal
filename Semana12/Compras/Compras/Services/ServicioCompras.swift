import Foundation
import SwiftData

enum ErrorCompra: LocalizedError {
    case datosIncompletos
    case cantidadInvalida
    case costoInvalido
    case motivoVacio
    case sinPermiso
    case estadoInvalido

    var errorDescription: String? {
        switch self {
        case .datosIncompletos: return "Selecciona proveedor y producto."
        case .cantidadInvalida: return "La cantidad debe ser mayor que cero."
        case .costoInvalido: return "El costo unitario debe ser mayor que cero."
        case .motivoVacio: return "Escribe el motivo del rechazo."
        case .sinPermiso: return "Solo el supervisor puede hacer esta operación."
        case .estadoInvalido: return "La compra ya no está en un estado válido para esta operación."
        }
    }
}

/// Vista previa del efecto de aprobar una compra sobre el producto.
struct EfectoAprobacion {
    let stockAntes: Int
    let stockDespues: Int
    let costoAntes: Double
    let costoDespues: Double
}

/// Operaciones sobre compras que cambian datos (registrar, aprobar, rechazar, pagar).
@MainActor
enum ServicioCompras {

    // MARK: - Registrar (Comprador)

    @discardableResult
    static func registrar(cantidad: Int,
                          costoUnitario: Double,
                          alCredito: Bool,
                          producto: Producto?,
                          proveedor: Proveedor?,
                          comprador: Usuario,
                          fecha: Date = .now,
                          en contexto: ModelContext) throws -> Compra {
        guard let producto, let proveedor else { throw ErrorCompra.datosIncompletos }
        guard cantidad > 0 else { throw ErrorCompra.cantidadInvalida }
        guard costoUnitario > 0 else { throw ErrorCompra.costoInvalido }

        let subtotal = ReglasCompra.subtotal(cantidad: cantidad, costoUnitario: costoUnitario)
        let igv = ReglasCompra.igv(subtotal: subtotal)
        let total = ReglasCompra.total(subtotal: subtotal, igv: igv)
        let necesitaAprobacion = ReglasCompra.requiereAprobacion(total: total)

        let compra = Compra(
            fecha: fecha,
            cantidad: cantidad,
            costoUnitario: costoUnitario,
            igv: igv,
            total: total,
            alCredito: alCredito,
            vence: alCredito ? ReglasCompra.fechaVencimiento(desde: fecha) : fecha,
            estado: (necesitaAprobacion ? EstadoCompra.pendiente : EstadoCompra.aprobada).rawValue,
            pagada: !alCredito // Contado: queda pagada. Crédito: pendiente de pago.
        )
        // Primero se inserta y luego se enlazan las relaciones (mismo contexto)
        contexto.insert(compra)
        compra.comprador = comprador
        compra.proveedor = proveedor
        compra.producto = producto

        // Menor a S/ 5,000: aprobada al instante, se aplican sus efectos
        if !necesitaAprobacion {
            aplicarEfectos(de: compra)
        }
        try contexto.save()
        return compra
    }

    // MARK: - Efectos de una compra aprobada

    static func efecto(de compra: Compra) -> EfectoAprobacion? {
        guard let producto = compra.producto else { return nil }
        let nuevoCosto = ReglasCompra.costoPromedio(stockActual: producto.stock,
                                                    costoActual: producto.costoPromedio,
                                                    cantidad: compra.cantidad,
                                                    costoUnitario: compra.costoUnitario)
        return EfectoAprobacion(stockAntes: producto.stock,
                                stockDespues: producto.stock + compra.cantidad,
                                costoAntes: producto.costoPromedio,
                                costoDespues: nuevoCosto)
    }

    /// Sube el stock y recalcula el costo promedio ponderado del producto
    private static func aplicarEfectos(de compra: Compra) {
        guard let producto = compra.producto, let cambio = efecto(de: compra) else { return }
        producto.costoPromedio = cambio.costoDespues
        producto.stock = cambio.stockDespues
    }

    // MARK: - Aprobar / Rechazar (Supervisor)

    static func aprobar(_ compra: Compra, por usuario: Usuario?, en contexto: ModelContext) throws {
        guard usuario?.esSupervisor == true else { throw ErrorCompra.sinPermiso }
        guard compra.estadoCompra == .pendiente else { throw ErrorCompra.estadoInvalido }
        compra.estado = EstadoCompra.aprobada.rawValue
        aplicarEfectos(de: compra)
        try contexto.save()
    }

    /// Rechazar no cambia stock, costo ni cuentas por pagar; solo guarda el motivo.
    static func rechazar(_ compra: Compra, motivo: String, por usuario: Usuario?, en contexto: ModelContext) throws {
        guard usuario?.esSupervisor == true else { throw ErrorCompra.sinPermiso }
        guard compra.estadoCompra == .pendiente else { throw ErrorCompra.estadoInvalido }
        let motivoLimpio = motivo.trimmingCharacters(in: .whitespacesAndNewlines)
        guard !motivoLimpio.isEmpty else { throw ErrorCompra.motivoVacio }
        compra.estado = EstadoCompra.rechazada.rawValue
        compra.motivoRechazo = motivoLimpio
        try contexto.save()
    }

    // MARK: - Pagar (Supervisor)

    static func pagar(_ compra: Compra, por usuario: Usuario?, en contexto: ModelContext) throws {
        guard usuario?.esSupervisor == true else { throw ErrorCompra.sinPermiso }
        guard compra.esPorPagar else { throw ErrorCompra.estadoInvalido }
        compra.pagada = true
        try contexto.save()
    }
}
