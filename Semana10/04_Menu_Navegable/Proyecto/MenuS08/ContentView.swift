import SwiftUI
struct ContentView: View {
    var body: some View {
        ScrollView {
            VStack(spacing: 24) {
                Text("Aplicaciones de Tecsup en SwiftUI!").font(.title).foregroundStyle(.red).multilineTextAlignment(.center)
                Text("Laboratorio S08 · Introducción a SwiftUI")
                HStack(spacing: 20) {
                    Text("Actividad01"); Text("Actividad02"); Text("Actividad03")
                }.font(.subheadline)
                ZStack {
                    Rectangle().fill(.blue).frame(width: 250, height: 200)
                    Text("Texto encima de la imagen").foregroundStyle(.white)
                }
                Text("VStack ordena verticalmente; HStack, horizontalmente; ZStack superpone las vistas.")
                    .font(.footnote).foregroundStyle(.secondary)
            }.padding(20)
        }.navigationTitle("Actividad 01")
    }
}
#Preview { ContentView() }
