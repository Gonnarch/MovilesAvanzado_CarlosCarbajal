import SwiftUI

/// Filtro de B6: Todas / Pendientes / Rechazadas
enum FiltroCompras: String, CaseIterable, Identifiable {
    case todas = "Todas"
    case pendientes = "Pendientes"
    case rechazadas = "Rechazadas"

    var id: String { rawValue }

    func incluye(_ compra: Compra) -> Bool {
        switch self {
        case .todas: return true
        case .pendientes: return compra.estadoCompra == .pendiente
        case .rechazadas: return compra.estadoCompra == .rechazada
        }
    }
}

/// Lista con segmented y búsqueda por proveedor. Recibe las compras ya filtradas por rol.
struct ListaComprasView: View {
    let compras: [Compra]
    var mostrarComprador = false

    @State private var filtro: FiltroCompras = .todas
    @State private var busqueda = ""

    private var visibles: [Compra] {
        compras.filter { compra in
            filtro.incluye(compra)
            && (busqueda.isEmpty
                || (compra.proveedor?.nombre.localizedCaseInsensitiveContains(busqueda) ?? false))
        }
    }

    var body: some View {
        List {
            // ① Segmented Todas / Pendientes / Rechazadas
            Section {
                Picker("Filtro", selection: $filtro) {
                    ForEach(FiltroCompras.allCases) { Text($0.rawValue).tag($0) }
                }
                .pickerStyle(.segmented)
                .listRowBackground(Color.clear)
                .listRowInsets(EdgeInsets())
            }

            Section("\(visibles.count) compra(s)") {
                ForEach(visibles) { compra in
                    CompraFila(compra: compra, mostrarComprador: mostrarComprador)
                }
            }
        }
        .overlay {
            if visibles.isEmpty {
                ContentUnavailableView(busqueda.isEmpty ? "Sin compras" : "Sin resultados",
                                       systemImage: "tray",
                                       description: Text(busqueda.isEmpty ? "No hay compras en \(filtro.rawValue.lowercased())." : "Ningún proveedor coincide con \"\(busqueda)\"."))
            }
        }
        .searchable(text: $busqueda, prompt: "Buscar por proveedor")
    }
}
