import SwiftUI
import SwiftData

/// B1 · Inicio de sesión
struct LoginView: View {
    @Environment(\.modelContext) private var modelContext
    @Environment(Sesion.self) private var sesion

    @State private var usuario = ""
    @State private var clave = ""
    @State private var error: String?

    var body: some View {
        NavigationStack {
            ScrollView {
                VStack(spacing: 28) {
                    // ① Logo y nombre
                    VStack(spacing: 10) {
                        Image(systemName: "shippingbox.fill")
                            .font(.system(size: 44, weight: .semibold))
                            .foregroundStyle(.white)
                            .frame(width: 96, height: 96)
                            .background(Color.accentColor.gradient, in: RoundedRectangle(cornerRadius: 24))
                        Text("Compras")
                            .font(.largeTitle.bold())
                        Text("Distribuidora · proveedores, costos y cuentas por pagar")
                            .font(.subheadline)
                            .foregroundStyle(.secondary)
                            .multilineTextAlignment(.center)
                    }
                    .padding(.top, 40)

                    VStack(spacing: 14) {
                        // ② Usuario
                        TextField("Usuario", text: $usuario)
                            .textInputAutocapitalization(.never)
                            .autocorrectionDisabled()
                            .textContentType(.username)
                            .padding()
                            .background(.quaternary, in: RoundedRectangle(cornerRadius: 12))

                        // ③ Clave oculta
                        SecureField("Clave", text: $clave)
                            .textContentType(.password)
                            .padding()
                            .background(.quaternary, in: RoundedRectangle(cornerRadius: 12))

                        // ④ Mensaje de error genérico
                        if let error {
                            Label(error, systemImage: "exclamationmark.triangle.fill")
                                .font(.footnote)
                                .foregroundStyle(.red)
                                .frame(maxWidth: .infinity, alignment: .leading)
                        }

                        // ⑤ Ingresar
                        Button {
                            ingresar()
                        } label: {
                            Text("Ingresar")
                                .font(.headline)
                                .frame(maxWidth: .infinity)
                                .padding(.vertical, 6)
                        }
                        .buttonStyle(.borderedProminent)
                        .disabled(usuario.isEmpty || clave.isEmpty)
                    }

                    // ⑥ Ir a Crear cuenta
                    HStack(spacing: 4) {
                        Text("¿No tienes cuenta?")
                            .foregroundStyle(.secondary)
                        NavigationLink("Crear cuenta") {
                            Text("Registro")
                        }
                        .fontWeight(.semibold)
                    }
                    .font(.subheadline)
                }
                .padding(.horizontal, 24)
            }
            .onChange(of: usuario) { error = nil }
            .onChange(of: clave) { error = nil }
        }
    }

    private func ingresar() {
        if let encontrado = ServicioUsuarios.login(usuario: usuario, clave: clave, en: modelContext) {
            error = nil
            sesion.iniciar(encontrado)
        } else {
            error = ServicioUsuarios.mensajeLoginInvalido
        }
    }
}

#Preview {
    LoginView()
        .environment(Sesion())
        .modelContainer(for: [Usuario.self, Proveedor.self, Producto.self, Compra.self], inMemory: true)
}
