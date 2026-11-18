import SwiftUI
import SwiftData

/// B4 · Proveedores. Comprador: consultar y buscar. Supervisor: crear, editar y borrar.
struct ProveedoresView: View {
    @Environment(\.modelContext) private var modelContext
    @Environment(Sesion.self) private var sesion

    @Query(sort: \Proveedor.nombre) private var proveedores: [Proveedor]

    @State private var busqueda = ""
    @State private var mostrarNuevo = false
    @State private var proveedorAEditar: Proveedor?
    @State private var mensajeBorrado: String?

    private var esSupervisor: Bool { sesion.esSupervisor }

    private var accionBorrar: ((IndexSet) -> Void)? {
        esSupervisor ? { offsets in borrar(offsets: offsets) } : nil
    }

    private var proveedoresFiltrados: [Proveedor] {
        guard !busqueda.isEmpty else { return proveedores }
        return proveedores.filter {
            $0.nombre.localizedCaseInsensitiveContains(busqueda) || $0.ruc.contains(busqueda)
        }
    }

    var body: some View {
        NavigationStack {
            List {
                ForEach(proveedoresFiltrados) { proveedor in
                    ProveedorFila(proveedor: proveedor)
                        .contentShape(Rectangle())
                        .onTapGesture {
                            if esSupervisor { proveedorAEditar = proveedor }
                        }
                }
                .onDelete(perform: accionBorrar)
            }
            .overlay {
                if proveedores.isEmpty {
                    ContentUnavailableView("Sin proveedores", systemImage: "building.2",
                                           description: Text(esSupervisor ? "Pulsa + para crear uno." : "El supervisor aún no registra proveedores."))
                } else if proveedoresFiltrados.isEmpty {
                    ContentUnavailableView.search(text: busqueda)
                }
            }
            .searchable(text: $busqueda, prompt: "Buscar por nombre o RUC")
            .navigationTitle("Proveedores")
            .conAvatar()
            .toolbar {
                // ① Botón + solo supervisor
                if esSupervisor {
                    ToolbarItem(placement: .primaryAction) {
                        Button {
                            mostrarNuevo = true
                        } label: {
                            Label("Nuevo proveedor", systemImage: "plus")
                        }
                    }
                }
            }
            .sheet(isPresented: $mostrarNuevo) {
                ProveedorFormView(proveedor: nil)
            }
            .sheet(item: $proveedorAEditar) { proveedor in
                ProveedorFormView(proveedor: proveedor)
            }
            .alert("No se puede borrar",
                   isPresented: Binding(get: { mensajeBorrado != nil }, set: { if !$0 { mensajeBorrado = nil } })) {
                Button("Entendido", role: .cancel) { }
            } message: {
                Text(mensajeBorrado ?? "")
            }
        }
    }

    /// Bloqueado si el proveedor tiene compras (regla .deny)
    private func borrar(offsets: IndexSet) {
        for index in offsets {
            let proveedor = proveedoresFiltrados[index]
            guard proveedor.compras.isEmpty else {
                mensajeBorrado = "\"\(proveedor.nombre)\" tiene \(proveedor.compras.count) compra(s) registrada(s)."
                return
            }
            modelContext.delete(proveedor)
        }
        do {
            try modelContext.save()
        } catch {
            modelContext.rollback()
            mensajeBorrado = "No se pudo borrar: \(error.localizedDescription)"
        }
    }
}

/// ② Fila con insignia "Por pagar" o "Al día" y total comprado
/// ③ Valores calculados desde las compras del proveedor
struct ProveedorFila: View {
    let proveedor: Proveedor

    var body: some View {
        HStack(spacing: 12) {
            Image(systemName: "building.2.fill")
                .foregroundStyle(.white)
                .frame(width: 38, height: 38)
                .background(Color.accentColor.gradient, in: RoundedRectangle(cornerRadius: 10))

            VStack(alignment: .leading, spacing: 4) {
                Text(proveedor.nombre)
                    .font(.headline)
                Text("RUC \(proveedor.ruc)")
                    .font(.caption)
                    .foregroundStyle(.secondary)
                if proveedor.estaAlDia {
                    Insignia(texto: "Al día", color: .green)
                } else {
                    Insignia(texto: "Por pagar \(Moneda.formato(proveedor.porPagar))", color: .orange)
                }
            }
            Spacer()
            VStack(alignment: .trailing, spacing: 2) {
                Text("Comprado")
                    .font(.caption2)
                    .foregroundStyle(.secondary)
                Text(Moneda.formato(proveedor.totalComprado))
                    .font(.subheadline.weight(.semibold))
                    .monospacedDigit()
            }
        }
        .padding(.vertical, 2)
    }
}
