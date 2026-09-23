import Foundation

struct IMCResult {
    let value: Double
    let status: String
}

enum IMCCalculator {
    static func calculate(weight: Double, height: Double) -> IMCResult? {
        guard weight.isFinite, height.isFinite, weight > 0, height > 0 else { return nil }
        let bmi = weight / (height * height)
        guard bmi.isFinite, bmi > 0 else { return nil }
        // Se conservan los limites exactos del codigo de la guia (pagina 19).
        let status: String
        if bmi < 18.5 { status = "Bajo peso" }
        else if bmi < 24.9 { status = "Peso normal" }
        else if bmi < 29.9 { status = "Sobrepeso" }
        else { status = "Obesidad" }
        return IMCResult(value: bmi, status: status)
    }
}

enum DecimalInput {
    // Acepta coma o punto decimal, pero no separadores de miles.
    static func parse(_ text: String?) -> Double? {
        guard let text = text else { return nil }
        let normalized = text.trimmingCharacters(in: .whitespacesAndNewlines)
            .replacingOccurrences(of: ",", with: ".")
        guard let value = Double(normalized), value.isFinite else { return nil }
        return value
    }
}
