import SwiftUI
import SwiftData

/// B7 · Aprobar compras grandes (Supervisor)
struct AprobarView: View {
    @Environment(\.modelContext) private var modelContext
    @Environment(Sesion.self) private var sesion

    // Solo compras Pendientes (las de S/ 5,000 o más), la más antigua primero
    @Query(filter: #Predicate<Compra> { $0.estado == "Pendiente" }, sort: \Compra.fecha)
    private var pendientes: [Compra]

    @State private var compraARechazar: Compra?
    @State private var mensaje: String?

    var body: some View {
        NavigationStack {
            ScrollView {
                LazyVStack(spacing: 16) {
                    if !pendientes.isEmpty {
                        Text("\(pendientes.count) compra(s) por aprobar · \(Moneda.formato(pendientes.reduce(0) { $0 + $1.total }))")
                            .font(.subheadline)
                            .foregroundStyle(.secondary)
                            .frame(maxWidth: .infinity, alignment: .leading)
                    }
                    ForEach(pendientes) { compra in
                        TarjetaAprobacion(compra: compra,
                                          aprobar: { aprobar(compra) },
                                          rechazar: { compraARechazar = compra })
                    }
                }
                .padding()
            }
            .background(Color(.systemGroupedBackground))
            .overlay {
                if pendientes.isEmpty {
                    ContentUnavailableView("Nada por aprobar", systemImage: "checkmark.seal",
                                           description: Text("Las compras de S/ 5,000 o más aparecerán aquí."))
                }
            }
            .navigationTitle("Aprobar")
            .conAvatar() // ① Avatar de la sesión
            .toolbar {
                ToolbarItem(placement: .primaryAction) {
                    NavigationLink {
                        TodasLasComprasView()
                    } label: {
                        Label("Ver todas", systemImage: "list.bullet")
                    }
                }
            }
            .sheet(item: $compraARechazar) { compra in
                RechazoView(compra: compra)
            }
            .alert("Aviso",
                   isPresented: Binding(get: { mensaje != nil }, set: { if !$0 { mensaje = nil } })) {
                Button("OK", role: .cancel) { }
            } message: {
                Text(mensaje ?? "")
            }
        }
    }

    private func aprobar(_ compra: Compra) {
        do {
            try withAnimation {
                try ServicioCompras.aprobar(compra, por: sesion.usuario, en: modelContext)
            }
        } catch {
            mensaje = error.localizedDescription
        }
    }
}

/// ② Tarjeta de la compra pendiente con quién la solicitó
/// ③ Vista previa del efecto: stock y costo promedio antes y después
/// ④ Rechazar (pide motivo) o Aprobar
struct TarjetaAprobacion: View {
    let compra: Compra
    let aprobar: () -> Void
    let rechazar: () -> Void

    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            HStack(spacing: 10) {
                if let comprador = compra.comprador {
                    AvatarCircle(usuario: comprador, tamano: 36)
                    VStack(alignment: .leading) {
                        Text("Solicitó \(comprador.nombre)").font(.subheadline.weight(.semibold))
                        Text(Fecha.corta(compra.fecha)).font(.caption).foregroundStyle(.secondary)
                    }
                }
                Spacer()
                Insignia(texto: "Pendiente", color: .orange)
            }

            Divider()

            VStack(alignment: .leading, spacing: 4) {
                Text(compra.producto?.nombre ?? "Producto").font(.headline)
                Text(compra.proveedor?.nombre ?? "Proveedor").font(.subheadline).foregroundStyle(.secondary)
                Text("\(compra.cantidad) × \(Moneda.formato(compra.costoUnitario)) · \(compra.alCredito ? "Crédito 30 días" : "Contado")")
                    .font(.subheadline)
            }

            Grid(alignment: .leading, horizontalSpacing: 12, verticalSpacing: 4) {
                GridRow {
                    Text("Subtotal").foregroundStyle(.secondary)
                    Text(Moneda.formato(compra.subtotal))
                }
                GridRow {
                    Text("IGV 18 %").foregroundStyle(.secondary)
                    Text(Moneda.formato(compra.igv))
                }
                GridRow {
                    Text("Total").bold()
                    Text(Moneda.formato(compra.total)).bold()
                }
            }
            .font(.subheadline)
            .monospacedDigit()

            if let efecto = ServicioCompras.efecto(de: compra) {
                VStack(alignment: .leading, spacing: 6) {
                    Text("Si se aprueba").font(.caption.weight(.semibold)).foregroundStyle(.secondary)
                    FilaAntesDespues(titulo: "Stock",
                                     antes: "\(efecto.stockAntes) u.",
                                     despues: "\(efecto.stockDespues) u.")
                    FilaAntesDespues(titulo: "Costo promedio",
                                     antes: Moneda.formato(efecto.costoAntes),
                                     despues: Moneda.formato(efecto.costoDespues))
                }
                .padding(10)
                .frame(maxWidth: .infinity, alignment: .leading)
                .background(Color.accentColor.opacity(0.08), in: RoundedRectangle(cornerRadius: 10))
            }

            HStack(spacing: 12) {
                Button(role: .destructive, action: rechazar) {
                    Label("Rechazar", systemImage: "xmark")
                        .frame(maxWidth: .infinity)
                }
                .buttonStyle(.bordered)

                Button(action: aprobar) {
                    Label("Aprobar", systemImage: "checkmark")
                        .frame(maxWidth: .infinity)
                }
                .buttonStyle(.borderedProminent)
                .tint(.green)
            }
        }
        .padding()
        .background(Color(.secondarySystemGroupedBackground), in: RoundedRectangle(cornerRadius: 16))
    }
}

struct FilaAntesDespues: View {
    let titulo: String
    let antes: String
    let despues: String

    var body: some View {
        HStack {
            Text(titulo)
            Spacer()
            Text(antes).foregroundStyle(.secondary)
            Image(systemName: "arrow.right").font(.caption)
            Text(despues).bold()
        }
        .font(.subheadline)
        .monospacedDigit()
    }
}

/// Rechazo con motivo obligatorio: el botón está desactivado mientras el motivo esté vacío
struct RechazoView: View {
    @Environment(\.modelContext) private var modelContext
    @Environment(\.dismiss) private var dismiss
    @Environment(Sesion.self) private var sesion

    let compra: Compra

    @State private var motivo = ""
    @State private var error: String?

    private var motivoVacio: Bool { motivo.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty }

    var body: some View {
        NavigationStack {
            Form {
                Section("Compra") {
                    LabeledContent("Producto", value: compra.producto?.nombre ?? "-")
                    LabeledContent("Solicitó", value: compra.comprador?.nombre ?? "-")
                    LabeledContent("Total", value: Moneda.formato(compra.total))
                }
                Section {
                    TextField("Ej.: precio por encima del mercado", text: $motivo, axis: .vertical)
                        .lineLimit(3...6)
                } header: {
                    Text("Motivo del rechazo")
                } footer: {
                    Text("Obligatorio. El comprador verá este motivo. Rechazar no cambia el stock ni el costo promedio.")
                }
                if let error {
                    Section { Text(error).foregroundStyle(.red) }
                }
            }
            .navigationTitle("Rechazar compra")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .cancellationAction) {
                    Button("Cancelar") { dismiss() }
                }
                ToolbarItem(placement: .confirmationAction) {
                    Button("Rechazar", role: .destructive) { rechazar() }
                        .disabled(motivoVacio)
                }
            }
        }
        .presentationDetents([.medium, .large])
    }

    private func rechazar() {
        do {
            try ServicioCompras.rechazar(compra, motivo: motivo, por: sesion.usuario, en: modelContext)
            dismiss()
        } catch {
            self.error = error.localizedDescription
        }
    }
}
