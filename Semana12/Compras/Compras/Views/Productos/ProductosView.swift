import SwiftUI
import SwiftData

/// B3 · Productos. Comprador: consultar y buscar. Supervisor: crear, editar y borrar.
struct ProductosView: View {
    @Environment(\.modelContext) private var modelContext
    @Environment(Sesion.self) private var sesion

    @Query(sort: \Producto.nombre) private var productos: [Producto]

    @State private var busqueda = ""
    @State private var mostrarNuevo = false
    @State private var productoAEditar: Producto?
    @State private var mensajeBorrado: String?

    private var esSupervisor: Bool { sesion.esSupervisor }

    /// nil desactiva el deslizar para borrar (comprador)
    private var accionBorrar: ((IndexSet) -> Void)? {
        esSupervisor ? { offsets in borrar(offsets: offsets) } : nil
    }

    // ② Búsqueda por nombre o categoría
    private var productosFiltrados: [Producto] {
        guard !busqueda.isEmpty else { return productos }
        return productos.filter {
            $0.nombre.localizedCaseInsensitiveContains(busqueda)
            || $0.categoria.localizedCaseInsensitiveContains(busqueda)
        }
    }

    // ④ Valor del inventario = Σ stock × costo promedio
    private var valorInventario: Double {
        productos.reduce(0) { $0 + $1.valorInventario }
    }

    var body: some View {
        NavigationStack {
            List {
                Section {
                    HStack {
                        Label("Valor del inventario", systemImage: "shippingbox.and.arrow.backward")
                        Spacer()
                        Text(Moneda.formato(valorInventario))
                            .font(.headline)
                            .monospacedDigit()
                    }
                } footer: {
                    Text("Stock × costo promedio de \(productos.count) producto(s).")
                }

                Section("Productos") {
                    ForEach(productosFiltrados) { producto in
                        ProductoFila(producto: producto)
                            .contentShape(Rectangle())
                            .onTapGesture {
                                if esSupervisor { productoAEditar = producto }
                            }
                    }
                    // ⑤ Deslizar para borrar: solo supervisor
                    .onDelete(perform: accionBorrar)
                }
            }
            .overlay {
                if productos.isEmpty {
                    ContentUnavailableView("Sin productos", systemImage: "shippingbox",
                                           description: Text(esSupervisor ? "Pulsa + para crear uno." : "El supervisor aún no registra productos."))
                } else if productosFiltrados.isEmpty {
                    ContentUnavailableView.search(text: busqueda)
                }
            }
            .searchable(text: $busqueda, prompt: "Buscar producto o categoría")
            .navigationTitle("Productos")
            .conAvatar()
            .toolbar {
                // ① Botón + solo supervisor
                if esSupervisor {
                    ToolbarItem(placement: .primaryAction) {
                        Button {
                            mostrarNuevo = true
                        } label: {
                            Label("Nuevo producto", systemImage: "plus")
                        }
                    }
                }
            }
            .sheet(isPresented: $mostrarNuevo) {
                ProductoFormView(producto: nil)
            }
            .sheet(item: $productoAEditar) { producto in
                ProductoFormView(producto: producto)
            }
            .alert("No se puede borrar",
                   isPresented: Binding(get: { mensajeBorrado != nil }, set: { if !$0 { mensajeBorrado = nil } })) {
                Button("Entendido", role: .cancel) { }
            } message: {
                Text(mensajeBorrado ?? "")
            }
        }
    }

    /// Bloqueado si el producto tiene compras (regla .deny)
    private func borrar(offsets: IndexSet) {
        for index in offsets {
            let producto = productosFiltrados[index]
            guard producto.compras.isEmpty else {
                mensajeBorrado = "\"\(producto.nombre)\" tiene \(producto.compras.count) compra(s) registrada(s)."
                return
            }
            modelContext.delete(producto)
        }
        do {
            try modelContext.save()
        } catch {
            modelContext.rollback()
            mensajeBorrado = "No se pudo borrar: \(error.localizedDescription)"
        }
    }
}

/// ③ Fila con costo promedio y stock en color
struct ProductoFila: View {
    let producto: Producto

    var body: some View {
        HStack(spacing: 12) {
            VStack(alignment: .leading, spacing: 4) {
                Text(producto.nombre)
                    .font(.headline)
                Text(producto.categoria)
                    .font(.caption)
                    .foregroundStyle(.secondary)
                Text("Costo prom. \(Moneda.formato(producto.costoPromedio))")
                    .font(.subheadline)
                    .monospacedDigit()
            }
            Spacer()
            VStack(alignment: .trailing, spacing: 4) {
                Text("\(producto.stock) u.")
                    .font(.subheadline.weight(.bold))
                    .monospacedDigit()
                    .padding(.horizontal, 10)
                    .padding(.vertical, 4)
                    .foregroundStyle(.white)
                    .background(NivelStock.color(producto.stock), in: Capsule())
                Text(Moneda.formato(producto.valorInventario))
                    .font(.caption)
                    .foregroundStyle(.secondary)
                    .monospacedDigit()
            }
        }
        .padding(.vertical, 2)
    }
}
