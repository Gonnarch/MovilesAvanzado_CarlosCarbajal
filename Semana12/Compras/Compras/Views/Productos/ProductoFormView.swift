import SwiftUI
import SwiftData

/// Crear o editar un producto (solo supervisor).
/// El stock y el costo promedio se ingresan una sola vez (inventario inicial);
/// después solo cambian al aprobar compras, para no romper el costo promedio.
struct ProductoFormView: View {
    @Environment(\.modelContext) private var modelContext
    @Environment(\.dismiss) private var dismiss

    let producto: Producto?   // nil = nuevo

    @State private var nombre = ""
    @State private var categoria = ""
    @State private var stock = 0
    @State private var costoPromedio = 0.0
    @State private var error: String?

    private var esNuevo: Bool { producto == nil }
    private var valido: Bool {
        !nombre.trimmingCharacters(in: .whitespaces).isEmpty
        && !categoria.trimmingCharacters(in: .whitespaces).isEmpty
        && stock >= 0 && costoPromedio >= 0
    }

    var body: some View {
        NavigationStack {
            Form {
                Section("Producto") {
                    TextField("Nombre", text: $nombre)
                    TextField("Categoría", text: $categoria)
                }

                Section {
                    if esNuevo {
                        Stepper(value: $stock, in: 0...100_000) {
                            HStack {
                                Text("Stock inicial")
                                Spacer()
                                TextField("0", value: $stock, format: .number)
                                    .keyboardType(.numberPad)
                                    .multilineTextAlignment(.trailing)
                                    .frame(width: 80)
                            }
                        }
                        HStack {
                            Text("Costo promedio S/")
                            Spacer()
                            TextField("0.00", value: $costoPromedio, format: .number.precision(.fractionLength(2)))
                                .keyboardType(.decimalPad)
                                .multilineTextAlignment(.trailing)
                                .frame(width: 120)
                        }
                    } else if let producto {
                        LabeledContent("Stock", value: "\(producto.stock) u.")
                        LabeledContent("Costo promedio", value: Moneda.formato(producto.costoPromedio))
                        LabeledContent("Compras registradas", value: "\(producto.compras.count)")
                    }
                } header: {
                    Text("Inventario")
                } footer: {
                    Text(esNuevo
                         ? "Después, el stock y el costo promedio cambian solo al aprobar compras."
                         : "El stock y el costo promedio se actualizan al aprobar compras.")
                }

                if let error {
                    Section { Text(error).foregroundStyle(.red) }
                }
            }
            .navigationTitle(esNuevo ? "Nuevo producto" : "Editar producto")
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
                if let producto {
                    nombre = producto.nombre
                    categoria = producto.categoria
                    stock = producto.stock
                    costoPromedio = producto.costoPromedio
                }
            }
        }
    }

    private func guardar() {
        let nombreLimpio = nombre.trimmingCharacters(in: .whitespaces)
        let categoriaLimpia = categoria.trimmingCharacters(in: .whitespaces)
        if let producto {
            producto.nombre = nombreLimpio
            producto.categoria = categoriaLimpia
        } else {
            let nuevo = Producto(nombre: nombreLimpio, categoria: categoriaLimpia,
                                 stock: stock, costoPromedio: ReglasCompra.redondear(costoPromedio))
            modelContext.insert(nuevo)
        }
        do {
            try modelContext.save()
            dismiss()
        } catch {
            self.error = "No se pudo guardar: \(error.localizedDescription)"
        }
    }
}
