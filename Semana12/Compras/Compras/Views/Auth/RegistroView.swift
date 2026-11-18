import SwiftUI
import SwiftData

/// B2 · Crear cuenta. Al registrarse, la persona entra directo a la app.
struct RegistroView: View {
    @Environment(\.modelContext) private var modelContext
    @Environment(Sesion.self) private var sesion

    @State private var nombre = ""
    @State private var usuario = ""
    @State private var clave = ""
    @State private var confirmacion = ""
    @State private var rol: Rol = .comprador

    @State private var usuarioRepetido = false
    @State private var error: String?

    private var claveCorta: Bool { !clave.isEmpty && clave.count < ServicioUsuarios.longitudMinimaClave }
    private var noCoinciden: Bool { !confirmacion.isEmpty && clave != confirmacion }

    private var formularioCompleto: Bool {
        !nombre.trimmingCharacters(in: .whitespaces).isEmpty
        && !usuario.trimmingCharacters(in: .whitespaces).isEmpty
        && !clave.isEmpty && !confirmacion.isEmpty
    }

    var body: some View {
        Form {
            // ② Nombre completo
            Section("Datos personales") {
                TextField("Nombre completo", text: $nombre)
                    .textContentType(.name)
            }

            // ③ Usuario único, con aviso si ya existe
            Section {
                TextField("Usuario", text: $usuario)
                    .textInputAutocapitalization(.never)
                    .autocorrectionDisabled()
                    .textContentType(.oneTimeCode)
            } header: {
                Text("Usuario")
            } footer: {
                if usuarioRepetido {
                    Label("Ese usuario ya existe (no se distinguen mayúsculas)", systemImage: "xmark.octagon.fill")
                        .foregroundStyle(.red)
                } else {
                    Text("Sin espacios. \"MTorres\" y \"mtorres\" son el mismo usuario.")
                }
            }

            // ④ Clave (mínimo 6) y su confirmación
            Section {
                // .oneTimeCode evita que iOS tape el formulario con "¿Usar contraseña segura?"
                SecureField("Clave", text: $clave)
                    .textContentType(.oneTimeCode)
                SecureField("Confirmar clave", text: $confirmacion)
                    .textContentType(.oneTimeCode)
            } header: {
                Text("Clave")
            } footer: {
                if claveCorta {
                    Text("Mínimo \(ServicioUsuarios.longitudMinimaClave) caracteres").foregroundStyle(.red)
                } else if noCoinciden {
                    Text("Las claves no coinciden").foregroundStyle(.red)
                } else {
                    Text("Mínimo \(ServicioUsuarios.longitudMinimaClave) caracteres.")
                }
            }

            // ⑤ Rol: Comprador o Supervisor
            Section {
                Picker("Rol", selection: $rol) {
                    ForEach(Rol.allCases) { rol in
                        Text(rol.rawValue).tag(rol)
                    }
                }
                .pickerStyle(.segmented)
            } header: {
                Text("Rol")
            } footer: {
                Text("Práctica: el rol lo elige quien se registra. En una app real no debe ser así.")
            }

            if let error {
                Section {
                    Label(error, systemImage: "exclamationmark.triangle.fill")
                        .foregroundStyle(.red)
                }
            }

            // ⑥ Registrarme (entra directo a la app)
            Section {
                Button {
                    registrar()
                } label: {
                    Text("Registrarme")
                        .font(.headline)
                        .frame(maxWidth: .infinity)
                }
                .disabled(!formularioCompleto || usuarioRepetido)
            }
        }
        // ① Título; el botón "atrás" del NavigationStack vuelve al login
        .navigationTitle("Crear cuenta")
        .navigationBarTitleDisplayMode(.inline)
        .onChange(of: usuario) {
            usuarioRepetido = ServicioUsuarios.existe(usuario: usuario, en: modelContext)
            error = nil
        }
        .onChange(of: clave) { error = nil }
        .onChange(of: confirmacion) { error = nil }
    }

    private func registrar() {
        do {
            let nuevo = try ServicioUsuarios.registrar(nombre: nombre,
                                                       usuario: usuario,
                                                       clave: clave,
                                                       confirmacion: confirmacion,
                                                       rol: rol,
                                                       en: modelContext)
            sesion.iniciar(nuevo) // Entra directo: RootView cambia a las pestañas
        } catch {
            self.error = error.localizedDescription
        }
    }
}

#Preview {
    NavigationStack {
        RegistroView()
    }
    .environment(Sesion())
    .modelContainer(for: [Usuario.self, Proveedor.self, Producto.self, Compra.self], inMemory: true)
}
