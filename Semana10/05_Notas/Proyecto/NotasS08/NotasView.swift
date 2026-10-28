import SwiftUI
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
struct NotasView: View {
    @State private var notas = ["12", "15", "18", "AN"]
    var body: some View {
        Form {
            Section("Programación en Móviles Avanzado") {
                ForEach(0..<4, id: \.self) { i in Campo(nombre: "Nota \(i+1): 0 a 20 o AN", texto: $notas[i]) }
                Aviso(texto: "Criterio confirmado: AN vale 0 y se conserva. Se elimina una sola nota numérica mínima. Cuatro AN se promedian entre cuatro.")
            }
            Section("Promedio") {
                switch Result(catching: { try NotasModelo.calcular(notas) }) {
                case .success(let r):
                    Text("\(r.redondeado)").font(.largeTitle).bold()
                    Text(String(format: "Sin redondear: %.4f", r.promedio))
                    Text(r.indiceEliminado.map { "Se elimina la nota \($0+1). Divisor: \(r.cantidad)." } ?? "Ningún AN se elimina. Divisor: 4.")
                case .failure(let e): Text(e.localizedDescription).foregroundStyle(.red)
                }
            }
        }.navigationTitle("Notas de teoría")
    }
}
#Preview { NavigationStack { NotasView() } }
