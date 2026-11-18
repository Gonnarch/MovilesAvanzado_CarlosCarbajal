import SwiftUI

/// Pestañas según el rol del usuario de la sesión.
/// Comprador:  Productos, Proveedores, Compra, Mis compras
/// Supervisor: Resumen, Aprobar, Por pagar, Productos, Proveedores
struct MainTabView: View {
    let usuario: Usuario

    var body: some View {
        TabView {
            if usuario.esSupervisor {
                ResumenView()
                    .tabItem { Label("Resumen", systemImage: "chart.bar.xaxis") }
                AprobarView()
                    .tabItem { Label("Aprobar", systemImage: "checkmark.seal") }
                PorPagarView()
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
                MisComprasView()
                    .tabItem { Label("Mis compras", systemImage: "list.bullet.rectangle") }
            }
        }
    }
}
