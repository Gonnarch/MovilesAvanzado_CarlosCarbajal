import Foundation

/// Reglas de negocio puras (sin SwiftData ni UI) para poder probarlas con números.
enum ReglasCompra {

    static let tasaIGV = 0.18
    static let limiteAprobacion = 5_000.00
    static let diasCredito = 30

    /// subtotal = cantidad × costo unitario
    static func subtotal(cantidad: Int, costoUnitario: Double) -> Double {
        redondear(Double(cantidad) * costoUnitario)
    }

    /// IGV = 18 % del subtotal (crédito fiscal)
    static func igv(subtotal: Double) -> Double {
        redondear(subtotal * tasaIGV)
    }

    /// total = subtotal + IGV
    static func total(subtotal: Double, igv: Double) -> Double {
        redondear(subtotal + igv)
    }

    /// Desde S/ 5,000 la compra necesita aprobación del supervisor
    static func requiereAprobacion(total: Double) -> Bool {
        total >= limiteAprobacion
    }

    /// Costo promedio ponderado:
    /// (stock actual × costo promedio + cantidad × costo unitario) / (stock actual + cantidad)
    static func costoPromedio(stockActual: Int, costoActual: Double,
                              cantidad: Int, costoUnitario: Double) -> Double {
        let nuevoStock = stockActual + cantidad
        guard nuevoStock > 0 else { return costoActual }
        let valor = Double(stockActual) * costoActual + Double(cantidad) * costoUnitario
        return redondear(valor / Double(nuevoStock))
    }

    /// Crédito: vence a los 30 días de la fecha de compra
    static func fechaVencimiento(desde fecha: Date) -> Date {
        Calendar.current.date(byAdding: .day, value: diasCredito, to: fecha) ?? fecha
    }

    /// Redondeo a dos decimales (céntimos)
    static func redondear(_ valor: Double) -> Double {
        (valor * 100).rounded() / 100
    }
}
