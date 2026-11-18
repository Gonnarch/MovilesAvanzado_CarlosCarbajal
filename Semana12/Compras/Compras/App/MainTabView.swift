import SwiftUI

/// Pestañas según el rol del usuario de la sesión.
/// Comprador:  Productos, Proveedores, Compra, Mis compras
/// Supervisor: Resumen, Aprobar, Por pagar, Productos, Proveedores
struct MainTabView: View {
    let usuario: Usuario

    var body: some View {
        TabView {
            if usuario.esSupervisor {
                PantallaPendiente(titulo: "Resumen")
                    .tabItem { Label("Resumen", systemImage: "chart.bar.xaxis") }
                PantallaPendiente(titulo: "Aprobar")
                    .tabItem { Label("Aprobar", systemImage: "checkmark.seal") }
                PantallaPendiente(titulo: "Por pagar")
                    .tabItem { Label("Por pagar", systemImage: "creditcard") }
                ProductosView()
                    .tabItem { Label("Productos", systemImage: "shippingbox") }
                ProveedoresView()
                    .tabItem { Label("Proveedores", systemImage: "building.2") }
            } else {
                ProductosView()
                    .tabItem { Label("Productos", systemImage: "shippingbox") }
                ProveedoresView()
                    .tabItem { Label("Proveedores", systemImage: "building.2") }
                NuevaCompraView()
                    .tabItem { Label("Compra", systemImage: "cart.badge.plus") }
                PantallaPendiente(titulo: "Mis compras")
                    .tabItem { Label("Mis compras", systemImage: "list.bullet.rectangle") }
            }
        }
    }
}

/// Marcador temporal mientras se construye cada pantalla.
struct PantallaPendiente: View {
    let titulo: String

    var body: some View {
        NavigationStack {
            ContentUnavailableView(titulo, systemImage: "hammer",
                                   description: Text("Pantalla en construcción"))
                .navigationTitle(titulo)
                .conAvatar()
        }
    }
}
