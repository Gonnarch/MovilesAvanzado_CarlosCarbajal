import SwiftUI
import SwiftData

/// B6 · Mis compras. ④ El comprador solo ve las suyas (no hay opción de pagar).
struct MisComprasView: View {
    @Environment(Sesion.self) private var sesion

    @Query(sort: \Compra.fecha, order: .reverse) private var compras: [Compra]

    /// Filtramos el arreglo de @Query por el comprador de la sesión
    private var misCompras: [Compra] {
        guard let id = sesion.usuario?.persistentModelID else { return [] }
        return compras.filter { $0.comprador?.persistentModelID == id }
    }

    var body: some View {
        NavigationStack {
            ListaComprasView(compras: misCompras)
                .navigationTitle("Mis compras")
                .conAvatar()
        }
    }
}

/// Supervisor: ver todas las compras de todos los compradores
struct TodasLasComprasView: View {
    @Query(sort: \Compra.fecha, order: .reverse) private var compras: [Compra]

    var body: some View {
        ListaComprasView(compras: compras, mostrarComprador: true)
            .navigationTitle("Todas las compras")
            .navigationBarTitleDisplayMode(.inline)
    }
}
