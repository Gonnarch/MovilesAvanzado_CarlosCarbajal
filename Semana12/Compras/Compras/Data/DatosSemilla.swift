import Foundation
import SwiftData

/// Carga proveedores y productos de ejemplo la primera vez que se abre la app,
/// para poder ejecutar los casos de prueba (producto con stock 40 y costo promedio 110.00).
/// No crea usuarios: cada persona se registra en la pantalla B2.
@MainActor
enum DatosSemilla {

    static func cargarSiVacio(en contexto: ModelContext) {
        let hayProveedores = ((try? contexto.fetchCount(FetchDescriptor<Proveedor>())) ?? 0) > 0
        let hayProductos = ((try? contexto.fetchCount(FetchDescriptor<Producto>())) ?? 0) > 0
        guard !hayProveedores && !hayProductos else { return }

        let proveedores = [
            Proveedor(nombre: "Importaciones Andinas SAC", ruc: "20512345678"),
            Proveedor(nombre: "Distribuidora Lima Norte EIRL", ruc: "20654321987"),
            Proveedor(nombre: "Tecnología del Sur SAC", ruc: "20456789123")
        ]
        let productos = [
            Producto(nombre: "Monitor 24 pulgadas", categoria: "Tecnología", stock: 40, costoPromedio: 110.00),
            Producto(nombre: "Teclado mecánico", categoria: "Accesorios", stock: 12, costoPromedio: 85.00),
            Producto(nombre: "Silla ergonómica", categoria: "Mobiliario", stock: 8, costoPromedio: 320.00),
            Producto(nombre: "Cable HDMI 2 m", categoria: "Accesorios", stock: 4, costoPromedio: 15.00)
        ]
        proveedores.forEach { contexto.insert($0) }
        productos.forEach { contexto.insert($0) }

        do {
            try contexto.save()
        } catch {
            print("Error al cargar datos de ejemplo: \(error)")
        }
    }
}
