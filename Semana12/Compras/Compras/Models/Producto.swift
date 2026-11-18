import Foundation
import SwiftData

@Model
final class Producto {
    var nombre: String
    var categoria: String
    var stock: Int
    var costoPromedio: Double   // Costo promedio ponderado; se recalcula al aprobar una compra

    // Un producto aparece en muchas compras. .deny: no se puede borrar si tiene compras.
    @Relationship(deleteRule: .deny, inverse: \Compra.producto)
    var compras: [Compra] = []

    init(nombre: String, categoria: String, stock: Int, costoPromedio: Double) {
        self.nombre = nombre
        self.categoria = categoria
        self.stock = stock
        self.costoPromedio = costoPromedio
    }

    /// Valor del inventario de este producto = stock × costo promedio
    var valorInventario: Double { Double(stock) * costoPromedio }
}
