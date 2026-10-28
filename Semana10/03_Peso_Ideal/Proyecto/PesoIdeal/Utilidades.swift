import SwiftUI
import Foundation

enum ErrorEntrada: LocalizedError {
    case mensaje(String)
    var errorDescription: String? { if case .mensaje(let texto) = self { return texto }; return nil }
}
enum Entrada {
    static func numero(_ texto: String, _ nombre: String, min: Double = 0, max: Double = 1e12) throws -> Double {
        let limpio = texto.trimmingCharacters(in: .whitespacesAndNewlines).replacingOccurrences(of: ",", with: ".")
        guard let valor = Double(limpio), valor.isFinite, valor >= min, valor <= max else {
            throw ErrorEntrada.mensaje("\(nombre): ingresa un número entre \(min) y \(max). No uses separadores de miles.")
        }
        return valor
    }
    static func entero(_ texto: String, _ nombre: String, min: Int = 0, max: Int = 100000) throws -> Int {
        let v = try numero(texto, nombre, min: Double(min), max: Double(max))
        guard v.rounded() == v else { throw ErrorEntrada.mensaje("\(nombre): debe ser entero.") }
        return Int(v)
    }
    static func dinero(_ v: Double) -> Double { (v * 100).rounded(.toNearestOrAwayFromZero) / 100 }
    static func soles(_ v: Double) -> String { String(format: "S/ %.2f", v) }
}
struct Campo: View {
    let nombre: String
    @Binding var texto: String
    var body: some View {
        VStack(alignment: .leading, spacing: 5) {
            Text(nombre).font(.caption).foregroundStyle(.secondary)
            TextField(nombre, text: $texto).textFieldStyle(.roundedBorder)
                .autocorrectionDisabled().accessibilityLabel(nombre)
        }
    }
}
struct Aviso: View {
    let texto: String
    var body: some View { Text(texto).font(.footnote).foregroundStyle(.secondary).fixedSize(horizontal: false, vertical: true) }
}
