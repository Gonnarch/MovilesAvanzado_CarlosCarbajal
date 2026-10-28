import SwiftUI
struct Ventana02: View {
    var body: some View {
        ScrollView {
            VStack(spacing: 28) {
                Text("Tecsup · Software").font(.largeTitle).bold()
                HStack { Label("Izquierda", systemImage: "arrow.left"); Spacer(); Text("Derecha") }
                ZStack {
                    Circle().fill(.blue.opacity(0.15)).frame(width: 260, height: 260)
                    VStack(spacing: 12) {
                        Image(systemName: "graduationcap.fill").font(.system(size: 46)).foregroundStyle(.blue)
                        Text("Alumnos de 5.º ciclo").font(.title2).bold()
                        Text("Programación en móviles").font(.caption)
                    }
                }
                HStack { Image(systemName: "person.2.fill"); Text("Equipo de dos estudiantes") }
            }.padding()
        }.navigationTitle("Ventana 02")
    }
}
#Preview { Ventana02() }
