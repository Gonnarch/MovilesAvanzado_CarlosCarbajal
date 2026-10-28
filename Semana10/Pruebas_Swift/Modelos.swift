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

import Foundation
struct ResultadoNotas {
    let promedio: Double
    let redondeado: Int
    let indiceEliminado: Int?
    let cantidad: Int
}
enum NotasModelo {
    // Interpretación explícita: AN equivale a cero y nunca es eliminable.
    static func calcular(_ textos: [String]) throws -> ResultadoNotas {
        guard textos.count == 4 else { throw ErrorEntrada.mensaje("Se requieren exactamente cuatro notas.") }
        var notas: [Double] = []
        var anuladas: [Bool] = []
        for (i, texto) in textos.enumerated() {
            let an = texto.trimmingCharacters(in: .whitespacesAndNewlines).uppercased() == "AN"
            anuladas.append(an)
            if an { notas.append(0) }
            else { notas.append(try Entrada.numero(texto, "Nota \(i+1)", max: 20)) }
        }
        let elegibles = notas.indices.filter { !anuladas[$0] }
        // En empate se elimina la primera nota numérica mínima, solo una.
        let quitar = elegibles.min { notas[$0] == notas[$1] ? $0 < $1 : notas[$0] < notas[$1] }
        let cantidad = quitar == nil ? 4 : 3
        let suma = notas.enumerated().filter { $0.offset != quitar }.reduce(0) { $0 + $1.element }
        let promedio = suma / Double(cantidad)
        return ResultadoNotas(promedio: promedio, redondeado: Int(promedio.rounded(.toNearestOrAwayFromZero)), indiceEliminado: quitar, cantidad: cantidad)
    }
}

import Foundation
enum PesoModelo {
    static func calcular(altura: String, edad: String, mujer: Bool) throws -> Double {
        let h = try Entrada.numero(altura, "Altura en cm", min: 1, max: 300)
        if !edad.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty {
            _ = try Entrada.entero(edad, "Edad", min: 1, max: 120)
        }
        let r = (mujer ? 45.5 : 50) + 0.9 * (h - 152)
        guard r > 0 else { throw ErrorEntrada.mensaje("La fórmula produce un resultado no válido para esa altura.") }
        return r
    }
}

import Foundation
enum PagoModelo {
    static func impuestoAnual(_ ingreso: Double, uit: Double) -> Double {
        var exceso = max(0, ingreso - 7 * uit), impuesto = 0.0
        for (amplitud, tasa) in [(5.0,0.08),(15.0,0.14),(15.0,0.17),(10.0,0.20)] {
            let tramo = min(exceso, amplitud * uit); impuesto += tramo * tasa; exceso -= tramo
        }
        return impuesto + exceso * 0.30
    }
    static func retencion(ingreso: Double, uit: Double, mes: Int, retenido: Double, extraordinario: Double) -> Double {
        let divisor = mes <= 3 ? 12.0 : mes == 4 ? 9 : mes <= 7 ? 8 : mes == 8 ? 5 : mes <= 11 ? 4 : 1
        let anual = impuestoAnual(ingreso, uit: uit)
        let ordinaria = max(0, (anual - (mes <= 3 ? 0 : retenido)) / divisor)
        let adicional = impuestoAnual(ingreso + extraordinario, uit: uit) - anual
        return Entrada.dinero(ordinaria + adicional)
    }
}
