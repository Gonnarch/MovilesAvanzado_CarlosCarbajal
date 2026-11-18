import Foundation
import Observation

/// Recuerda al usuario conectado mientras la app está abierta.
/// Se pone en el entorno con .environment(sesion) y cualquier vista la lee con
/// @Environment(Sesion.self). Al cambiar `usuario`, la vista raíz se redibuja sola.
@Observable
final class Sesion {
    var usuario: Usuario?

    var estaConectado: Bool { usuario != nil }
    var esSupervisor: Bool { usuario?.esSupervisor ?? false }

    func iniciar(_ usuario: Usuario) {
        self.usuario = usuario
    }

    /// Cerrar sesión: basta poner la variable en nil y la vista vuelve al login
    func cerrar() {
        usuario = nil
    }
}
