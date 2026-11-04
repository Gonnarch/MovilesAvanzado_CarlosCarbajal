import SwiftUI
import SwiftData

// MARK: - CREATE formulario (paso 6)
struct NuevoAlumnoView: View {
    @Environment(\.modelContext) private var modelContext
    @Environment(\.dismiss) private var dismiss
    @State private var apellido = ""
    @State private var nombre = ""
    @State private var dni = ""
    @State private var error: String?
    private var incompleto: Bool {
        [apellido, nombre, dni].contains { $0.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty }
    }
    var body: some View {
        NavigationStack {
            Form {
                Section("Datos del Alumno") {
                    TextField("Apellido", text: $apellido)
                    TextField("Nombre", text: $nombre)
                    TextField("DNI", text: $dni).keyboardType(.numberPad)
                }
                Button("Guardar Alumno") {
                    let alumno = Alumno(
                        apellido: apellido.trimmingCharacters(in: .whitespacesAndNewlines),
                        nombre: nombre.trimmingCharacters(in: .whitespacesAndNewlines),
                        dni: dni.trimmingCharacters(in: .whitespacesAndNewlines))
                    modelContext.insert(alumno)
                    do {
                        try modelContext.save()
                        dismiss() // Solo cerrar si el guardado fue exitoso.
                    } catch {
                        modelContext.rollback()
                        self.error = error.localizedDescription
                    }
                }
                .disabled(incompleto)
            }
            .navigationTitle("Nuevo Alumno")
            .toolbar {
                ToolbarItem(placement: .cancellationAction) {
                    Button("Cancelar") { dismiss() }
                }
            }
            .alert("No se pudo guardar", isPresented: Binding(
                get: { error != nil }, set: { if !$0 { error = nil } })) {
                Button("Aceptar", role: .cancel) { error = nil }
            } message: { Text(error ?? "") }
        }
    }
}

