import Foundation

// ACTIVIDAD PROPUESTA 01 - CURSOS LIBRES DE TECSUP
// El usuario ingresa sus propios datos y los cursos que desea llevar.

struct CursoLibre {
    let nombre: String
    let cantidad: Int
    let precioUnitario: Double

    func subtotal() -> Double {
        return Double(cantidad) * precioUnitario
    }
}

class Alumno {
    let nombre: String
    let dni: String
    let esAlumnoTecsup: Bool
    var cursos: [CursoLibre] = []

    init(nombre: String, dni: String, esAlumnoTecsup: Bool) {
        self.nombre = nombre
        self.dni = dni
        self.esAlumnoTecsup = esAlumnoTecsup
    }

    func inscribir(curso: CursoLibre) {
        cursos.append(curso)
    }

    func calcularPago() {
        var subtotal = 0.0
        var cantidadTotalCursos = 0

        print("\n🎓 FACTURA DE CURSOS")
        print("Estudiante: \(nombre)")
        print("DNI: \(dni)")
        print("Alumno de Tecsup: \(esAlumnoTecsup ? "Sí ✅" : "No ❌")")
        print("")

        for curso in cursos {
            let montoCurso = curso.subtotal()
            subtotal = subtotal + montoCurso
            cantidadTotalCursos = cantidadTotalCursos + curso.cantidad
            print("\(curso.nombre) x\(curso.cantidad) -> S/ \(String(format: "%.2f", montoCurso))")
        }

        let igv = subtotal * 0.18
        let totalConIGV = subtotal + igv
        var descuentoPorCantidad = 0.0
        var descuentoTecsup = 0.0

        if cantidadTotalCursos >= 3 {
            descuentoPorCantidad = totalConIGV * 0.10

            if esAlumnoTecsup {
                descuentoTecsup = 400.0
            }
        }

        var totalFinal = totalConIGV - descuentoPorCantidad - descuentoTecsup

        if totalFinal < 0.0 {
            totalFinal = 0.0
        }

        print("\nSubtotal: S/ \(String(format: "%.2f", subtotal))")
        print("IGV (18%): S/ \(String(format: "%.2f", igv))")
        print("Total con IGV: S/ \(String(format: "%.2f", totalConIGV))")
        print("Descuento 10% por cantidad: -S/ \(String(format: "%.2f", descuentoPorCantidad)) \(cantidadTotalCursos >= 3 ? "✅" : "❌")")
        print("Descuento especial Tecsup: -S/ \(String(format: "%.2f", descuentoTecsup)) \(descuentoTecsup > 0 ? "✅" : "❌")")
        print("\n💰 TOTAL FINAL A PAGAR: S/ \(String(format: "%.2f", totalFinal))")
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

func leerEntero(_ mensaje: String) -> Int {
    while true {
        let texto = leerTexto(mensaje)
        let numero = Int(texto)

        if numero != nil && numero! > 0 {
            return numero!
        }

        print("Dato inválido. Ingresa un número entero mayor que 0.")
    }
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

print("===== REGISTRO DE CURSOS LIBRES TECSUP =====")

let nombre = leerTexto("Nombre del estudiante: ")
let dni = leerTexto("DNI: ")
let respuestaTecsup = leerTexto("¿Es alumno de Tecsup? (S/N): ").uppercased()
let esAlumnoTecsup = respuestaTecsup == "S"

let alumno = Alumno(nombre: nombre, dni: dni, esAlumnoTecsup: esAlumnoTecsup)
let cantidadTiposCurso = leerEntero("¿Cuántos cursos diferentes desea registrar?: ")

for i in 1...cantidadTiposCurso {
    print("\n--- Curso \(i) ---")
    let nombreCurso = leerTexto("Nombre del curso: ")
    let cantidad = leerEntero("Cantidad: ")
    let precioUnitario = leerDouble("Precio unitario: S/ ")

    let curso = CursoLibre(
        nombre: nombreCurso,
        cantidad: cantidad,
        precioUnitario: precioUnitario
    )

    alumno.inscribir(curso: curso)
}

alumno.calcularPago()
