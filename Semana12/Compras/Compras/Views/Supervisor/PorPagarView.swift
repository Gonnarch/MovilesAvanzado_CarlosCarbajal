import SwiftUI
import SwiftData

/// Filtro de B8: Pendientes / Vencidas / Pagadas
enum FiltroPago: String, CaseIterable, Identifiable {
    case pendientes = "Pendientes"
    case vencidas = "Vencidas"
    case pagadas = "Pagadas"

    var id: String { rawValue }

    /// Cada filtro es un #Predicate que SwiftData resuelve en la base de datos.
    /// Solo cuentan las compras a crédito y Aprobadas (las pendientes de aprobación no suman).
    func predicado(ahora: Date) -> Predicate<Compra> {
        let aprobada = EstadoCompra.aprobada.rawValue
        switch self {
        case .pendientes:
            return #Predicate<Compra> { $0.alCredito == true && $0.pagada == false && $0.estado == aprobada }
        case .vencidas:
            return #Predicate<Compra> { $0.alCredito == true && $0.pagada == false && $0.estado == aprobada && $0.vence < ahora }
        case .pagadas:
            return #Predicate<Compra> { $0.alCredito == true && $0.pagada == true && $0.estado == aprobada }
        }
    }
}

/// B8 · Cuentas por pagar (Supervisor)
struct PorPagarView: View {
    @Environment(\.modelContext) private var modelContext
    @Environment(Sesion.self) private var sesion

    // ⑤ Total por pagar: todas las compras a crédito aprobadas y no pagadas
    @Query(filter: #Predicate<Compra> { $0.alCredito == true && $0.pagada == false && $0.estado == "Aprobada" })
    private var porPagar: [Compra]

    @State private var filtro: FiltroPago = .pendientes
    @State private var busqueda = ""
    @State private var mensaje: String?

    private var totalPorPagar: Double { porPagar.reduce(0) { $0 + $1.total } }
    private var vencidas: Int { porPagar.filter(\.estaVencida).count }

    var body: some View {
        NavigationStack {
            VStack(spacing: 0) {
                // ⑤ Total por pagar
                HStack {
                    VStack(alignment: .leading, spacing: 2) {
                        Text("Total por pagar").font(.caption).foregroundStyle(.secondary)
                        Text(Moneda.formato(totalPorPagar))
                            .font(.title2.bold())
                            .monospacedDigit()
                    }
                    Spacer()
                    VStack(alignment: .trailing, spacing: 4) {
                        Text("\(porPagar.count) pendiente(s)").font(.caption)
                        if vencidas > 0 {
                            Insignia(texto: "\(vencidas) VENCIDA(S)", color: .red)
                        }
                    }
                }
                .padding()
                .background(Color(.secondarySystemGroupedBackground))

                // ① Segmented Pendientes / Vencidas / Pagadas
                Picker("Filtro", selection: $filtro) {
                    ForEach(FiltroPago.allCases) { Text($0.rawValue).tag($0) }
                }
                .pickerStyle(.segmented)
                .padding([.horizontal, .bottom])
                .background(Color(.secondarySystemGroupedBackground))

                // La lista se vuelve a crear con otro #Predicate al cambiar el filtro
                ListaPorPagar(filtro: filtro, busqueda: busqueda, pagar: pagar)
                    .id(filtro)
            }
            .searchable(text: $busqueda, prompt: "Buscar por proveedor")
            .navigationTitle("Por pagar")
            .conAvatar()
            #if DEBUG
            .toolbar {
                ToolbarItem(placement: .primaryAction) {
                    Menu {
                        Button("Crear compra vencida (caso 8)") { crearCompraVencidaDePrueba() }
                    } label: {
                        Label("Pruebas", systemImage: "testtube.2")
                    }
                }
            }
            #endif
            .alert("Aviso",
                   isPresented: Binding(get: { mensaje != nil }, set: { if !$0 { mensaje = nil } })) {
                Button("OK", role: .cancel) { }
            } message: {
                Text(mensaje ?? "")
            }
        }
    }

    // ④ Pagar: solo supervisor (el servicio vuelve a revisar el rol)
    private func pagar(_ compra: Compra) {
        do {
            try withAnimation {
                try ServicioCompras.pagar(compra, por: sesion.usuario, en: modelContext)
            }
        } catch {
            mensaje = error.localizedDescription
        }
    }

    #if DEBUG
    /// Solo para probar el caso 8: compra a crédito con fecha de hace 40 días (venció hace 10)
    private func crearCompraVencidaDePrueba() {
        guard let usuario = sesion.usuario else { return }
        let productos = (try? modelContext.fetch(FetchDescriptor<Producto>(sortBy: [SortDescriptor(\.nombre)]))) ?? []
        let proveedores = (try? modelContext.fetch(FetchDescriptor<Proveedor>(sortBy: [SortDescriptor(\.nombre)]))) ?? []
        guard let producto = productos.first, let proveedor = proveedores.first else {
            mensaje = "Primero registra al menos un producto y un proveedor."
            return
        }
        let hace40Dias = Calendar.current.date(byAdding: .day, value: -40, to: .now) ?? .now
        do {
            try ServicioCompras.registrar(cantidad: 2,
                                          costoUnitario: max(producto.costoPromedio, 1),
                                          alCredito: true,
                                          producto: producto,
                                          proveedor: proveedor,
                                          comprador: usuario,
                                          fecha: hace40Dias,
                                          en: modelContext)
        } catch {
            mensaje = error.localizedDescription
        }
    }
    #endif
}

/// Lista filtrada con @Query construido en el init a partir del filtro
struct ListaPorPagar: View {
    @Environment(Sesion.self) private var sesion
    @Query private var compras: [Compra]

    let filtro: FiltroPago
    let busqueda: String
    let pagar: (Compra) -> Void

    init(filtro: FiltroPago, busqueda: String, pagar: @escaping (Compra) -> Void) {
        self.filtro = filtro
        self.busqueda = busqueda
        self.pagar = pagar
        _compras = Query(filter: filtro.predicado(ahora: .now), sort: \Compra.vence)
    }

    private var visibles: [Compra] {
        guard !busqueda.isEmpty else { return compras }
        return compras.filter { $0.proveedor?.nombre.localizedCaseInsensitiveContains(busqueda) ?? false }
    }

    var body: some View {
        List {
            Section {
                ForEach(visibles) { compra in
                    // ② Compra a crédito pendiente · ③ Etiqueta VENCIDA (en CompraFila)
                    CompraFila(compra: compra, mostrarComprador: true)
                        .swipeActions(edge: .trailing) {
                            if sesion.esSupervisor && compra.esPorPagar {
                                Button {
                                    pagar(compra)
                                } label: {
                                    Label("Pagar", systemImage: "banknote")
                                }
                                .tint(.green)
                            }
                        }
                }
            } footer: {
                if !visibles.isEmpty {
                    Text("\(filtro.rawValue): \(Moneda.formato(visibles.reduce(0) { $0 + $1.total }))."
                         + (filtro == .pagadas ? "" : " Desliza a la izquierda para pagar."))
                }
            }
        }
        .listStyle(.insetGrouped)
        .overlay {
            if visibles.isEmpty {
                ContentUnavailableView("Sin compras \(filtro.rawValue.lowercased())", systemImage: "creditcard",
                                       description: Text("Solo aparecen compras a crédito aprobadas."))
            }
        }
    }
}
