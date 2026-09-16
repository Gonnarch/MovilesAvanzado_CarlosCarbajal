import Foundation

// ACTIVIDAD PROPUESTA 02 - HERENCIA DE CLIENTES
// La imagen del laboratorio es una referencia de estructura y presentación.
// El usuario ingresa sus propios datos para crear un cliente natural o jurídico.

class Cliente {
    let codigo: String
    let direccion: String
    let fechaDeRegistro: String
    let numeroCuenta: String
    let montoMinimoApertura: Double

    init(codigo: String, direccion: String, fechaDeRegistro: String, numeroCuenta: String, montoMinimoApertura: Double) {
        self.codigo = codigo
        self.direccion = direccion
        self.fechaDeRegistro = fechaDeRegistro
        self.numeroCuenta = numeroCuenta
        self.montoMinimoApertura = montoMinimoApertura
    }

    func mostrarDatos() {
        print("📌 Código: \(codigo)")
        print("📍 Dirección: \(direccion)")
        print("📅 Fecha de registro: \(fechaDeRegistro)")
        print("🏦 N° Cuenta: \(numeroCuenta)")
        print(String(format: "💰 Monto mínimo de apertura: S/ %.2f", montoMinimoApertura))
    }
}

class ClienteNatural: Cliente {
    let nombreCompleto: String
    let dni: String

    init(nombreCompleto: String, dni: String, codigo: String, direccion: String, fechaDeRegistro: String, numeroCuenta: String, montoMinimoApertura: Double) {
        self.nombreCompleto = nombreCompleto
        self.dni = dni
        super.init(codigo: codigo, direccion: direccion, fechaDeRegistro: fechaDeRegistro, numeroCuenta: numeroCuenta, montoMinimoApertura: montoMinimoApertura)
    }

    override func mostrarDatos() {
        print("\n👤 CLIENTE NATURAL")
        print("Nombre completo: \(nombreCompleto)")
        print("DNI: \(dni)")
        super.mostrarDatos()
    }
}

class ClienteJuridico: Cliente {
    let razonSocial: String
    let ruc: String
    let representanteLegal: String

    init(razonSocial: String, ruc: String, representanteLegal: String, codigo: String, direccion: String, fechaDeRegistro: String, numeroCuenta: String, montoMinimoApertura: Double) {
        self.razonSocial = razonSocial
        self.ruc = ruc
        self.representanteLegal = representanteLegal
        super.init(codigo: codigo, direccion: direccion, fechaDeRegistro: fechaDeRegistro, numeroCuenta: numeroCuenta, montoMinimoApertura: montoMinimoApertura)
    }

    override func mostrarDatos() {
        print("\n🏢 CLIENTE JURÍDICO")
        print("Razón social: \(razonSocial)")
        print("RUC: \(ruc)")
        print("Representante legal: \(representanteLegal)")
        super.mostrarDatos()
    }
}

func leerTexto(_ mensaje: String) -> String {
    print(mensaje, terminator: "")
    let entrada = readLine()

    if entrada == nil {
        return ""
    }

    return entrada!
}

func leerDouble(_ mensaje: String) -> Double {
    while true {
        let texto = leerTexto(mensaje)
        let numero = Double(texto)

        if numero != nil && numero! >= 0 {
            return numero!
        }

        print("Dato inválido. Ingresa un monto válido.")
    }
}

print("===== REGISTRO DE CLIENTES =====")
print("1. Cliente Natural")
print("2. Cliente Jurídico")

var opcion = ""
while opcion != "1" && opcion != "2" {
    opcion = leerTexto("Seleccione el tipo de cliente: ")

    if opcion != "1" && opcion != "2" {
        print("Opción inválida. Ingresa 1 o 2.")
    }
}

let codigo = leerTexto("Código: ")
let direccion = leerTexto("Dirección: ")
let fechaDeRegistro = leerTexto("Fecha de registro: ")
let numeroCuenta = leerTexto("Número de cuenta: ")
let montoMinimoApertura = leerDouble("Monto mínimo de apertura: S/ ")

if opcion == "1" {
    let nombreCompleto = leerTexto("Nombre completo: ")
    let dni = leerTexto("DNI: ")

    let cliente = ClienteNatural(
        nombreCompleto: nombreCompleto,
        dni: dni,
        codigo: codigo,
        direccion: direccion,
        fechaDeRegistro: fechaDeRegistro,
        numeroCuenta: numeroCuenta,
        montoMinimoApertura: montoMinimoApertura
    )

    cliente.mostrarDatos()
} else {
    let razonSocial = leerTexto("Razón social: ")
    let ruc = leerTexto("RUC: ")
    let representanteLegal = leerTexto("Representante legal: ")

    let cliente = ClienteJuridico(
        razonSocial: razonSocial,
        ruc: ruc,
        representanteLegal: representanteLegal,
        codigo: codigo,
        direccion: direccion,
        fechaDeRegistro: fechaDeRegistro,
        numeroCuenta: numeroCuenta,
        montoMinimoApertura: montoMinimoApertura
    )

    cliente.mostrarDatos()
}
