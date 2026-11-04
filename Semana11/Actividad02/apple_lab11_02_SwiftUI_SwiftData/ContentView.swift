import SwiftUI
import SwiftData

// MARK: - READ DELETE búsqueda y detalle (pasos 7 y 10)
struct ContentView: View {
    @Environment(\.modelContext) private var modelContext
    @Query(sort: \Alumno.apellido) private var alumnos: [Alumno]
    @State private var alumnoSeleccionado: Alumno?
    @State private var mostrarFormulario = false
    @State private var alumnoAEditar: Alumno?
    @State private var busqueda = ""
    @State private var error: String?
    private var alumnosFiltrados: [Alumno] {
        if busqueda.isEmpty { return alumnos }
        return alumnos.filter { $0.apellido.localizedCaseInsensitiveContains(busqueda) }
    }
    var body: some View {
        NavigationSplitView {
            List(selection: $alumnoSeleccionado) {
                ForEach(alumnosFiltrados) { alumno in
                    NavigationLink(value: alumno) {
                        VStack(alignment: .leading) {
                            Text("\(alumno.apellido), \(alumno.nombre)").font(.headline)
                            Text("DNI: \(alumno.dni)").font(.subheadline)
                        }
                    }
                }
                .onDelete(perform: deleteAlumnos)
            }
            .navigationTitle("Alumnos")
            .toolbar {
                ToolbarItem(placement: .topBarLeading) { EditButton() }
                ToolbarItem(placement: .topBarTrailing) {
                    Button { mostrarFormulario = true } label: {
                        Label("Nuevo Alumno", systemImage: "plus")
                    }
                }

            }
        } detail: {
            if let alumno = alumnoSeleccionado {
                VStack(alignment: .leading, spacing: 12) {
                    Text("Detalles del Alumno").font(.title2)
                    Text("Nombre: \(alumno.nombre)")
                    Text("Apellido: \(alumno.apellido)")
                    Text("DNI: \(alumno.dni)")
                }
                .padding()
            } else { Text("Selecciona un alumno") }
        }
        .sheet(isPresented: $mostrarFormulario) { NuevoAlumnoView() }
        .alert("Error de persistencia", isPresented: Binding(
            get: { error != nil }, set: { if !$0 { error = nil } })) {
            Button("Aceptar", role: .cancel) { error = nil }
        } message: { Text(error ?? "") }
    }
    private func deleteAlumnos(offsets: IndexSet) {
        // Los índices corresponden al resultado visible, no a todos los alumnos.
        let eliminados = offsets.map { alumnosFiltrados[$0] }
        let seleccionAnterior = alumnoSeleccionado
        if eliminados.contains(where: { $0 == alumnoSeleccionado }) { alumnoSeleccionado = nil }
        for alumno in eliminados { modelContext.delete(alumno) }
        do { try modelContext.save() }
        catch {
            modelContext.rollback()
            alumnoSeleccionado = seleccionAnterior
            self.error = error.localizedDescription
        }
    }
    // MARK: - Relación Curso a muchos Alumnos (paso 11)
    private func asignarCursoDemo() {
        let nombreCurso = "Programación en Móviles"
        let request = FetchDescriptor<Curso>(predicate: #Predicate { $0.nombre == nombreCurso })
        do {
            let curso: Curso
            if let existente = try modelContext.fetch(request).first { curso = existente }
            else {
                curso = Curso(nombre: nombreCurso)
                modelContext.insert(curso)
            }
            for alumno in alumnos { alumno.curso = curso }
            try modelContext.save()
            print("Curso \(curso.nombre): \(curso.alumnos.count) alumno(s)")
        } catch {
            modelContext.rollback()
            self.error = error.localizedDescription
        }
    }
}


#Preview {
    ContentView().modelContainer(for: [Alumno.self, Curso.self], inMemory: true)
}
