import SwiftUI
import SwiftData

/// B5 · Registrar compra (Comprador)
struct NuevaCompraView: View {
    @Environment(\.modelContext) private var modelContext
    @Environment(Sesion.self) private var sesion

    @Query(sort: \Proveedor.nombre) private var proveedores: [Proveedor]
    @Query(sort: \Producto.nombre) private var productos: [Producto]

    @State private var proveedor: Proveedor?
    @State private var producto: Producto?
    @State private var cantidad = 1
    @State private var costoUnitario = 0.0
    @State private var alCredito = false

    @State private var mensaje: String?
    @State private var tituloMensaje = ""

    // MARK: - Cálculo en vivo

    private var subtotal: Double { ReglasCompra.subtotal(cantidad: cantidad, costoUnitario: costoUnitario) }
    private var igv: Double { ReglasCompra.igv(subtotal: subtotal) }
    private var total: Double { ReglasCompra.total(subtotal: subtotal, igv: igv) }
    private var requiereAprobacion: Bool { ReglasCompra.requiereAprobacion(total: total) }

    private var formularioValido: Bool {
        proveedor != nil && producto != nil && cantidad > 0 && costoUnitario > 0
    }

    var body: some View {
        NavigationStack {
            Form {
                // ① Avatar de la sesión (también en la barra con el menú Cerrar sesión)
                if let usuario = sesion.usuario {
                    Section {
                        HStack(spacing: 12) {
                            AvatarCircle(usuario: usuario, tamano: 40)
                            VStack(alignment: .leading) {
                                Text(usuario.nombre).font(.headline)
                                Text("Comprador de la sesión").font(.caption).foregroundStyle(.secondary)
                            }
                        }
                    }
                }

                // ② Proveedor
                Section("Proveedor") {
                    Picker("Proveedor", selection: $proveedor) {
                        Text("Selecciona…").tag(nil as Proveedor?)
                        ForEach(proveedores) { p in
                            Text(p.nombre).tag(p as Proveedor?)
                        }
                    }
                }

                // ③ Producto
                Section {
                    Picker("Producto", selection: $producto) {
                        Text("Selecciona…").tag(nil as Producto?)
                        ForEach(productos) { p in
                            Text(p.nombre).tag(p as Producto?)
                        }
                    }
                } header: {
                    Text("Producto")
                } footer: {
                    if let producto {
                        Text("Stock actual \(producto.stock) u. · costo promedio \(Moneda.formato(producto.costoPromedio))")
                    }
                }

                // ④ Cantidad y costo unitario
                Section("Cantidad y costo") {
                    Stepper(value: $cantidad, in: 1...100_000) {
                        HStack {
                            Text("Cantidad")
                            Spacer()
                            TextField("1", value: $cantidad, format: .number)
                                .keyboardType(.numberPad)
                                .multilineTextAlignment(.trailing)
                                .frame(width: 80)
                        }
                    }
                    HStack {
                        Text("Costo unitario S/")
                        Spacer()
                        TextField("0.00", value: $costoUnitario, format: .number.precision(.fractionLength(2)))
                            .keyboardType(.decimalPad)
                            .multilineTextAlignment(.trailing)
                            .frame(width: 120)
                    }
                }

                // ⑤ Contado o Crédito 30 días
                Section {
                    Picker("Forma de pago", selection: $alCredito) {
                        Text("Contado").tag(false)
                        Text("Crédito 30 días").tag(true)
                    }
                    .pickerStyle(.segmented)
                } header: {
                    Text("Forma de pago")
                } footer: {
                    if alCredito {
                        Text("Vence el \(Fecha.corta(ReglasCompra.fechaVencimiento(desde: .now))). Queda pendiente de pago.")
                    } else {
                        Text("Al contado la compra queda pagada.")
                    }
                }

                // Resumen calculado
                Section("Resumen") {
                    LabeledContent("Subtotal", value: Moneda.formato(subtotal))
                    LabeledContent("IGV 18 % (crédito fiscal)", value: Moneda.formato(igv))
                    LabeledContent {
                        Text(Moneda.formato(total)).font(.headline)
                    } label: {
                        Text("Total").font(.headline)
                    }
                }
                .monospacedDigit()

                // ⑥ Aviso cuando el total llega a S/ 5,000
                if requiereAprobacion {
                    Section {
                        Label {
                            Text("El total llega a \(Moneda.formato(ReglasCompra.limiteAprobacion)). La compra quedará **Pendiente** hasta que el supervisor la apruebe; mientras tanto no cambia el stock ni el costo promedio.")
                        } icon: {
                            Image(systemName: "exclamationmark.shield.fill")
                        }
                        .foregroundStyle(.orange)
                        .font(.subheadline)
                    }
                }

                // ⑦ Enviar a aprobación / Registrar compra
                Section {
                    Button {
                        registrar()
                    } label: {
                        Text(requiereAprobacion ? "Enviar a aprobación" : "Registrar compra")
                            .font(.headline)
                            .frame(maxWidth: .infinity)
                    }
                    .disabled(!formularioValido)
                }
            }
            .navigationTitle("Nueva compra")
            .conAvatar()
            .onChange(of: producto) {
                // Sugerir el costo promedio actual como costo unitario
                if let producto, costoUnitario == 0 { costoUnitario = producto.costoPromedio }
            }
            .alert(tituloMensaje,
                   isPresented: Binding(get: { mensaje != nil }, set: { if !$0 { mensaje = nil } })) {
                Button("OK", role: .cancel) { }
            } message: {
                Text(mensaje ?? "")
            }
        }
    }

    private func registrar() {
        guard let usuario = sesion.usuario else { return }
        do {
            let compra = try ServicioCompras.registrar(cantidad: cantidad,
                                                       costoUnitario: costoUnitario,
                                                       alCredito: alCredito,
                                                       producto: producto,
                                                       proveedor: proveedor,
                                                       comprador: usuario,
                                                       en: modelContext)
            if compra.estadoCompra == .pendiente {
                tituloMensaje = "Enviada a aprobación"
                mensaje = "Total \(Moneda.formato(compra.total)). El supervisor debe aprobarla."
            } else {
                tituloMensaje = "Compra registrada"
                let pago = compra.alCredito ? "vence el \(Fecha.corta(compra.vence))" : "pagada al contado"
                mensaje = "Total \(Moneda.formato(compra.total)) · Aprobada · \(pago).\nStock: \(compra.producto?.stock ?? 0) u. · costo promedio \(Moneda.formato(compra.producto?.costoPromedio ?? 0))."
            }
            limpiar()
        } catch {
            tituloMensaje = "No se pudo registrar"
            mensaje = error.localizedDescription
        }
    }

    private func limpiar() {
        producto = nil
        cantidad = 1
        costoUnitario = 0
        alCredito = false
    }
}
