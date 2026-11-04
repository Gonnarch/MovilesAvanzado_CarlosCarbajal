// LAB 11 - Actividad 02: SwiftUI + SwiftData. iOS 17 o posterior.
// Proyecto SEPARADO: iOS App / SwiftUI / Storage None.
// Quita del target App y ContentView de la plantilla; agrega ESTE archivo.
// Incluye todos los tipos de la actividad en un único archivo de entrega.
import SwiftUI
import SwiftData

// MARK: - Modelos Alumno y Curso (pasos 3 y 11)
@Model
final class Alumno {
    var idAlumno: UUID
    var apellido: String
    var nombre: String
    var dni: String
    var curso: Curso?
    init(idAlumno: UUID = UUID(), apellido: String, nombre: String, dni: String) {
        self.idAlumno = idAlumno
        self.apellido = apellido
        self.nombre = nombre
        self.dni = dni
    }
}

@Model
final class Curso {
    var nombre: String
    @Relationship(deleteRule: .nullify, inverse: \Alumno.curso)
    var alumnos: [Alumno] = []
    init(nombre: String) { self.nombre = nombre }
}

// MARK: - Contenedor persistente (paso 4)
@MainActor
final class ModelContainerProvider {
    static let shared = ModelContainerProvider()
    let container: ModelContainer
    private init() {
        let schema = Schema([Alumno.self, Curso.self])
        do {
            let directorio = try FileManager.default.url(
                for: .applicationSupportDirectory, in: .userDomainMask,
                appropriateFor: nil, create: true)
            let config = ModelConfiguration("AlumnosData", schema: schema,
                url: directorio.appendingPathComponent("AlumnosData.sqlite"))
            container = try ModelContainer(for: schema, configurations: [config])
            print("Base de datos SQLite en: \(config.url.path)")
        } catch { fatalError("Error al inicializar ModelContainer: \(error)") }
    }
}

// MARK: - Entrada y entorno (paso 5)
@main
struct AlumnosApp: App {
    var body: some Scene {
        WindowGroup { ContentView() }
            .modelContainer(ModelContainerProvider.shared.container)
    }
}

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
            .searchable(text: $busqueda, prompt: "Buscar por apellido")
            .navigationTitle("Alumnos")
            .toolbar {
                ToolbarItem(placement: .topBarLeading) { EditButton() }
                ToolbarItem(placement: .topBarTrailing) {
                    Button { mostrarFormulario = true } label: {
                        Label("Nuevo Alumno", systemImage: "plus")
                    }
                }
                ToolbarItem(placement: .topBarTrailing) {
                    Button { asignarCursoDemo() } label: {
                        Label("Curso demo", systemImage: "book")
                    }
                    .disabled(alumnos.isEmpty)
                }
            }
        } detail: {
            if let alumno = alumnoSeleccionado {
                VStack(alignment: .leading, spacing: 12) {
                    Text("Detalles del Alumno").font(.title2)
                    Text("Nombre: \(alumno.nombre)")
                    Text("Apellido: \(alumno.apellido)")
                    Text("DNI: \(alumno.dni)")
                    Text("Curso: \(alumno.curso?.nombre ?? "Sin curso")")
                    Button("Editar") { alumnoAEditar = alumno }
                        .buttonStyle(.borderedProminent)
                }
                .padding()
            } else { Text("Selecciona un alumno") }
        }
        .sheet(isPresented: $mostrarFormulario) { NuevoAlumnoView() }
        .sheet(item: $alumnoAEditar) { EditarAlumnoView(alumno: $0) }
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

#Preview {
    ContentView().modelContainer(for: [Alumno.self, Curso.self], inMemory: true)
}
