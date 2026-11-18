import SwiftUI
import SwiftData
import Charts

/// B9 · Resumen del supervisor
struct ResumenView: View {
    @Environment(Sesion.self) private var sesion

    @Query private var productos: [Producto]
    @Query private var compras: [Compra]
    @Query(sort: \Proveedor.nombre) private var proveedores: [Proveedor]

    // MARK: - Indicadores

    private var aprobadas: [Compra] { compras.filter { $0.estadoCompra == .aprobada } }
    private var pendientes: [Compra] { compras.filter { $0.estadoCompra == .pendiente } }

    /// ② Valor del inventario = Σ stock × costo promedio
    private var valorInventario: Double { productos.reduce(0) { $0 + $1.valorInventario } }
    /// ③ Crédito fiscal = Σ IGV de las compras aprobadas
    private var creditoFiscal: Double { aprobadas.reduce(0) { $0 + $1.igv } }
    /// Por pagar = compras a crédito aprobadas y no pagadas
    private var porPagar: Double { compras.filter(\.esPorPagar).reduce(0) { $0 + $1.total } }
    private var vencidas: Int { compras.filter(\.estaVencida).count }
    /// ④ Compras por aprobar
    private var importePorAprobar: Double { pendientes.reduce(0) { $0 + $1.total } }

    /// ⑤ Total comprado por proveedor (solo aprobadas), de mayor a menor
    private var totalesPorProveedor: [TotalProveedor] {
        proveedores
            .map { TotalProveedor(nombre: $0.nombre, total: $0.totalComprado) }
            .filter { $0.total > 0 }
            .sorted { $0.total > $1.total }
    }

    private let columnas = [GridItem(.flexible(), spacing: 12), GridItem(.flexible(), spacing: 12)]

    var body: some View {
        NavigationStack {
            ScrollView {
                VStack(alignment: .leading, spacing: 16) {
                    // ① Avatar de la sesión con saludo
                    if let usuario = sesion.usuario {
                        HStack(spacing: 12) {
                            AvatarCircle(usuario: usuario, tamano: 48)
                            VStack(alignment: .leading) {
                                Text("Hola, \(usuario.nombre.split(separator: " ").first.map(String.init) ?? usuario.nombre)")
                                    .font(.title3.bold())
                                Text(usuario.rol).font(.subheadline).foregroundStyle(.secondary)
                            }
                        }
                    }

                    LazyVGrid(columns: columnas, spacing: 12) {
                        TarjetaIndicador(titulo: "Valor del inventario",
                                         valor: Moneda.formato(valorInventario),
                                         detalle: "\(productos.count) producto(s)",
                                         icono: "shippingbox.fill", color: .blue)
                        TarjetaIndicador(titulo: "Crédito fiscal (IGV)",
                                         valor: Moneda.formato(creditoFiscal),
                                         detalle: "\(aprobadas.count) compra(s) aprobada(s)",
                                         icono: "percent", color: .purple)
                        TarjetaIndicador(titulo: "Por pagar",
                                         valor: Moneda.formato(porPagar),
                                         detalle: vencidas > 0 ? "\(vencidas) vencida(s)" : "Ninguna vencida",
                                         icono: "creditcard.fill", color: vencidas > 0 ? .red : .orange)
                        TarjetaIndicador(titulo: "Por aprobar",
                                         valor: Moneda.formato(importePorAprobar),
                                         detalle: "\(pendientes.count) compra(s)",
                                         icono: "hourglass", color: .teal)
                    }

                    // ⑤ Total comprado por proveedor con barras
                    VStack(alignment: .leading, spacing: 10) {
                        Text("Total comprado por proveedor").font(.headline)
                        if totalesPorProveedor.isEmpty {
                            Text("Aún no hay compras aprobadas.")
                                .font(.subheadline)
                                .foregroundStyle(.secondary)
                        } else {
                            Chart(totalesPorProveedor) { fila in
                                BarMark(x: .value("Total", fila.total),
                                        y: .value("Proveedor", fila.nombre))
                                    .foregroundStyle(Color.accentColor.gradient)
                                    .annotation(position: .trailing) {
                                        Text(Moneda.formato(fila.total))
                                            .font(.caption2)
                                            .foregroundStyle(.secondary)
                                    }
                            }
                            .chartXAxis(.hidden)
                            .frame(height: CGFloat(max(totalesPorProveedor.count, 1)) * 52)
                        }
                    }
                    .padding()
                    .background(Color(.secondarySystemGroupedBackground), in: RoundedRectangle(cornerRadius: 16))

                    // Dato para el cierre conjunto de IGV con el Grupo A
                    VStack(alignment: .leading, spacing: 6) {
                        Label("Cierre de IGV del mes", systemImage: "doc.text.magnifyingglass")
                            .font(.headline)
                        Text("IGV por pagar = IGV de ventas (Grupo A) − crédito fiscal de compras.")
                            .font(.subheadline)
                            .foregroundStyle(.secondary)
                        Text("Crédito fiscal a llevar: \(Moneda.formato(creditoFiscal))")
                            .font(.subheadline.bold())
                            .monospacedDigit()
                    }
                    .padding()
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .background(Color(.secondarySystemGroupedBackground), in: RoundedRectangle(cornerRadius: 16))
                }
                .padding()
            }
            .background(Color(.systemGroupedBackground))
            .navigationTitle("Resumen")
            .conAvatar()
        }
    }
}

/// Dato para el gráfico de barras
struct TotalProveedor: Identifiable {
    let nombre: String
    let total: Double
    var id: String { nombre }
}

struct TarjetaIndicador: View {
    let titulo: String
    let valor: String
    let detalle: String
    let icono: String
    let color: Color

    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            Image(systemName: icono)
                .font(.headline)
                .foregroundStyle(.white)
                .frame(width: 32, height: 32)
                .background(color.gradient, in: RoundedRectangle(cornerRadius: 8))
            Text(titulo)
                .font(.caption)
                .foregroundStyle(.secondary)
            Text(valor)
                .font(.headline)
                .monospacedDigit()
                .minimumScaleFactor(0.7)
                .lineLimit(1)
            Text(detalle)
                .font(.caption2)
                .foregroundStyle(.secondary)
        }
        .padding()
        .frame(maxWidth: .infinity, alignment: .leading)
        .background(Color(.secondarySystemGroupedBackground), in: RoundedRectangle(cornerRadius: 16))
    }
}
