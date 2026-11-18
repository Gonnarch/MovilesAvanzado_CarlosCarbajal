import SwiftUI

/// Fila reutilizable de una compra (Mis compras, Todas las compras, Por pagar)
struct CompraFila: View {
    let compra: Compra
    var mostrarComprador = false

    var body: some View {
        VStack(alignment: .leading, spacing: 6) {
            HStack(alignment: .firstTextBaseline) {
                Text(compra.producto?.nombre ?? "Producto")
                    .font(.headline)
                Spacer()
                Text(Moneda.formato(compra.total))
                    .font(.headline)
                    .monospacedDigit()
            }

            Text("\(compra.proveedor?.nombre ?? "Proveedor") · \(compra.cantidad) × \(Moneda.formato(compra.costoUnitario))")
                .font(.subheadline)
                .foregroundStyle(.secondary)

            HStack(spacing: 6) {
                Insignia(texto: compra.estado, color: compra.estadoCompra.color)
                if compra.alCredito {
                    if compra.estaVencida {
                        Insignia(texto: "VENCIDA", color: .red)
                    } else if compra.pagada {
                        Insignia(texto: "Pagada", color: .green)
                    } else {
                        Insignia(texto: "Crédito · vence \(Fecha.corta(compra.vence))", color: .blue)
                    }
                } else {
                    Insignia(texto: "Contado", color: .gray)
                }
                Spacer()
                Text(Fecha.corta(compra.fecha))
                    .font(.caption2)
                    .foregroundStyle(.secondary)
            }

            if mostrarComprador, let comprador = compra.comprador {
                Label("Registró: \(comprador.nombre)", systemImage: "person")
                    .font(.caption)
                    .foregroundStyle(.secondary)
            }

            // ③ Compra rechazada con su motivo
            if compra.estadoCompra == .rechazada, let motivo = compra.motivoRechazo {
                Label("Motivo: \(motivo)", systemImage: "text.bubble")
                    .font(.caption)
                    .foregroundStyle(.red)
            }
        }
        .padding(.vertical, 4)
    }
}
