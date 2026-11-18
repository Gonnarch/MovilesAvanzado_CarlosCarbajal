import SwiftUI

/// Montos en soles con dos decimales y separador de miles: "S/ 1,416.00"
enum Moneda {
    private static let formateador: NumberFormatter = {
        let f = NumberFormatter()
        f.numberStyle = .decimal
        f.locale = Locale(identifier: "en_US_POSIX")
        f.usesGroupingSeparator = true
        f.groupingSeparator = ","
        f.decimalSeparator = "."
        f.minimumFractionDigits = 2
        f.maximumFractionDigits = 2
        return f
    }()

    static func formato(_ valor: Double) -> String {
        "S/ " + (formateador.string(from: NSNumber(value: valor)) ?? String(format: "%.2f", valor))
    }
}

enum Fecha {
    static func corta(_ fecha: Date) -> String {
        fecha.formatted(.dateTime.day(.twoDigits).month(.twoDigits).year())
    }
}

/// Color del stock: verde más de 10, ámbar de 6 a 10, rojo 5 o menos
enum NivelStock {
    static func color(_ stock: Int) -> Color {
        switch stock {
        case ...5: return .red
        case 6...10: return .orange
        default: return .green
        }
    }
}

/// Etiqueta pequeña con fondo de color (estado, VENCIDA, Al día, etc.)
struct Insignia: View {
    let texto: String
    let color: Color

    var body: some View {
        Text(texto)
            .font(.caption2.weight(.bold))
            .padding(.horizontal, 8)
            .padding(.vertical, 3)
            .foregroundStyle(color)
            .background(color.opacity(0.15), in: Capsule())
    }
}

extension EstadoCompra {
    var color: Color {
        switch self {
        case .pendiente: return .orange
        case .aprobada: return .green
        case .rechazada: return .red
        }
    }
}
