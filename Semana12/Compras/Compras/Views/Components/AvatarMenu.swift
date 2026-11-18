import SwiftUI

/// Círculo con las iniciales del usuario. Supervisor en índigo, comprador en verde azulado.
struct AvatarCircle: View {
    let usuario: Usuario
    var tamano: CGFloat = 34

    var body: some View {
        Text(usuario.iniciales)
            .font(.system(size: tamano * 0.4, weight: .bold))
            .foregroundStyle(.white)
            .frame(width: tamano, height: tamano)
            .background(usuario.esSupervisor ? Color.indigo : Color.teal, in: Circle())
            .accessibilityLabel("Cuenta de \(usuario.nombre)")
    }
}

/// Cuenta: menú del avatar con nombre, rol y Cerrar sesión.
struct AvatarMenu: View {
    @Environment(Sesion.self) private var sesion

    var body: some View {
        if let usuario = sesion.usuario {
            Menu {
                Section {
                    Label(usuario.nombre, systemImage: "person.fill")
                    Label("@\(usuario.usuario) · \(usuario.rol)",
                          systemImage: usuario.esSupervisor ? "person.badge.shield.checkmark" : "cart")
                }
                Button(role: .destructive) {
                    sesion.cerrar()
                } label: {
                    Label("Cerrar sesión", systemImage: "rectangle.portrait.and.arrow.right")
                }
            } label: {
                AvatarCircle(usuario: usuario, tamano: 32)
            }
        }
    }
}

extension View {
    /// Agrega el avatar de la sesión a la izquierda de la barra de navegación.
    func conAvatar() -> some View {
        toolbar {
            ToolbarItem(placement: .topBarLeading) {
                AvatarMenu()
            }
        }
    }
}
