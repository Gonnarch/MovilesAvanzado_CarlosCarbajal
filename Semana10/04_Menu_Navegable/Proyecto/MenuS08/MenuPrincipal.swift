import SwiftUI
struct MenuPrincipal: View {
    var body: some View {
        NavigationStack {
            List {
                Section("Introducción a SwiftUI") {
                    NavigationLink("Presentación y stacks") { ContentView() }
                    NavigationLink("Ventana 02: contenedores") { Ventana02() }
                    NavigationLink("Ventana 03: peso ideal") { Ventana03() }
                }
            }.navigationTitle("Menú principal")
        }
    }
}
#Preview { MenuPrincipal() }
