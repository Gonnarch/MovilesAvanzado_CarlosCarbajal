import SwiftUI
import SwiftData

/// Crear o editar un proveedor (solo supervisor). El RUC debe tener 11 dígitos.
struct ProveedorFormView: View {
    @Environment(\.modelContext) private var modelContext
    @Environment(\.dismiss) private var dismiss

    let proveedor: Proveedor?   // nil = nuevo

    @State private var nombre = ""
    @State private var ruc = ""
    @State private var error: String?

    private var rucValido: Bool { ruc.count == 11 && ruc.allSatisfy(\.isNumber) }
    private var valido: Bool { !nombre.trimmingCharacters(in: .whitespaces).isEmpty && rucValido }

    var body: some View {
        NavigationStack {
            Form {
                Section("Proveedor") {
                    TextField("Razón social", text: $nombre)
                }
                Section {
                    TextField("RUC", text: $ruc)
                        .keyboardType(.numberPad)
                } header: {
                    Text("RUC")
                } footer: {
                    if !ruc.isEmpty && !rucValido {
                        Text("El RUC debe tener 11 dígitos").foregroundStyle(.red)
                    } else {
                        Text("11 dígitos.")
                    }
                }
                if let proveedor {
                    Section("Compras") {
                        LabeledContent("Registradas", value: "\(proveedor.compras.count)")
                        LabeledContent("Total comprado", value: Moneda.formato(proveedor.totalComprado))
                        LabeledContent("Por pagar", value: Moneda.formato(proveedor.porPagar))
                    }
                }
                if let error {
                    Section { Text(error).foregroundStyle(.red) }
                }
            }
            .navigationTitle(proveedor == nil ? "Nuevo proveedor" : "Editar proveedor")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .cancellationAction) {
                    Button("Cancelar") { dismiss() }
                }
                ToolbarItem(placement: .confirmationAction) {
                    Button("Guardar") { guardar() }
                        .disabled(!valido)
                }
            }
            .onAppear {
                if let proveedor {
                    nombre = proveedor.nombre
                    ruc = proveedor.ruc
                }
            }
        }
    }

    private func guardar() {
        let nombreLimpio = nombre.trimmingCharacters(in: .whitespaces)
        if let proveedor {
            proveedor.nombre = nombreLimpio
            proveedor.ruc = ruc
        } else {
            modelContext.insert(Proveedor(nombre: nombreLimpio, ruc: ruc))
        }
        do {
            try modelContext.save()
            dismiss()
        } catch {
            self.error = "No se pudo guardar: \(error.localizedDescription)"
        }
    }
}
