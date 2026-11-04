import SwiftUI
import SwiftData

// MARK: - UPDATE con Bindable (paso 9)
struct EditarAlumnoView: View {
    @Bindable var alumno: Alumno
    @Environment(\.modelContext) private var modelContext
    @Environment(\.dismiss) private var dismiss
    @State private var error: String?
    var body: some View {
        NavigationStack {
            Form {
                Section("Datos del Alumno") {
                    TextField("Apellido", text: $alumno.apellido)
                    TextField("Nombre", text: $alumno.nombre)
                    TextField("DNI", text: $alumno.dni).keyboardType(.numberPad)
                }
            }
            .navigationTitle("Editar Alumno")
            .toolbar {
                ToolbarItem(placement: .confirmationAction) {
                    Button("Listo") {
                        do { try modelContext.save(); dismiss() }
                        catch { self.error = error.localizedDescription }
                    }
                    .disabled([alumno.apellido, alumno.nombre, alumno.dni].contains {
                        $0.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty
                    })
                }
            }
            .alert("No se pudo guardar", isPresented: Binding(
                get: { error != nil }, set: { if !$0 { error = nil } })) {
                Button("Aceptar", role: .cancel) { error = nil }
            } message: { Text(error ?? "") }
        }
    }
}

