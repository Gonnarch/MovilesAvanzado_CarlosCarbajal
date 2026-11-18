import Foundation
import SwiftData

/// Login y registro de usuarios con SwiftData.
@MainActor
enum ServicioUsuarios {

    /// Mensaje genérico: no dice si falló el usuario o la clave
    static let mensajeLoginInvalido = "Usuario o clave incorrectos"

    /// El usuario se guarda sin espacios a los lados y en minúsculas,
    /// así "MTorres" y "mtorres" son el mismo usuario.
    static func normalizar(_ usuario: String) -> String {
        usuario.trimmingCharacters(in: .whitespacesAndNewlines).lowercased()
    }

    // MARK: - Login

    /// Devuelve el usuario si usuario y clave coinciden; nil en otro caso.
    static func login(usuario: String, clave: String, en contexto: ModelContext) -> Usuario? {
        // #Predicate no acepta llamadas a funciones: guardamos el texto en un let antes
        let buscado = normalizar(usuario)
        let claveIngresada = clave
        let descriptor = FetchDescriptor<Usuario>(
            predicate: #Predicate { $0.usuario == buscado && $0.clave == claveIngresada }
        )
        return (try? contexto.fetch(descriptor))?.first
    }

    // MARK: - Registro

    static let longitudMinimaClave = 6

    /// Usuario único: FetchDescriptor con #Predicate y fetchCount
    static func existe(usuario: String, en contexto: ModelContext) -> Bool {
        let buscado = normalizar(usuario)
        guard !buscado.isEmpty else { return false }
        let descriptor = FetchDescriptor<Usuario>(predicate: #Predicate { $0.usuario == buscado })
        return ((try? contexto.fetchCount(descriptor)) ?? 0) > 0
    }

    /// Devuelve el primer error encontrado o nil si los datos son válidos.
    static func validar(nombre: String,
                        usuario: String,
                        clave: String,
                        confirmacion: String,
                        en contexto: ModelContext) -> String? {
        if nombre.trimmingCharacters(in: .whitespaces).isEmpty {
            return "Ingresa tu nombre completo"
        }
        let usuarioNormalizado = normalizar(usuario)
        if usuarioNormalizado.isEmpty {
            return "Ingresa un usuario"
        }
        if usuarioNormalizado.contains(" ") {
            return "El usuario no debe tener espacios"
        }
        if existe(usuario: usuarioNormalizado, en: contexto) {
            return "El usuario \"\(usuarioNormalizado)\" ya existe"
        }
        if clave.count < longitudMinimaClave {
            return "La clave debe tener al menos \(longitudMinimaClave) caracteres"
        }
        if clave != confirmacion {
            return "La clave y su confirmación no coinciden"
        }
        return nil
    }

    enum ErrorRegistro: LocalizedError {
        case invalido(String)
        var errorDescription: String? {
            switch self {
            case .invalido(let mensaje): return mensaje
            }
        }
    }

    /// Valida, crea y guarda el usuario. Lanza ErrorRegistro con el mensaje si no es válido.
    @discardableResult
    static func registrar(nombre: String,
                          usuario: String,
                          clave: String,
                          confirmacion: String,
                          rol: Rol,
                          en contexto: ModelContext) throws -> Usuario {
        if let mensaje = validar(nombre: nombre, usuario: usuario, clave: clave,
                                 confirmacion: confirmacion, en: contexto) {
            throw ErrorRegistro.invalido(mensaje)
        }
        let nuevo = Usuario(nombre: nombre.trimmingCharacters(in: .whitespaces),
                            usuario: normalizar(usuario),
                            clave: clave,
                            rol: rol.rawValue)
        contexto.insert(nuevo)
        try contexto.save()
        return nuevo
    }
}
