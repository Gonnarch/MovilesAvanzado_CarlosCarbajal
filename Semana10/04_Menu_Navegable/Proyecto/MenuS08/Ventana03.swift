import SwiftUI
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
struct Ventana03: View {
    @State private var altura = "170"
    @State private var edad = ""
    @State private var mujer = false
    var body: some View {
        Form {
            Section("Calculadora de peso ideal") {
                Campo(nombre: "Altura (cm)", texto: $altura)
                Campo(nombre: "Edad (opcional; no interviene en la fórmula)", texto: $edad)
                Picker("Fórmula de la guía", selection: $mujer) {
                    Text("Hombre").tag(false); Text("Mujer").tag(true)
                }.pickerStyle(.segmented)
            }
            Section("Resultado actualizado") {
                switch resultado {
                case .success(let peso): Text(String(format: "%.1f kg", peso)).font(.largeTitle).bold()
                case .failure(let error): Text(error.localizedDescription).foregroundStyle(.red)
                }
                Aviso(texto: "Ejercicio de programación: reproduce la fórmula de la guía. No es una evaluación de salud ni una recomendación de peso.")
            }
        }.navigationTitle("Ventana 03")
    }
    private var resultado: Result<Double, Error> { Result { try PesoModelo.calcular(altura: altura, edad: edad, mujer: mujer) } }
}
#Preview { NavigationStack { Ventana03() } }
